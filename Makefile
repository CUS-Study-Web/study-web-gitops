IMAGE_BASE ?= ghcr.io/cus-study-web/frontend
IMAGE_TAG ?= staging

fe-prod:
	podman system migrate || true
	podman rm -f study-web-fe 2>/dev/null || true
	podman pull $(IMAGE_BASE):$(IMAGE_TAG)
	podman run -d --name study-web-fe --net slirp4netns -p 8081:80 --restart unless-stopped $(IMAGE_BASE):$(IMAGE_TAG)

fe-staging:
	@echo "==> Pulling image..."
	podman rm -f study-web-fe-staging 2>/dev/null || true
	podman pull $(IMAGE_BASE):$(IMAGE_TAG)
	@echo "==> Spawning container detached from runner cgroup..."
	nohup podman run -d \
		--name study-web-fe-staging \
		--net slirp4netns \
		--cgroup-manager=cgroupfs \
		-p 8080:80 \
		--restart unless-stopped \
		$(IMAGE_BASE):$(IMAGE_TAG) > /dev/null 2>&1 &
	@sleep 2
	@podman ps | grep study-web-fe-staging