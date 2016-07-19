# /etc/nixos/configuration.nix
# ----------------------------

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the gummiboot efi boot loader.
  boot.loader.gummiboot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "cliq"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment = {
    systemPackages = with pkgs; [
     	wget
	networkmanager
	networkmanagerapplet
	firefox
	transmission_gtk
	weechat
	python35Packages.youtube-dl
	wvdial
	usb_modeswitch
	ntp
	openssl
	wireshark

	gcc
	gnumake
	gdb
	cmake
	valgrind
	python
	python35
	go
	lua5_3
	git
	bash
	bashCompletion
	boost
	clang
	#clang_38
	python27Packages.jedi
	man-pages
	posix_man_pages

	neovim
	python27Packages.neovim
	ctags
	xsel
	
	spaceFM
	i3
	i3status
	dmenu
	spaceFM
	xfce.thunar
	ranger
	rxvt_unicode
	parcellite
	llpp
	djview
	evince
	mcomix
	

	lxappearance
	mate-icon-theme
	xcompmgr
	scrot

	mpd
	ncmpcpp
	mpv
	alsaUtils
	feh
	ffmpeg


	htop
	powertop
	iftop
	screenfetch
	lm_sensors
	mtpfs
	ntfs3g
	usbutils

	file
	which
	time
	unzip
	zip
	unrar
	gnupg
	gparted
	gnufdisk
	gptfdisk
	nox
   ];

    # For C/C++/etc. development it's easiest to just symlink the /include
    # in each package to /run/current-system/sw/include
    pathsToLink = ["/include"];

    shellInit = "
    	export LIBRARY_PATH=/run/current-system/sw/lib
      	export C_INCLUDE_PATH=/run/current-system/sw/include
    ";
  };

  # Mobo requires this flag >.>

  boot.extraKernelParams = ["iommu=soft"];



  # Timezone

  time.timeZone = "Asia/Kolkata";

  # List services that you want to enable:
  
  networking.networkmanager.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable window manager
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.windowManager.i3.enable = true;


  # Nvidia drivers
  nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.driSupport32Bit = true;

  # How to define a new user
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };
  
  users.extraUsers.snyp = {
  	isNormalUser = true;
	home = "/home/snyp";
	description = "Soumik Rakshit";
	extraGroups = [ "wheel" "networkmanager" "wireshark"];
  };

  # Wireshark related
  security.setuidOwners = [
  { 	program = "dumpcap";
  	owner = "root";
	group = "wireshark";
	setuid = true;
	setgid = false;
	permissions = "u+rx,g+x";
  }];
  users.extraGroups.wireshark.gid = 500;

  # Fontconfig ultimate
  fonts.fontconfig.ultimate.rendering = pkgs.fontconfig-ultimate.rendering.ultimate-lightest;

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";
}

