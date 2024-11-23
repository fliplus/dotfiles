{ lib, ... }:

{
  options.custom = with lib; {
    persist = {
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
}
