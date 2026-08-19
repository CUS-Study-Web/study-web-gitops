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
	@echo ">> Triggering Systemd Service for Staging..."
	systemctl --user daemon-reload
	systemctl --user restart study-web-be-staging
	@sleep 2
	@podman ps | grep studyweb-backend-staging || true

be-prod:
	@echo ">> Pulling backend image"
	podman pull ghcr.io/cus-study-web/backend:latest
	@echo ">> Triggering Systemd Service for Production..."
	systemctl --user daemon-reload
	systemctl --user restart study-web-be-production
	@sleep 2
	@podman ps | grep studyweb-backend || true

infra:
	@echo ">> Ensuring infrastructure is running..."
	systemctl --user daemon-reload
	systemctl --user start study-web-infra
	@sleep 2
	@podman ps | grep studyweb-postgres || true
