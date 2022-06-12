#!/bin/bash -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# install mattermost https://docs.mattermost.com/install/install-tar.html
yum install -y wget
wget https://releases.mattermost.com/6.7.0/mattermost-6.7.0-linux-amd64.tar.gz
tar -xvzf mattermost*.gz
mv mattermost /opt
mkdir /opt/mattermost/data
useradd --system --user-group mattermost
chown -R mattermost:mattermost /opt/mattermost
chmod -R g+w /opt/mattermost

# install mysql client
yum remove -y mariadb-libs
yum localinstall -y https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
yum-config-manager --disable mysql80-community
yum-config-manager --enable mysql57-community
rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
yum install mysql-community-client -y

# create mattermost schema on database
set +e
mysql --host=${AURORA_HOST} --user=${AURORA_USER} --password=${AURORA_PASSWORD} << EOF
create database mattermost;
exit
EOF
set -e

# edit config
yum install -y jq
cp -a /opt/mattermost/config/config.json /opt/mattermost/config/config.json.dafault
cp -a /opt/mattermost/config/config.json temp1.json
cat temp1.json | jq '.SqlSettings.DriverName |= "mysql"' > temp2.json
cat temp2.json | jq '.SqlSettings.DataSource |= "${AURORA_USER}:${AURORA_PASSWORD}@tcp(${AURORA_HOST}:3306)/mattermost?charset=utf8mb4,utf8&writeTimeout=30s"' >temp3.json
cat temp3.json | jq '.FileSettings.DriverName |= "amazons3"' > temp4.json
cat temp4.json | jq '.FileSettings.Directory |= "/mm/mattermost-data"' > temp5.json
cat temp5.json | jq '.FileSettings.AmazonS3Bucket |= "${S3_BUCKET_NAME}"' > temp6.json
cat temp6.json | jq '.FileSettings.AmazonS3Region |= "ap-northeast-1"' > temp7.json
cat temp7.json | jq '.LocalizationSettings.DefaultServerLocale |= "ja"' > temp8.json
cat temp8.json | jq '.LocalizationSettings.DefaultClientLocale |= "ja"' > temp9.json
cp -af temp8.json /opt/mattermost/config/config.json
chown -R mattermost:mattermost /opt/mattermost/config/config.json
chmod -R g+w /opt/mattermost/config/config.json

# make mattermost daemon
cat << EOF > /lib/systemd/system/mattermost.service
[Unit]
Description=Mattermost
After=network.target
[Service]
Type=notify
ExecStart=/opt/mattermost/bin/mattermost
TimeoutStartSec=3600
KillMode=mixed
Restart=always
RestartSec=10
WorkingDirectory=/opt/mattermost
User=mattermost
Group=mattermost
LimitNOFILE=49152
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable mattermost.service
systemctl start mattermost.service
systemctl status mattermost.service

# security update
yum update -y
