#!/bin/bash
set -e

# Push Prometheus2
cf push -f manifest-prometheus2.yml
cf map-route prometheus2 apps.internal -n prometheus2
cf add-network-policy prometheus2 --destination-app demo-micrometer --protocol tcp --port 8080
cf add-network-policy prometheus2 --destination-app tweet-micrometer --protocol tcp --port 8080

# Push Grafana5
cf push -f manifest-grafana5-for-prom2.yml
cf add-network-policy grafana5-for-prom2 --destination-app prometheus2 --protocol tcp --port 8080
