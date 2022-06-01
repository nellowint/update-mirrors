#!\bin\bash
#file install update-mirrors in /opt/update-mirrors

if [ -d "/opt/update-mirrors" ]; then
	echo "update-mirrors is installed in /opt/update-mirrors"
else
	dependency=$( pacman -Qs bash-completion )
	if [ "$dependency" == "" ]; then
		sudo pacman -S bash-completion --noconfirm
	fi
	sudo mkdir "/opt/update-mirrors"
	sudo cp "$PWD/src/update-mirrors.sh" "/opt/update-mirrors"
	sudo cp "$PWD/src/update-mirrors-complete.sh" "/usr/share/bash-completion/completions/"
	sudo chmod +x "/opt/update-mirrors/update-mirrors.sh"
	sudo chmod +x "/$PWD/uninstall.sh"
	echo -e "\nalias update-mirrors='sudo sh /opt/update-mirrors/update-mirrors.sh'\n" >> "/$HOME/.bashrc"
	echo -e "source /usr/share/bash-completion/completions/update-mirrors-complete.sh" >> "/$HOME/.bashrc"
	exec bash --login
fi