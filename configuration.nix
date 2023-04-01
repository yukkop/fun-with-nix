
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
 
  networking.hostName = "hectic"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.wireless.userControlled.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  boot.initrd.kernelModules = ["amdgpu"];
  # services.xserver.videoDrivers = ["amdgpu" "modesetting"];

  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  # nvidia-drm.modeset=1 is required for some wayland compositors, e.g. sway
  hardware.nvidia.modesetting.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;

    # Enable the XFCE Desktop Environment.
    # displayManager.lightdm.enable = true;
    desktopManager = {
      # xterm.enable = false;
      xfce = {
        enable = true;
        # noDesktop = true;
        # enableXfwm = false;
      };
    };
    # windowManager = {
    #   xmonad = {
    #     enable = true;
    #     enableContribAndExtras = true;
    #     extraPackages = haskellPackages : [
    #       haskellPackages.xmonad-contrib
    #       haskellPackages.xmonad-extras
    #       haskellPackages.xmonad
    #     ];
    #     config = ''
    #       import XMonad
    #       import XMonad.Config.Xfce
    #       import XMonad.Hooks.EwmhDesktops
    #       import XMonad.Hooks.SetWMName
    #       
    #       main = xmonad xfceConfig
    #         { terminal = "kitty"
    #           , modMask = mod4Mask -- optional: use Win key instead of Alt as MODi key
    #         }
    #     '';
    #   };
    # };
    # displayManager.defaultSession = "xfce+xmonad";

    # Configure keymap in X11
    layout = "us,ru";
    xkbVariant = "";
    xkbOptions = "grp:alt_shift_toggle,grp_led:scroll";
  };


  # Docker
  virtualisation.docker.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.yukkop = {
    isNormalUser = true;
    description = "yukkop";
    extraGroups = [ "networkmanager" "wheel" ];
    # openssh.authorizedKeys.keys = [ "" "" ]
    packages = with pkgs; [
      jetbrains.rider
      arduino
      pamixer
      ncpamixer
      jamesdsp
      firefox
      kitty
      pciutils
      usbutils
      lutris
      git
      gh # github cli
      glab # gitlab cli
      vieb # vim like browser
      vimb # vim like browser
      dbeaver
      chromium
      ncdu
      libreoffice
      steam
      unzip
      zip
      omnisharp-roslyn
      wally-cli # A tool to flash firmware to mechanical keyboards
      (vscode-with-extensions.override {
        vscodeExtensions = with vscode-extensions; [
          alefragnani.project-manager
	  dart-code.dart-code
	  esbenp.prettier-vscode
          asvetliakov.vscode-neovim
	  vscodevim.vim
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "remote-ssh-edit";
            publisher = "ms-vscode-remote";
            version = "0.47.2";
            sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
          }
          {
            name = "JavaScriptSnippets";
            publisher = "xabikos";
            version = "1.8.0";
            sha256 = "86de969b55fbce27a7f9f8ccbfceb8a8ff8ecf833a5fa7f64578eb4e1511afa7";
          }
        ];
      })
    ];
  };
# Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget 
  environment = {
    systemPackages = with pkgs; [
      neovim
      tmux
      xclip
      (with dotnetCorePackages; combinePackages [
        sdk_3_1
        sdk_6_0
	sdk_7_0
      ])
      wineWowPackages.full
      (python39.withPackages(ps: with ps; [ pandas requests google-api-python-client uuid ])	)
      nodejs-16_x
      nodePackages.npm
      xkblayout-state
      docker
      docker-compose
      jq
      htop-vim
      nginx
      cmake
      flutter
      dart
      ninja
      msbuild
      cmake
      gcc9
      mono
    ];

    shells = [
      "/run/current-system/sw/bin/zsh"
    ];

    shellInit = ''
      alias ll='ls -la'
      alias copy='xclip -selection clipboard'
      alias paste='xclip -selection clipboard -o'
      alias psql='sudo docker exec -it $(sudo docker ps --filter "NAME=postgresql-15-db-1" --format "{{.ID}}") psql'
      alias psqlp='sudo docker exec -it $(sudo docker ps --filter "NAME=postgresql-15-db-1" --format "{{.ID}}") psql -U postgres'
    '';
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # programs.hyprland.enable = true;

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
  system.stateVersion = "22.11"; # Did you read the comment?

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
