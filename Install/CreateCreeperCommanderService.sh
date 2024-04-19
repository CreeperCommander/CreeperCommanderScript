#!/bin/bash

sudo useradd -r -s /bin/false creeper_commander_user


sudo tee /etc/systemd/system/creeper_commander.service > /dev/null <<EOF
[Unit]
Description=Creeper Commander Service
After=network.target

[Service]
ExecStart=/usr/bin/docker run hello-world
Restart=on-failure
User=creeper_commander_user

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload

sudo systemctl enable --now creeper_commander.service
