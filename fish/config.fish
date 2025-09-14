if status is-interactive
    # Commands to run in interactive sessions can go here
end


# Set this options in your config.fish (if you want to :])
set -g theme_display_user yes
set -g theme_hide_hostname yes
# set -g theme_hide_hostname no
set -g default_user martin
set -g VIRTUAL_ENV_DISABLE_PROMPT 1

# Welcome message with Tokyo Ghoul ASCII art
function fish_greeting
    ## Picture
    #echo -ne "\e[s"
    #kitty +kitten icat --place 30x30@30x0 ~/.config/centipede.png
    #echo -ne "\e[u"

    # Your Tokyo Ghoul text
    echo (set_color E84154)"───── ⋆⋅☆⋅⋆ ─────"
    echo "   東京喰種"
    #echo (set_color normal)"   「1000-7...」"
    echo "   この世界は、間違っている"
    echo (set_color E84154)"───── ⋆⋅☆⋅⋆ ─────"
end
# Kagune mode for root (turns everything red)
function sudo
    set -lx SUDO_PROMPT (set_color -o E84154)"[Kagune Mode] Password: "
    command sudo $argv
end
