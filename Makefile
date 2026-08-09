fe-prod:
	rm -rf /run/user/1000/netns/* /run/user/1000/libpod/tmp/* || true
	podman system migrate || true
	podman rm -f study-web-fe || true
	podman pull ghcr.io/cus-study-web/frontend:latest
	podman run -d --name study-web-fe --net slirp4netns -p 8081:80 --restart unless-stopped ghcr.io/cus-study-web/frontend:latest

fe-staging:
	rm -rf /run/user/1000/netns/* /run/user/1000/libpod/tmp/* || true
	podman system migrate || true
	podman rm -f study-web-fe-staging || true
	podman pull ghcr.io/cus-study-web/frontend:staging
	podman run -d --name study-web-fe-staging --net slirp4netns -p 8080:80 --restart unless-stopped ghcr.io/cus-study-web/frontend:staging
