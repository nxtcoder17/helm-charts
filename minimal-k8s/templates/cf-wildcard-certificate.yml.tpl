{{if .Values.cloudflareWildcardCert.enabled }}
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: {{.Values.cloudflareWildcardCert.name}}
  namespace: {{.Release.Namespace}}
spec:
  dnsNames:
  {{range $v := .Values.cloudflareWildcardCert.domains}}
    - {{$v|squote}}
  {{end}}
  secretName: {{.Values.cloudflareWildcardCert.name}}-tls
  issuerRef:
    name: {{.Values.clusterIssuer.Name}}
    kind: ClusterIssuer
{{end}}
