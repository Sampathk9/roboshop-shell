source common.sh

print_head "Copying MongoDB repo file"
cp ${script_location}/Files/mongodb.repo /etc/yum.repos.d/mongodb.repo
status_check

print_head "Install MondoDb"
yum install mongodb-org -y
status_check

print_head "Updating MongoDB address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
status_check

print_head "Enable MongoDB"
systemctl enable mongod
status_check

print_head "Restart MongoDB"
systemctl restart mongod
status_check