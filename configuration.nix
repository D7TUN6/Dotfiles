{ config, lib, pkgs, inputs, ... }:

{

    imports = [
        ./hardware-configuration.nix
        inputs.home-manager.nixosModules.default
        inputs.musnix.nixosModules.musnix
    ];

    system = {
        stateVersion = "24.11";
    };

    boot = {
        kernelPackages = pkgs.linuxPackages-rt_latest;
        kernelParams = [
            "intel_pstate=disable"
        ];
        kernelModules = [
            "xt_multiport"
        ];
        loader = {
            systemd-boot = {
                enable = true;
            };
            efi = {
                canTouchEfiVariables = true;
            };
        };
    };

    systemd = {
        oomd = {
            enable = true;
        };
        timers = {
            fstrim = {
                enable = true;
            };
            "gen-cleaner" = {
                wantedBy = [ "timers.target" ];
                timerConfig = {
                    OnCalendar = "Mon..Sun *-*-* *:30:*";
                    Persistent = true;
                    Unit = "gen-cleaner.service";
                };
            };
            "nixos-upgrader" = {
                wantedBy = [ "timers.target" ];
                timerConfig = {
                    OnCalendar = "Mon..Sun *-*-* *:00:*";
                    Persistent = true;
                    Unit = "gen-cleaner.service";
                };
            };
        };
        targets = {
            sleep = {
                enable = false;
            };
            susped = {
                enable = false;
            };
            hibernate = {
                enable = false;
            };
            hybrid-sleep = {
                enable = false;
            };
        };
        services = {
            NetworkManager-wait-online = {
                enable = false;
            };
            "gen-cleaner" = {
                serviceConfig = {
                    Type = "oneshot";
                    User = "root";
                };
                script = ''
                    set -eu
                    /run/current-system/sw/bin/nix-collect-garbage -d
                '';
            };
            "nixos-upgrader" = {
                serviceConfig = {
                    Type = "oneshot";
                    User = "root";
                };
                script = ''
                    set -eu
                    /run/current-system/sw/bin/nixos-rebuild switch --upgrade --flake /etc/nixos#Workstation1
                '';
            };
        };
    };

    networking = {
        hostName = "Workstation1";
        nameservers = [
            "1.1.1.1"
            "1.0.0.1"
            "8.8.8.8"
            "8.8.4.4"
        ];
        networkmanager = {
            enable = true;
        };
        firewall = {
            enable = false;
        };
    };

    powerManagement = {
        enable = false;
    };

    security = {
        sudo = {
            enable = false;
        };
        doas = {
            enable = true;
            extraRules = [{
                users = ["alex"];
                keepEnv = true;
                noPass = true;
            }];
        };
        rtkit = {
            enable = true;
        };
        polkit = {
            enable = true;
        };
    };

    time = {
        timeZone = "Asia/Yekaterinburg";
    };

    users = {
        users = {
            alex = {
                isNormalUser = true;
                initialPassword = "1590";
                shell = pkgs.fish;
                extraGroups = [
                    "wheel"
                    "audio"
                    "video"
                    "storage"
                    "input"
                    "plugdev"
                ];
            };
        };
    };

    home-manager = {
        extraSpecialArgs = { inherit inputs; };
        backupFileExtension = "old-backup";
        users = {
            "alex" = import ./home.nix;
        };
    };

    hardware = {
        cpu = {
            intel = {
                updateMicrocode = true;
            };
        };
        graphics = {
            enable = true;
            enable32Bit = true;
        };
        nvidia = {
            modesetting = {
                enable = true;
            };
            powerManagement = {
                enable = false;
            };
            open = false;
            nvidiaSettings = true;
            package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
        };
        bluetooth = {
            enable = true;
            package = pkgs.bluez-experimental;
        };
    };

    nix = {
        settings = {
            auto-optimise-store = true;
            experimental-features = [
                "nix-command"
                "flakes"
            ];
        };
        optimise = {
            automatic = true;
            dates = ["*:00"];
        };
    };

    nixpkgs = {
        config = {
            allowUnfree = true;
            nvidia = {
                acceptLicense = true;
            };
        };
    };

    services = {
        xserver = {
            enable = true;
            videoDrivers = ["nvidia"];
            xkb = {
                layout = "us,ru";
                options = "alt_shift_toggle";
            };
        };
        displayManager = {
            defaultSession = "plasmax11";
            sddm = {
                enable = true;
                wayland = {
                    enable = true;
                };
                settings = {
                    General = {
                        DisplayServer = "x11-user";
                    };
                };
            };
        };
        desktopManager = {
            plasma6 = {
                enable = true;
            };
        };
        ananicy = {
            enable = true;
            package = pkgs.ananicy-cpp;
            rulesProvider = pkgs.ananicy-rules-cachyos;
        };
        irqbalance = {
            enable = true;
        };
        pipewire = {
            enable = true;
            alsa = {
                enable = true;
                support32Bit = true;
            };
            pulse = {
                enable = true;
            };
            jack = {
                enable = true;
            };
            wireplumber = {
                enable = true;
            };
        };
        pulseaudio = {
            enable = false;
        };
        libinput = {
            enable = true;
        };
    };

    programs = {
        fish = {
            enable = true;
        };
        appimage = {
            enable = true;
            binfmt = true;
        };
        steam = {
            enable = true;
            remotePlay = {
                openFirewall = true;
            };
            dedicatedServer = {
                openFirewall = true;
            };
        };
        gamemode = {
            enable = true;
        };
        java = {
            enable = true;
        };
    };

    musnix = {
        enable = true;
    };

    zramSwap = {
        enable = true;
        memoryPercent = 100;
        algorithm = "zstd";
    };

    environment = {
        variables = {
            __GL_THREADED_OPTIMIZATION = "1";
            __GL_MaxFramesAllowed = "1";
            __GL_YIELD = "NOTHING";
            __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";
            RADV_PERFTEST = "sam";
            VKD3D_CONFIG = "no_upload_hvv";
            mesa_glthread = "true";
            EDITOR = "nvim";
        };
        systemPackages = with pkgs; [
            # System.
            neovim-unwrapped
            wget
            rsync
            btop
            fastfetch
            appimage-run
            inetutils

            # Alsa.
            alsa-lib
            alsa-utils
            alsa-plugins
            apulse
            
            # Drivers & Firmware.
            linux-firmware
            sof-firmware
            sof-tools
            alsa-firmware
            mesa
            mesa-demos

            # Sound.
            #Controllers & Mixers
            pavucontrol
            #DAW
            reaper
            lmms
            audacity
            # Audio plugins.
            #Synth
            zynaddsubfx
            surge
            #Rack
            carla
            #Effects
            calf
            
            # Desktop.
            #Xorg
            xorg.libxcvt
            xorg.xkill
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib
            libkrb5
            keyutils
            #Screenshot & Capture
            flameshot
            obs-studio
            #Utils
            peazip
            
            # Work & Office
            chromium
            brave
            firefox
            firefox-devedition-bin-unwrapped
            onlyoffice-desktopeditors


            # Multimedia.
            vlc
            handbrake
            ffmpeg-full

            # Development.
            #IDE
            vscode
            #Compilers
            gcc
            #Version control
            git
            #Containerization
            compose2nix
            podman-compose
            dive

            # Graphics & Photo.
            krita
            gimp3
            inkscape
            kdePackages.kdenlive
            shotcut

            # Windows apps.
            winePackages.stagingFull
            wineWowPackages.stagingFull
            winetricks

            # Gaming.
            lutris-unwrapped
            steam
            protonup-qt
        ];
    };

}
