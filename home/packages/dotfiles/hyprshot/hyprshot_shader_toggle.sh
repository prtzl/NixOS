#!/usr/bin/env bash

options=("$@")

active=$(hyprshade current)
if [ -n "$active" ]; then
    hyprshade off
fi

hyprshot "${options[@]}"

if [ -n "$active" ]; then
    hyprshade on "$active"
fi
