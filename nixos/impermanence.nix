{ config, lib, pkgs, user, ... }:
let
  assertNoHomeDirectories =
    paths:
    assert (lib.assertMsg (!lib.any (lib.hasPrefix "/home") paths) "/home used in a root persist.");
    paths;
  homeConfig = config.home-manager.users.${user};
in
{
  options.custom = with lib; {
    persist = {
      root = {
        directories = mkOption {
          description = "Directories to persist in root filesystem";
          type = types.listOf types.str;
          default = [ ];
          apply = assertNoHomeDirectories;
        };
        files = mkOption {
          description = "Files to persist in root filesystem";
          type = types.listOf types.str;
          default = [ ];
          apply = assertNoHomeDirectories;
        };
      };
      home = {
        directories = mkOption {
          description = "Directories to persist in home directory";
          type = types.listOf types.str;
          default = [ ];
        };
        files = mkOption {
          description = "Files to persist in home directory";
          type = types.listOf types.str;
          default = [ ];
        };
      };
    };
  };

  config = { 
    boot.initrd.postDeviceCommands = lib.mkAfter ''
      mkdir /btrfs_tmp
      mount /dev/root_vg/root /btrfs_tmp
      if [[ -e /btrfs_tmp/root ]]; then
          mkdir -p /btrfs_tmp/old_roots
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
          mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
      fi

      delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
      }

      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
          delete_subvolume_recursively "$i"
      done
  
      btrfs subvolume create /btrfs_tmp/root
      umount /btrfs_tmp
    '';

    fileSystems."/persist".neededForBoot = true;
    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [ ] ++ config.custom.persist.root.directories;
      files = [ ] ++ config.custom.persist.root.files;

      users.${user} = {
        directories = [ ] ++ config.custom.persist.home.directories ++ homeConfig.custom.persist.home.directories;
        files = [ ] ++ config.custom.persist.home.files ++ homeConfig.custom.persist.home.files;
      };
    };

    security.sudo.extraConfig = "Defaults lecture=never";

    environment.systemPackages = with pkgs; [
      (writeShellScriptBin "persist-list" ''
        echo "Persisted root directories:"
        echo "${builtins.concatStringsSep "\n" config.custom.persist.root.directories}" | sort
        echo ""
        echo "Persisted root files:"
        echo "${builtins.concatStringsSep "\n" config.custom.persist.root.files}" | sort
        echo ""
        echo "Persisted home directories:"
        echo "${builtins.concatStringsSep "\n" (config.custom.persist.home.directories ++ homeConfig.custom.persist.home.directories)}" | sort
        echo ""
        echo "Persisted home files:"
        echo "${builtins.concatStringsSep "\n" (config.custom.persist.home.files ++ homeConfig.custom.persist.home.files)}" | sort
      '')
    ];
  };
}
