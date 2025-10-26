{
  programs.plasma = {
    enable = true;
    workspace.wallpaper = ./10-3-6k.jpg;
    kscreenlocker.appearance.wallpaper = ./10-3-6k.jpg;
    panels = [
      {
        widgets = [
          {
            name = "org.kde.plasma.kickoff";
            config = {
              General = {
                icon = "nix-snowflake";
                alphaSort = true;
              };
            };
          }
          "org.kde.plasma.pager"
          {
            iconTasks = {
              launchers = [
                "applications:systemsettings.desktop"
                "preferred://filemanager"
                "preferred://browser"
                "applications:com.mitchellh.ghostty.desktop"
              ];
            };
          }
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
          "org.kde.plasma.showdesktop"
        ];
      }
    ];
    shortcuts = {
      "org_kde_powerdevil"."Decrease Screen Brightness" = [
        "Monitor Brightness Down"
        "Meta+Volume Down"
      ];
      "org_kde_powerdevil"."Decrease Screen Brightness Small" = [
        "Shift+Monitor Brightness Down"
        "Meta+Shift+Volume Down"
      ];
      "org_kde_powerdevil"."Increase Screen Brightness" = [
        "Monitor Brightness Up"
        "Meta+Volume Up"
      ];
      "org_kde_powerdevil"."Increase Screen Brightness Small" = [
        "Shift+Monitor Brightness Up"
        "Meta+Shift+Volume Up"
      ];
    };
  };
}
