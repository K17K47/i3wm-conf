#!/bin/sh

if [ "$(xinput list-props "ELAN1200:00 04F3:301A Touchpad" | grep "Device Enabled" | awk '{print $4}')" == "1" ]
then
   xinput disable "ELAN1200:00 04F3:301A Touchpad"
else
   xinput enable "ELAN1200:00 04F3:301A Touchpad"
fi
