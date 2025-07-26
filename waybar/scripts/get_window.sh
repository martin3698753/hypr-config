#!/bin/bash
focused_window=$(swaymsg -t get_tree | jq -r '.. | select(.focused?) | .app_id // .window_properties.class // .name')
if [ -n "$focused_window" ]; then
    echo "{\"text\":\"$focused_window\", \"tooltip\":false}"  # Show text if window exists
else
    echo "{\"text\":\"\", \"tooltip\":false}"  # Empty JSON = no module rendered
fi
