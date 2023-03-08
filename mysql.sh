source common.sh

if [ -z "${root_mysql_password}" ]; then
  echo "variable root_mysql_password is missing"
 exit
fi

print_head " Disable Mysql"
dnf module disable mysql -y &>>${LOG}
status_check

print_head "copy Mysql Repo file"
cp ${script_location}/Files/mysql.repo /etc/yum.repos.d/mysql.repo &>>${LOG}
status_check

print_head "Install My Sql Server"
yum install mysql-community-server -y &>>${LOG}
status_check

print_head "Enable Mysql"
systemctl enable mysqld &>>${LOG}
status_check

print_head "Start Mysql"
systemctl restart mysqld &>>${LOG}
status_check

print_head "Reset Default Database Password"
mysql_secure_installation --set-root-pass RoboShop@1  &>>${LOG}
status_check
