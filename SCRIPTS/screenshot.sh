#! /bin/sh

output=~/screenshots/%Y-%m-%d-%T-sc.png

case "$1" in
	"select") scrot -s -q 100 -l mode=classic "$output" || exit ;;
	"window") scrot -q 100 --focused -b "$output" || exit ;;
	*) scrot "$output" || exit ;;
esac

notify-send "Screenshot taken."
