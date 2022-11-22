#!\bin\bash
#Update mirrors-list for Arch Linux

option="$1"
version="1.0.0-alpha05"
name="update-mirrors"
directory="$HOME/.$name"

function printError {
	echo "invalid option, consult manual with command $name --help"
}

function printManual {
	echo "use:	$name <operation>"
	echo "operations:"
	echo "$name {-Sy  --sync      }"
	echo "$name {-R   --restore   }"
	echo "$name {-L   --lisl      }"
	echo "$name {-h   --help      }"
	echo "$name {-U   --uninstall }"
	echo "$name {-V   --version   }"
}

function printVersion {
	echo "$name $version"
	echo "2019-2022 Vieirateam Developers"
	echo "this is free software: you are free to change and redistribute it."
	echo "learn more at https://github.com/wellintonvieira/$name "
}

function progress {
	for (( i = 0; i < 100; i++ )); do
	    sleep 1
	    progressBar $i 100
	done
}

function progressBar {
    let _progress=(${1}*100/${2}*100)/100
    let _done=(${_progress}*8)/10
    let _left=80-$_done
    _full=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")
    printf "\r[${_full// /#}${_empty// /-}] ${_progress}%%"
}

function printMirrors {
	echo "$(cat /etc/pacman.d/mirrorlist)"
}

function updateMirrors {
	sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
	reflector -l 10 --protocol https --download-timeout 60 --sort rate --save /etc/pacman.d/mirrorlist &
	echo "::Updating mirrorslist, please wait..."
	progress
	wait
	sudo rm -f /etc/pacman.d/mirrorlist.pacnew
	sleep 1
	echo ":: Mirrorlist updated successfully!"
	finalizeUpdate
}

function restoreMirrors {
	sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
	sudo mv /etc/pacman.d/mirrorlist.backup /etc/pacman.d/mirrorlist
	sleep 1
	echo ":: Mirrorlist restored successfully!"
	finalizeUpdate
}

function finalizeUpdate {
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
	"--sync"|"-Sy"		) updateMirrors ;;
	"--restore"|"-R"    ) restoreMirrors ;;
	"--list"|"-L"		) printMirrors ;;
	"--help"|"-h"		) printManual ;;
	"--uninstall"|"-U"	) uninstallApp;;
	"--version"|"-V" 	) printVersion ;;
	*) printError ;;
esac
