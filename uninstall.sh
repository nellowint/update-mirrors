#!\bin\bash
#file uninstall update-mirrors in /opt/update-mirrors

if [ -d "/opt/update-mirrors" ]; then
	sudo rm -rf "/opt/update-mirrors"
	sudo rm -rf "/usr/share/bash-completion/completions/update-mirrors-complete.sh"
	sed -i "/update-mirrors/d" "/$HOME/.bashrc"
	echo "update-mirrors was uninstalled successfully"
	exec bash --login
else
	echo "update-mirrors is not installed"
fi