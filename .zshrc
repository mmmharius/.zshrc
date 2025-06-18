#➤ Configuration Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh
source $ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

#➤ PATH pour Chromium tools
export PATH="/mnt/c/sys42/CHROMIUM/depot_tools:$PATH:$HOME/.local/bin"

#➤ nous somme FRANCAIS
export LANG=fr_FR.UTF-8
export LC_ALL=fr_FR.UTF-8
export LC_TIME=fr_FR.UTF-8
export LC_NUMERIC=fr_FR.UTF-8
export LC_MONETARY=fr_FR.UTF-8

#➤ Heure en haut à droite
function afficher_heure_droite() {
    local heure_fr=$(date '+%H:%M:%S')
    local date_courte=$(date '+%d/%m')
    local affichage="$date_courte $heure_fr"
    local largeur_terminal=$COLUMNS
    local longueur_affichage=${#affichage}
    local position=$((largeur_terminal - longueur_affichage))
    printf "\033[s\033[1;${position}H\033[1;36m%s\033[0m\033[u" "$affichage"
}

#➤prompt Git si présente
function git_branch_prompt() {
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    [[ -n "$branch" ]] && echo " %F{red}(${branch})%f"
}

#➤ Prompt personnalisé avec mes couleurs
function precmd() {
    afficher_heure_droite
    local heure=$(date '+%H:%M:%S')
    local dossier="${PWD##*/}"
    local branch=$(git_branch_prompt)

    PROMPT="%F{cyan}${heure}%f %F{blue}➜ %f%F{cyan}${dossier}%f${branch} "
}

function preexec() {
    afficher_heure_droite
}

#➤ Couleurs de syntaxe personnalisées
ZSH_HIGHLIGHT_STYLES[command]='fg=078'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=197'
ZSH_HIGHLIGHT_STYLES[comment]='fg=240'
ZSH_HIGHLIGHT_STYLES[alias]='fg=078'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=078'
ZSH_HIGHLIGHT_STYLES[function]='fg=078'

#➤ SSH silencieux
ssh-add ~/.ssh/id_rsa 2>/dev/null

#➤ Auto-completion sans surbrillance moche
autoload -U colors && colors
autoload -U compinit && compinit
zstyle ':completion:*' list-colors 'di=00:fi=00:ln=00:ex=00'
zstyle ':completion:*' menu select
zstyle ':completion:*' select-prompt ''

#➤ Aliases Git + clear
alias clear='command clear && afficher_heure_droite'
alias clr='command clear && afficher_heure_droite'
alias gs="git status"
alias gl="git log --oneline --graph --decorate"
alias gb="git branch"
alias ga="git add ."
alias gc="git commit -m"
alias gp="git push"
alias gpl="git pull"
alias glog="git log --oneline --graph --decorate"

#➤ Répertoire de démarrage
cd /mnt/c/sys42

#➤ Fonction Claude
claude() {
    if [[ "$PWD" == "/mnt/c/sys42"* ]]; then
        echo -e "\033[1;32m✅ Claude Code activé\033[0m"
        /mnt/c/sys42/node_modules/.bin/claude "$@"
    else
        echo -e "\033[1;31m❌ Claude Code disponible uniquement dans /mnt/c/sys42\033[0m"
    fi
}

#➤ Source des styles si existants
[[ -f ~/.zsh_highlight_config.zsh ]] && source ~/.zsh_highlight_config.zsh
