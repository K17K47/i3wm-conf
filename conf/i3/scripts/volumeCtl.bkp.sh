#!/bin/sh

function sinkname(){
   echo $(pacmd list-sinks | grep -A1 "index: $1" | grep "name:" | cut -f2 -d"<" | cut -f1 -d">")
}

SINK=$(pacmd list-sinks | grep "* index" | awk '{print $3}')

case $1 in
   up)
      pactl set-sink-volume @DEFAULT_SINK@ +5%
      ;;
   down)
      pactl set-sink-volume @DEFAULT_SINK@ -5%
      ;;
   mute)
      pactl set-sink-mute @DEFAULT_SINK@ toggle
      ;;
   prevSink)
      if [ $SINK -eq 0 ]
      then
         SINK=$(pactl list sinks | grep "Destino" | cut -f2 -d"#" | tail -n1)
      else
         SINK=$(($SINK-1))
      fi
      pactl set-default-sink $(sinkname $SINK)
      ;;
   nextSink)
      N=$(pactl list sinks | grep "Destino" | cut -f2 -d"#" | tail -n1)

      if [ $SINK -eq $N ]
      then
         SINK=0
      else
         SINK=$(($SINK+1))
      fi
      pactl set-default-sink $(sinkname $SINK)
      ;;
   sink)
      echo "$SINK"
      ;;
   sinkname)
      echo "$(sinkname $SINK)"
      ;;
   sinkdesc)
      N=$(($SINK+1))
      echo $(pacmd list-sinks | grep "device.description" | head -n$N | tail -n1 | cut -f2 -d'"')
      ;;
   volume)
      VOL=$(pacmd list-sinks|grep -A10 "* index:"|grep "volume:"|head -n1|rev|cut -f2 -d"%"|cut -f1 -d" "|rev)
      echo "$VOL"
      ;;
esac
