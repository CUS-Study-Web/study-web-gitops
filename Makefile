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

pull-be:
	@echo ">> Pulling backend image: $(IMAGE_NAME)"
	podman pull $(IMAGE_NAME)

be: pull-be
	@echo ">> Pulling auxiliary images Postgres, Redis..."
	podman-compose -f docker-compose.backend.prod.yaml --env-file backend.env pull postgres redis

	@echo ">> Starting infrastructure with backend image: $(IMAGE_NAME)..."
	IMAGE_NAME=$(IMAGE_NAME) podman-compose -f docker-compose.backend.prod.yaml --env-file backend.env up -d --force-recreate