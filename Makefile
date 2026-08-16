IMAGE_BASE ?= ghcr.io/cus-study-web/frontend
IMAGE_TAG ?= latest

fe-prod:
	podman system migrate || true
	podman rm -f study-web-fe 2>/dev/null || true
	podman pull $(IMAGE_BASE):$(IMAGE_TAG)
	podman run -d --name study-web-fe --net slirp4netns -p 8081:80 --restart unless-stopped $(IMAGE_BASE):$(IMAGE_TAG)

fe-staging:
	podman system migrate || true
	podman rm -f study-web-fe-staging 2>/dev/null || true
	podman pull $(IMAGE_BASE):staging
	podman run -d --name study-web-fe-staging --net slirp4netns -p 8080:80 --restart unless-stopped $(IMAGE_BASE):staging