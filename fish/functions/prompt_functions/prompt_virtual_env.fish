function prompt_virtual_env
  if test "$VIRTUAL_ENV"
    prompt_segment white black (basename $VIRTUAL_ENV)
  end
end
