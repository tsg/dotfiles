
set -g __fish_hg_prompt_color "cyan"
set -g __fish_hg_prompt_color_status "cyan"
set -g __fish_virtualenv_prompt_color "yellow"
set -g __fish_git_prompt_showdirtystate "yes"
set -g __fish_git_prompt_showuntrackedfiles "yes"

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
		hg prompt " {branch}{ ({bookmark})}" 2> /dev/null

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


  echo -n -s "$__fish_prompt_cwd" (prompt_pwd) (__fish_git_prompt) (__fish_hg_prompt) (__fish_virtualenv_prompt) "$__fish_prompt_normal" "$prompt_status" "$delim" ' '

end

function restart_audio_server --description "Restart the OSX audio server to fix Airplay"
	sudo kill (ps -ax | grep 'coreaudiod' | grep 'sbin' | awk '{print $1}')
end

function pprint_json_logs --description "Pretty prints a file containing one json object per line"
  set -l i 0
  cat $argv | while read in
    echo "line: " $i;
    underscore -d $in print --color
    set -l i (math $i + 1)
  end
end
