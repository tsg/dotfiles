
set -g __fish_hg_prompt_color "blue"
set -g __fish_hg_prompt_color_status $fish_color_host
set -g __fish_virtualenv_prompt_color "blue"

# disable the virtual_env override prompt
set -g VIRTUAL_ENV_DISABLE_PROMPT "true"

# check only on startup if the "hg prompt" extension is installed
hg prompt 2>/dev/null
if test ! -z $status
	set -g __fish_has_hg_prompt "yes"
end

function __fish_hg_prompt --description 'Prompt function for Mercurial'
	set -q -g __fish_has_hg_prompt ; or return

	set -q -g __fish_hg_prompt_color; and set_color $__fish_hg_prompt_color
	hg prompt " {bookmark}" 2> /dev/null

	set -q -g __fish_hg_prompt_color_status; and set_color $__fish_hg_prompt_color_status
	hg prompt "{status}{outgoing}" 2> /dev/null
end

function __fish_virtualenv_prompt --description 'Prompt function for virtualenv'
	if test $VIRTUAL_ENV
	  set -q -g __fish_virtualenv_prompt_color; and set_color $__fish_virtualenv_prompt_color
		printf " (%s)" (basename $VIRTUAL_ENV)
	end
end

function fish_prompt --description 'Write out the prompt'
  
  set -l last_status $status

  # Just calculate these once, to save a few cycles when displaying the prompt
  if not set -q __fish_prompt_hostname
    set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
  end

  if not set -q __fish_prompt_normal
    set -g __fish_prompt_normal (set_color normal)
  end
  
  if not set -q -g __fish_custom_prompt_functions_defined
    set -g __fish_custom_prompt_functions_defined

    function __fish_repaint_user --on-variable fish_color_user --description "Event handler, repaint when fish_color_user changes"
      if status --is-interactive
        set -e __fish_prompt_user
        commandline -f repaint ^/dev/null
      end
    end
    
    function __fish_repaint_host --on-variable fish_color_host --description "Event handler, repaint when fish_color_host changes"
      if status --is-interactive
        set -e __fish_prompt_host
        commandline -f repaint ^/dev/null
      end
    end
    
    function __fish_repaint_status --on-variable fish_color_status --description "Event handler; repaint when fish_color_status changes"
      if status --is-interactive
        set -e __fish_prompt_status
        commandline -f repaint ^/dev/null
      end
    end
  end

  set -l delim '>'

  switch $USER

  case root

    if not set -q __fish_prompt_cwd
      if set -q fish_color_cwd_root
        set -g __fish_prompt_cwd (set_color $fish_color_cwd_root)
      else
        set -g __fish_prompt_cwd (set_color $fish_color_cwd)
      end
    end

  case '*'

    if not set -q __fish_prompt_cwd
      set -g __fish_prompt_cwd (set_color $fish_color_cwd)
    end

  end

  set -l prompt_status
  if test $last_status -ne 0
    if not set -q __fish_prompt_status
      set -g __fish_prompt_status (set_color $fish_color_status)
    end
    set prompt_status "$__fish_prompt_status [$last_status]$__fish_prompt_normal"
  end

  if not set -q __fish_prompt_user
    set -g __fish_prompt_user (set_color $fish_color_user)
  end
  if not set -q __fish_prompt_host
    set -g __fish_prompt_host (set_color $fish_color_host)
  end

  #echo -n -s "$__fish_prompt_user" "$USER" "$__fish_prompt_normal" @ "$__fish_prompt_host" "$__fish_prompt_hostname" "$__fish_prompt_normal" ' ' "$__fish_prompt_cwd" (prompt_pwd) (__fish_git_prompt) (__fish_hg_prompt) "$__fish_prompt_normal" "$prompt_status" "$delim" ' '


  echo -n -s  "$__fish_prompt_cwd" (prompt_pwd) (__fish_git_prompt) (__fish_hg_prompt) (__fish_virtualenv_prompt) "$__fish_prompt_normal"  "$prompt_status" "$delim" ' '
end
