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

	@echo "==> Triggering Systemd User Service for Backend Staging..."
	systemctl --user daemon-reload
	systemctl --user restart study-web-be-staging
	@sleep 2
	@podman ps | grep studyweb-backend-staging

be-prod:
	@echo ">> Pulling backend image"
	podman pull ghcr.io/cus-study-web/backend:latest

	@echo "==> Triggering Systemd User Service for Backend Production..."
	systemctl --user daemon-reload
	systemctl --user restart study-web-be-production
	@sleep 2
	@podman ps | grep studyweb-backend

infra:
	@echo ">> Checking staging infrastructure..."
	@if [ "$$(podman inspect -f '{{.State.Running}}' studyweb-postgres 2>/dev/null)" = "true" ] && \
	    [ "$$(podman inspect -f '{{.State.Running}}' studyweb-redis 2>/dev/null)" = "true" ]; then \
		echo ">> PostgreSQL and Redis are already running."; \
	else \
		echo ">> Infrastructure is missing or stopped. Triggering Systemd User Service..."; \
		systemctl --user daemon-reload; \
		systemctl --user start study-web-infra; \
	fi
