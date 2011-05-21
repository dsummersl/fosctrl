#!/bin/sh

################################################################################
# variables:

user="user"
password="password"
host="host"

# number of seconds to go 'up','down', etc.
timeout=2

################################################################################

set -e
#set -x

curl="curl -s --max-time 60 -u$user:$password http://$host/"

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
noflipandmirror="${curl}camera_control.cgi?param=5&value=0"
video="${curl}videostream.cgi"
snapshot="${curl}snapshot.cgi"

help() {
  echo "Foscam Camera control"
  echo "-----------------"
  echo ""
  echo "Commands:"
  echo "              left : go left for ${timeout}s"
  echo "             right : go right for ${timeout}s"
  echo "                up : go up for ${timeout}s"
  echo "              down : go down for ${timeout}s"
  echo "            center : center the camera"
  echo "     flipandmirror : set flip and mirror settings"
  echo "   noflipandmirror : disable flip or mirror settings"
  echo "          snapshot : take a snapshot. Returns the name of the file."
#  echo "             video : take a video. This redirects to 'video.mpg'. It exits after"
#	echo "                     60 seconds, or type Control-C to exit."
	echo ""
	echo "Example:"
	echo "fosctrl.sh center"
	exit 0
}

if [[ -z "$1" ]]
then
	help
else
  command=$1
fi

if [[ "$1" == "flipandmirror" ]]
then
  test `$flipandmirror` == 'ok.'
elif [[ "$1" == "center" ]]
then
  test `${move}25` == 'ok.'
elif [[ "$1" == "noflipandmirror" ]]
then
  test `$noflipandmirror` == 'ok.'
elif [[ "$1" == "up" ]]
then
  test `${move}0` == 'ok.'
  sleep ${timeout}
  test `${move}1` == 'ok.'
elif [[ "$1" == "down" ]]
then
  test `${move}2` == 'ok.'
  sleep ${timeout}
  test `${move}3` == 'ok.'
elif [[ "$1" == "right" ]]
then
  test `${move}6` == 'ok.'
  sleep ${timeout}
  test `${move}7` == 'ok.'
elif [[ "$1" == "left" ]]
then
  test `${move}4` == 'ok.'
  sleep ${timeout}
  test `${move}5` == 'ok.'
elif [[ "$1" == "snapshot" ]]
then
	snapname=`date +%m%d%y-%H%M.jpg`
  `$snapshot > $snapname`
	echo $snapname
#elif [[ "$1" == "video" ]]
#then
# The header from the actual file returned by videostream is:
# I think JFIF is the beginning of something that is JPEG, but I'm not
# sure how/where I can make this viewable..

#0000000: 2d2d 6970 6361 6d65 7261 0d0a 436f 6e74  --ipcamera..Cont
#0000010: 656e 742d 5479 7065 3a20 696d 6167 652f  ent-Type: image/
#0000020: 6a70 6567 0d0a 436f 6e74 656e 742d 4c65  jpeg..Content-Le
#0000030: 6e67 7468 3a20 3335 3632 380d 0a0d 0aff  ngth: 35628.....
#0000040: d8ff e000 134a 4649 4600 0102 0200 0000  .....JFIF.......

# Oh...save it as mpg and cut off the first 4 lines does the trick:
#...no...
# TODO This doesn' twork. The header appears in front of every single image.
# probably the best thing to do is just break the image up into separate JPG images.
# Supposedly VLC and QuickTime works, but thats not particularly universal...

# see http://en.wikipedia.org/wiki/Motion_JPEG (M-JPEG over HTTP)

  #`$video | tail +5 > video.mpg`
#  `$video > video.mpg`
else
	help
fi
