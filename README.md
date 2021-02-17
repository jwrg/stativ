# Stativ

Status monitor script for a laptop

## Use case

The intended use for this script is to continually
call `xsetroot -name $VAR` to set status information
in a lightweight wm like dwm

### NB

This script may or may not work for your laptop as it
assumes that battery information is located
at `/sys/class/power_supply/BAT1/`; it would probably
be trivial to adapt the script for your system as per
a different battery information location.

## Usage

Clone/emerge and then call the script when your GUI session
begins; e.g., place the following in your `~/.xinitrc`
(remembering to background the process):
```shell
~/bin/stativ/stativ.sh &
```
