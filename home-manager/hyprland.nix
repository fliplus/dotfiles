{ config, lib, pkgs, inputs, host, ... }:

{
  home.packages = with pkgs; [
    swww
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;

    settings = {
      monitor = [
        "HDMI-A-1, 1920x1080@240, 0x0, 1"
        "DP-1, 1920x1080@144, 1920x0, 1"
      ];

      "$terminal" = "alacritty";
      "$menu" = "wofi --show drun";

      exec-once = [
        "swww-daemon"
      ];

      env = [
        "HYPRCURSOR_THEME,${config.home.pointerCursor.name}"
        "XCURSOR_SIZE,${toString config.home.pointerCursor.size}"

        "LIBVA_DRIVER_NAME,nvidia"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      ];

      cursor = {
        no_hardware_cursors = true;
      };

      general = rec {
        gaps_in = 5;
        gaps_out = gaps_in*2;

        border_size = 2;

        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        layout = "dwindle";
      };

      decoration = {
        rounding = 10;

        blur = {
          enabled = true;
          size = 3;
          passes = 1;

          vibrancy = 0.1696;
        };

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };

      animations = {
        enabled = true;

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      input = {
        kb_layout = "us";
      };

      "$mod" = "SUPER";

      bind = [
        "$mod, Q, exec, $terminal"
        "$mod, R, exec, $menu"
        "$mod, B, exec, firefox"
        "$mod, D, exec, vesktop"

        "$mod, C, killactive,"
        "$mod SHIFT, M, exit,"
        "$mod, V, togglefloating,"
        "$mod, P, pseudo,"
        "$mod, J, togglesplit,"
        "$mod, F, fullscreen,"

        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"
      ] ++ (
        builtins.concatLists (builtins.genList (i:
          let
            key = builtins.toString (i + 1 - ((i + 1) / 10) * 10);
            workspace = toString (i + 1);
          in [
              "$mod, ${key}, workspace, ${workspace}"
              "$mod SHIFT, ${key}, movetoworkspace, ${workspace}"
          ]
        ) 10)
      );

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];

      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      workspace = [
        "1, monitor:HDMI-A-1"
        "2, monitor:HDMI-A-1"
        "3, monitor:HDMI-A-1"
        "4, monitor:HDMI-A-1"
        "5, monitor:HDMI-A-1"
        "6, monitor:HDMI-A-1"
        "7, monitor:HDMI-A-1"
        "8, monitor:HDMI-A-1"
        "9, monitor:DP-1"
        "10, monitor:DP-1"
      ];

      windowrulev2 = [
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

        # Fix 1Password's Quick Acess closing whenever the cursor is moved outside of the window.
        "stayfocused,title:Quick Access — 1Password" 
      ];
    };
  };

  custom.persist = {
    home.directories = [
      ".cache/swww"
    ];
  };
}
