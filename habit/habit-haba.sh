#!/bin/bash

# Things to do as user haba

# install platformio
if test $PIO ; then
    wget -O get-platformio.py https://raw.githubusercontent.com/platformio/platformio-core-installer/master/get-platformio.py
    python3 get-platformio.py
    rm get-platformio.py
    cp ~/.platformio/penv/bin/pio ~/bin/scripts/
fi

# install vivaldi (download with browser and then dpkg -i)

# install arduino ide 1.8.19
# cd /usr/share/arduino
# xzcat /afs/stacken.kth.se/home/haba/Arduino/arduino-1.8.19-linux64.tar.xz | sudo tar xf -


