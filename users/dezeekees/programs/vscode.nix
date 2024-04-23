{ pkgs, inputs, ... }:

let 
  extensions = inputs.nix-vscode-extensions.extensions.x86_64-linux;
in {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      extensions.vscode-marketplace.unthrottled.doki-theme
      extensions.vscode-marketplace.pkief.material-icon-theme
      extensions.vscode-marketplace.rangav.vscode-thunder-client
      extensions.vscode-marketplace.formulahendry.auto-close-tag
      extensions.vscode-marketplace.github.copilot
      extensions.vscode-marketplace.github.copilot-chat
    ];
  };

  home.packages = with pkgs; [
    nil
  ];
}