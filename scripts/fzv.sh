#!/bin/zsh
file=$(fzf)
[ -n "$file" ] && nvim "$file"
