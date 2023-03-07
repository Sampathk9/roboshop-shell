script_location=$(pwd)

#log is where log's are stored
LOG=/tmp/roboshop.log
echo -e "\e[35m Install Nginx\e[0m"
yum install nginx -y   &>>${LOG}
if [ $? -eq 0 ]
then
  echo success
else echo fail
fi




echo -e "\e[35m Remove Nginx old content \e[0m"
rm -rf /usr/share/nginx/html/*  &>>${LOG}
if [ $? -eq 0 ]
then
  echo success
else echo fail
fi

echo -e "\e[35m Download Frontend content \e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}
if [ $? -eq 0 ]
then
  echo success
else echo fail
fi



cd /usr/share/nginx/html &>>${LOG}

echo -e "\e[35m Extract frontend content \e[0m"
unzip /tmp/frontend.zip  &>>${LOG}
if [ $? -eq 0 ]
then
  echo success
else echo fail
fi



echo -e "\e[35m Copy roboshop Nginx config file\e[0m"
cp ${script_location}/Files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${LOG}
 if [ $? -eq 0 ]
 then
   echo success
 else echo fail
 fi




echo -e "\e[35m Enabled Nginx \e[0m"
systemctl  enable nginx
if [ $? -eq 0 ]
then
  echo success
else echo fail
fi


echo -e "\e[35m Started Nginx \e[0m"
systemctl  restart nginx
if [ $? -eq 0 ]
then
  echo success
else echo fail
fi