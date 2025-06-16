# Configuration Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# Configuration localisation française complète
export LANG=fr_FR.UTF-8
export LC_ALL=fr_FR.UTF-8
export LC_TIME=fr_FR.UTF-8
export LC_NUMERIC=fr_FR.UTF-8
export LC_MONETARY=fr_FR.UTF-8

# Fonction pour afficher l'heure française en temps réel en haut à droite
function afficher_heure_droite() {
    local heure_fr=$(LC_TIME=fr_FR.UTF-8 date '+%H:%M:%S')
    local date_courte=$(LC_TIME=fr_FR.UTF-8 date '+%d/%m')
    local affichage="$date_courte $heure_fr"
    local largeur_terminal=$COLUMNS
    local longueur_affichage=${#affichage}
    local position=$((largeur_terminal - longueur_affichage))
    printf "\033[s\033[1;${position}H\033[1;36m%s\033[0m\033[u" "$affichage"
}

# Crochet pour afficher l'heure avant chaque invite ET à chaque commande
function precmd() {
    afficher_heure_droite
}

# Crochet pour mettre à jour l'heure avant l'exécution de chaque commande
function preexec() {
    afficher_heure_droite
}

# Invite personnalisée avec couleurs douces
PROMPT='%F{078}$(LC_TIME=fr_FR.UTF-8 date "+%H:%M:%S")%f %F{039}➜%f %F{033}sys42%f '

# Redéfinir la commande effacer pour afficher l'heure en haut à droite
alias clear='command clear && afficher_heure_droite'
alias clr='command clear && afficher_heure_droite'

# Styles de coloration syntaxique avec couleurs douces
ZSH_HIGHLIGHT_STYLES[command]='fg=078'              
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=197'
ZSH_HIGHLIGHT_STYLES[comment]='fg=240'
ZSH_HIGHLIGHT_STYLES[alias]='fg=078'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=078'
ZSH_HIGHLIGHT_STYLES[function]='fg=078'

# Agent SSH (silencieux)
ssh-add ~/.ssh/id_rsa 2>/dev/null

# Chemins d'exécution
export PATH="$PATH:$HOME/.local/bin"

# Options système avancées
setopt NO_BEEP     
setopt HIST_IGNORE_DUPS          
setopt HIST_IGNORE_SPACE         
setopt AUTO_CD                 
setopt CORRECT

# Raccourcis Git classiques (gardés pour compatibilité)
alias gs="git status"
alias gl="git log --oneline --graph --decorate"
alias gb="git branch"
alias ga="git add ."
alias gc="git commit -m"
alias gp="git push"
alias gpl="git pull"
alias glog="git log --oneline --graph --decorate"

# Répertoire par défaut sys42
cd /mnt/c/sys42

claude() {
    if [[ "$PWD" == "/mnt/c/sys42"* ]]; then
        echo -e "\033[1;32m✅ Claude Code activé\033[0m"
        /mnt/c/sys42/node_modules/.bin/claude "$@"
    else
        echo -e "\033[1;31m❌ Claude Code disponible uniquement dans /mnt/c/sys42\033[0m"
    fi
}

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' menu no
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'    
zstyle ':completion:*' list-colors 'di=094:ln=37:so=37:pi=37:ex=37:bd=37:cd=37:su=37:sg=37:tw=37:ow=37'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*' verbose no
zstyle ':completion:*:descriptions' format ''
zstyle ':completion:*:messages' format ''
zstyle ':completion:*:warnings' format ''

# Fonction d'aide
function aide() {
    echo
    echo -e "\033[1;37m🇫🇷 COMMANDES SYS42\033[0m"
    echo
    echo -e "\033[1;32mGIT :\033[0m"
    echo -e "  statut/etat     - Afficher le statut Git"
    echo -e "  branches        - Lister les branches"
    echo -e "  ajouter         - Ajouter tous les fichiers"
    echo -e "  valider 'msg'   - Valider avec message"
    echo -e "  pousser         - Pousser vers le dépôt"
    echo -e "  tirer           - Tirer du dépôt"
    echo -e "  historique      - Afficher l'historique"
    echo
    echo -e "\033[1;33mSYSTÈME :\033[0m"
    echo -e "  lister          - Lister les fichiers détaillés"
    echo -e "  repertoire/ou   - Afficher le répertoire courant"
    echo -e "  monter          - Remonter d'un niveau"
    echo -e "  retour          - Retour au répertoire précédent"
    echo -e "  effacer         - Effacer l'écran"
    echo
    echo -e "\033[1;35mCLAUDE :\033[0m"
    echo -e "  claude [cmd]    - Exécuter Claude Code"
    echo
}

# Source des configurations personnalisées
[[ -f ~/.zsh_highlight_config.zsh ]] && source ~/.zsh_highlight_config.zsh

