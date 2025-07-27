#!/bin/bash

# 1. SAFETY CHECK AND CLEANUP
echo "=== Tokyo Ghoul Fish Prompt Setup ==="
# 2. REMOVE EXISTING FILES
echo "Cleaning up old files..."
rm -fv ~/.config/fish/functions/fish_prompt.fish 2>/dev/null
rm -fv ~/.config/fish/functions/prompt_functions/*.fish 2>/dev/null
mkdir -p ~/.config/fish/functions/prompt_functions

# 4. FINAL VERIFICATION
echo -e "\n=== Setup Complete ==="
echo "Created these files:"
ls -1 ~/.config/fish/functions/prompt_functions/
echo -e "\nTo activate:"
echo "1. Restart your shell: exec fish"
echo "2. Verify functions: functions -a | grep prompt_"


# Create directory structure
mkdir -p ~/.config/fish/functions/prompt_functions

# 1. Create the main prompt file with consistent sourcing
cat > ~/.config/fish/functions/fish_prompt.fish << 'EOF'
# Load configuration first
source ~/.config/fish/functions/prompt_functions/config_vars.fish

# Load utility functions
source ~/.config/fish/functions/prompt_functions/parse_git_dirty.fish
source ~/.config/fish/functions/prompt_functions/prompt_segment.fish
source ~/.config/fish/functions/prompt_functions/prompt_finish.fish

# Load prompt components (all with prompt_ prefix)
source ~/.config/fish/functions/prompt_functions/prompt_status.fish
source ~/.config/fish/functions/prompt_functions/prompt_virtual_env.fish
source ~/.config/fish/functions/prompt_functions/prompt_user.fish
source ~/.config/fish/functions/prompt_functions/prompt_dir.fish
source ~/.config/fish/functions/prompt_functions/prompt_git.fish

function fish_prompt
  set -g RETVAL $status
  prompt_status
  prompt_virtual_env
  prompt_user
  prompt_dir
  type -q hg; and prompt_hg
  type -q git; and prompt_git
  type -q svn; and prompt_svn
  prompt_finish
  echo ""
  prompt_segment $colour_path $colour_text_path $prompt_text
  prompt_finish
end
EOF

# 2. Create config variables file
cat > ~/.config/fish/functions/prompt_functions/config_vars.fish << 'EOF'
# Tokyo Ghoul Prompt Configuration
set -g current_bg NONE

# Icons and symbols
set -g hard_space '\u2060'
set -g icon_root '/'
set -g icon_home '~'
set -g prompt_text '→'
set -g segment_separator \uE0B0
set -g segment_splitter \uE0B1

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
EOF

# 3. Create individual utility functions

# parse_git_dirty.fish
cat > ~/.config/fish/functions/prompt_functions/parse_git_dirty.fish << 'EOF'
function parse_git_dirty
  set -l submodule_syntax "--ignore-submodules=dirty"
  set git_dirty (command git status --porcelain $submodule_syntax 2> /dev/null)
  if [ -n "$git_dirty" ]
    if [ $__fish_git_prompt_showdirtystate = "yes" ]
      echo -n "$__fish_git_prompt_char_dirtystate"
    end
  else
    if [ $__fish_git_prompt_showdirtystate = "yes" ]
      echo -n "$__fish_git_prompt_char_cleanstate"
    end
  end
end
EOF

# prompt_segment.fish
cat > ~/.config/fish/functions/prompt_functions/prompt_segment.fish << 'EOF'
function prompt_segment -d "Function to draw a segment"
  set -l bg
  set -l fg
  if [ -n "$argv[1]" ]
    set bg $argv[1]
  else
    set bg normal
  end
  if [ -n "$argv[2]" ]
    set fg $argv[2]
  else
    set fg normal
  end
  if [ "$current_bg" != 'NONE' -a "$argv[1]" != "$current_bg" ]
    set_color -b $bg
    set_color $current_bg
    echo -n "$segment_separator "
    set_color -b $bg
    set_color $fg
  else
    set_color -b $bg
    set_color $fg
    echo -n " "
  end
  set current_bg $argv[1]
  if [ -n "$argv[3]" ]
    echo -n -s $argv[3] " "
  end
end
EOF

# prompt_finish.fish
cat > ~/.config/fish/functions/prompt_functions/prompt_finish.fish << 'EOF'
function prompt_finish -d "Close open segments"
  if [ -n $current_bg ]
    set_color -b normal
    set_color $current_bg
    echo -n "$segment_separator "
  end
  set -g current_bg NONE
end
EOF

# 4. Create all prompt component files with consistent naming

# prompt_status.fish
cat > ~/.config/fish/functions/prompt_functions/prompt_status.fish << 'EOF'
function prompt_status
  if [ $RETVAL -ne 0 ]
    prompt_segment black red "⚠️ "
  end
  if [ (id -u $USER) -eq 0 ]
    prompt_segment black yellow "⚡"
  end
  if [ (jobs -l | wc -l) -gt 0 ]
    prompt_segment black cyan "⚙"
  end
end
EOF

# prompt_virtual_env.fish
cat > ~/.config/fish/functions/prompt_functions/prompt_virtual_env.fish << 'EOF'
function prompt_virtual_env
  if test "$VIRTUAL_ENV"
    prompt_segment white black (basename $VIRTUAL_ENV)
  end
end
EOF

# prompt_user.fish
cat > ~/.config/fish/functions/prompt_functions/prompt_user.fish << 'EOF'
function prompt_user
  if [ "$theme_display_user" = "yes" ]
    if [ "$USER" != "$default_user" -o -n "$SSH_CLIENT" ]
      set USER (whoami)
      get_hostname
      if [ $HOSTNAME_PROMPT ]
        set USER_PROMPT $USER@$HOSTNAME_PROMPT
      else
        set USER_PROMPT $USER
      end
      prompt_segment black yellow $USER_PROMPT
    end
  else
    get_hostname
    if [ $HOSTNAME_PROMPT ]
      prompt_segment black yellow $HOSTNAME_PROMPT
    end
  end
end

function get_hostname
  set -g HOSTNAME_PROMPT ""
  if [ "$theme_hide_hostname" = "no" -o \( "$theme_hide_hostname" != "yes" -a -n "$SSH_CLIENT" \) ]
    set -g HOSTNAME_PROMPT (hostname)
  end
end
EOF

# prompt_dir.fish
cat > ~/.config/fish/functions/prompt_functions/prompt_dir.fish << 'EOF'
function prompt_dir
  set -l clean_path (string replace -r '^\/$' "$icon_root" \
    (string replace -r '^\/(.+?)' "$icon_root/\$1" \
    (string replace -r '^\~' "$icon_home" \
    (prompt_pwd))))
  prompt_segment $colour_path $colour_text_path (string join " $segment_splitter " (string split '/' $clean_path))
end
EOF

# prompt_git.fish
cat > ~/.config/fish/functions/prompt_functions/prompt_git.fish << 'EOF'
function prompt_git
  set -l ref
  set -l dirty
  if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
    set dirty (parse_git_dirty)
    set ref (command git symbolic-ref HEAD 2> /dev/null)
    if [ $status -gt 0 ]
      set -l branch (command git show-ref --head -s --abbrev | head -n1 2> /dev/null)
      set ref "➦ $branch "
    end
    set branch_symbol \uE0A0
    set -l branch (string join " $segment_splitter " (string split '/' (echo $ref | sed "s-refs/heads/-$branch_symbol -")))
    if [ "$dirty" = "$__fish_git_prompt_char_dirtystate" ]
      prompt_segment $colour_dirty $colour_text_dirty "$branch $dirty"
    else
      prompt_segment $colour_clean $colour_text_clean "$branch $dirty"
    end
  end
end
EOF

# 5. Set proper permissions
chmod 644 ~/.config/fish/functions/prompt_functions/*.fish

# 6. Cleanup and verification
echo "Tokyo Ghoul Fish prompt setup complete with consistent naming!"
echo "Files created in ~/.config/fish/functions/prompt_functions/:"
ls -1 ~/.config/fish/functions/prompt_functions/
echo -e "\nTo activate:"
echo "1. Restart your shell: exec fish"
echo "2. Verify functions: functions -a | grep prompt_"
