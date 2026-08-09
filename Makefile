fe-prod:
	podman compose -f docker.fe.prod.compose.yml pull
	podman compose -f docker.fe.prod.compose.yml up -d

fe-staging:
	podman compose -p study-web-fe-staging -f docker.fe.staging.compose.yml down || true
	podman compose -p study-web-fe-staging -f docker.fe.staging.compose.yml pull
	podman compose -p study-web-fe-staging -f docker.fe.staging.compose.yml up -d
