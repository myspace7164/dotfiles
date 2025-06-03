#!/usr/bin/env bash

outdir="$(xdg-user-dir VIDEOS)"
mkdir -vp $outdir
file="$outdir/$(date +%Y%m%d-%H%M%S).mp4"

case "${1:-full}" in
    full)
        geom="0,0 0x0"
        ;;
    region)
        geom=$(slurp) || exit 1
        ;;
    window)
        geom=$(swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | "\(.rect.x+.window_rect.x),\(.rect.y+.window_rect.y) \(.window_rect.width)x\(.window_rect.height)"' | slurp) || exit 1
        ;;
    *)
        echo "Usage: $0 {full|region|window}" >&2
        exit 1
        ;;
esac

wf-recorder -g "$geom" -f "$file"
wl-copy -t text/uri-list <<< "file://$file"
