apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: {{.Values.clusterIssuer.name}}
spec:
  acme:
    email: {{.Values.clusterIssuer.acmeEmail}}
    privateKeySecretRef:
      name: {{.Values.clusterIssuer.name}}
    server: https://acme-v02.api.letsencrypt.org/directory
    solvers:
      {{- if .Values.cloudflareWildcardCert.create}}
      - dns01:
          cloudflare:
            email: {{.Values.cloudflareWildcardCert.cloudflareCreds.email}}
            apiTokenSecretRef:
              name: {{.Values.cloudflareWildcardCert.name}}-cf-api-token
              key: api-token
        selector:
          dnsNames:
            {{- range $v := .Values.cloudflareWildcardCert.domains}}
            - {{$v | squote}}
            {{- end }}
      {{- end}}
      - http01:
          ingress:
            class: "{{.Values.ingressClass}}"
