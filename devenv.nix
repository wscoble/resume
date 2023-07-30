{ pkgs, ... }:

{
  packages = with pkgs; [
    coreutils
    gh
    git
    j2cli
    pandoc
    texlive.combined.scheme-small
    yq
  ];

  scripts = {
    install-ctan-dependencies.exec = ''
      mkdir -p $DEVENV_ROOT/Resume/.texmf
      pushd $DEVENV_ROOT/Resume/.texmf
      if [[ ! -d enumitem ]]; then
        wget https://mirrors.ctan.org/macros/latex/contrib/enumitem.zip
        unzip enumitem.zip
        rm enumitem.zip
      fi
      if [[ ! -d titlesec ]]; then
        wget https://mirrors.ctan.org/macros/latex/contrib/titlesec.zip
        unzip titlesec.zip
        rm titlesec.zip
      fi
      if [[ ! -d tcolorbox ]]; then
        wget https://mirrors.ctan.org/macros/latex/contrib/tcolorbox.zip
        unzip tcolorbox.zip
        rm tcolorbox.zip
      fi
      if [[ ! -d fira ]]; then
        wget https://mirrors.ctan.org/fonts/fira.zip
        unzip fira.zip
        rm fira.zip
      fi
      popd
    '';
    
    build-resume.exec = ''
      pushd $DEVENV_ROOT/Resume
      j2 resume.j2 resume.yaml -o resume.tex && \
      TEXINPUTS=".texmf//:" xelatex resume.tex && \
      pandoc -s resume.tex -o resume.docx 
      popd
    '';
  };
}
