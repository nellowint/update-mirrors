#!\bin\bash
#Update mirrors-list for Arch Linux

option="$1"
version="1.0.0-alpha07"
name="update-mirrors"
directory="$HOME/.$name"

function printError {
	echo "invalid option, consult manual with command $name --help"
}

function printManual {
	echo "use:	$name <operation>"
	echo "operations:"
	echo "$name {-S   --sync      }"
	echo "$name {-L   --lisl      }"
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
	w3m -dump "https://archlinux.org/mirrorlist/?country=all&protocol=https&ip_version=4&use_mirror_status=on" | sed 's/#Server/Server/' | grep "Server" | head -n 10 > $directory/mirrorlist &
	wait
	sudo cp /etc/pacman.d/mirrorlist $directory/mirrorlist.backup
	sudo mv $directory/mirrorlist /etc/pacman.d/mirrorlist
	sudo rm -f /etc/pacman.d/mirrorlist.pacnew
	sleep 1
	echo ":: Mirrorlist updated successfully!"
}

function restoreMirrors {
	sudo mv /$directory/mirrorlist.backup /etc/pacman.d/mirrorlist
	sleep 1
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
	"--uninstall"|"-U"	) uninstallApp;;
	"--version"|"-V" 	) printVersion ;;
	*) printError ;;
esac
