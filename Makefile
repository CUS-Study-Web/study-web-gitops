fe-staging:
	@echo "==> Triggering Systemd User Service for Staging..."
	systemctl --user daemon-reload
	systemctl --user restart study-web-fe-staging
	@sleep 2
	@podman ps | grep study-web-fe-staging

fe-prod:
	@echo "==> Triggering Systemd User Service for Production..."
	systemctl --user daemon-reload
	systemctl --user restart study-web-fe
	@sleep 2
	@podman ps | grep study-web-fe

be-staging:
	@echo ">> Pulling backend image"
	podman pull ghcr.io/cus-study-web/backend:staging

	@echo ">> Removing old container"
	podman rm -f studyweb-backend-staging 2>/dev/null || true

	@echo ">> Recreating backend"
	systemd-run --user podman-compose -p studyweb-be-staging -f docker.be.staging.compose.yml \
		--env-file backend.env \
		up -d 

be-prod:
	@echo ">> Pulling backend image"
	podman pull ghcr.io/cus-study-web/backend:latest

	@echo ">> Removing old container"
	podman rm -f studyweb-backend 2>/dev/null || true

	@echo ">> Recreating backend"
	systemd-run --user podman-compose -p studyweb-be-prod -f docker.be.prod.compose.yml \
		--env-file backend.env \
		up -d

infra:
	@echo ">> Checking staging infrastructure..."
	@if [ "$$(podman inspect -f '{{.State.Running}}' studyweb-postgres 2>/dev/null)" = "true" ] && \
	    [ "$$(podman inspect -f '{{.State.Running}}' studyweb-redis 2>/dev/null)" = "true" ]; then \
		echo ">> PostgreSQL and Redis are already running."; \
	else \
		echo ">> Infrastructure is missing or stopped. Starting..."	; \
		systemd-run --user podman-compose -p studyweb-infra -f docker.infra.compose.yml \
			--env-file backend.env \
			up -d postgres redis; \
	fi
