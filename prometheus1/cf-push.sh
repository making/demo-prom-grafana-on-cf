#!/bin/bash
set -e

# Push Promtheus1
cf push -f manifest-prometheus1.yml
cf map-route prometheus1 apps.internal -n prometheus1
cf add-network-policy prometheus1 --destination-app demo-micrometer --protocol tcp --port 8080
cf add-network-policy prometheus1 --destination-app tweet-micrometer --protocol tcp --port 8080

# Push Grafana5
cf push -f manifest-grafana5-for-prom1.yml
cf add-network-policy grafana5-for-prom1 --destination-app prometheus1 --protocol tcp --port 8080