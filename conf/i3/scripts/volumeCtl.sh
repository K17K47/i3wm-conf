#!/bin/sh

SNDCARD=/home/K17K47/.sndcard

function cardname(){
   echo $(amixer -c$1 info | awk -F"'" '/Mixer/ {print $2}')
}

function checkcardID(){
   if [ ! -e $SNDCARD ] || [ ! -s $SNDCARD ]
   then
      aplay -l | grep -oE '(card )[0-9]+' | uniq | cut -f2 -d' ' | sort | head -n1 > $SNDCARD
   fi

   cat $SNDCARD
}

case $1 in
   up)
      amixer -c$(checkcardID) -M -- sset Master playback 5%+
      ;;
   down)
      amixer -c$(checkcardID) -M -- sset Master playback 5%-
      ;;
   mute)
      #pactl set-sink-mute @DEFAULT_SINK@ toggle
      ;;
   prevCard)
      N=$(aplay -l | grep -oE '(card )[0-9]+' | uniq | cut -f2 -d' ' | sort | grep -B1 $(checkcardID) | wc -l)

      if [ $N -eq 1 ]
      then
         aplay -l | grep -oE '(card )[0-9]+' | uniq | cut -f2 -d' ' | sort | tail -n1 > $SNDCARD
      else
         aplay -l | grep -oE '(card )[0-9]+' | uniq | cut -f2 -d' ' | sort | grep -B1 $(checkcardID) | head -n1 > $SNDCARD
      fi
      ;;
   nextCard)
      N=$(aplay -l | grep -oE '(card )[0-9]+' | uniq | cut -f2 -d' ' | sort | grep -A1 $(checkcardID) | wc -l)

      if [ $N -eq 1 ]
      then
         aplay -l | grep -oE '(card )[0-9]+' | uniq | cut -f2 -d' ' | sort | head -n1 > $SNDCARD
      else
         aplay -l | grep -oE '(card )[0-9]+' | uniq | cut -f2 -d' ' | sort | grep -A1 $(checkcardID) | tail -n1 > $SNDCARD
      fi
      ;;
   cardID)
      echo "$(checkcardID)"
      ;;
   cardName)
      echo "$(cardname $(checkcardID))"
      ;;
   volume)
      #VOL=$(amixer -c$(checkcardID) -- sget Master | grep -oE '(-)?[0-9]+\.[0-9]+(dB)')
      VOL=$(amixer -c$(checkcardID) -M -- sget Master | grep -oE '[0-9]+(%)')
      echo "$VOL"
      ;;
esac
