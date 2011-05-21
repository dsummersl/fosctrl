#!/bin/sh

################################################################################
# variables:

user="user"
password="user"
host="host.com"

################################################################################

set -e
#set -x

curl="curl -s -u$user:$password http://$host/"

# commands:
move="${curl}decoder_control.cgi?command="
# where command = 
#-----
#0 up
#1 Stop up
#2 down
#3 Stop down
#4 left
#5 Stop left
#6 right
#7 Stop right
#25 center
#26 Vertical patrol
#27 Stop vertical patrol
#28 Horizon patrol
#29 Stop horizon patrol
#94 IO output high
#95 IO output lo
#-----

flipandmirror="${curl}camera_control.cgi?param=5&value=3"

if [[ -z "$1" ]]
then
  # center:
  echo "Camera IP control"
  echo "-----------------"
  echo ""
  echo "Commands:"
  echo "  left : go left one second"
  echo " right : go right one second"
  echo "    up : go up one second"
  echo "  down : go down one second"
  echo "center : center the camera"
  exit 0
else
  command=$1
fi

if [[ "$1" == "flip" ]]
then
  test `$flipandmirror` == 'ok.'
elif [[ "$1" == "up" ]]
then
  test `${move}0` == 'ok.'
  sleep 1
  test `${move}1` == 'ok.'
elif [[ "$1" == "down" ]]
then
  test `${move}2` == 'ok.'
  sleep 1
  test `${move}3` == 'ok.'
elif [[ "$1" == "right" ]]
then
  test `${move}6` == 'ok.'
  sleep 1
  test `${move}7` == 'ok.'
elif [[ "$1" == "left" ]]
then
  test `${move}4` == 'ok.'
  sleep 1
  test `${move}5` == 'ok.'
else
  center="${move}${command}"
  test `$center` == 'ok.'
fi
