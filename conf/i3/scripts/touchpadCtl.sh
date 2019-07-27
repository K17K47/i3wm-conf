#!/bin/sh

NOME="ELAN1200:00 04F3:301A Touchpad"

case $1 in
   toggle)
      if [ "$(xinput list-props "$NOME" | grep "Device Enabled" | awk '{print $4}')" == "1" ]
      then
         xinput disable "$NOME"
      else
         xinput enable "$NOME"
      fi
      ;;
   enable)
      xinput enable "$NOME"
      ;;
   disable)
      xinput disable "$NOME"
      ;;
   tap2click)
      PROP=$(xinput list-props "$NOME" | grep "Tapping Enabled (" | cut -f2 -d"(" | cut -f1 -d")")
      xinput set-prop "$NOME" $PROP 1
      ;;
esac
