nodeSelector: &nodeSelector {}
tolerations: &tolerations []
podLabels: &podLabels {}

ingressClass: {{.IngressClassName}}

clusterIssuer:
  # -- whether to install cluster issuer
  create: true

  # -- name of cluster issuer, to be used for issuing wildcard cert
  name: "cluster-issuer"
  # -- email that should be used for communicating with letsencrypt services
  acmeEmail: {{.AcmeEmail}}

cloudflareWildcardCert:
  create: {{.WildcardCertEnabled}}

  # -- name for wildcard cert
  name: {{.WildcardCertName}}

  # -- k8s secret where wildcard cert should be stored
  secretName: {{.WildcardCertName}}-tls

  # -- cloudflare authz credentials
  cloudflareCreds:
    # -- cloudflare authorized email
    email: {{.CloudflareEmail}}
    # -- cloudflare authorized secret token
    secretToken: {{.CloudflareSecretToken}}

  # -- list of all SANs (Subject Alternative Names) for which wildcard certs should be created
  domains: 
    {{- range $v := splitList "," .Domains }}
    - {{$v| squote |}}
    {{- end}}


cert-manager:
  install: true
  installCRDs: false

  extraArgs:
    - "--dns01-recursive-nameservers-only"
    - "--dns01-recursive-nameservers=1.1.1.1:53,8.8.8.8:53"

  startupapicheck:
    # -- whether to enable startupapicheck, disabling it by default as it unnecessarily increases chart installation time
    enabled: false

  tolerations: *tolerations
  nodeSelector: *nodeSelector

  podLabels: *podLabels

  resources:
    limits:
      cpu: 80m
      memory: 120Mi
    requests:
      cpu: 40m
      memory: 120Mi

  webhook:
    podLabels: *podLabels
    resources:
      limits:
        cpu: 60m
        memory: 60Mi
      requests:
        cpu: 30m
        memory: 60Mi

  cainjector:
    podLabels: *podLabels
    resources:
      limits:
        cpu: 120m
        memory: 200Mi
      requests:
        cpu: 80m
        memory: 200Mi

ingress-nginx:
  rbac:
    create: true

  serviceAccount:
    create: true

  controller:
    kind: DaemonSet
    hostNetwork: true
    hostPort:
      enabled: true
      ports:
        http: 80
        https: 443
        healthz: 10254

    dnsPolicy: ClusterFirstWithHostNet

    ingressClassByName: true
    ingressClass: {{.IngressClassName}}
    electionID: {{.IngressClassName}}
    ingressClassResource:
      enabled: true
      name: "{{.IngressClassName}}"
      controllerValue: "k8s.io/{{.IngressClassName}}"

    service:
      type: "ClusterIP"

    extraArgs:
      default-ssl-certificate: "{{.WildcardCertNamespace}}/{{.WildcardCertName}}-tls"

    resources:
      requests:
        cpu: 100m
        memory: 200Mi

    nodeSelector: *nodeSelector

    tolerations: *tolerations

    admissionWebhooks:
      enabled: false
      failurePolicy: Ignore

