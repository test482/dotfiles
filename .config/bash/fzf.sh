export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
export FZF_DEFAULT_OPTS='--height 60% --layout=reverse --border'
export FZF_COMPLETION_TRIGGER='\'
export fzf_preview_cmd='[[ $(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --color=always --line-range 0:200 {}) 2> /dev/null'
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}" # ^T preview the content of the file
export FZF_CTRL_T_OPTS="--preview '${fzf_preview_cmd}'"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow' # Alt+C cd into the selected directory
[ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
[ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash
