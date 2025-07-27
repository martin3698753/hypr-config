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
