#!/bin/sh

hostname=$(hostname)

# Set output and lid depending on hostname
case $hostname in
    "macbook-mini")
        output="DSI-1"
        lid="LID0"
        ;;
    "carbon")
        output="eDP-1"
        lid="LID"
        ;;
    *)
        output=""
        lid=""
        ;;
esac

# Disable output when lid is closed
swaymsg -- bindswitch --reload --locked lid:on output $output disable
swaymsg -- bindswitch --reload --locked lid:off output $output enable

# While reloading sway in clamshell mode, make sure the output is disabled
if [[ -n $output ]]; then
    if grep -q open /proc/acpi/button/lid/$lid/state; then
        swaymsg output $output enable
    else
        swaymsg output $output disable
    fi
fi
