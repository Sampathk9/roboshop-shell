script_location=$(pwd)
LOG=/tmp/roboshop.log
#stops where the error is
#set -e
echo -e "\e[35m Configuring Nodejs repo \e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
if [ $? -eq 0 ]
then
  echo success
else echo fail
fi


echo -e "\e[35m Install Nodejs \e[0m"
yum install nodejs -y &>>${LOG}
if [ $? -eq 0 ]
then
  echo success
else echo fail
fi


echo -e "\e[35m Add Application User \e[0m"
useradd roboshop &>>${LOG}
if [ $? -eq 0 ]
then
  echo success
else echo fail
fi

#-p skips if directory exists if not it creates a directory
mkdir -p /app &>>${LOG}
if [ $? -eq 0 ]
then
  echo success
else echo fail
fi


echo -e "\e[35m Downloading App Content \e[0m"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}

if [ $? -eq 0 ]
then
  echo success
else echo fail
fi

echo -e "\e[35m Cleanup content \e[0m"
rm -rf /app/* &>>${LOG}

if [ $? -eq 0 ]
then
  echo success
else echo fail
fi


echo -e "\e[35m Extracting Zip File \e[0m"
cd /app
unzip /tmp/catalogue.zip &>>${LOG}

if [ $? -eq 0 ]
then
  echo success
else echo fail
fi



echo -e "\e[35m Installing Nodejs Dependencies \e[0m"
cd /app &>>${LOG}
npm install &>>${LOG}
if [ $? -eq 0 ]
then
  echo success
else echo fail
fi


echo -e "\e[35m Configuring Catalog service file \e[0m"
cp ${script_location}/Files/catalogue.service /etc/systemd/system.catalogue.service &>>${LOG}

if [ $? -eq 0 ]
then
  echo success
else echo fail
fi


echo -e "\e[35m Reload System \e[0m"
systemctl daemon-reload &>>${LOG}

if [ $? -eq 0 ]
then
  echo success
else echo fail
fi


echo -e "\e[35m Enable service \e[0m"
systemctl enable catalogue &>>${LOG}
if [ $? -eq 0 ]
then
  echo success
else echo fail
fi


echo -e "\e[35m start catalogue service \e[0m"
systemctl start catalogue &>>${LOG}
if [ $? -eq 0 ]
then
  echo success
else echo fail
fi


echo -e "\e[35m Configuring mongodb \e[0m"
cp ${script_location}/Files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
if [ $? -eq 0 ]
then
  echo success
else echo fail
fi


echo -e "\e[35m Installing Mongo client \e[0m"
yum install mongodb-org-shell -y &>>${LOG}
if [ $? -eq 0 ]
then
  echo success
else echo fail
fi



echo -e "\e[35m Load schema \e[0m"
mongo --host mongodb-dev.sampathkumar.online </app/schema/catalogue.js &>>${LOG}
if [ $? -eq 0 ]
then
  echo success
else echo fail
fi
