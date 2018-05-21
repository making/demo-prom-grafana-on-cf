#!/bin/bash
set -e

# Push Prometheus2
cf push prometheus2 -b binary_buildpack -c './prometheus --web.listen-address=:8080 --config.file=./prometheus-cf.yml' -m 128m --random-route -p prometheus-2.2.1.linux-amd64
cf map-route prometheus2 apps.internal -n prometheus2
cf add-network-policy prometheus2 --destination-app demo-micrometer --protocol tcp --port 8080
cf add-network-policy prometheus2 --destination-app tweet-micrometer --protocol tcp --port 8080

# Push Grafana5
cf push grafana5-for-prom2 -b binary_buildpack -c './bin/grafana-server -config=./conf/grafana-cf.ini' -m 128m  --random-route -p grafana-5.1.2
cf add-network-policy grafana5-for-prom2 --destination-app prometheus2 --protocol tcp --port 8080
