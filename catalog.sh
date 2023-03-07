script_location=$(pwd)
set -e

curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y

useradd roboshop
mkdir /app
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip

cd /app
npm install

cp ${script_location}/Files/catalog.service /etc/systemd/system.catalog.service
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue