# vim:ft=sh

# Bubble Theme
# Inspired by bubblewritten and agnoster
# written by hohmannr

# SYMBOL CONSTANTS
blub_left=''
blub_right=''

prompt_symbol='❯'

user_symbol='%n'
user_machine_symbol=' 🐧'
machine_symbol='%M'

filepath_symbol='%~'

git_branch_symbol=''
git_clean_symbol=''
git_modified_symbol='•'
git_added_symbol=''
git_deleted_symbol=''
git_renamed_symbol=''
git_untracked_symbol='裸'
git_copied_symbol=''
git_unmerged_symbol='!'
git_stashed_symbol=''

ssh_symbol='ssh'

# COLOR CONSTANTS
# NOTE: Possible values include zsh-color-strings like 'red', 'black', 'magenta' etc. Aswell as zsh-color-codes which you can list with the command 'spectrum_ls', e.g. '078' for the 78th color code.
bubble_color='black'

prompt_symbol_color='blue'
prompt_symbol_error_color='red'

user_color='yellow'
user_machine_symbol_color='green'
machine_color='magenta'

filepath_color='blue'

git_clean_color='green'
git_unstaged_color='yellow'
git_staged_color='magenta' 
git_stashed_color='blue'
git_unmerged_color='red'
git_symbols_color='black'

ssh_symbol_color='black'
ssh_bubble_color='green'

# HELPER FUNCTIONS
bubblify () {
    # This is a helper function to build custom bubbles.
    # 
    # ARGS      VALUES          DESC
    # ----      ------          ----
    # 1.        {0, 1, 2, 3}        0: build left side bubble: content█
    #                               1: build right side bubble: █content                
    #                               2: build middle part: █content█
    #                               3: build custom colored whole bubble: content
    #
    # 2.        string              content to be displayed in partial bubble
    #
    # 3.        {'red', '073' ...}  foreground color (text color) as zsh-color-string or zsh-color-code
    #
    # 4.        {'red', '073' ...}  background color (bubble segment color) as zsh-color-string or zsh-color-code

    if [[ $1 -eq 0 ]]; then
        echo -n "$(foreground $4)$blub_left$(foreground $3)$(background $4)$2%{$reset_color%}"
    elif [[ $1 -eq 1 ]]; then
        echo -n "$(foreground $3)$(background $4)$2%{$reset_color%}"
    elif [[ $1 -eq 2 ]]; then
        echo -n "$(foreground $3)$(background $4)$2%{$reset_color%}$(foreground $4)$blub_right%{$reset_color%}"
    elif [[ $1 -eq 3 ]]; then
        echo -n "$(foreground $4)$blub_left$(foreground $3)$(background $4)$2%{$reset_color%}$(foreground $4)$blub_right%{$reset_color%}"
    else
        echo -n 'bblfy_fail'
    fi
}

foreground () {
    # Helper function for 256 color support beyond basic color terms such as 'black', 'red' ...
    if [[ $1 =~ '[0-9]{3}' && $1 -le 255 && $1 -ge 0 ]]; then
        echo -n "%{$FG[$1]%}"
    else
        echo -n "%{$fg[$1]%}"
    fi
}

background () {
    # Helper function for 256 color support beyond basic color terms such as 'black', 'red' ...
    if [[ $1 =~ '[0-9]{3}' && $1 -le 255 && $1 -ge 0 ]]; then
        echo "%{$BG[$1]%}"
    else
        echo "%{$bg[$1]%}"
    fi
}

# PROMPT FUNCTIONS
git_bubble () {
    # This parses 'git status -s' to retrieve all necessary information...I am new to this zsh scripting...mercy!
    local git_branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)

    if [[ -n $git_branch ]]; then
        # branch name with symbol, initialize symbols and git status output
        local git_info="$git_branch_symbol $git_branch"
        local git_symbols=""
        local git_status=$(git status -s 2> /dev/null | awk '{print substr($0,1,2)}') 

        # used for coloring (and some for icons)
        local git_unmerged=$(grep -m1 -E -- 'U|DD|AA' <<< $git_status)
        local git_branch_stashed=$(git stash list | grep $git_branch)
        local git_unstaged=$(echo -n $git_status | awk '{print substr($0,2,1)}')

        # used for icons
        local git_not_clean=$git_status
        local git_modified=$(grep -m1 'M' <<< $git_status)
        local git_added=$(grep -m1 'A' <<< $git_status)
        local git_deleted=$(grep -m1 'D' <<< $git_status)
        local git_untracked=$(grep -m1 '??' <<< $git_status)
        local git_renamed=$(grep -m1 'R' <<< $git_status)
        local git_copied=$(grep -m1 'C' <<< $git_status)

        # coloring
        if [[ -n $git_unmerged ]]; then
            local git_color=$git_unmerged_color   
            git_symbols="$git_symbols$git_unmerged_symbol"
        elif [[ -n $git_branch_stashed ]]; then
            local git_color=$git_stashed_color
            git_symbols="$git_symbols$git_stashed_symbol"
        elif [[ -n "${git_unstaged//[$' \t\r\n']}" && -n $git_not_clean ]]; then
            local git_color=$git_unstaged_color
        elif [[ -z "${git_unstaged//[$' \t\r\n']}" && -n $git_not_clean ]]; then
            local git_color=$git_staged_color
        else
            local git_color=$git_clean_color
            git_symbols="$git_symbols$git_clean_symbol"
        fi

        # icons
        if [[ -n $git_modified ]]; then
            git_symbols="$git_symbols$git_modified_symbol"
        fi
        if [[ -n $git_added ]]; then
            git_symbols="$git_symbols$git_added_symbol"
        fi
        if [[ -n $git_deleted ]]; then
            git_symbols="$git_symbols$git_deleted_symbol"
        fi
        if [[ -n $git_untracked ]]; then
            git_symbols="$git_symbols$git_untracked_symbol"
        fi
        if [[ -n $git_renamed ]]; then
            git_symbols="$git_symbols$git_renamed_symbol"
        fi
        if [[ -n $git_copied ]]; then
            git_symbols="$git_symbols$git_copied_symbol"
        fi

        echo -n "$(bubblify 0 "$git_info " $git_color $bubble_color)$(bubblify 2 " $git_symbols" $git_symbols_color $git_color) "
    fi
}

ssh_bubble () {
    # detects an ssh connection and displays a bubble 
    if [[ -n $SSH_CLIENT || -n $SSH_TTY || -n $SSH_CONNECTION ]]; then
        echo -n "$(bubblify 3 "$ssh_symbol" $ssh_symbol_color $ssh_bubble_color) "
    fi
}

preexec () {
    (( $#_elapsed > 1000 )) && set -A _elapsed $_elapsed[-1000,-1]
    typeset -ig _start=SECONDS
}
precmd () {
   (( _start >= 0 )) && set -A _elapsed $_elapsed $(( SECONDS-_start ))
   _start=-1
}
exec_time_bubble() {
    local hour=$((_elapsed[-1]/3600))
    local minute=$((_elapsed[-1]%3600/60))
    local second=$((_elapsed[-1]%3600%60))

    if [[ $minute -lt 10 ]]
    then
        local _minute="0$minute"
    else
        local _minute=$minute
    fi
    if [[ $second -lt 10 ]]
    then
        local _second="0$second"
    else
        local _second=$second
    fi

    local out=""
    if [[ $_elapsed[-1] > 0 ]]
    then
        if [[ $hour -gt 0 ]]
        then
            local out="$hour:$_minute:$_second"
        elif [[ $minute -gt 0 ]]
        then
            local out="$minute:$_second"
        elif [[ $second -gt 0 ]]
        then
            local out=$second"s"
        fi
    fi

    if [[ $_elapsed[-1] > 86399 ]]
    then
        out="It took more than a day :|"
    fi

    if [[ $out ]]
    then
        echo -n "$bubble_left$(foreground '165')$out$bubble_right"
        set -A _elapsed
    fi
}

battery_bubble () {
    local battery_percent=`cat /sys/class/power_supply/BAT0/capacity`
    if [[ $battery_percent == 100 ]]
    then
        local battery_color='027'
        local battery_icon='\uf578'
    elif [[ $battery_percent > 90 ]]
    then
        local battery_color='046'
        local battery_icon='\uf578'
    elif [[ $battery_percent > 80 ]]
    then
        local battery_color='046'
        local battery_icon='\uf581'
    elif [[ $battery_percent > 70 ]]
    then
        local battery_color='047'
        local battery_icon='\uf580'
    elif [[ $battery_percent > 60 ]]
    then
        local battery_color='047'
        local battery_icon='\uf57f'
    elif [[ $battery_percent > 50 ]]
    then
        local battery_color='120'
        local battery_icon='\uf57e'
    elif [[ $battery_percent > 40 ]]
    then
        local battery_color='190'
        local battery_icon='\uf57d'
    elif [[ $battery_percent > 30 ]]
    then
        local battery_color='220'
        local battery_icon='\uf57c'
    elif [[ $battery_percent > 20 ]]
    then
        local battery_color='202'
        local battery_icon='\uf57b'
    elif [[ $battery_percent > 10 ]]
    then
        local battery_color='196'
        local battery_icon='\uf57a'
    elif [[ $battery_percent > 5 ]]
    then
        local battery_color='009'
        local battery_icon='\uf579'
    else
        local battery_color='001'
        local battery_icon='\uf58d'
    fi
    
    echo -n "$bubble_left$(foreground $battery_color)$battery_percent%% $battery_icon$bubble_right"
}

# DEFAULT PROMPT BUILDING BLOCKS
bubble_left="$(foreground $bubble_color)$blub_left%{$reset_color%}$(background $bubble_color)"
bubble_right="%{$reset_color%}$(foreground $bubble_color)$blub_right%{$reset_color%} "

end_of_prompt_bubble="$bubble_left%(?,$(foreground $prompt_symbol_color)$prompt_symbol,$(foreground $prompt_symbol_error_color)$prompt_symbol)$bubble_right"

end_of_prompt=" %(?,$(foreground $prompt_symbol_color)$prompt_symbol,$(foreground $prompt_symbol_error_color)$prompt_symbol%{$reset_color%}) "

user_machine_bubble="$bubble_left$(foreground $user_color)$user_symbol$(foreground $user_machine_symbol_color)$user_machine_symbol$(foreground $machine_color)$machine_symbol$bubble_right"

filepath_bubble="$bubble_left$(foreground $filepath_color)$filepath_symbol$bubble_right"

error_code_bubble="%(?,,$bubble_left$(foreground $prompt_symbol_error_color)%?$bubble_right)"

date_bubble="$bubble_left$(foreground '208')%W$bubble_right"

time_bubble="$bubble_left$(foreground '073')%T  $bubble_right"

# PROMPTS
# different prompts to try out, just uncomment/comment

# --- 1 ---
#PROMPT='$(ssh_bubble)$user_machine_bubble$filepath_bubble$(git_bubble)'

# --- 2 ---
#PROMPT='$end_of_prompt_bubble'
#RPROMPT='$(ssh_bubble)$filepath_bubble$(git_bubble)$error_code_bubble'

# --- 3 ---
_newline=$'\n'
_lineup=$'\e[1A'
_linedown=$'\e[1B'

PROMPT='$_newline$(ssh_bubble)$user_machine_bubble$filepath_bubble$_newline$end_of_prompt%{$reset_color%}'
RPROMPT='%{$_lineup%}$(git_bubble)$error_code_bubble$(exec_time_bubble)$date_bubble$time_bubble$(battery_bubble)%{$_linedown%}%{$reset_color%}'

