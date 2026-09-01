#!\bin\bash
# Maintainer: Wellinton Vieira <wellintonvieira.office@gmail.com>
# A simple command line (CLI) tool designed to simplify updating mirrors of Arch Linux-based systems.

option="$1"
limit_mirrors="$2"
filter_country="$3"
countries="${@:4}"
pkgname="update-mirrors"
pkgver="1.24"
author="nellowint"
base_url="https://archlinux.org"
directory="$HOME/.$pkgname"
mirrorlist_file="$directory/mirrorlist"
mirrorlist_backup="$directory/mirrorlist.backup"

GREEN=$(tput setaf 2)
PINK=$(tput setaf 5)
BLUE=$(tput setaf 6)
BOLD=$(tput bold)
RESET=$(tput sgr0)

function print_manual {
	echo "use:	$pkgname <operation>"
	echo "operations:"
	echo "$pkgname {-S   --sync      } [number of mirrors]"
	echo "$pkgname {-S   --sync      } [number of mirrors] -C [optional list country acronym]"
	echo "$pkgname {-L   --list      }"
	echo "$pkgname {-h   --help      }"
	echo "$pkgname {-R   --restore   }"
	echo "$pkgname {-V   --version   }"
}

function print_version {
	echo "$BOLD$PINK$pkgname $RESET$BOLD$GREEN$pkgver$RESET"
	echo "2019-$( date +"%Y" ) VWTeam Developers"
	echo "this is free software: you are free to change and redistribute it."
	echo "learn more at https://github.com/$author/$pkgname "
}

function print_error {
	echo "invalid option, consult manual with command $pkgname --help"
}

function print_error_connection {
	echo "no internet connection!"
}

function print_mirrors {
	echo "$(cat /etc/pacman.d/mirrorlist)"
}

function check_connection {
	local response="$( curl -s -I $base_url )"
	local status_code=$( echo $response | grep "HTTP" | cut -d " " -f 2 )
	if [[ $status_code -eq "200" ]]; then
		return 0
	fi
	return 1
}

function update_mirrors {
	if check_connection; then
		if verify_limit_mirrors; then
			mkdir -p $directory
			echo "$BOLD$BLUE::$RESET$BOLD updating mirror list, please wait..."$RESET
			local date_update=$( date +'Mirrorlist updated %d/%m/%Y %H:%M:%S' )
			local country_option="country=all&protocol"

			if [[ $filter_country == "-C" ]]; then
			    if [[ -n "$countries" ]]; then
			    	country_option=""
				    for country in $countries; do
						country_option+="country=$country&"
					done
					country_option+=protocol
				fi
			fi

			local url="$base_url/mirrorlist/?$country_option=https&ip_version=4&use_mirror_status=on"
			curl -s "$url" | sed 's/#Server/Server/' | grep "Server" | head -n $limit_mirrors > $mirrorlist_file
			sed -i "1i ##\n## Arch Linux repository mirrorlist\n## Filtered by mirror score from mirror status page\n## Generated on $date_update\n##\n" $mirrorlist_file
			sudo cp /etc/pacman.d/mirrorlist $mirrorlist_backup
			sudo mv $mirrorlist_file /etc/pacman.d/mirrorlist
			sudo rm -f /etc/pacman.d/mirrorlist.pacnew
			echo "$BOLD$BLUE::$RESET$BOLD mirrorlist updated successfully!"$RESET
		else
			print_error
		fi
	else
		print_error_connection
	fi
}

function verify_limit_mirrors {
	local regex='^[0-9]+$'
	if [[ $limit_mirrors > 0 && $limit_mirrors =~ $regex ]]; then
		return 0
	fi
	return 1
}

function restore_mirrors {
	sudo mv $mirrorlist_backup /etc/pacman.d/mirrorlist
	echo "$BOLD$BLUE::$RESET$BOLD mirrorlist restored successfully!"$RESET
}

case $option in
	"--sync"|"-S"		) update_mirrors ;;
	"--list"|"-L"		) print_mirrors ;;
	"--help"|"-h"		) print_manual ;;
	"--restore"|"-R"    ) restore_mirrors ;;
	"--version"|"-V" 	) print_version ;;
	*) print_error ;;
esac
