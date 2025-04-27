#!/bin/bash

read -p "Server User: " server_user
read -p "Server Address: " server_address
read -p "Agent User: " agent_user
read -p "Agent Address: " agent_address

node_token=$(
    ssh \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        $server_user@$server_address \
        'sudo cat /var/lib/rancher/k3s/server/node-token'
)

ssh \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    $agent_user@$agent_address \
    "curl -sfL https://get.k3s.io | K3S_URL=https://$server_address:6443 K3S_TOKEN=$node_token sh -"


