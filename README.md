#tasks

1. Set up GNOME icons path




{ config, pkgs, lib, ... }:

{
# 1. Link the external directory
	home.file.".local/share/icons/Custom-Icons" = {
		source = config.lib.file.mkOutOfStoreSymlink "/home/user/Downloads/MyTheme";
	};

# 2. Configure dconf to use it
	dconf.settings = {
		"org/gnome/desktop/interface" = {
			icon-theme = "Custom-Icons";
		};
	};

# Optional: Ensure dconf is enabled
	dconf.enable = true;
}
