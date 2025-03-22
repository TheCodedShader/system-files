#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='eza --icons'
alias ll='eza --icons -l'
alias la='eza --icons -a'
alias vim='nvim'
alias grep='grep --color=auto'
#PS1='[\u@\h \W]\$ '

# GRAY="\[\033[1;30m\]"
# LIGHT_GRAY="\[\033[0;37m\]"
# WHITE="\[\033[1;37m\]"
#
# LIGHT_BLUE="\[\033[1;34m\]"
# LIGHT_RED="\[\033[1;31m\]"
# YELLOW="\[\033[1;33m\]"
#
# case $TERM in
#     xterm*)
#         TITLEBAR='\[\033]0;\u@\h:\w\007\]'
#         ;;
#     *)
#         TITLEBAR=""
#         ;;
# esac
#
# PS1="
# $TITLEBAR\
# $YELLOW-$LIGHT_BLUE-(\
# $YELLOW\u$LIGHT_BLUE@$YELLOW\h\
# $LIGHT_BLUE)-(\
# $YELLOW\$PWD\
# $LIGHT_BLUE)-$YELLOW-\
# $LIGHT_GRAY\n\
# $YELLOW-$LIGHT_BLUE-(\
# $YELLOW\$(date +%H%M)$LIGHT_BLUE:$YELLOW\$(date \"+%a,%d %b %y\")\
# $LIGHT_BLUE:$WHITE\$$LIGHT_BLUE)-$YELLOW-$LIGHT_GRAY "
#
# PS2="$LIGHT_BLUE-$YELLOW-$YELLOW-$LIGHT_GRAY "
#

function set_bash_prompt() {
    # Colors for PS1 prompt - these include the special \[ \] markers
    GRAY="\[\033[1;30m\]"
    LIGHT_GRAY="\[\033[0;37m\]"
    WHITE="\[\033[1;37m\]"
    LIGHT_BLUE="\[\033[1;34m\]"
    YELLOW="\[\033[1;33m\]"
    GREEN="\[\033[1;32m\]"
    RED="\[\033[1;31m\]"
    PURPLE="\[\033[1;35m\]"
    CYAN="\[\033[1;36m\]"
    RESET="\[\033[0m\]"

    # Set title bar
    case $TERM in
        xterm*)
            TITLEBAR='\[\033]0;\u@\h:\w\007\]'
            ;;
        *)
            TITLEBAR=""
            ;;
    esac

    # Function to update Git status
    function update_git_status() {
        GIT_STATUS=""

        # Check if we're in a git repo
        if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
            # Get current branch
            local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
            local git_status=$(git status --porcelain 2>/dev/null)
            local symbols=""

            if [[ -z "$git_status" ]]; then
                # Clean repo
                GIT_STATUS="$LIGHT_BLUE)-($GREEN $branch$LIGHT_BLUE"
            else
                # Collect git status symbols
                [[ "$git_status" =~ \?\? ]] && symbols+=""
                [[ "$git_status" =~ ^.M ]] && symbols+=""
                [[ "$git_status" =~ ^A ]] && symbols+="󰐕"
                [[ "$git_status" =~ ^M ]] && symbols+="󰜘"
                [[ "$git_status" =~ ^(D|.D) ]] && symbols+=""

                # Repo has changes
                GIT_STATUS="$LIGHT_BLUE)-($RED$symbols $branch$LIGHT_BLUE"
            fi
        fi
    }

    # Define dynamic PS1 inside PROMPT_COMMAND
    function update_prompt() {
        update_git_status  # Refresh Git status each time the prompt updates

        PS1="
$TITLEBAR\
$YELLOW-$LIGHT_BLUE-(\
$YELLOW\u$LIGHT_BLUE@$YELLOW\h\
$LIGHT_BLUE)-(\
$GREEN\w\
$GIT_STATUS\
$LIGHT_BLUE)-$YELLOW-\
$LIGHT_GRAY\n\
$YELLOW-$LIGHT_BLUE-(\
$YELLOW\$(date +%H%M)$LIGHT_BLUE:$YELLOW\$(date \"+%a,%d %b %y\")\
$LIGHT_BLUE:$WHITE\$$LIGHT_BLUE)-$YELLOW-$LIGHT_GRAY "
    }

    # Ensure prompt updates dynamically
    PROMPT_COMMAND="update_prompt"
}

# Call the function to set the prompt
set_bash_prompt




# Check if ssh-agent is running and kill it if it is
if pgrep -u "$USER" ssh-agent > /dev/null 2>&1; then
    pkill -u "$USER" ssh-agent > /dev/null 2>&1
fi

# Start a new ssh-agent instance
eval "$(ssh-agent -s)" > /dev/null 2>&1

source ~/.local/share/blesh/ble.sh

#export PATH=$PATH:/home/coded/.millennium/ext/bin

