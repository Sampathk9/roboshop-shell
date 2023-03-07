script_location=$(pwd)
#stops where the error is
#set -e

curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y

useradd roboshop
#-p skips if directory exists if not it creates a directory
mkdir -p /app
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
rm -rf /app/*
cd /app
unzip /tmp/catalogue.zip

cd /app
npm install

cp ${script_location}/Files/catalogue.service /etc/systemd/system.catalogue.service
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue

cp ${script_location}/Files/mongodb.repo /etc/yum.repos.d/mongodb.repo
yum install mongidb-org-shell -y

mongo --host mongodb-dev.sampathkumar.online </app/schema/catalogue.js