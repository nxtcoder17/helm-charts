apiVersion: v1
kind: Service
metadata:
  name: nginx
  namespace: {{.Release.Namespace}}
spec:
  type: ClusterIP
  ports:
    - port: 80
      targetPort: 80
      protocol: TCP
      name: http
  selector:
    app: nginx
