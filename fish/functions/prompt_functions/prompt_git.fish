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
