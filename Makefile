fe-staging:
	@echo "==> Copying systemd service file..."
	mkdir -p /home/study-web/.config/systemd/user
	cp study-web-fe-staging.service /home/study-web/.config/systemd/user/
	@echo "==> Triggering Systemd User Service for Staging..."
	systemctl --user daemon-reload
	systemctl --user restart study-web-fe-staging
	@sleep 2
	@podman ps | grep study-web-fe-staging

fe-prod:
	@echo "==> Copying systemd service file..."
	mkdir -p /home/study-web/.config/systemd/user
	cp study-web-fe.service /home/study-web/.config/systemd/user/
	@echo "==> Triggering Systemd User Service for Production..."
	systemctl --user daemon-reload
	systemctl --user restart study-web-fe
	@sleep 2
	@podman ps | grep study-web-fe

dns-refresh:
	@echo ">> Refreshing Aardvark DNS daemon..."
	@pkill -u "$$(id -u)" aardvark-dns || true

be-staging: dns-refresh
	@echo ">> Pulling backend image"
	podman pull ghcr.io/cus-study-web/backend:staging
	@echo ">> Triggering Systemd Service for Staging..."
	systemctl --user daemon-reload
	systemctl --user restart study-web-be-staging
	@sleep 2
	@podman ps | grep studyweb-backend-staging || true

be-prod: dns-refresh
	@echo ">> Pulling backend image"
	podman pull ghcr.io/cus-study-web/backend:latest
	@echo ">> Triggering Systemd Service for Production..."
	systemctl --user daemon-reload
	systemctl --user restart study-web-be-production
	@sleep 2
	@podman ps | grep studyweb-backend || true

infra: dns-refresh
	@echo ">> Ensuring infrastructure is running..."
	systemctl --user daemon-reload
	systemctl --user start study-web-infra
	@sleep 2
	@podman ps | grep studyweb-postgres || true

nginx:
	systemctl --user daemon-reload
	systemctl --user start study-web-nginx
