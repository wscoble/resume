{ pkgs, ... }:

{
  # https://devenv.sh/basics/
  # env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = with pkgs; [
    coreutils
    gh
    git
    j2cli
    texlive.combined.scheme-small
    yq
  ];

  # https://devenv.sh/scripts/
  scripts = {
    build-resume.exec = ''
      pushd $DEVENV_ROOT/Resume
      j2 resume.j2 resume.yaml -o resume.tex
      pdflatex resume.tex
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
