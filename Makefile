fe:
	podman compose -f docker.fe.prod.compose.yml pull
	podman compose -f docker.fe.prod.compose.yml up -d
