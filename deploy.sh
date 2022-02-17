#!/bin/bash

function add_repo {
    local repo_name $1
    local repo_url $2
    
    repos=$(helm repo list | grep "$repo_name" )

    if [ -z $repos ]; then
        helm repo add "$repo_name" "$repo_url"
    fi

    ## Update repositories
    helm repo update
}

function install_chart {
    local release_name=$1
    local chart_name=$2
    local values_file=$3
    local namespace=$4

    helm upgrade  -f "$values_file" \
        --install \
        --atomic \
        --dependency-update \
        --create-namespace \
        --namespace "$namespace" \
        "$release_name" "$chart_name"
}

add_repo 'prometheus-community' 'https://prometheus-community.github.io/helm-charts'

## Install prometheus
install_chart 'prometheus' 'prometheus-community/prometheus' 'prometheus-values.yaml' 'prometheus'

## Install blackbox-exporter
install_chart 'blackbox-exporter' 'prometheus-community/prometheus-blackbox-exporter' 'blackbox-values.yaml' 'prometheus'
