# Scott Scoble's Resume

This repository contains the source code for generating my resume. The resume is written in LaTeX and can be built into a PDF or DOCX file.

## Prerequisites

- [Nix](https://nixos.org/download.html)
- [devenv.sh](https://install.devenv.sh/latest)

## Building the Resume

1. Clone this repository.
2. Run `devenv shell ci` to build the resume.
3. The generated resume will be in the root directory with the name `Scott\ Scoble\ Resume.pdf`.

## GitHub Actions

This repository uses GitHub Actions to automatically build and release the resume whenever changes are pushed. The versioning of the resume is determined by the changes in the `experience` section of the `resume.yaml` file:

- If the size of the `experience` list has changed, the major version is incremented.
- If the hash of the `experience` section has changed, the minor version is incremented.
- Otherwise, the patch version is incremented.

## Contributing

As this is a personal resume, contributions are not expected. However, if you notice any issues with the LaTeX code or the GitHub Actions workflow, feel free to open an issue or a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
