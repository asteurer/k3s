#!/bin/bash

read -p "Server user: " server_user
read -p "Server address: " server_address
read -p "kubeconfig name: " config_name

mkdir -p ~/.kube

# Retrieve the KUBECONFIG file from the server, alter it, then place it in the ~/.kube directory
ssh \
	-o StrictHostKeyChecking=no \
	-o UserKnownHostsFile=/dev/null \
	$server_user@$server_address \
	'sudo cat /etc/rancher/k3s/k3s.yaml' | ADDRESS=$server_address CONFIG_NAME=$config_name python3 ./kubeconfig_edit.py > ~/.kube/$config_name.config
