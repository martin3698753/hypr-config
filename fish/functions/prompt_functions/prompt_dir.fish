function prompt_dir
  set -l clean_path (string replace -r '^\/$' "$icon_root" \
    (string replace -r '^\/(.+?)' "$icon_root/\$1" \
    (string replace -r '^\~' "$icon_home" \
    (prompt_pwd))))
  prompt_segment $colour_path $colour_text_path (string join " $segment_splitter " (string split '/' $clean_path))
end
