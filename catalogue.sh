source common.sh

schema_type=mongo
#stops where the error is
#set -e
echo -e "\e[31m Configuring Nodejs repo \e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check


echo -e "\e[31m Install Nodejs \e[0m"
yum install nodejs -y &>>${LOG}
status_check

echo -e "\e[31m Add Application User \e[0m"
id roboshop &>>${LOG}
if [ $? -ne 0 ]; then
 useradd roboshop &>>${LOG}
fi
status_check

echo -e "\e[31m Makes a new directory \e[0m"
#-p skips if directory exists if not it creates a directory
mkdir -p /app &>>${LOG}
status_check

echo -e "\e[31m Downloading App Content \e[0m"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
status_check

echo -e "\e[31m Cleanup content \e[0m"
rm -rf /app/* &>>${LOG}
status_check

echo -e "\e[31m Extracting Zip File \e[0m"
cd /app
unzip /tmp/catalogue.zip &>>${LOG}
status_check

echo -e "\e[31m Installing Nodejs Dependencies \e[0m"
npm install &>>${LOG}
status_check

echo -e "\e[31m Configuring Catalog service file \e[0m"
cp ${script_location}/Files/catalogue.service /etc/systemd/system/catalogue.service &>>${LOG}
status_check


echo -e "\e[31m Reload System \e[0m"
systemctl daemon-reload &>>${LOG}
status_check

echo -e "\e[31m Enable Service \e[0m"
#catalog was misplaced as catalogue before and it was not working earlier. issue resolved after replacing catalogue with catalog
systemctl enable catalog &>>${LOG}
status_check


echo -e "\e[31m start catalogue service \e[0m"
systemctl start catalog &>>${LOG}
status_check

echo -e "\e[31m Configuring mongodb \e[0m"
cp ${script_location}/Files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
status_check

echo -e "\e[31m Installing Mongo client \e[0m"
yum install mongodb-org-shell -y &>>${LOG}
status_check

echo -e "\e[31m Load schema \e[0m"
mongo --host mongodb-dev.sampathkumar.online </app/schema/catalogue.js &>>${LOG}
status_check