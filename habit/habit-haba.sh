#!/bin/bash

# Things to do as user haba

# install platformio
if test $PIO ; then
    wget -O get-platformio.py https://raw.githubusercontent.com/platformio/platformio-core-installer/master/get-platformio.py
    python3 get-platformio.py
    rm get-platformio.py
    cp ~/.platformio/penv/bin/pio ~/bin/scripts/
fi

