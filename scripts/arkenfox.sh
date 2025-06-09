#!/usr/bin/env bash

basedir=$(dirname "$0")
echo $basedir

# Set Firefox profile directory
moz_dir="$HOME/.mozilla/firefox"
user_overrides_source="$(pwd)/$basedir/../config/user-overrides.js"
user_overrides_source="$(realpath $user_overrides_source)"
profile_suffix="arkenfox"

# Look for existing *.arkenfox profile
profile_dir=$(find "$moz_dir" -maxdepth 1 -type d -name "*.$profile_suffix" | head -n 1)

# If no profile found, start Firefox to generate profiles
if [ -z "$profile_dir" ]; then
    if [[ -z "$DISPLAY" && -z "$WAYLAND_DISPLAY" ]]; then
        echo "Error: No graphical session detected. Cannot start Firefox."
        exit 1
    fi

    echo "No .arkenfox profile found. Starting Firefox to create one..."
    echo "Make sure you name the profile: $profile_suffix"
    firefox --ProfileManager

    # Try finding the profile again
    profile_dir=$(find "$moz_dir" -maxdepth 1 -type d -name "*.$profile_suffix" | head -n 1)

    # Fail if it still doesn't exist
    if [ -z "$profile_dir" ]; then
        echo "Failed to create .arkenfox profile."
        exit 1
    fi
fi

# Symlink user-overrides.js to profile directory
target="$profile_dir/user-overrides.js"
if [ ! -e "$target" ]; then
    echo "Creating symlink: $target"
    ln -s "$user_overrides_source" "$target"
else
    echo "Symlink or file already exists: $target"
fi

pushd "$profile_dir" || exit

echo "Downloading updater.sh to $(pwd)"
curl -o updater.sh https://raw.githubusercontent.com/arkenfox/user.js/master/updater.sh

echo "Downloading prefsCleaner.sh to $(pwd)"
curl -o prefsCleaner.sh https://raw.githubusercontent.com/arkenfox/user.js/master/prefsCleaner.sh

bash updater.sh -s -u
bash prefsCleaner.sh -s

popd
