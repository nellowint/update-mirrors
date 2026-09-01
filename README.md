# update-mirrors

[![AUR](https://img.shields.io/aur/version/update-mirrors-git)](https://aur.archlinux.org/packages/update-mirrors-git)
[![AUR votes](https://img.shields.io/aur/votes/update-mirrors-git)](https://aur.archlinux.org/packages/update-mirrors-git)
[![License: GPL v3](https://img.shields.io/badge/license-GPL%20v3-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Arch%20Linux%20%26%20derivatives-lightgrey.svg)]()

##

A simple command line (CLI) tool designed to simplify updating mirrors of Arch Linux-based systems.

## Installation

### From AUR
```bash
aurup -S update-mirrors-git
```
### From Git
```
git clone https://github.com/nellowint/update-mirrors.git
cd update-mirrors
makepkg -si
```

## Features

update-mirrors {-S or --sync	} [number of mirrors]

update-mirrors {-L or --lisl	}

update-mirrors {-h or --help	}

update-mirrors {-R or --restore	}

update-mirrors {-V or --version	}

## Contributing
✨ Contributions are welcome! Please:

1) Fork the repository
2) Create a feature branch (git checkout -b feature/your-feature)
3) Commit your changes (git commit -am 'Add some feature')
4) Push to the branch (git push origin feature/your-feature)
5) Open a Pull Request

## Dependencies

* [bash-completion](https://archlinux.org/packages/?name=bash-completion)
* [curl](https://archlinux.org/packages/?name=curl)
* [git](https://archlinux.org/packages/?name=git)

## License
This project is licensed under the GNU GENERAL PUBLIC LICENSE - see the LICENSE file for details.