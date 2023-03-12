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
      {{if .Values.cloudflareWildcardCert.enabled}}
      - dns01:
          cloudflare:
            email: {{.Values.cloudflareWildcardCert.email}}
            apiTokenSecretRef:
              name: {{.Values.cloudflareWildcardCert.secretRef.name}}
              key: {{.Values.cloudflareWildcardCert.secretRef.key}}
        selector:
          dnsNames:
            {{range $v := .Values.cloudflareWildcardCert.domains}}
            - {{$v | squote}}
            {{ end }}
      {{end}}
      - http01:
          ingress:
            class: "{{.Values.ingressClass}}"
