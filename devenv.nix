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
      mkdir -p $DEVENV_ROOT/.texmf
      pushd $DEVENV_ROOT/.texmf
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
      j2 resume.j2 resume.yaml -o resume.tex && \
      TEXINPUTS=".texmf//:" xelatex resume.tex && \
      pandoc -s resume.tex -o resume.docx 
    '';

    next-tag.exec = ''
      # Get the latest tag
      CURRENT_TAG=$(git describe --tags --abbrev=0)
      # Get the hash of the experience section in the current commit and the previous one
      CURRENT_HASH=$(yq '.experience' resume.yaml | sha256sum | awk '{print $1}')
      PREVIOUS_HASH=$(git show $CURRENT_TAG:resume.yaml | yq '.experience' | sha256sum | awk '{print $1}')
      
      # Get the size of the experience list in the current commit and the previous one
      CURRENT_SIZE=$(yq '.experience | length' resume.yaml)
      PREVIOUS_SIZE=$(git show $CURRENT_TAG:resume.yaml | yq '.experience | length')

      increment="patch"
      
      # Check the sizes and hashes to determine the version increment
      if [ "$CURRENT_SIZE" -ne "$PREVIOUS_SIZE" ]; then
        # If the size of the experience list has changed, increment the major version
        increment="major"
      elif [ "$CURRENT_HASH" != "$PREVIOUS_HASH" ]; then
        # If the hash of the experience section has changed, increment the minor version
        increment="minor"
      fi

      IFS='.' read -ra VERSION_PARTS <<< "$CURRENT_TAG"
      case $increment in
        major)
          echo "$((''${VERSION_PARTS[0]} + 1)).0.0"
          ;;
        minor)
          echo "''${VERSION_PARTS[0]}.$((''${VERSION_PARTS[1]} + 1)).0"
          ;;
        patch)
          echo "''${VERSION_PARTS[0]}.''${VERSION_PARTS[1]}.$((''${VERSION_PARTS[2]} + 1))"
          ;;
      esac
    '';

    clean.exec = ''
      for d in $(cat .gitignore); do
        rm -fr $d
      done
    '';

    ci.exec = ''
      clean
      install-ctan-dependencies
      build-resume
    '';
  };
}
