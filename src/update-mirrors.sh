#!\bin\bash
#Update mirrors-list for Arch Linux

option="$1"
limitMirrors="$2"
version="1.0.0-alpha11"
name="update-mirrors"
directory="$HOME/.$name"

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
	echo "2019-2022 Vieirateam Developers"
	echo "this is free software: you are free to change and redistribute it."
	echo "learn more at https://github.com/wellintonvieira/$name "
}

function printMirrors {
	echo "$(cat /etc/pacman.d/mirrorlist)"
}

function updateMirrors {
	if verifyLimitMirrors; then
		echo ":: Updating mirror list, please wait..."
		w3m -dump "https://archlinux.org/mirrorlist/?country=all&protocol=https&ip_version=4&use_mirror_status=on" | sed 's/#Server/Server/' | grep "Server" | head -n $limitMirrors > $directory/mirrorlist &
		wait
		sudo cp /etc/pacman.d/mirrorlist $directory/mirrorlist.backup
		sudo mv $directory/mirrorlist /etc/pacman.d/mirrorlist
		sudo rm -f /etc/pacman.d/mirrorlist.pacnew
		echo ":: Mirrorlist updated successfully!"
	else
		printError
	fi
}

function updateMirrorsPackage {
	if verifyVersion; then
		echo "$name is on the latest version"
	else
		uninstallApp
		echo ":: Preparing to update the $name package..."
		cd $directory
		git clone "https://github.com/wellintonvieira/$name.git"
		cd $name
		sh install.sh
		rm -rf $name
	fi
}

function verifyVersion {
	local serverVersion="$( w3m -dump "https://github.com/wellintonvieira/update-mirrors/blob/main/src/update-mirrors.sh" | grep "version" | head -n 1 | sed 's/version=//' | sed 's/ //g' | sed 's/"//g' )"
	if [[ "$version" == "$serverVersion" ]]; then
		return 0
	fi
	return 1
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
	echo ":: Mirrorlist restored successfully!"
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
	"--update"|"-Sy"	) updateMirrorsPackage ;;
	"--uninstall"|"-U"	) uninstallApp;;
	"--version"|"-V" 	) printVersion ;;
	*) printError ;;
esac
