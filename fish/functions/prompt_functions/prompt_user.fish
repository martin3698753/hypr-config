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

function get_hostname -d "Set current hostname to prompt variable $HOSTNAME_PROMPT if connected via SSH"
  set -g HOSTNAME_PROMPT ""
  if [ "$theme_hide_hostname" = "no" -o \( "$theme_hide_hostname" != "yes" -a -n "$SSH_CLIENT" \) ]
    set -g HOSTNAME_PROMPT (hostname)
  end
end
