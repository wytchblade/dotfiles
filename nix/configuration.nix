# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.home-manager
    ];


  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.wytchblade = import ./home.nix;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Phoenix";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };


# Configure keyd with overloaded CAPSLOCK key (ESC on tap, CTRL on hold)
services.keyd = {
    enable = true;
    keyboards = {
      # The name 'default' will create /etc/keyd/default.conf
      default = {
        ids = [ "*" ]; # Match all keyboards
        settings = {
          main = {
            capslock = "overload(control, esc)";
          };
          # You can add other layers here
          # shift = {
            # remap_example = "macro(hello world)";
          };
        };
      };
    };


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.wytchblade = {
    isNormalUser = true;
    description = "wytchblade";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };
  
  # Enable experimental features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
    # Add any other experimental feature here, e.g., "recursive-nix"
  ];
  

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

environment.variables = {
    SUDO_EDITOR = "nvim";
    VISUAL = "nvim";
    EDITOR = "nvim";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    neovim
    git
    discord
    julia-bin
    ghostty
    libGL
    libxkbcommon
    wayland
    tmux
    stow
    glib
    element-desktop
    pkg-config
    gimp
    inkscape
    gnomeExtensions.advanced-alttab-window-switcher
    gnomeExtensions.desktop-clock
    gnomeExtensions.just-perfection
    # packages that are required for neovim
    lua-language-server
    ripgrep
    fd
    telegram-desktop
    gcc 
    mangohud
    protonup-qt
    python315
    zoxide
    wl-clipboard
    tree
    blender
    sioyek
    texliveFull
    tree-sitter
    imagemagick
    nodejs_22
    nodePackages.mathjax-node-cli
    nodePackages.mathjax
    librsvg
    typst
    zathura
    ];

# Configuration option for neovim

# programs.neovim = {
#   enable = true;
#   defaultEditor = true;
#
#   # This injects your existing init.lua into the Nix-managed config
#   configure = {
#     customRC = ''
#       lua << EOF
#        ${builtins.readFile ./path/to/your/init.lua} EOF
#     '';
#
#     # Optional: List plugins here if you want Nix to manage them
#     packages.myVimPackage = with pkgs.vimPlugins; {
#       start = [ 
#         nvim-treesitter.withAllGrammars
#         telescope-nvim
#         catppuccin-nvim
#       ];
#     };
#   };
# };


  programs.dconf.profiles.user.databases = [
  {
    settings = {
      "org/gnome/desktop/background" = {
        picture-uri = "file:///home/wytchblade/Downloads/background.png";
        picture-uri-dark = "file:///home/wytchblade/Downloads/background.png";
        picture-options = "zoom"; # Can be 'centered', 'scaled', 'stretched', 'zoom', 'spanned'
      };
      "org/gnome/desktop/screensaver" = {
        picture-uri = "file:///path/to/your/wallpaper.jpg";
      };
      "org/gnome/mutter" = {
        auto-maximize = true;
        center-new-windows = true; # Helpful for non-maximized windows
      };
# "org/gnome/desktop/peripherals/keyboard" = {
# delay = lib.hm.gvariant.mkUint32 200;            # 200ms delay
# repeat-interval = lib.hm.gvariant.mkUint32 25;   # 25ms between repeats (Fast!)
# repeat = true;
# };
    };
  }
  ];



# enable Steam	
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports for Source Dedicated Server
  };


# tmux configuration
  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";               # Use vi keys for copy mode
      shortcut = "b";               # Set prefix to Ctrl-a (instead of Ctrl-b)
      baseIndex = 1;                # Start window numbering at 1
      newSession = true;            # Automatically spawn a session if none exist

# This is where you put your custom .tmux.conf lines
      extraConfig = builtins.readFile ../tmux/.tmux.conf;
  };

#bash shell configuration
  programs.bash.interactiveShellInit = builtins.readFile ../bash/.bashrc;


  xdg.mime.defaultApplications = {
    "application/pdf" = [ "sioyek.desktop" ];
  };

# Install firefox.
  programs.firefox.enable = true;

  # This ensures the gnome user desktop uses your layout every time you boot, and gdm uses the same layout
  # systemd.tmpfiles.rules = [
  #   "L+ /home/wytchblade/.config/monitors.xml - - - - ${../gnome/monitor_configuration.xml}"
  #   "L+ /run/gdm/.config/monitors.xml - - - - ${../gnome/monitor_configuration.xml}"
  # ];


# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
# };

# List services that you want to enable:

# Enable the OpenSSH daemon.
# services.openssh.enable = true;

# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
