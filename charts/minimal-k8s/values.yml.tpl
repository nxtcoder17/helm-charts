nodeSelector: &nodeSelector {}
tolerations: &tolerations []
podLabels: &podLabels {}

ingressClass: {{.IngressClassName}}

clusterIssuer:
  name: cluster-issuer
  acmeEmail: {{.AcmeEmail}}

cloudflareWildcardCert:
  enabled: false
  name: &cfCertName {{.WildcardCertName}}
  email: {{.CloudflareEmail}}
  secretRef:
    name: *cfCertName
    key: api-token
  domains: 
    {{- range $v := splitList "," .Domains }}
    - {{$v| squote |}}
    {{- end}}

cert-manager:
  installCRDs: true

  extraArgs:
    - "--dns01-recursive-nameservers-only"
    - "--dns01-recursive-nameservers=1.1.1.1:53,8.8.8.8:53"

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
  nameOverride: {{.ingressNginxName}}
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
      default-ssl-certificate: "{{.WildcardCertNamespace}}/{{.WildcardCertName}}"

    resources:
      requests:
        cpu: 100m
        memory: 200Mi

    nodeSelector: *nodeSelector

    tolerations: *tolerations

    admissionWebhooks:
      enabled: false
      failurePolicy: Ignore

