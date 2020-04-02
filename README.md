# Bubblified zsh-theme

![bubblified.gif](https://raw.githubusercontent.com/hohmannr/bubblified/master/bubblified.gif)

A zsh-theme inspired by [agnoster](https://github.com/agnoster/agnoster-zsh-theme) and [bubblewritten](https://github.com/paracorde/dots/blob/master/bubblewritten.zsh-theme). Best used with [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh).

## Installation
***Assuming you are using ohmyzsh***.

Get the sourcefile
```
$ wget https://raw.githubusercontent.com/hohmannr/bubblified/master/bubblified.zsh-theme
```

Move it to your ohmyzsh theme folder
```
$ mv bubblified.zsh-theme $ZSH/themes
```

Open your `.zshrc` and change the theme
```
ZSH_THEME="bubblified"
```

Restart your terminal emulator and enjoy.


## Customization

This theme is built with customization in mind. This means that you should be able to customize colors and icons aswell as add custom bubbles in the theme's style.

### Icons

To change icons for the default bubbles, just change their constants under the `# SYMBOL CONSTANTS` section.

### Colors

To change colors for the default bubbles, just change their constants under the `# COLOR CONSTANTS` section. Valid values are `{'black', 'red', 'blue', 'cyan', 'yellow', 'green', 'white', 'magenta'}`, they correspond to the colors set in your terminal.

### Custom bubbles

Normal bubbles are bubbles with the default `bubble_color` and content.

1. Declare a variable (e.g. the current time)

`time_bubble="%T"`
    
2. Build a bubble by enclosing the variable with `$bubble_left` and `$bubble_right`

`time_bubble="$bubble_left%T$bubble_right"`

3. *OPTIONAL* - If you want a different text color, then add an escape sequence with the color definition

`time_bubble="$bubble_left%{$fg[red]%}%T$bubble_right"`

4. Add the variable to the `PROMPT`

`PROMPT='...$time_bubble...'`

Custom bubbles are in the style of the default `git_bubble`. They consist of multiple segments for which the text and the background can be colored individually.

1. Define a custom function that echos the bubble's content
        
`foo () { echo -n "left middle right" }`

2. Use the provided `bubblify` function to build custom colored bubble segments

`foo () { echo -n "$(bubblify 0 "left" "black" "red")$(bubblify 1 "middle" "green" "black")$(bubblify "right" "yellow" "magenta")" }`

*TIP* - `bubblify {0, 1, 2} "foreground-color" "background-color"` where `0` builds a left segment, `1` builds a middle segment and `2` builds a right segment.

*TIP* - Including `%{$reset_color%}` at the end of the echo will make sure that colors are reset to the default ones after your bubble finishes rendering.

3. Add the function as a subshell call to the `PROMPT`

`PROMPT='...$(foo)...'`

