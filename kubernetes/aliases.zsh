alias k="kubectl"

k-secrets() {
	kubectl get secret -A -l "app.kubernetes.io/name=$1" -oyaml | yq '.items.[].data | . |= map_values(@base64d)'
}
