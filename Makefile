fe-prod:
	rm -rf /run/user/1000/netns/* /run/user/1000/libpod/tmp/* || true
	podman system migrate || true
	podman rm -f study-web-fe || true
	podman compose -f docker.fe.prod.compose.yml pull
	podman compose -f docker.fe.prod.compose.yml up -d

fe-staging:
	rm -rf /run/user/1000/netns/* /run/user/1000/libpod/tmp/* || true
	podman system migrate || true
	podman rm -f study-web-fe-staging || true
	podman compose -p study-web-fe-staging -f docker.fe.staging.compose.yml pull
	podman compose -p study-web-fe-staging -f docker.fe.staging.compose.yml up -d
