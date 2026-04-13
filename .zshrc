export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export LS_COLORS="di=0:ln=0:so=0:pi=0:ex=0:bd=0:cd=0:su=0:sg=0:tw=0:ow=0"

function setup_scroll_region() {
    local hauteur=$(tput lines)
    printf '\033[2;%dr' "$hauteur"
    printf '\033[2;1H'
}

function reset_scroll_region() {
    printf '\033[r'
}
trap reset_scroll_region EXIT

function TRAPWINCH() {
    setup_scroll_region
    if zle; then
        afficher_heure_droite
        zle reset-prompt
    fi
}

setup_scroll_region

function afficher_heure_droite() {
    local heure_fr=$(date '+%H:%M:%S')
    local date_courte=$(date '+%d/%m')
    local affichage="$date_courte $heure_fr"
    local largeur_terminal=$(tput cols)
    local longueur_affichage=${#affichage}
    local position=$((largeur_terminal - longueur_affichage))
    local f="$HOME/.local/share/type-faster/last_run"
    local today=$(date +%Y-%m-%d)
    if [[ ! -f "$f" ]] || [[ "$(< "$f")" != "$today" ]]; then
        local tf_str="\033[2m[tf]\033[0m "
    else
        local tf_str="     "
    fi
    printf "\033[s\033[1;1H${tf_str}\033[1;${position}H\033[1;36m%s\033[0m\033[u" "$affichage"
}

TMOUT=1
function TRAPALRM() {
    if zle; then
        if [[ "$WIDGET" != *complete* && "$WIDGET" != *menu-select* \
           && "$WIDGET" != "smart_tab" && "$WIDGET" != *history* \
           && "$WIDGET" != *up-line* && "$WIDGET" != *down-line* ]]; 
           then
            afficher_heure_droite
            zle reset-prompt
        fi
    fi
}

TRAPINT() {
    afficher_heure_droite
    return $(( 128 + $1 ))
}

typeset -g last_exit_code=0

function git_branch_prompt() {
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    [[ -n "$branch" ]] && echo " %F{red}(${branch})%f"
}

function venv_prompt() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        local venv_name=$(basename "$VIRTUAL_ENV")
        echo " %F{red}(${venv_name})%f"
    fi
}

function precmd() {
    last_exit_code=$?
    afficher_heure_droite
    local dossier="${PWD##*/}"
    local branch=$(git_branch_prompt)
    local venv=$(venv_prompt)
    local fleche_couleur=$([[ $last_exit_code -eq 0 ]] && echo "%F{blue}" || echo "%F{red}")
    PROMPT="${fleche_couleur}➜ %f%F{cyan}${dossier}%f${branch}${venv} "
}

function preexec() {
    afficher_heure_droite
}

function clear_avec_heure() {
    printf '\033[2;1H\033[J'
    afficher_heure_droite
}

function clear-screen-with-time() {
    printf '\033[2;1H\033[J'
    afficher_heure_droite
    zle reset-prompt
}
zle -N clear-screen-with-time
bindkey '^L' clear-screen-with-time


function whoami() {
    cat << "EOF"
╔═══════════════════════════════════════════════════════════════╗
║  ██╗   ██╗███████╗███████╗██████╗  ██████╗ ███╗   ██╗███████╗ ║
║  ██║   ██║██╔════╝██╔════╝██╔══██╗██╔═══██╗████╗  ██║██╔════╝ ║
║  ██║   ██║███████╗█████╗  ██████╔╝██║   ██║██╔██╗ ██║█████╗   ║
║  ██║   ██║╚════██║██╔══╝  ██╔══██╗██║   ██║██║╚██╗██║██╔══╝   ║
║  ╚██████╔╝███████║███████╗██║  ██║╚██████╔╝██║ ╚████║███████╗ ║
║   ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝ ║
╚═══════════════════════════════════════════════════════════════╝
EOF
}

function smart_tab() {
    if [[ -z "$BUFFER" ]]; then
        BUFFER="cd "
        CURSOR=3
        zle reset-prompt
    else
        zle expand-or-complete
    fi
}
zle -N smart_tab
bindkey '^I' smart_tab

ZSH_HIGHLIGHT_STYLES[command]='fg=078'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=197'
ZSH_HIGHLIGHT_STYLES[comment]='fg=240'
ZSH_HIGHLIGHT_STYLES[alias]='fg=078'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=078'
ZSH_HIGHLIGHT_STYLES[function]='fg=078'


autoload -U colors && colors
autoload -U compinit && compinit
zstyle ':completion:*' list-colors "${LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*' select-prompt ''
zstyle ':completion:*' special-dirs true
zstyle ':completion:*:cd:*' tag-order local-directories
zstyle ':completion:*:*:cd:*' group-name ''

alias clear='clear_avec_heure'
alias clr='clear_avec_heure'
alias gs="git status"
alias gl="git log --oneline --graph --decorate"
alias gb="git branch"
alias ga="git add ."
alias gc="git commit -m"
alias gp="git push"
alias gpm="git push origin HEAD:main"
alias gpl="git pull"
alias gck="git checkout"
alias gm="git merge"
alias gf="git fetch --all"
alias glog="git log --oneline --graph --decorate"
alias whoami="whoami"
alias c="code ."

export NVM_DIR="$HOME/.nvm"
cd /home/oneus/sys42

function _nvm_lazy_load() {
    unfunction node npm npx nvm 2>/dev/null
    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
}

function node() { _nvm_lazy_load && node "$@" }
function npm()  { _nvm_lazy_load && npm "$@" }
function npx()  { _nvm_lazy_load && npx "$@" }
function nvm()  { _nvm_lazy_load && nvm "$@" }