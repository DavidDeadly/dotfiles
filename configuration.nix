{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "davnix";
  networking.networkmanager.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  time.timeZone = "America/Bogota";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_CO.UTF-8";
    LC_IDENTIFICATION = "es_CO.UTF-8";
    LC_MEASUREMENT = "es_CO.UTF-8";
    LC_MONETARY = "es_CO.UTF-8";
    LC_NAME = "es_CO.UTF-8";
    LC_NUMERIC = "es_CO.UTF-8";
    LC_PAPER = "es_CO.UTF-8";
    LC_TELEPHONE = "es_CO.UTF-8";
    LC_TIME = "es_CO.UTF-8";
  };

  console.keyMap = "la-latin1";
  sound.enable = true;
  security.rtkit.enable = true;

  hardware = {
    pulseaudio.enable = false;
    opengl.enable = true;
    nvidia.modesetting.enable = true;
  };

  programs = {
    zsh.enable = true;
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };
  };

  xdg.portal = {
    enable = true;
  };

  services = {
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        theme = "catppuccin-mocha";
        package = pkgs.kdePackages.sddm;
      };
    };

    # Enable CUPS to print documents.
    printing.enable = true;

    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };

      jack.enable = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.daviddeadly = {
    isNormalUser = true;
    description = "daviddeadly";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
    shell = pkgs.zsh;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # $ nix search <package to search>
  environment.systemPackages = with pkgs; [
    home-manager

    (pkgs.catppuccin-sddm.override {
      flavor = "mocha";
      fontSize = "12";
      background = ./images/mountain-view.png;
      loginBackground = true;
    })

    # langs
    python3
    #
    # deps
    socat # socket utility
    libnotify # notifications
  ];
}
