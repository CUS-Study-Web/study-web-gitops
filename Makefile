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
	@echo ">> Pulling auxiliary images Postgres, Redis..."
	podman-compose -f docker.be.staging.compose.yml --env-file backend.env pull postgres redis

	@echo ">> Starting infrastructure with backend image: staging"
	podman-compose -f docker.be.staging.compose.yml --env-file backend.env up -d --force-recreate

be-prod: 
	@echo ">> Pulling backend image"
	podman pull ghcr.io/cus-study-web/backend:latest
	@echo ">> Pulling auxiliary images Postgres, Redis..."
	podman-compose -f docker.be.prod.compose.yml --env-file backend.env pull postgres redis

	@echo ">> Starting infrastructure with backend production"
	podman-compose -f docker.be.prod.compose.yml --env-file backend.env up -d --force-recreate
