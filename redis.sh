source common.sh

print_head "setup Redis Repo"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${LOG}
status_check

print_head "ENABLE Redis Package 6.2 Stream"
dnf module enable redis:remi-6.2 -y &>>${LOG}
status_check

print_head " Install Redis"
yum install redis -y &>>${LOG}
status_checks

print_head "Update Redis Listen Address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf &>>${LOG}
status_check

print_head "Enable Redis Service"
systemctl enable redis &>>${LOG}
status_check

print_head "Start Redis Service"
systemctl start redis &>>${LOG}
status_check