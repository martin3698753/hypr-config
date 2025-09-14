#!/bin/bash
ID=9998
PLAYER="firefox"

# Wait until Firefox YouTube player is available
while ! playerctl -p "$PLAYER" metadata &> /dev/null; do
  sleep 1
done

# Watch for status changes and show notifications
playerctl --follow status -p "$PLAYER" | while read -r status; do
  if [[ "$status" == "Playing" ]]; then
    title=$(playerctl -p "$PLAYER" metadata xesam:title 2>/dev/null)
    artist=$(playerctl -p "$PLAYER" metadata xesam:artist 2>/dev/null)
    icon=$(playerctl -p "$PLAYER" metadata mpris:artUrl 2>/dev/null)

    # Fallbacks for missing metadata
    [[ -z "$artist" ]] && artist="YouTube"
    [[ -z "$icon" ]] && icon="youtube"  # Will default to icon theme name

    if [[ -n "$title" ]]; then
      dunstify -r $ID -u low -i "$icon" "🎵 Now Playing" "$artist - $title"
    fi
  fi
done
