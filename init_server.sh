#!/bin/bash

read -p "Server User: " server_user
read -p "Server Address: " server_address

ssh \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    $server_user@$server_address \
    "curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC=\"--tls-san $server_address\" sh -"