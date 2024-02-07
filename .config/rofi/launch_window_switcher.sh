#!/usr/bin/sh

dir="$HOME/.config/rofi/"
theme='b_bar'

## Run
rofi \
    -show window \
    -theme ${dir}/${theme}.rasi
