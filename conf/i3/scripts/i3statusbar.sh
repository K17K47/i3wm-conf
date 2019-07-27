#!/bin/sh
# ♪

function sanitize(){
   sed 's/\\/\\\\/g' | sed 's/\x08/\\b/g; s/"/\\"/g; s/x09/\\t/g; s/x0A//g; s/x0C//g; s/x0D//g'
}

scpt=/home/<username>/.config/i3/scripts

echo "{\"version\":1}"
echo "["
echo "[],"

i3status | while :
do
   read line
   if [ ! "$line" == "{\"version\":1}" ] && [ ! "$line" == "[" ]
   then
      line="$(echo $line | cut -f2 -d'[' | cut -f1 -d']')"

      bgt=( $(</sys/class/backlight/intel_backlight/brightness) )
      maxBgt=( $(</sys/class/backlight/intel_backlight/max_brightness) )
      bgtPerc=$[100*$bgt/$maxBgt]

      line="$line,{\"name\":\"brightness\",\"color\":\"#EEEE00\",\"full_text\":\"☀ $bgtPerc%\"}"

      line="{\"name\":\"sndcard\",\"color\":\"#FFFFFF\",\"full_text\":\"$($scpt/volumeCtl.sh cardName)\"},$line"

      if [ -z "$( playerctl status 2>&1 | grep 'No players found')" ]
      then
         full_text="♪($(playerctl status)) $(playerctl metadata title | sanitize), $(playerctl metadata album | sanitize) - $(playerctl metadata artist | sanitize)"
         line="{\"name\":\"playingnow\",\"full_text\":\"$full_text\"},$line"
      fi

      echo "[$line]," || exit 1
   fi
done

