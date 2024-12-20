{ config, lib, pkgs, inputs, host, ... }:

{
  options.custom = with lib; {
    monitors = mkOption {
      description = "Configuration for monitors";
      type = with types; nonEmptyListOf (submodule {
        options = {
          name = mkOption {
            description = "Name of the display";
            type = str;
          };
          resolution = mkOption {
            description = "Resolution of the display";
            type = str;
          };
          refreshRate = mkOption {
            description = "Refresh rate of the display";
            type = int;
          };
          position = mkOption {
            description = "Position of the display";
            type = str;
          };
          workspaces = mkOption {
            description = "List of workspace numbers";
            type = listOf int;
          };
        };
      });
      default = [ ];
    };
  };

  config = {
    home.packages = with pkgs; [
      swww
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;

      settings = {
        monitor = (lib.forEach config.custom.monitors (monitor:
          "${monitor.name}, ${monitor.resolution}@${toString monitor.refreshRate}, ${monitor.position}, 1"
        ));

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

          "col.active_border" = "rgba(33ccffff) rgba(00ff99ff) 45deg";
          "col.inactive_border" = "rgba(595959ff)";

          layout = "dwindle";
        };

        decoration = {
          rounding = 10;

          blur = {
            enabled = true;
            size = 3;
            passes = 2;

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

          bezier = "overshot, 0.05, 0.9, 0.1, 1.05";

          animation = [
            "windows, 1, 5, overshot, slide"
            "windowsOut, 1, 5, default, slide"
            "border, 1, 5, default"
            "borderangle, 1, 8, default"
            "fade, 1, 5, default"
            "workspaces, 1, 5, default"
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

          touchpad = lib.mkIf (host == "twolessone") {
            disable_while_typing = false;
            natural_scroll = true;
          };
        };

        "$mod" = "SUPER";

        bind = [
          "$mod, Q, exec, alacritty"
          "$mod, R, exec, wofi --show drun"
          "$mod, B, exec, firefox"
          "$mod, D, exec, vesktop"

          "$mod, C, killactive,"
          "$mod SHIFT, M, exit,"
          "$mod, V, togglefloating,"
          "$mod, P, pseudo,"
          "$mod, J, togglesplit,"

          "$mod, F, fullscreen,"
          "$mod ALT, F, fullscreenstate, 0 2"

          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"

          "$mod, W, togglespecialworkspace, scratchpad"
          "$mod SHIFT, W, movetoworkspace, special:scratchpad"
        ] ++ (
          builtins.concatLists (builtins.genList (i:
            let
              bind = builtins.toString (i + 1 - ((i + 1) / 10) * 10);
              workspace = toString (i + 1);
            in [
                "$mod, ${bind}, workspace, ${workspace}"
                "$mod SHIFT, ${bind}, movetoworkspace, ${workspace}"
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

        workspace = [ ] ++ lib.optionals (lib.length config.custom.monitors > 1) (lib.flatten (lib.forEach config.custom.monitors (monitor:
          (lib.forEach monitor.workspaces (workspace:
            "${toString workspace}, monitor:${monitor.name}"
          ))
        )));

        windowrulev2 = [
          "suppressevent maximize, class:.*"
          "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

          # Fix 1Password's Quick Acess closing whenever the cursor is moved outside of the window.
          "stayfocused,title:Quick Access — 1Password" 
        ];
      };
    };

    custom.persist = {
      home.directories = [ ".cache/swww" ];
    };
  };
}
