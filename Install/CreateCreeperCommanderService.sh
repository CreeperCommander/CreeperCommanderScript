#!/bin/bash

sudo useradd -r -s /bin/false creeper_commander_user

sudo tee /etc/systemd/system/creeper_commander.service > /dev/null <<EOF
[Unit]
Description=Creeper Commander Service
After=network.target

[Service]
ExecStart=/usr/bin/npm run start
WorkingDirectory=$CREEPER_COMMANDER_DIR/start.sh
Restart=always
User=creeper_commander_user

[Install]
WantedBy=multi-user.target
EOF



sudo tee $CREEPER_COMMANDER_DIR/start.sh > /dev/null <<EOF
cd $CREEPER_COMMANDER_DIR/CreeperCommanderWebsite
npm run start
EOF

sudo chown -R creeper_commander_user:creeper_commander_user $CREEPER_COMMANDER_DIR
sudo chown -R creeper_commander_user:creeper_commander_user /usr/bin/npm
sudo chown -R creeper_commander_user:creeper_commander_user /usr/bin/node
sudo chmod -R 777 $NVM_DIR
sudo chmod -R 777 $CREEPER_COMMANDER_DIR
sudo chmod +x /home/albanagisa/.nvm/versions/node/v20.11.1/bin/npm

sudo systemctl daemon-reload

sudo systemctl enable --now creeper_commander.service
