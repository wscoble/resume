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
      fi
      if [[ ! -d roboto ]]; then
        wget https://mirrors.ctan.org/fonts/roboto.zip
        unzip roboto.zip
      fi
      if [[ ! -d fontaxes ]]; then
        wget https://mirrors.ctan.org/macros/latex/contrib/fontaxes.zip
        unzip fontaxes
      fi
      popd
    '';
    
    build-resume.exec = ''
      pushd $DEVENV_ROOT/Resume
      j2 resume.j2 resume.yaml -o resume.tex && \
      TEXINPUTS=".texmf//:" pdflatex resume.tex && \
      pandoc -s resume.tex -o resume.docx 
      popd
    '';
  };
}
