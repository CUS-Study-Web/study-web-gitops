fe-prod:
	podman system migrate || true
	podman rm -f study-web-fe || true
	podman pull ghcr.io/cus-study-web/frontend:latest
	podman run -d --name study-web-fe --net slirp4netns -p 8081:80 --restart unless-stopped ghcr.io/cus-study-web/frontend:latest

fe-staging:
	podman system migrate || true
	podman rm -f study-web-fe-staging || true
	podman pull ghcr.io/cus-study-web/frontend:staging
	podman run -d --name study-web-fe-staging --net slirp4netns -p 8080:80 --restart unless-stopped ghcr.io/cus-study-web/frontend:staging
