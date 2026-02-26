scriptdir=$(readlink -f $(dirname "$0"))

nix flake update --flake $scriptdir

sudo nixos-rebuild switch --flake $scriptdir
nixos-rebuild switch --flake $scriptdir#pronto --build-host root@192.168.1.50 --target-host root@192.168.1.50
nixos-rebuild switch --flake $scriptdir#marlin --build-host root@192.168.1.160 --target-host root@192.168.1.160
nixos-rebuild switch --flake $scriptdir#staring --build-host root@192.168.1.6 --target-host root@192.168.1.6
