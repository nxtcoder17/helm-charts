apiVersion: v1
kind: Secret
metadata:
  name: {{.Values.cloudflareWildcardCert.name}}-cf-api-token
  namespace: {{.Release.Namespace}}
stringData:
  api-token: {{.Values.cloudflareWildcardCert.cloudflareCreds.secretToken}}


