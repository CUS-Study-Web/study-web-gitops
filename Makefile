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

	@echo ">> Recreating backend"
	podman-compose -f docker.be.staging.compose.yml \
		--env-file backend.env \
		up -d --force-recreate

be-prod:
	@echo ">> Pulling backend image"
	podman pull ghcr.io/cus-study-web/backend:latest

	@echo ">> Recreating backend"
	podman-compose -f docker.be.prod.compose.yml \
		--env-file backend.env \
		up -d --force-recreate

infra:
	@echo ">> Checking staging infrastructure..."
	@if [ "$$(podman inspect -f '{{.State.Running}}' studyweb-postgres 2>/dev/null)" = "true" ] && \
	    [ "$$(podman inspect -f '{{.State.Running}}' studyweb-redis 2>/dev/null)" = "true" ]; then \
		echo ">> PostgreSQL and Redis are already running."; \
	else \
		echo ">> Infrastructure is missing or stopped. Starting..."; \
		podman-compose -f docker.infra.compose.yml \
			--env-file backend.env \
			up -d postgres redis; \
	fi
