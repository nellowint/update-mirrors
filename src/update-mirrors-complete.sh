_update_mirrors_complete() {
	local cur prev letters words
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    letters="-Sy -L -h -V"
    words="--sync --list --help --version"

	case "$cur" in
		--*) COMPREPLY=( $( compgen -W "$words" -- $cur ) );;
		-*) COMPREPLY=( $( compgen -W "$letters" -- $cur ) );;
	esac
	return 0
}

complete -F _update_mirrors_complete -o filenames update-mirrors