{ config, pkgs, ... }:

{
  
  home = {
    username = "alex";
    homeDirectory = "/home/alex";
    stateVersion = "24.11";
    file = {
    };
    packages = with pkgs; [
      gnomeExtensions.user-themes
      gnomeExtensions.tray-icons-reloaded
      gnomeExtensions.dash-to-dock
    ];
    sessionVariables = {
    };
  };

  programs = {
    home-manager = { 
      enable = true;
    };
    git = {
      enable = true;
      userName = "D7TUN6";
      userEmail = "d7tun6@gmail.com";
      lfs = {
        enable = true;
      };
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      plugins = with pkgs.vimPlugins; [
        vim-nix
	SudoEdit-vim
      ];
    };
  };

  services = {
    #flameshot = {
    #  enable = true;
    #};
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    #theme = {
      #name = "";
      #package = ;
    #};
    #cursorTheme = {
    #  name = "";
    #  package = ;
    #};
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

    dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "trayIconsReloaded@selfmade.pl"
        "dash-to-dock@micxgx.gmail.com"
      ];
      favorite-apps = [
        "org.gnome.Console.desktop"
        "org.gnome.Nautilus.desktop"
        "chromium-browser.desktop"
      ];
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
    };
    "org/gnome/shell/extensions/user-theme" = {
      #name = "";
    };
    "org/gnome/desktop/wm/preferences" = {
      workspace-names = [ "Main" ];
    };
    "org/gnome/desktop/background" = {
      #picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/vnc-l.png";
      #picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/vnc-d.png";
    };
  };

}

