source common.sh

component=payment
schema_load=false

if [ -z "${roboshop_rabbitmq_password}" ]; then
  echo " Variable roboshop_rabbitmq_password is not valid"
  exit
fi

PYTHON
