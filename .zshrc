# Configuration Oh My zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh
source $ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Variable globale code de retour
typeset -g last_exit_code=0

# NOUS SOMMES FRANCAIS
export LANG=fr_FR.UTF-8
export LC_ALL=fr_FR.UTF-8
export LC_TIME=fr_FR.UTF-8
export LC_NUMERIC=fr_FR.UTF-8
export LC_MONETARY=fr_FR.UTF-8

# Heure en haut à droite
function afficher_heure_droite() {
    local heure_fr=$(date '+%H:%M:%S')
    local date_courte=$(date '+%d/%m')
    local affichage="$date_courte $heure_fr"
    local largeur_terminal=$COLUMNS
    local longueur_affichage=${#affichage}
    local position=$((largeur_terminal - longueur_affichage))
    printf "\033[s\033[1;${position}H\033[1;36m%s\033[0m\033[u" "$affichage"
}

# Prompt Git (si dans un repo git)
function git_branch_prompt() {
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    [[ -n "$branch" ]] && echo " %F{red}(${branch})%f"
}

# Prompt venv
function venv_prompt() {
    if [[ -n "$VIRTUAL_ENV" ]] && [[ -d "./venv" ]]; then
        local venv_name=$(basename "$VIRTUAL_ENV")
        echo " %F{red}(${venv_name})%f"
    fi
}

# Prompt heure 
function precmd() {
    last_exit_code=$?
    afficher_heure_droite
    local heure=$(date '+%H:%M:%S')
    local dossier="${PWD##*/}"
    local branch=$(git_branch_prompt)
    local venv=$(venv_prompt)
    local fleche_couleur
    if [[ $last_exit_code -eq 0 ]]; then
        fleche_couleur="%F{blue}" 
    else
        fleche_couleur="%F{red}" 
    fi
    PROMPT="${fleche_couleur}➜ %f%F{cyan}${dossier}%f${branch}${venv} "
}

function preexec() {
    afficher_heure_droite
}

# clr = heure 
function clear_avec_heure() {
    /usr/bin/clear
    afficher_heure_droite
    echo
}

# Couleurs de syntaxe 
ZSH_HIGHLIGHT_STYLES[command]='fg=078'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=197'
ZSH_HIGHLIGHT_STYLES[comment]='fg=240'
ZSH_HIGHLIGHT_STYLES[alias]='fg=078'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=078'
ZSH_HIGHLIGHT_STYLES[function]='fg=078'

# SSH silencieux
ssh-add ~/.ssh/id_rsa 2>/dev/null

echo "53244"

# Auto-completion sans surbrillance moche
autoload -U colors && colors
autoload -U compinit && compinit
zstyle ':completion:*' list-colors 'di=0:ln=0:so=0:pi=0:ex=0:bd=0:cd=0:su=0:sg=0:tw=0:ow=0:ma=34'
zstyle ':completion:*' menu select
zstyle ':completion:*' select-prompt ''

# a moi
alias clear='clear_avec_heure'
alias clr='clear_avec_heure'
alias gs="git status"
alias gl="git log --oneline --graph --decorate"
alias gb="git branch"
alias ga="git add ."
alias gc="git commit -m"
alias gp="git push"
alias gpl="git pull"
alias glog="git log --oneline --graph --decorate"

# chez oim sa 
cd /mnt/c/sys42

# restreindre se grand foud de Claude
claude() {
    if [[ "$PWD" == "/mnt/c/sys42"* ]]; then
        echo -e "\033[1;32m✅ Claude Code activé\033[0m"
        /mnt/c/sys42/node_modules/.bin/claude "$@"
    else
        echo -e "\033[1;31m❌ Claude Code disponible uniquement dans /mnt/c/sys42\033[0m"
    fi
}

# Source des styles si existants
[[ -f ~/.zsh_highlight_config.zsh ]] && source ~/.zsh_highlight_config.zsh
