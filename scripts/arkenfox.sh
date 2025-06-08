#!/usr/bin/env bash

basedir=$(dirname "$0")

echo "basedir=$basedir"

# TODO Maybe verify download?
echo "Downloading updater.sh to $basedir"
curl -o $basedir/updater.sh https://raw.githubusercontent.com/arkenfox/user.js/master/updater.sh

echo "Downloading prefsCleaner.sh to $basedir"
curl -o $basedir/prefsCleaner.sh https://raw.githubusercontent.com/arkenfox/user.js/master/prefsCleaner.sh

bash $basedir/updater.sh -s -u
bash $basedir/prefsCleaner.sh -s

echo "Deleting $basedir/updater.sh"
rm -vf $basedir/updater.sh

echo "Deleting $basedir/prefsCleaner.sh"
rm -vf $basedir/prefsCleaner.sh

unset basedir
