#!\bin\bash
#Update mirrors-list for Arch Linux

option="$1"
version="1.0.0-alpha03"
name="update-mirrors"
directory="$HOME/.$name"

function printError {
	echo "invalid option, consult manual with command $name --help"
}

function printManual {
	echo "use:	$name <operation>"
	echo "operations:"
	echo "$name {-Sy  --sync     }"
	echo "$name {-L  --lisl      }"
	echo "$name {-h  --help      }"
	echo "$name {-U  --uninstall }"
	echo "$name {-V  --version   }"
}

function printVersion {
	echo "$name $version"
	echo "2019-2022 Vieirateam Developers"
	echo "this is free software: you are free to change and redistribute it."
	echo "learn more at https://github.com/wellintonvieira/$name "
}

function progress {
	for i in {0..100}; do
		echo -ne ":: Updating mirrorlist... [ $i% ]\r"
		sleep 1
	done
}

function printMirrors {
	echo "$(cat /etc/pacman.d/mirrorlist)"
}

function updateMirrorsList {
	sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
	reflector -l 10 --protocol https --download-timeout 60 --sort rate --save /etc/pacman.d/mirrorlist &
	progress
	wait
	sudo rm -f /etc/pacman.d/mirrorlist.pacnew
	sleep 1s
	echo ":: Mirrorlist updated successfully!"
	sleep 1s
	read -rsp $':: Press any key to complete...' -n1 key
	echo ""
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
	"--sync"|"-Sy" ) updateMirrorsList ;;
	"--list"|"-L" ) printMirrors ;;
	"--help"|"-h" ) printManual ;;
	"--uninstall"|"-U" ) uninstallApp;;
	"--version"|"-V" ) printVersion ;;
	*) printError ;;
esac
