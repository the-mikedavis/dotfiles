#! /usr/bin/env bash

killall -q polybar

polybar main >> /tmp/polybar-main.log 2>&1 & disown

echo "Bar(s) launched!"
