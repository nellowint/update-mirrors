#!\bin\bash
#Update mirrors-list for Arch Linux

option="$1"
limitMirrors="$2"
version="1.0.0-alpha18"
name="update-mirrors"
author="wellintonvieira"
directory="$HOME/.$name"

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

function printError {
	echo "invalid option, consult manual with command $name --help"
}

function printManual {
	echo "use:	$name <operation>"
	echo "operations:"
	echo "$name {-S   --sync      } [number of mirrors]"
	echo "$name {-Sy  --update    }"
	echo "$name {-L   --list      }"
	echo "$name {-h   --help      }"
	echo "$name {-R   --restore   }"
	echo "$name {-U   --uninstall }"
	echo "$name {-V   --version   }"
}

function printVersion {
	echo "$name $version"
	echo "2019-2024 Vieirateam Developers"
	echo "this is free software: you are free to change and redistribute it."
	echo "learn more at https://github.com/$author/$name "
}

function printMirrors {
	echo "$(cat /etc/pacman.d/mirrorlist)"
}

function updateMirrors {
	if verifyLimitMirrors; then
		local dateUpdate=$( date +'Mirrorlist updated %d/%m/%Y %H:%M:%S' )
		echo ":: updating mirror list, please wait..."
		w3m -dump "https://archlinux.org/mirrorlist/?country=all&protocol=https&ip_version=4&use_mirror_status=on" | sed 's/#Server/Server/' | grep "Server" | head -n $limitMirrors > $directory/mirrorlist &
		wait
		sed -i "1i # $dateUpdate" $directory/mirrorlist
		sudo sed -i "1i # $dateUpdate" /etc/pacman.d/mirrorlist
		sudo cp /etc/pacman.d/mirrorlist $directory/mirrorlist.backup
		sudo mv $directory/mirrorlist /etc/pacman.d/mirrorlist
		sudo rm -f /etc/pacman.d/mirrorlist.pacnew
		echo ":: mirrorlist updated successfully!"
	else
		printError
	fi
}

function verifyLimitMirrors {
	local regex='^[0-9]+$'
	if [[ $limitMirrors > 0 && $limitMirrors =~ $regex ]]; then
		return 0
	fi
	return 1
}

function restoreMirrors {
	sudo mv /$directory/mirrorlist.backup /etc/pacman.d/mirrorlist
	echo ":: mirrorlist restored successfully!"
}

function verifyVersion {
	local serverVersion="$( w3m -dump "https://raw.githubusercontent.com/$author/$name/main/src/$name.sh" | grep "version" | head -n 1 | sed 's/version=//' | sed 's/ //g' | sed 's/"//g' )"
	if [[ "$version" == "$serverVersion" ]]; then
		return 0
	fi
	return 1
}

function updateApp {
	if verifyVersion; then
		echo "${green}$name ${reset}is on the latest version"
	else
		cd /tmp/
		if [ -d "$name" ]; then
			rm -rf "$name"
		fi
		echo "${red}$name ${reset}needs to be updated"
		git clone "https://github.com/wellintonvieira/$name.git"
		echo "preparing to install the package ${green}$name${reset}"
		cd $name
		sh install.sh
		cd $HOME
	fi
}

function uninstallApp {
	if [ -d $directory ]; then
		rm -rf "$directory"
		sudo rm -rf "/usr/share/bash-completion/completions/$name-complete.sh"
		sed -i "/$name/d" "/$HOME/.bashrc"
		echo "$name was uninstalled successfully"
		exec bash --login
	else
		echo "$name is not installed"
	fi
}

case $option in
	"--sync"|"-S"		) updateMirrors ;;
	"--list"|"-L"		) printMirrors ;;
	"--help"|"-h"		) printManual ;;
	"--restore"|"-R"    ) restoreMirrors ;;
	"--update"|"-Sy"	) updateApp ;;
	"--uninstall"|"-U"	) uninstallApp;;
	"--version"|"-V" 	) printVersion ;;
	*) printError ;;
esac
