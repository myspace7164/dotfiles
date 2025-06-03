#!/usr/bin/env bash

# get selection
selection=$(cliphist list | wmenu -i -f "Iosevka 10" | cliphist decode)

# does it start with file:// ?
if [[ $selection == file://* ]]; then
    filepath="${selection#file://}"
    decoded_path=$(printf '%b' "${filepath//%/\\x}")
    if [[ -e "$decoded_path" ]]; then
        # if the file exists set the proper mimetype
        printf '%s\n' "$selection" | wl-copy -t text/uri-list
        exit 0
    fi
fi

# else fall back to normal wl-copy
printf '%s\n' "$selection" | wl-copy
