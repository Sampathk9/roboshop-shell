source common.sh

print_head "Install Nginx"
yum install nginx -y   &>>${LOG}
status_check

echo -e "\e[35m Remove Nginx old content \e[0m"
rm -rf /usr/share/nginx/html/*  &>>${LOG}
status_check

echo -e "\e[35m Download Frontend content \e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}
status_check

cd /usr/share/nginx/html &>>${LOG}

echo -e "\e[35m Extract frontend content \e[0m"
unzip /tmp/frontend.zip  &>>${LOG}
status_check

echo -e "\e[35m Copy roboshop Nginx config file\e[0m"
cp ${script_location}/Files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${LOG}
status_check

echo -e "\e[35m Enabled Nginx \e[0m"
systemctl  enable nginx
status_check


echo -e "\e[35m Started Nginx \e[0m"
systemctl  restart nginx
status_check