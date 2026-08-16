IMAGE_BASE ?= ghcr.io/cus-study-web/frontend
IMAGE_TAG ?= staging

fe-prod:
	@echo "==> Deploying Production..."
	podman rm -f study-web-fe 2>/dev/null || true
	podman pull $(IMAGE_BASE):$(IMAGE_TAG)
	systemd-run --user --scope podman run -d \
		--name study-web-fe \
		--net slirp4netns \
		-p 8081:80 \
		--restart unless-stopped \
		$(IMAGE_BASE):$(IMAGE_TAG)
	@sleep 2
	@podman ps | grep study-web-fe

fe-staging:
	@echo "==> Deploying Staging..."
	podman rm -f study-web-fe-staging 2>/dev/null || true
	podman pull $(IMAGE_BASE):$(IMAGE_TAG)
	systemd-run --user --scope podman run -d \
		--name study-web-fe-staging \
		--net slirp4netns \
		-p 8080:80 \
		--restart unless-stopped \
		$(IMAGE_BASE):$(IMAGE_TAG)
	@sleep 2
	@podman ps | grep study-web-fe-staging