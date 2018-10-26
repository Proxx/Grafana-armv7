# Grafana-armv7
Dockerfile of grafana on armv7

# Grafana Docker image

## Running your Grafana container

Start your container binding the external port `3000`.

```bash
docker run -d --name=grafana -p 3000:3000 proxx/grafana-armv7
```

Try it out, default admin user is admin/admin.

## How to use the container

Further documentation can be found at http://docs.grafana.org/installation/docker/

## Dockerhub
https://hub.docker.com/r/proxx/grafana-armv7/
