source common.sh
#stops where the error is
#set -e
echo -e "\e[35m Configuring Nodejs repo \e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check


echo -e "\e[35m Install Nodejs \e[0m"
yum install nodejs -y &>>${LOG}
status_check

echo -e "\e[35m Add Application User \e[0m"
id roboshop &>>${LOG}
if [ $? -ne 0 ]; then
 useradd roboshop &>>${LOG}
fi
status_check

echo -e "\e[35m Makes a new directory \e[0m"
#-p skips if directory exists if not it creates a directory
mkdir -p /app &>>${LOG}
status_check

echo -e "\e[35m Downloading App Content \e[0m"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
status_check

echo -e "\e[35m Cleanup content \e[0m"
rm -rf /app/* &>>${LOG}
status_check

echo -e "\e[35m Extracting Zip File \e[0m"
cd /app
unzip /tmp/catalogue.zip &>>${LOG}
status_check

echo -e "\e[35m Installing Nodejs Dependencies \e[0m"
cd /app &>>${LOG}
npm install &>>${LOG}
status_check

echo -e "\e[35m Configuring Catalog service file \e[0m"
cp ${script_location}/Files/catalogue.service /etc/systemd/system.catalogue.service &>>${LOG}
status_check


echo -e "\e[35m Reload System \e[0m"
systemctl daemon-reload &>>${LOG}
status_check

echo -e "\e[35m Enable service \e[0m"
systemctl enable catalogue &>>${LOG}
status_check

echo -e "\e[35m start catalogue service \e[0m"
systemctl restart catalogue &>>${LOG}
status_check

echo -e "\e[35m Configuring mongodb \e[0m"
cp ${script_location}/Files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
status_check

echo -e "\e[35m Installing Mongo client \e[0m"
yum install mongodb-org-shell -y &>>${LOG}
status_check

echo -e "\e[35m Load schema \e[0m"
mongo --host mongodb-dev.sampathkumar.online </app/schema/catalogue.js &>>${LOG}
status_check