source common.sh

if [ -z "${roboshop_rabbitmq_password}" ]; then
  echo " Variable roboshop_rabbitmq_password is not valid"
  exit
fi

print_head "Configuring Erlang YUM Repo"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>${LOG}
status_check


print_head "Configuring Rabbitmq Repo"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${LOG}
status_check


print_head "Install Erlang and Rabbitmq"
yum install erlang rabbitmq-server -y &>>${LOG}
status_check


print_head "Enable Rabbitmq"
systemctl enable rabbitmq-server &>>${LOG}
status_check


print_head "start rabbitmq"
systemctl start rabbitmq-server &>>${LOG}
status_check


print_head "Add Application user"
rabbitmqctl add_user roboshop ${roboshop_rabbitmq_password} &>>${LOG}
status_check


print_head "User tags"
rabbitmqctl set_user_tags roboshop administrator &>>${LOG}
status_check


print_head "Add Permissions"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
status_check