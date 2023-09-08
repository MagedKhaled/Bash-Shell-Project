#!/bin/bash

source ddl_functions.sh
source connectDB.sh


while true 
do
echo '1)Create Database'
echo '2)List Database'
echo '3)Connect To Databases'
echo '4)Drop Database'
echo '5)Exit'


read -p "Make Your Choice: " inp
case $inp in 
1) clear;createDB ;;
2) clear;listDB ;;
3) clear;connecteDB ;;
4) clear;dropDB ;;
5) break ;;
*) echo invald choice;;
esac

read -p "Press Enter To Continue " inp
clear
done
