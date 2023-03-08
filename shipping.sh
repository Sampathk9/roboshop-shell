source common.sh

if [ -z "${root_mysql_password}" ]; then
  echo "Variable root_mysql_password is needed"
  exit
fi

compenent=shipping
schema_load=true
schema_type=mysql

MAVEN
