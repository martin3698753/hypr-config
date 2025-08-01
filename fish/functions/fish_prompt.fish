# name: emoji-powerline
# 
# based on agnoster's Theme - https://gist.github.com/3712874
# A Powerline-inspired theme for FISH
#
# # README
#
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://gist.github.com/1595572).

## Set this options in your config.fish (if you want to :])
# set -g theme_display_user yes
# set -g theme_hide_hostname yes
# set -g theme_hide_hostname no
# set -g default_user your_normal_user

set -g current_bg NONE

set hard_space '\u2060'
#set icon_root '🌏'
#set icon_home '🏡'
set icon_root '/'
set icon_home '~'

set prompt_text '→'

set colour_text_path ff2e2e
set colour_text_dirty 0c0c0c
set colour_text_clean 2A0095

set colour_path 2f2f2f
set colour_dirty ff2e2e
set colour_clean 7E6FFF

set segment_separator \uE0B0
set segment_splitter \uE0B1
set right_segment_separator \uE0B0
# ===========================
# Helper methods
# ===========================

set -g __fish_git_prompt_showdirtystate yes
set -g __fish_git_prompt_char_dirtystate '📂'
set -g __fish_git_prompt_char_cleanstate '📁'

function parse_git_dirty
    set -l submodule_syntax
    set submodule_syntax "--ignore-submodules=dirty"
    set git_dirty (command git status --porcelain $submodule_syntax  2> /dev/null)
    if [ -n "$git_dirty" ]
        if [ $__fish_git_prompt_showdirtystate = yes ]
            echo -n "$__fish_git_prompt_char_dirtystate"
        end
    else
        if [ $__fish_git_prompt_showdirtystate = yes ]
            echo -n "$__fish_git_prompt_char_cleanstate"
        end
    end
end

# ===========================
# Segments functions
# ===========================

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
    if [ "$current_bg" != NONE -a "$argv[1]" != "$current_bg" ]
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

function prompt_finish -d "Close open segments"
    if [ -n $current_bg ]
        set_color -b normal
        set_color $current_bg
        echo -n "$segment_separator "
    end
    set -g current_bg NONE
end

# ===========================
# Theme components
# ===========================

function prompt_virtual_env -d "Display Python virtual environment"
    if test "$VIRTUAL_ENV"
        prompt_segment white black (basename $VIRTUAL_ENV)
    end
end

function prompt_user -d "Display current user if different from $default_user"
    if [ "$theme_display_user" = yes ]
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

function get_hostname -d "Set current hostname to prompt variable $HOSTNAME_PROMPT if connected via SSH"
    set -g HOSTNAME_PROMPT ""
    if [ "$theme_hide_hostname" = no -o \( "$theme_hide_hostname" != yes -a -n "$SSH_CLIENT" \) ]
        set -g HOSTNAME_PROMPT (hostname)
    end
end

function wrap_root

end

# function prompt_dir -d "Display the current directory"
#   prompt_segment $colour_path $colour_text_path (string trim (string join " $segment_splitter " (string split '/' (string replace -r '^\/$' "$icon_root$hard_space" (string replace -r '^\/(.+?)' "$icon_root/\$1" (string replace -r '^\~' "$icon_home$hard_space" (string trim (prompt_pwd))))))))
# end

function prompt_dir -d "Display the current directory"
    set -l clean_path (string replace -r '^\/$' "$icon_root" \
    (string replace -r '^\/(.+?)' "$icon_root/\$1" \
    (string replace -r '^\~' "$icon_home" \
    (prompt_pwd))))

    prompt_segment $colour_path $colour_text_path (string join " $segment_splitter " (string split '/' $clean_path))
end

function prompt_hg -d "Display mercurial state"
    set -l branch
    set -l state
    if command hg id >/dev/null 2>&1
        if command hg prompt >/dev/null 2>&1
            set branch (command hg prompt "{branch}")
            set state (command hg prompt "{status}")
            set branch_symbol \uE0A0
            if [ "$state" = "!" ]
                prompt_segment red white "$branch_symbol $branch ±"
            else if [ "$state" = "?" ]
                prompt_segment $colour_clean $colour_text_clean "$branch_symbol $branch ±"
            else
                prompt_segment $colour_dirty $colour_text_dirty "$branch_symbol $branch"
            end
        end
    end
end

function prompt_git -d "Display the current git state"
    set -l ref
    set -l dirty
    if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
        set dirty (parse_git_dirty)
        set ref (command git symbolic-ref HEAD 2> /dev/null)
        if [ $status -gt 0 ]
            set -l branch (command git show-ref --head -s --abbrev |head -n1 2> /dev/null)
            set ref "➦ $branch "
        end
        set branch_symbol \uE0A0
        set -l branch (string join " $segment_splitter " (string split '/' (echo $ref | sed  "s-refs/heads/-$branch_symbol -")))
        if [ "$dirty" = "$__fish_git_prompt_char_dirtystate" ]
            prompt_segment $colour_dirty $colour_text_dirty "$branch $dirty"
        else
            prompt_segment $colour_clean $colour_text_clean "$branch $dirty"
        end
    end
end

function prompt_svn -d "Display the current svn state"
    set -l ref
    if command svn ls . >/dev/null 2>&1
        set branch (svn_get_branch)
        set branch_symbol \uE0A0
        set revision (svn_get_revision)
        prompt_segment green black "$branch_symbol $branch:$revision"
    end
end

function svn_get_branch -d "get the current branch name"
    svn info 2>/dev/null | awk -F/ \
        '/^URL:/ { \
        for (i=0; i<=NF; i++) { \
          if ($i == "branches" || $i == "tags" ) { \
            print $(i+1); \
            break;\
          }; \
          if ($i == "trunk") { print $i; break; } \
        } \
      }'
end

function svn_get_revision -d "get the current revision number"
    svn info 2>/dev/null | sed -n 's/Revision:\ //p'
end

function prompt_status -d "the symbols for a non zero exit status, root and background jobs"
    if [ $RETVAL -ne 0 ]
        prompt_segment black red "⚠️ "
    end

    # if superuser (uid == 0)
    set -l uid (id -u $USER)
    if [ $uid -eq 0 ]
        prompt_segment black yellow "⚡"
    end

    # Jobs display
    if [ (jobs -l | wc -l) -gt 0 ]
        prompt_segment black cyan "⚙"
    end
end

function prompt_time -d "Display current time in powerline segment"
    set -l time_text (date +"%H:%M:%S")

    prompt_segment $colour_path $colour_text_path $time_text
end

function prompt_duration -d "Display last command execution time in powerline segment"
    # Only show if command took longer than 1 second
    if test $CMD_DURATION -gt 1000
        set -l duration_sec (math -s2 "$CMD_DURATION/1000") # Convert ms to seconds
        set -l duration_text "$duration_sec s"
        
        # Use different colors based on duration (optional)
        if test $CMD_DURATION -gt 5000
            # Long duration (red)
            prompt_segment $colour_dirty $colour_text_dirty $duration_text
        else
            # Normal duration (same as directory)
            prompt_segment $colour_path $colour_text_path $duration_text
        end
    end
end

# ===========================
# Apply theme
# ===========================

function fish_right_prompt
    set -g RETVAL $status
    prompt_status
    prompt_virtual_env
    prompt_time
    prompt_finish
end

function fish_prompt
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

