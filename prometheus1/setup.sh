#!/bin/bash

if [ ! -d prometheus-1.8.2.linux-amd64 ];then
    wget https://github.com/prometheus/prometheus/releases/download/v1.8.2/prometheus-1.8.2.linux-amd64.tar.gz
    tar xzf prometheus-1.8.2.linux-amd64.tar.gz
    rm -f prometheus-1.8.2.linux-amd64.tar.gz
fi

if [ ! -d grafana-5.1.2 ];then
    wget https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-5.1.2.linux-x64.tar.gz 
    tar xzf grafana-5.1.2.linux-x64.tar.gz 
    rm -f grafana-5.1.2.linux-x64.tar.gz 
fi

if [ ! -d grafana-5.1.2/dashboards ];then
    mkdir -p grafana-5.1.2/dashboards 
    curl -Ls https://github.com/making/demo-micrometer/raw/master/grafana/micrometer-summary-cf.json | sed 's/\${DS_PROMETHEUS}/prometheus/g' > grafana-5.1.2/dashboards/micrometer-summary-cf.json
    curl -Ls https://github.com/making/demo-micrometer/raw/master/grafana/micrometer-ux-cf.json | sed 's/\${DS_PROMETHEUS}/prometheus/g' > grafana-5.1.2/dashboards/micrometer-ux-cf.json
fi

cp ../prometheus.yml prometheus-1.8.2.linux-amd64/prometheus-cf.yml

sed -e 's|^http_port = 3000$|http_port = 8080|' grafana-5.1.2/conf/defaults.ini > grafana-5.1.2/conf/grafana-cf.ini

cat <<EOF > grafana-5.1.2/conf/provisioning/datasources/prometheus.yml
apiVersion: 1
datasources:
- name: prometheus
  type: prometheus
  access: proxy
  orgId: 1
  url: http://prometheus1.apps.internal:8080
  password:
  basicAuth: false
  isDefault: true
  version: 1
  editable: true
EOF

cat <<EOF > grafana-5.1.2/conf/provisioning/dashboards/micrometer.yml
apiVersion: 1

providers:
- name: 'micrometer'
  orgId: 1
  folder: ''
  type: file
  options:
    path: /home/vcap/app/dashboards
EOF