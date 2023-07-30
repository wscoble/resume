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
      # if [[ ! -d environ ]]; then
      #   wget https://mirrors.ctan.org/macros/latex/contrib/environ.zip
      #   unzip environ.zip
      #   rm environ.zip
      #   pushd environ
      #   latex environ.ins
      #   popd
      # fi
      # if [[ ! -d trimspaces ]]; then
      #   wget https://mirrors.ctan.org/macros/latex/contrib/trimspaces.zip
      #   unzip trimspaces.zip
      #   rm trimspaces.zip

      #   if [[ ! -d pstool ]]; then
      #     wget https://mirrors.ctan.org/macros/latex/contrib/pstool.zip
      #     unzip pstool.zip
      #     rm pstool.zip
      #   fi
      #   pushd trimspaces
      #   ln -s ../pstool/pstool.tex
      #   ln -s ../titlesec/titlesec.sty
      #   latex trimspaces.ins
      #   popd
      # fi
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
