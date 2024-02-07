#!/usr/bin/sh

dir="$HOME/.config/rofi/"
theme='bar'

## Run
rofi \
    -show drun \
    -theme ${dir}/${theme}.rasi
