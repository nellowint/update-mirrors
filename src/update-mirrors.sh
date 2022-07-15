#!\bin\bash
#Update mirrors-list for Arch Linux

option="$1"
version="1.0.0-alpha02"

function printError {
	echo "invalid option, consult manual with command update-mirrors --help"
}

function printManual {
	echo "use:	update-mirrors <operation>"
	echo "operations:"
	echo "update-mirrors {-Sy  --sync	}"
	echo "update-mirrors {-L  --list	}"
	echo "update-mirrors {-h  --help	}"
	echo "update-mirrors {-V  --version	}"
}

function printVersion {
	echo "update-mirrors $version"
	echo "2019-2022 Vieirateam Developers"
	echo "this is free software: you are free to change and redistribute it."
	echo "learn more at https://github.com/wellintonvieira/update-mirros "
}

function verifyDependency {
	dependency=$( pacman -Qs reflector )
	if [ "$dependency" == "" ]; then
		pacman -S reflector --noconfirm
	fi
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
	reflector -l 10 --protocol https --download-timeout 60 --sort rate --save /etc/pacman.d/mirrorlist &
	progress
	wait
	rm -f /etc/pacman.d/mirrorlist.pacnew
	sleep 1s
	echo ":: Mirrorlist updated successfully!"
	sleep 1s
	read -rsp $':: Press any key to complete...' -n1 key
	echo ""
}

if [[ "$option" == "--sync" || "$option" == "-Sy" ]]; then
	verifyDependency
	updateMirrorsList
elif [[ "$option" == "--list" || "$option" == "-L" ]]; then
	printMirrors
elif [[ "$option" == "--help" || "$option" == "-h" ]]; then
	printManual
elif [[ "$option" == "--version" || "$option" == "-V" ]]; then
	printVersion
else
	printError
fi
