{ config, pkgs, ... }:

{
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    python3
    fastfetch
    nixfmt
    age
    pandoc
    texliveSmall
  ];

  home.file = { };
  home.sessionVariables = { };
  home.shellAliases = { };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;
    extraConfig = "theme = \"autumn\"";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
  };

  programs.nix-your-shell = {
    enable = true;
    enableNushellIntegration = true;
    enableFishIntegration = true;
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    signing.signByDefault = true;
    settings = {
      user.name = "Emin Arslan";
      user.email = "me@emin.engineer";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
    };
  };

  programs.emacs = {
    # I put a lot of effort into this config so I don't
    # want to get rid of it in case it's useful...
    # but I also haven't really used emacs in a long while,
    # helix is very good and vscode is good enough when
    # helix doesn't cut it.
    #
    # so I'm temporarily disabling emacs, to see if I actually
    # use it. if I don't, I'll get rid of it at some point.
    enable = false;
    package = pkgs.emacs-macport;
    extraConfig = ''
        (envrc-global-mode)
        (add-hook 'tuareg-mode-hook 'merlin-mode)
        (with-eval-after-load
      		'company
      		(add-to-list 'company-backends 'merlin-company-backend))
      	(add-hook 'after-init-hook 'global-company-mode)
        (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
        (add-hook 'haskell-mode-hook 'eglot-ensure)

        (load-theme 'leuven-dark 't)
        

        ;; configure meta key to be command instead of option
        (setq mac-command-modifier 'meta)
        (setq mac-option-modifier 'none)

        (set-face-attribute 'default nil :height 160)
    '';
    extraPackages =
      epkgs: with epkgs; [
        tuareg
        dune
        merlin
        company
        envrc
        nix-mode
        nixfmt
        yaml-mode
        haskell-mode
        cmake-mode
        markdown-mode
      ];
  };
  programs.vscode = {
    enable = true;
  };
  programs.alacritty = {
    enable = true;
    theme = "catppuccin_mocha";
    settings = {
      font.size = 18;
      terminal.shell.program = "${pkgs.fish}/bin/fish";
    };
  };

  # gpg config
  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry_mac;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };
}
