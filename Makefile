fe-prod:
	podman compose -f docker.fe.prod.compose.yml pull
	podman compose -f docker.fe.prod.compose.yml up -d

fe-staging:
	podman system migrate || true
	podman rm -f study-web-fe-staging || true
	podman compose -p study-web-fe-staging -f docker.fe.staging.compose.yml pull
	podman compose -p study-web-fe-staging -f docker.fe.staging.compose.yml up -d
