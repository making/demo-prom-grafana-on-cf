#!/bin/bash
set -e

# Push Promtheus1
# cf push prometheus1 -b binary_buildpack -c './prometheus -web.listen-address=:8080 -config.file=./prometheus-cf.yml' -m 128m --random-route -p prometheus-1.8.2.linux-amd64
# cf map-route prometheus1 apps.internal -n prometheus1
# cf add-network-policy prometheus1 --destination-app demo-micrometer --protocol tcp --port 8080
# cf add-network-policy prometheus1 --destination-app tweet-micrometer --protocol tcp --port 8080

# Push Grafana5
cf push grafana5-for-prom1 -b binary_buildpack -c './bin/grafana-server -config=./conf/grafana-cf.ini' -m 128m  --random-route -p grafana-5.1.2
cf add-network-policy grafana5-for-prom1 --destination-app prometheus1 --protocol tcp --port 8080