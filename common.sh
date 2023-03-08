script_location=$(pwd)
LOG=/tmp/roboshop.log


status_check()
{
  if [ $? -eq 0 ];
  then
    echo -e "\e[34mSuccess\e[0m"
  else echo -e "\e[36mFail\e[0m"
  echo " refer log file for more information log file is in ${LOG}"
  exit
  fi
}

print_head()
 {

  echo -e "\e[1m $1 \e[0m"

}

NODEJS() {
  source common.sh
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
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${LOG}
  status_check
  
  echo -e "\e[31m Cleanup content \e[0m"
  rm -rf /app/* &>>${LOG}
  status_check
  
  echo -e "\e[31m Extracting Zip File \e[0m"
  cd /app
  unzip /tmp/${component}.zip &>>${LOG}
  status_check
  
  echo -e "\e[31m Installing Nodejs Dependencies \e[0m"
  npm install &>>${LOG}
  status_check
  
  echo -e "\e[31m Configuring ${component} service file \e[0m"
  cp ${script_location}/Files/${component}.service /etc/systemd/system/${component}.service &>>${LOG}
  status_check
  
  
  echo -e "\e[31m Reload System \e[0m"
  systemctl daemon-reload &>>${LOG}
  status_check
  
  echo -e "\e[31m Enable ${component} Service \e[0m"
  systemctl enable ${component} &>>${LOG}
  status_check
  
  
  echo -e "\e[31m start ${component} service \e[0m"
  systemctl start ${component} &>>${LOG}
  status_check

  if [ ${schema_load} == "true" ]; then
  echo -e "\e[31m Configuring mongodb \e[0m"
  cp ${script_location}/Files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
  status_check
  
  echo -e "\e[31m Installing Mongo client \e[0m"
  yum install mongodb-org-shell -y &>>${LOG}
  status_check
  
  echo -e "\e[31m Load schema \e[0m"
  mongo --host mongodb-dev.sampathkumar.online </app/schema/${component}.js &>>${LOG}
  status_check
  fi
  
}