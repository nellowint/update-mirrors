#!\bin\bash
#file install update-mirrors in /$HOME/.update-mirrors

name="update-mirrors"
directory="$HOME/.$name"

function checkingDependencies {
	dependencies=("bash-completion" "reflector")
	for dependency in $dependencies; do
		condition=$( pacman -Qs $dependency )
		if [ "$dependency" == "" ]; then
			sudo pacman -S $dependency --noconfirm
		else
			echo -e "checking dependencies to install $name..."
			sleep 1
		fi
	done
	echo "$name installed successfully"
}

if [ -d "$directory" ]; then
	echo "$name is installed in $directory"
else
	mkdir $directory
	cp "$PWD/src/$name.sh" $directory
	chmod +x "$directory/$name.sh"
	sudo cp "$PWD/src/$name-complete.sh" "/usr/share/bash-completion/completions/"
	echo -e "\nalias $name='sh $directory/$name.sh'\n" >> "/$HOME/.bashrc"
	echo -e "source /usr/share/bash-completion/completions/$name-complete.sh" >> "/$HOME/.bashrc"
	checkingDependencies
	exec bash --login
fi