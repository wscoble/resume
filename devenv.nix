{ pkgs, ... }:

{
  # https://devenv.sh/basics/
  # env.GREET = "devenv";
  env.TEXINPUTS = "./.texmf//:";

  # https://devenv.sh/packages/
  packages = with pkgs; [
    coreutils
    gh
    git
    j2cli
    pandoc
    texlive.combined.scheme-minimal
    yq
  ];

  # https://devenv.sh/scripts/
  scripts = {
    install-ctan-dependencies.exec = ''
      mkdir -p $DEVENV_ROOT/Resume/.texmf
      pushd $DEVENV_ROOT/Resume/.texmf
      if [[ ! -d enumitem ]]; then
        wget https://mirrors.ctan.org/macros/latex/contrib/enumitem.zip
        unzip enumitem.zip
      fi
      if [[ ! -d roboto ]]; then
        wget https://mirrors.ctan.org/fonts/roboto.zip
        unzip roboto.zip
      fi
      popd
    '';
    
    build-resume.exec = ''
      pushd $DEVENV_ROOT/Resume
      j2 resume.j2 resume.yaml -o resume.tex && \
      pdflatex resume.tex && \
      # xelatex resume.tex && \
      pandoc -s resume.tex -o resume.docx 
      popd
    '';
  };

  enterShell = ''
    hello
    git --version
  '';

  # https://devenv.sh/languages/
  # languages.nix.enable = true;

  # https://devenv.sh/pre-commit-hooks/
  # pre-commit.hooks.shellcheck.enable = true;

  # https://devenv.sh/processes/
  # processes.ping.exec = "ping example.com";

  # See full reference at https://devenv.sh/reference/options/
}
