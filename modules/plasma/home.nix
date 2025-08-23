{
  programs.plasma.enable = true;

  programs.plasma.workspace.wallpaper = ./10-3-6k.jpg;
  programs.plasma.kscreenlocker.appearance.wallpaper = ./10-3-6k.jpg;

  programs.plasma.shortcuts = {
    "org_kde_powerdevil"."Decrease Screen Brightness" = [ "Meta+Volume Down" ];
    "org_kde_powerdevil"."Decrease Screen Brightness Small" = [ "Meta+Shift+Volume Down" ];
    "org_kde_powerdevil"."Increase Screen Brightness" = [ "Meta+Volume Up" ];
    "org_kde_powerdevil"."Increase Screen Brightness Small" = [ "Meta+Shift+Volume Up" ];
  };
}
