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

  # networking.firewall = {
  #   allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
  # };
  # 
  # # Enable WireGuard
  # networking.wireguard.interfaces = {
  # 
  #   # "wg0" is the network interface name. You can name the interface arbitrarily.
  #   wg0 = {
  # 
  #     # Determines the IP address and subnet of the client's end of the tunnel interface.
  #     ips = [ "10.13.37.30/32" ];
  #     listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)
  # 
  #     # Path to the private key file.
  #     #
  #     # Note: The private key can also be included inline via the privateKey option,
  #     # but this makes the private key world-readable; thus, using privateKeyFile is
  #     # recommended.
  #     # privateKeyFile = "path to private key file";
  # 
  #     peers = [
  #       # For a client configuration, one peer entry for the server will suffice.
  # 
  #       {
  #         # Public key of the server (not a file path).
  #         publicKey = "l2T2w3s7ORe1UpiLDJbt+8wiAL45CtsH2L0lmFkU8nA=";
  # 
  #         # Forward all the traffic via VPN.
  #         allowedIPs = [ "0.0.0.0/0" "::0/0" ];
  #         # Or forward only particular subnets
  #         #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ];
  # 
  #         # Set this to the server IP and port.
  #         endpoint = "88.85.81.81:51820";
  #         # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing
  #         # https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577
  # 
  #         # Send keepalives every 25 seconds. Important to keep NAT tables alive.
  #         persistentKeepalive = 25;
  #       }
  #     ];
  #   };
  # };

  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "10.13.37.30/32" ];
      dns = [ "10.0.0.1" "fdc9:281f:04d7:9ee9::1" "8.8.8.8" "1.1.1.1" "2001:4860:4860::8888" "2606:4700:4700::1111" ];
      privateKeyFile = "/root/wireguard-keys/privatekey";
      
      peers = [
        {
          publicKey = "l2T2w3s7ORe1UpiLDJbt+8wiAL45CtsH2L0lmFkU8nA=";
          # presharedKeyFile = "/root/wireguard-keys/preshared_from_peer0_key";
          allowedIPs = [ "0.0.0.0/0" "::/0" ];
          endpoint = "88.85.81.81:51820";
          persistentKeepalive = 25;
        }
      ];
    };
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
      wireguard-tools # vpn
      translate-shell # translator
      glow    # md reader
      pandoc  # md convertor
      zathura # pdf reader
      gimp
      jetbrains.rider
      arduino
      pamixer
      ncpamixer
      jamesdsp
      kitty
      pciutils
      usbutils
      lutris
      minecraft
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
          redhat.vscode-xml
          alefragnani.project-manager
	  dart-code.dart-code
	  esbenp.prettier-vscode
          asvetliakov.vscode-neovim
	  vscodevim.vim
          ms-dotnettools.csharp
          ms-azuretools.vscode-docker
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
	  {
            name = "vscode-typescript-next";
            publisher = "ms-vscode";
            version = "5.1.20230331";
	    sha256 = "54b107cb96db24a925aedb5b26c70259586592742709c52ef94cdcb2d7c11c39";
	  }
        ];
      })

      # expiriments:
      ulauncher
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
        sdk_5_0
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
      shellcheck
      xorg.xmodmap
      zsh
    ];

    shells = [
      "/runcurrent-system/sw/bin/zsh"
    ];

    variables.EDITOR = "nvim";

    interactiveShellInit = ''
      # navigation #

      # temp
      alias tcinema='cd /home/yukkop/prj/kwp/cinema'
      alias tpj='cd /home/yukkop/prj'

      # system #
      alias conf='nvim /home/yukkop/prj/nix/configuration.nix' 
      alias confcommit='cd'
      alias nixrb='sudo nixos-rebuild switch --flake /home/yukkop/prj/nix#hectic' 

      # misc #
      alias copy='xclip -selection clipboard'
      alias put='xclip -selection clipboard -o'

      alias nv='nvim'

      # psql #
      # TODO if docker container "postgresql-15-db-1" exist
      alias psql='sudo docker exec -it $(sudo docker ps --filter "NAME=postgresql-15-db-1" --format "{{.ID}}") psql'
      alias psqlp='sudo docker exec -it $(sudo docker ps --filter "NAME=postgresql-15-db-1" --format "{{.ID}}") psql -U postgres'

      # games #
      alias battlenet="env WINEPREFIX='/home/yukkop/Games/homeyukkopdownloadsbattlenet-setupexe' wine '/home/yukkop/Games/homeyukkopdownloadsbattlenet-setupexe/drive_c/ProgramData/Microsoft/Windows/Start Menu/Programs/Battle.net/Battle.net.lnk' > /tmp/battlenet_log.txt 2>&1 & disown"
      alias chummer='wine /home/yukkop/prg/chummer/Chummer5.exe > /tmp/chummer_log.txt 2>&1 & disown'
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
  programs.neovim = {
    enable = true;
    configure = {
      customRC = ''
        set number
        set cc=80
        set list
        set listchars=tab:→\ ,space:·,nbsp:␣,trail:•,eol:¶,precedes:«,extends:»
        if &diff
          colorscheme blue
        endif
      '';
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [ vim-nix ];
      };
    };
  };

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
