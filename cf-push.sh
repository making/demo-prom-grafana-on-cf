#!/bin/bash
set -e
cf push prometheus -b binary_buildpack -c './prometheus --web.listen-address=:8080 --config.file=./prometheus-cf.yml' -m 128m --random-route -p prometheus-2.2.1.linux-amd64
cf map-route prometheus apps.internal -n prometheus
cf push grafana -b binary_buildpack -c './bin/grafana-server -config=./conf/grafana-cf.ini' -m 128m  --random-route -p grafana-5.1.2
cf add-network-policy grafana --destination-app prometheus --protocol tcp --port 8080
cf add-network-policy prometheus --destination-app demo-micrometer --protocol tcp --port 8080
cf add-network-policy prometheus --destination-app tweet-micrometer --protocol tcp --port 8080
