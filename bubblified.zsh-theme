# vim filetype declaration for highlighting
# vim:ft=sh
#
# Bubble Theme
# Inspired by bubblewritten and agnoster
# written by hohmannr

# SYMBOL CONSTANTS
blub_left=''
blub_right=''

# prompt_symbol='-->'
prompt_symbol='==>'
user_symbol='%n'
user_machine_symbol='@' machine_symbol='%M'
filepath_symbol='%~'

# git asset
git_branch_symbol=''
git_new_symbol=''
git_deleted_symbol=''
git_modified_symbol='•'
git_renamed_symbol=''
git_untracked_symbol='*'
git_clean_symbol=''
git_push_symbol=''
git_pull_symbol=''

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
git_modified_color='red'
git_staged_color='magenta'
git_icons_color='black'

# HELPER FUNCTIONS
bubblify () {
    # This is a helper function to build custom bubbles.
    # 
    # ARGS      VALUES          DESC
    # ----      ------          ----
    # 1.        {0, 1, 2}       0: build left side bubble: content█
    #                           1: build right side bubble: █content                
    #                           2: build middle part: █content█
    #
    # 2.        string          content to be displayed in partial bubble
    #
    # 3.        {"red", ...}    foreground color (text color) as zsh-color-string
    #
    # 4.        {"red", ...}    background color (bubble segment color) as zsh-color-string

    [[ $1 -eq 0 ]] && echo -n "%{$fg[$4]%}$blub_left%{$fg[$3]%}%{$bg[$4]%}$2%{$reset_color%}"

    [[ $1 -eq 1 ]] && echo -n "%{$fg[$3]%}%{$bg[$4]%}$2%{$reset_color%}%{$fg[$4]%}$blub_right%{$reset_color%}"

    [[ $1 -eq 2 ]] && echo -n "%{$fg[$3]%}%{$bg[$4]%}$2%{$reset_color%}"

    [[ $1 -ne 0 && $1 -ne 1 && $1 -ne 2 ]] && echo fail
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
        local git_untracked=$(grep -m1 "git add" <<< $git_status)
        local git_unstaged=$(grep -m1 "Changes not staged for commit:" <<< $git_status)
        local git_staged=$(grep -m1 "Changes to be committed:" <<< $git_status)

        # used for icons
        local git_modified=$(grep -m1 "modified:" <<< $git_status)
        local git_renamed=$(grep -m1 "renamed:" <<< $git_status)
        local git_new=$(grep -m1 "new file:" <<< $git_status)
        local git_deleted=$(grep -m1 "deleted:" <<< $git_status)
        local git_clean=$(grep -m1 "nothing to commit" <<< $git_status)
        local git_push=$(grep -m1 "git push" <<< $git_status)
        local git_pull=$(grep -m1 "git pull" <<< $git_status)

        # determining coloring
        [[ -n $git_untracked || -n $git_unstaged ]] && local git_color=$git_modified_color

        [[ -n $git_staged ]] && local git_color=$git_staged_color

        [[ -z $git_untracked && -z $git_staged ]] && local git_color=$git_default_color


        # determining which icons to add
        local git_icons=""
        [[ -n $git_deleted ]] && git_icons="$git_deleted_symbol"

        [[ -n $git_modified ]] && git_icons="$git_modified_symbol"

        [[ -n $git_renamed ]] && git_icons="$git_renamed_symbol"

        [[ -n $git_new ]] && git_icons="$git_new_symbol"

        [[ -n $git_untracked ]] && git_icons="$git_untracked_symbol"

        [[ -n $git_clean ]] && git_icons="$git_clean_symbol"

        [[ -n $git_push ]] && git_icons="$git_push_symbol"

        [[ -n $git_pull ]] && git_icons="$git_push_symbol"

        echo -n "$(bubblify 0 "$git_info " $git_color $bubble_color)$(bubblify 1 " $git_icons" $git_icons_color $git_color) "
    fi
}

preexec() {
    timer=${timer:-$SECONDS}
}

precmd() {
    if [ $timer ]; then
        timer_show=$(($SECONDS - $timer))
        timer_show=$(printf '%.*f\n' 3 $timer_show)
        exit_code_and_command_time_bubble_error="%(?,%{$fg[blue]%}$bubble_left%{$fg[blue]%}[%?] : $timer_show $bubble_right,%{$fg[red]%}$bubble_left%{$fg[red]%}[%?] : $timer_show $bubble_right)"
        unset timer
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
# PROMPT='$user_machine_bubble$filepath_bubble$(git_bubble)'

# --- 2 ---
# PROMPT='$end_of_prompt_bubble'
# RPROMPT='$filepath_bubble$(git_bubble)$error_code_bubble'

# --- 3 ---

# RPROMPT='%{${_lineup}%}%F{$hcolor}[%?%F{$dcolor}] : %F{$hcolor}${timer_show}s %F{$dcolor} %{${_linedown}%'
# RPROMPT='%{${_lineup}%}$exit_code_and_command_time_bubble_success %{${_linedown}%'

_newline=$'\n'
_lineup=$'\e[1A'
_linedown=$'\e[1B'

PROMPT='${_linedown}$filepath_bubble$(git_bubble)${_newline}$end_of_prompt'
RPROMPT='%{${_lineup}%}$exit_code_and_command_time_bubble_error %{${_linedown}%'
