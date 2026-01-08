{config, pkgs, ...}:

{

	home.username = "wytchblade";
	home.homeDirectory = "/home/wytchblade";

# config for neovim
	home.file.".config/nvim" = {
		enable = true;
		recursive = true;
		source = ../nvim/.config/nvim;
	};

# config for sioyek
	home.file.".config/sioyek" = {
		enable = true;
		recursive = true;
		source = ../sioyek/.config/sioyek;
	};

# config for GNOME icons
	home.file.".local/share/icons" = {
		enable = true;
		recursive = true;
		source = ../gnome/icon_themes;
	};

# config for GNOME extensions built from source
	home.file.".local/share/gnome-shell/extensions" = {
		enable = true;
		recursive = true;
		source = ../gnome/extensions;
	};

# Symlink gnome-shell-extension-transparent-window to .local/share/gnome-shell/extensions
# home.file.".local/share/gnome-shell/extensions/transparent-window@qbxdown.github.com" = {
# 	enable = true;
# 	recursive = true;
#   source = ../gnome_extensions/gnome-shell-extension-transparent-window;
# };

# home.file.".local/share/gnome-shell/extensions/transparent-window@pbxqdown.github.com" = {
#     # Check your metadata.json to confirm if it is 'pbxqdown' or 'qbxdown'
#     source = ../extensions/gnome-shell-extension-transparent-window;
#     # Default is recursive = false, which is usually preferred for extensions
#     recursive = false; 
# };

# config for ghostty
	home.file.".config/ghostty" = {
		enable = true;
		recursive = true;
		source = ../ghostty/.config/ghostty;
	};


	programs.neovim = {
		enable = true;

# Use Neovim as the system-wide default editor
		defaultEditor = true;

# Create aliases for common commands
		viAlias = true;
		vimAlias = true;
		vimdiffAlias = true;

# Configuration for external tools required by plugins (LSPs, formatters, etc.)
		extraPackages = with pkgs; [
			ripgrep               # Required for Telescope
				fd                    # Better find for Telescope
				lua-language-server   # Lua LSP
				nil                   # Nix LSP
		];

	};



	home.stateVersion = "23.11";
	programs.home-manager.enable = true;

# # Make windows borderless
# 	gtk = {
# 		enable = true;
#
# # This targets GTK3 apps
# 		gtk3.extraCss = ''
# 			headerbar {
# 				min-height: 0px;
# padding: 0;
# margin: -100px;
# 			}
# 		'';
#
# # This targets GTK4/Libadwaita apps
# 		gtk4.extraCss = ''
# 			headerbar, 
# 			headerbar.titlebar {
# 				min-height: 0px;
# padding: 0;
# 				 margin-top: -100px;
# 			}
#
# 		/* Target specific Libadwaita child elements to prevent ghost spacing */
# 		headerbar windowhandle {
# 			min-height: 0px;
# 		}
#
# 		headerbar windowtitle {
# visibility: hidden;
# opacity: 0;
# 		}
# 		'';
# 	};



	home.packages = with pkgs; [
		gnomeExtensions.dash-to-panel
		gnomeExtensions.highlight-focus
	];

	dconf.settings = {
		"org/gnome/shell" = {
			disable-user-extensions = false;
			enabled-extensions = [
				pkgs.gnomeExtensions.dash-to-panel.extensionUuid
				pkgs.gnomeExtensions.advanced-alttab-window-switcher.extensionUuid
				pkgs.gnomeExtensions.highlight-focus.extensionUuid
				pkgs.gnomeExtensions.desktop-clock.extensionUuid
				pkgs.gnomeExtensions.just-perfection.extensionUuid
				# Custom extensions can be added like so
				"transparent-window@pbxqdown.github.com"
			];
		};
		"org/gnome/desktop/interface" = {
			icon-theme = "wytchblade";
		};

		"org/gnome/desktop/wm/keybindings" = {
				switch-to-workspace-left = [ "<Alt>h" ];
				switch-to-workspace-right = [ "<Alt>l" ];
				# snapping windows to the left/right sides
				toggle-tiled-left = [ "<Control><Alt>h" ];
				toggle-tiled-right = [ "<Control><Alt>l" ];
				
				# maximize and unmaximize
				maximize = [ "<Control><Alt>k" ];
				unmaximize = [ "<Control><Alt>j" ];

				# Moving windows between monitors
				move-to-monitor-up = [ "<Shift><Alt>k" ];
				move-to-monitor-down = [ "<Shift><Alt>j" ];
						
				# move windows to the left/right workspaces
				move-to-workspace-left = [ "<Shift><Alt>h" ];
				move-to-workspace-right = [ "<Shift><Alt>l" ];

				# Pin window to all workspaces
				toggle-on-all-workspaces = [ "<Control><Alt>j" ];
			};

		# disable the default lock shortcut
		"org/gnome/settings-daemon/plugins/media-keys" = {
			screensaver = [ "" ];
		};



	};


}


