# Bubblified zsh-theme

![bubblified.gif](https://raw.githubusercontent.com/hohmannr/bubblified/master/pics/bubblified.gif)

A zsh-theme inspired by [agnoster](https://github.com/agnoster/agnoster-zsh-theme) and [bubblewritten](https://github.com/paracorde/dots/blob/master/bubblewritten.zsh-theme).

**Best used with [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh) and powered by [nerdfonts](https://github.com/ryanoasis/nerd-fonts)**

## Installation

### Antigen

Place the following line in the [right](https://github.com/zsh-users/antigen) spot of your `.zshrc`

```
antigen theme arsalanyavari/bubblified
```


### Manual

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

## Features

### Git support

The theme's git parser adds two level of git information. Firstly, it colors all common git states differently. Secondly, it gives detailed change information by displaying a variety of icons.

**State Colors**

- `green` – clean branch
- `yellow` – unstaged changes
- `magenta` – all changes are staged
- `blue` – there are stashed changes for this branch
- `red` – unmerged changes/merge conflict

**Icons**

- `•` – indexed file modified
- `` – file added to index
- `` – indexed file removed
- `` – indexed file renamed
- `裸` – untracked file
- `` – indexed file copied

![git-demo.png](https://raw.githubusercontent.com/hohmannr/bubblified/master/pics/git-demo.png)

### SSH Support

If you are installing this theme on a ssh-machine, it automatically detects when you connect to this machine and displays a ssh symbol. You can freely choose this symbol and the bubble color for every ssh-machine that you manage, making them easily differentiable. Check the **Customization** section for further information.

![ssh-demo.png](https://raw.githubusercontent.com/hohmannr/bubblified/master/pics/ssh-demo.png)

### 256 Color support

This theme supports 256 colors, you can use zsh-color-codes (get a list by running the command `spectrum_ls`) or the traditional zsh-color-strings (e.g. `'red'`). Check the **Customization** section for further information.

![256-colors-demo.png](https://raw.githubusercontent.com/hohmannr/bubblified/master/pics/256-colors-demo.png)

## Customization

This theme is built with customization in mind. This means that you should be able to customize colors and icons aswell as add custom bubbles in the theme's style.

### What to do before

***Assuming you are using ohmyzsh***.

Before customization please copy this theme to ohmyzsh's custom theme directory.
```
$ cp $ZSH/themes/bubblified.zsh-theme $ZSH/custom/themes
```

Then edit the theme using your favorite editor, mine is neovim.
```
$ nvim $ZSH/custom/themes/bubblified.zsh-theme
```
To load the edited theme, restart your terminal emulator or source your `.zshrc`.
```
$ source ~/.zshrc
```

### Icons

To change icons for the default bubbles, just change their constants under the `# SYMBOL CONSTANTS` section.

### Colors

To change colors for the default bubbles, just change their constants under the `# COLOR CONSTANTS` section. Valid values are `{'black', 'red', 'blue', 'cyan', 'yellow', 'green', 'white', 'magenta'}`, they correspond to the colors set in your terminal.

```
filepath_color='blue'
```

You can also use zsh-color-codes for a wider spectrum of 256 colors (use the command `spectrum_ls` for a complete list). When working with color codes, make sure that you set all three digits.

```
filepath_color='078'
```

### SSH

***Assuming you have installed the theme ON your SSH-MACHINE.***

To change the icon and the colors (including the bubble's color) you have to customize the theme **on your ssh-machine**.

### Custom Bubbles

#### Simple Bubbles

Simple bubbles are bubbles with the default `bubble_color` and content.
Declare a variable (e.g. the current time)

```
time_bubble="%T"
```
    
Build a bubble by enclosing the variable with `$bubble_left` and `$bubble_right`.

```
time_bubble="$bubble_left%T$bubble_right"
```

*OPTIONAL* - If you want a different text color, then add an escape sequence with the color definition or achieve 256 color support by using the in-built foreground function and a zsh-color-string or a zsh-color-code.

```
time_bubble="$bubble_left%{$fg[red]%}%T$bubble_right"
# or
time_bubble="$bubble_left$(foreground '073')%T$bubble_right"
```

Add the variable to the `PROMPT`.

```
PROMPT='...$time_bubble...'
```

#### Fancy Bubbles

Fancy bubbles are in the style of the default `git_bubble`. They consist of multiple segments for which the text and the background can be colored individually.
Define a custom function that echos the bubble's content.

```
foo () {
    echo -n "left middle right"
}
```

Use the provided `bubblify` function to build custom colored bubble segments.

```
foo () {
    echo -n "$(bubblify 0 "left" "black" "red")$(bubblify 1 "middle" "green" "black")$(bubblify "right" "yellow" "magenta")"
}
```

*TIP* - `bubblify {0, 1, 2, 3} "foreground-color" "background-color"` where `0` builds a left segment, `1` builds a middle segment, `2` builds a right segment and `3` builds a whole custom colored bubble with only one segment. "foreground-color" and "background-color" can be used with zsh-color-strings or zsh-color-codes.

*TIP* - Including `%{$reset_color%}` at the end of the echo will make sure that colors are reset to the default ones after your bubble finishes rendering.

Add the function as a subshell call to the `PROMPT`.

```
PROMPT='...$(foo)...'
```

## Changelog

- version 0.3:
    - added git functionality
    - fastified git parser

- version 0.2:
    - added ssh support
    - added 256 color support

- version 0.1.2:
    - removed unnecessary escape sequences

- version 0.1.1:
    - fixed bug in `bubblify` where function description and README suggested the wrong building order for `$1`

- version 0.1:
    - initial commit

