{
  description = "Agrovate Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # Use the unstable branch
    nix-darwin.url = "github:LnL7/nix-darwin/master"; # Use the master branch
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager"; # Use the 24.11 branch
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {
      # Allow aliases to resolve collisions
      nixpkgs.config.allowAliases = true;

      # List packages installed in system profile
      environment.systemPackages = with pkgs; [
        # Packages from brew-packages.txt
        cmatrix
        eza
        fd
        fontconfig
        fzf
        gcc
        go
        graphite2
        gnugrep
        harfbuzz
        ncurses
        neofetch
        neovim
        nodejs
        python3Packages.packaging
        python313
        ripgrep
        ruby
        rustup
        sqlite
        starship
        stow
        texinfo
        tmux
        tree-sitter
        zig
        zoxide
        tealdeer
        bat
        gh
      ];

      # Auto upgrade nix package and the daemon service
      services.nix-daemon.enable = true;

      # Necessary for using flakes on this system
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment
      programs.zsh.enable = true;  # default shell on catalina

      # Set Git commit hash for darwin-version
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility
      system.stateVersion = 5;

      # The platform the configuration will be used on
      nixpkgs.hostPlatform = "aarch64-darwin";

      # Add homebrew support
      homebrew.enable = true;
      homebrew.onActivation.autoUpdate = true;
      homebrew.onActivation.cleanup = "zap";
      
      # Add any remaining Homebrew formulae here
      homebrew.brews = [ 
        "htop"
        "wget"
        "zsh-autosuggestions"
        "zsh-syntax-highlighting"
      ];
      
      # Casks from brew-casks.txt
      homebrew.casks = [
        "aerospace"
        "font-go-mono-nerd-font"
        "ghostty"
        "nordvpn"
        "notion"
        "obsidian"
        "raycast"
        "visual-studio-code"
      ];

      # Configure macOS system defaults
      system.defaults.NSGlobalDomain.AppleShowAllFiles = true;
      system.defaults.dock.autohide = true;
      system.defaults.finder.AppleShowAllExtensions = true;

      # Configure user account
      users.users.nishant = {
        home = "/Users/nishant";
        shell = pkgs.zsh;
      };
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#mac
    darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.nishant = { pkgs, ... }: {
            # home.backupFileExtension = "backup"; # Temporarily removed
            home.stateVersion = "23.11";
            home.packages = with pkgs; [ htop ripgrep fd ];
            programs.bash.enable = true;
          };
        }
      ];
    };

    # Expose the package set, including overlays, for convenience
    darwinPackages = self.darwinConfigurations."mac".pkgs;
  };
}
