# Setup fzf
# ---------
if [[ ! "$PATH" == */home/kali/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/kali/.fzf/bin"
fi

# Auto-completion
# ---------------
source "/home/kali/.fzf/shell/completion.zsh"

# Key bindings
# ------------
source "/home/kali/.fzf/shell/key-bindings.zsh"
