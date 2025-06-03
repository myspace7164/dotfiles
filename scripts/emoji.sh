#!/usr/bin/env bash
#
# emoji-dmenu.sh – list every Unicode emoji with its name, ready for dmenu
#
#   chosen=$(emoji-dmenu.sh | dmenu -i -l 20)
#   printf '%s\n' "${chosen%% *}" | xclip -selection clipboard
#
# Requirements: curl, python3 (for the tiny parsing helper), coreutils.

set -euo pipefail

UNICODE_VER="15.1"                       # change when a newer spec lands
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/emoji.sh"

if [[ -r /usr/share/unicode/emoji/emoji-test.txt ]]; then
    EMOJI_SRC="/usr/share/unicode/emoji/emoji-test.txt"
else
    EMOJI_SRC="$CACHE_DIR/emoji-test.txt"   # fall back to download + cache
fi

EMOJI_LST="$CACHE_DIR/emoji-dmenu.lst"   # pretty list for dmenu

mkdir -p "$CACHE_DIR"

# 1. Download spec if we don’t have it (or it’s empty)
if [[ ! -s "$EMOJI_SRC" ]]; then
  curl -L --progress-bar "https://unicode.org/Public/emoji/${UNICODE_VER}/emoji-test.txt" -o "$EMOJI_SRC"
fi

# 2. (Re)generate the pretty list if needed
if [[ ! -s "$EMOJI_LST" || "$EMOJI_SRC" -nt "$EMOJI_LST" ]]; then
  python3 - "$EMOJI_SRC" "$EMOJI_LST" <<'PY'
import re, sys, unicodedata, pathlib, html
src, dst = sys.argv[1], sys.argv[2]
pat = re.compile(r'^\s*([0-9A-F ]+)\s*; fully-qualified\s*#\s*(\S.*)$')
with open(src, encoding='utf-8') as fin, open(dst, 'w', encoding='utf-8') as fout:
    for line in fin:
        m = pat.match(line)
        if not m:                 # skip comments, unqualified, components, …
            continue
        cps, tail = m.groups()    # “1F600  FE0F”  and  “😀 grinning face”
        # tail → first field is the actual emoji, remainder is the name
        emoji, *rest = tail.split(' ', 1)
        name = rest[0] if rest else unicodedata.name(emoji, '')
        fout.write(f"{emoji} {name}\n")
PY
fi

# 3. Spit the list to stdout (dmenu takes it from here)
cat "$EMOJI_LST"
