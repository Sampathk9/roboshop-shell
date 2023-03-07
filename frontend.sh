script_location=$(pwd)

echo -e "\e[35m Install Nginx\e[0m"
yum install nginx -y
systemctl enable nginx
systemctl start nginx
echo -e "\e[35m Remove Nginx old content \e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[35m Download Frontend content \e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
echo -e "\e[35m Extract frontend content \e[0m"
unzip /tmp/frontend.zip

echo -e "\e[35m Copy roboshop Nginx config file\e[0m"
cp ${script_location}/Files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf
echo start Nginx
systemctl  restart nginx