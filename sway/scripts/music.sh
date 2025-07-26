#!/bin/bash
ID=9999

while ! playerctl -p AudioTube metadata &> /dev/null; do
  sleep 1
done

# Sleduje stav AudioTube přehrávače a vypisuje změny do terminálu
playerctl --follow status -p AudioTube | while read -r status; do
  if [[ "$status" == "Playing" ]]; then
    title=$(playerctl -p AudioTube metadata xesam:title 2>/dev/null)
    artist=$(playerctl -p AudioTube metadata xesam:artist 2>/dev/null)
    icon=$(playerctl -p AudioTube metadata mpris:artUrl)
    if [[ -n "$title" && -n "$artist" ]]; then
      dunstify -r $ID -u low -i "$icon" "🎵 Now Playing" "$artist - $title"
    fi
  fi
done
