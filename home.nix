{ config, pkgs, ... }:

{
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    python3
    direnv
    fastfetch
    nix-direnv
    nixfmt-classic
    age
    aichat
  ];

  home.file = {
  };
  home.sessionVariables = {
  };
  home.shellAliases = {
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      direnv hook fish | source
    '';
  };

  programs.git = {
    enable = true;
    signing.key = "~/.ssh/id_ed25519.pub";
    signing.signByDefault = true;
    settings = {
      user.name = "Emin Arslan";
      user.email = "me@emin.engineer";
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
    };
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;
    extraConfig = ''
          (add-hook 'tuareg-mode-hook 'merlin-mode)
          (with-eval-after-load
        		'company
        		(add-to-list 'company-backends 'merlin-company-backend))
        	(add-hook 'after-init-hook 'global-company-mode)
          (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
          (add-hook 'haskell-mode-hook 'eglot-ensure)

          (load-theme 'leuven-dark 't)
          (envrc-global-mode)

          ;; configure meta key to be command instead of option
          (setq mac-command-modifier 'meta)
          (setq mac-option-modifier 'none)

          ;; grab PATH from a fresh shell
          (exec-path-from-shell-initialize)
          (set-face-attribute 'default nil :height 160)
      '';
    extraPackages = epkgs:
      with epkgs; [
        tuareg
        dune
        merlin
        company
        envrc
        nix-mode
        nixfmt
        yaml-mode
        haskell-mode
        exec-path-from-shell
      ];
  };
}
