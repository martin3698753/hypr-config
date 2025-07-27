# Tokyo Ghoul Prompt Configuration
# set -g theme_display_user yes
# set -g theme_hide_hostname yes
# set -g theme_hide_hostname no
set -g default_user martin

set -g current_bg NONE
# Icons and symbols
set -g hard_space '\u2060'
set -g icon_root '/'
set -g icon_home '~'
set -g prompt_text '→'

set -g segment_separator \uE0B0
set -g segment_splitter \uE0B1
set -g right_segment_separator \uE0B0

# Color definitions
set -g colour_text_path 006272
set -g colour_text_dirty 510C38
set -g colour_text_clean 2A0095

set -g colour_path 41C1D7
set -g colour_dirty BE4D95
set -g colour_clean 7E6FFF

# Git prompt settings
set -g __fish_git_prompt_showdirtystate 'yes'
set -g __fish_git_prompt_char_dirtystate '📂'
set -g __fish_git_prompt_char_cleanstate '📁'
