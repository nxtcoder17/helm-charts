apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  namespace: {{.Release.Namespace}}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      annotations: {{.Values.podAnnotations | toJson }}
      labels:
        {{ .Values.podLabels | toYaml | nindent 8 }}
        app: nginx
    spec:
      containers:
        - name: "nginx"
          image: '{{.Values.nginx.image.repository}}:{{.Values.nginx.image.tag}}'
          imagePullPolicy: '{{ .Values.nginx.image.pullPolicy | default "Always" }}'
