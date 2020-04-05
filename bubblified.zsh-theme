# vim filetype declaration for highlighting
# vim:ft=sh
#
# Bubble Theme
# Inspired by bubblewritten and agnoster
# written by hohmannr

# SYMBOL CONSTANTS
blub_left=''
blub_right=''

prompt_symbol='-->'

user_symbol='%n'
user_machine_symbol='@' machine_symbol='%M'

filepath_symbol='%~'

git_branch_symbol=''
git_new_symbol=''
git_deleted_symbol=''
git_modified_symbol='•'
git_renamed_symbol=''
git_untracked_symbol='裸'

ssh_symbol='ssh'

# COLOR CONSTANTS
# NOTE: Possible values include zsh-color-strings like 'red', 'black', 'magenta' etc.
# TODO: Add support for zsh-color-codes like '000' to '255' for 256 color support (use command 'spectrum_ls' for all color codes)
bubble_color='black'

prompt_symbol_color='blue'
prompt_symbol_error_color='red'

user_color='yellow'
user_machine_symbol_color='green'
machine_color='magenta'

filepath_color='blue'

git_default_color='green'
git_modified_color='yellow'
git_staged_color='magenta' 
git_icons_color='black'

ssh_symbol_color='black'
ssh_bubble_color='green'

# HELPER FUNCTIONS
bubblify () {
    # This is a helper function to build custom bubbles.
    # 
    # ARGS      VALUES          DESC
    # ----      ------          ----
    # 1.        {0, 1, 2, 3}    0: build left side bubble: content█
    #                           1: build right side bubble: █content                
    #                           2: build middle part: █content█
    #                           3: build custom colored whole bubble: content
    #
    # 2.        string          content to be displayed in partial bubble
    #
    # 3.        {"red", ...}    foreground color (text color) as zsh-color-string
    #
    # 4.        {"red", ...}    background color (bubble segment color) as zsh-color-string

    if [[ $1 -eq 0 ]]; then
        echo -n "%{$fg[$4]%}$blub_left%{$fg[$3]%}%{$bg[$4]%}$2%{$reset_color%}"
    elif [[ $1 -eq 1 ]]; then
        echo -n "%{$fg[$3]%}%{$bg[$4]%}$2%{$reset_color%}"
    elif [[ $1 -eq 2 ]]; then
        echo -n "%{$fg[$3]%}%{$bg[$4]%}$2%{$reset_color%}%{$fg[$4]%}$blub_right%{$reset_color%}"
    elif [[ $1 -eq 3 ]]; then
        echo -n "%{$fg[$4]%}$blub_left%{$fg[$3]%}%{$bg[$4]%}$2%{$reset_color%}%{$fg[$4]%}$blub_right%{$reset_color%}"
    else
        echo 'bblfy_fail'
    fi
}

# PROMPT FUNCTIONS
git_bubble () {
    # This parses git status in a very very ugly and dirty way to retrieve all necessary information...I am new to this bash scripting...mercy!
    # NOTE: Feel free to submit a pull request to beautify this code to reduce lagg.
    local git_branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)

    if [[ -n $git_branch ]]; then
        # branch name with symbol
        local git_info="$git_branch_symbol $git_branch"

        # used for coloring
        local git_status=$(git status 2> /dev/null) 

        local git_untracked=$(echo "$git_status" | grep -m1 "Untracked files:")
        local git_unstaged=$(echo "$git_status" | grep -m1 "Changes not staged for commit:")
        local git_staged=$(echo "$git_status"| grep -m1 "Changes to be committed:")

        # used for icons
        local git_modified=$(echo "$git_status" | grep -m1 "modified:")
        local git_renamed=$(echo "$git_status" | grep -m1 "renamed:")
        local git_new=$(echo "$git_status" | grep -m1 "new file:")
        local git_deleted=$(echo "$git_status" | grep -m1 "deleted:")

        # determining coloring
        if [[ -n $git_untracked || -n $git_unstaged ]]; then
            local git_color=$git_modified_color
        elif [[ -n $git_staged ]]; then
            local git_color=$git_staged_color
        else
            local git_color=$git_default_color
        fi

        # determining which icons to add 
        local git_icons=""
        if [[ -n $git_modified ]]; then
            git_icons="$git_icons$git_modified_symbol"
        fi
        if [[ -n $git_renamed ]]; then
            git_icons="$git_icons$git_renamed_symbol"
        fi
        if [[ -n $git_new ]]; then
            git_icons="$git_icons$git_new_symbol"
        fi
        if [[ -n $git_deleted ]]; then
            git_icons="$git_icons$git_deleted_symbol"
        fi
        if [[ -n $git_untracked ]]; then
            git_icons="$git_icons$git_untracked_symbol"
        fi

        echo -n "$(bubblify 0 "$git_info " $git_color $bubble_color)$(bubblify 2 " $git_icons" $git_icons_color $git_color) "
    fi
}

ssh_bubble () {
    # detects an ssh connection and displays a bubble 
    if [[ -n $SSH_CLIENT || -n $SSH_TTY || -n $SSH_CONNECTION ]]; then
        echo -n "$(bubblify 3 "$ssh_symbol" $ssh_symbol_color $ssh_bubble_color) "
    fi
}

# DEFAULT PROMPT BUILDING BLOCKS
bubble_left="%{$fg[$bubble_color]%}$blub_left%{$reset_color%}%{$bg[$bubble_color]%}"
bubble_right="%{$reset_color%}%{$fg[$bubble_color]%}$blub_right%{$reset_color%} "

end_of_prompt_bubble="$bubble_left%(?,%{$fg[$prompt_symbol_color]%}$prompt_symbol,%{$fg[$prompt_symbol_error_color]%}$prompt_symbol)$bubble_right"

end_of_prompt=" %(?,%{$fg[$prompt_symbol_color]%}$prompt_symbol,%{$fg[$prompt_symbol_error_color]%}$prompt_symbol%{$reset_color%}) "

user_machine_bubble="$bubble_left%{$fg[$user_color]%}$user_symbol%{$fg[$user_machine_symbol_color]%}$user_machine_symbol%{$fg[$machine_color]%}$machine_symbol$bubble_right"

filepath_bubble="$bubble_left%{$fg[$filepath_color]%}$filepath_symbol$bubble_right"

error_code_bubble="%(?,,$bubble_left%{$fg[$prompt_symbol_error_color]%}%?$bubble_right)"

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

PROMPT='$(ssh_bubble)$user_machine_bubble$filepath_bubble$_newline$end_of_prompt'
RPROMPT='%{$_lineup%}$(git_bubble)$error_code_bubble%{$_linedown%}%{$reset_color%}'

