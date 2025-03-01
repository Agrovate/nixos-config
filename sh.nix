{config, pkgs, ...}: 
{
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    shellAliases = {
      tmux = "tmux -u";
      ls = "eza -la";
      cd = "z";
      vim = "nvim";
    };
  };
}
