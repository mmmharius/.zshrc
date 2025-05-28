#Myzsh
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

plugins=(git zsh-syntax-highlighting zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# Couleurs custom
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)

ZSH_HIGHLIGHT_STYLES[command]='fg=white'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=white'
ZSH_HIGHLIGHT_STYLES[function]='fg=white'
ZSH_HIGHLIGHT_STYLES[alias]='fg=white'

ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

