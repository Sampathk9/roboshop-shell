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

print_head{

  echo -e ""\e[1m $1 \e[0m"

}