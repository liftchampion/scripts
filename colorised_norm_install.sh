# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    colorised_norm_install.sh                          :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ggerardy <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/04/25 18:53:10 by ggerardy          #+#    #+#              #
#    Updated: 2019/04/28 17:37:55 by ggerardy         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/usr/bin/env bash

DIRNAME=~/.scripts/
ALIASNAME=norminette

#############################  CHECK ZSHRC  ####################################

function check_zshrc {
	ISZSHRC=$(find ~ -d 1 -name '.zshrc' 2> /dev/null | wc -w)
	if (( $ISZSHRC == 0)); then
		echo "No ~/.zshrc found. Sorry"
		exit 1
	fi
}
################################  ASK REOPEN  ##################################
function ask_reopen {
	echo "Reopen your terminal, please"
}

################  CHECK PREV ALIASES TO COLORISED NORM  ########################

function find_prev_alias {
	PREV_ALIAS_TO_THIS=$(cat ~/.zshrc | grep '^alias.\+/colorised_norm\.sh')
	if [[ $PREV_ALIAS_TO_THIS != "" ]]; then
		ALIASNAME=$(echo $PREV_ALIAS_TO_THIS | sed 's/alias //g' | \
						awk -F '=' '{print $1}')
		DIRNAME=$(echo $PREV_ALIAS_TO_THIS | sed 's/^.*=//g' | \
						awk -F '/' '{$NF=""; print $0}' | tr ' ' '/' | tr -d "'")
		echo "Found \x1B[38;5;202mexisting\x1B[0m alias to this script:"
		echo "alias \x1B[38;5;29m$ALIASNAME\x1B[0m='\x1B[38;5;29m${DIRNAME}colorised_norm.sh\x1B[0m'"
	fi
}
#############################  GET ALIASNAME  ###################################

function get_alias_name {
	echo "Choose alias name (leave blank for '$ALIASNAME') :"
	read NEW_ALIASNAME
	NEW_ALIASNAME=$(echo $NEW_ALIASNAME | tr -d '\n')
	WORDS_IN_NEW_ALIASNAME=$(echo $NEW_ALIASNAME | wc -w)
	SAME_ALIASES=$(cat ~/.zshrc | grep "^alias $NEW_ALIASNAME=" | grep -v 'colorised_norm.sh')
	echo $SAME_ALIASES
	SAME_ALIASES_COUNT=$(echo $SAME_ALIASES | wc -w)
	if (( $WORDS_IN_NEW_ALIASNAME > 1)) || (( $SAME_ALIASES_COUNT > 0)); then
		echo "Bad aliasname: '$NEW_ALIASNAME'"
		if (( $SAME_ALIASES_COUNT > 0)); then
			echo "Alias with this name already exists"
			echo $SAME_ALIASES
		fi
		printf "Try again (Y/n): "
		read Q_RES
		if [[ "$Q_RES" == 'n' ]] || [[ "$Q_RES" == 'N' ]]; then
			exit 0
		fi
		get_alias_name
	elif (( $WORDS_IN_NEW_ALIASNAME == 1 )) ; then
		ALIASNAME=$NEW_ALIASNAME
	fi
}

#############################  GET DIRNAME  ###################################
function add_slash_to_dirname {
	NEW_DIRNAME=$(echo $NEW_DIRNAME | sed 's/\/$//g' | sed 's/$/\//g')
}

function get_dir_name {
	echo "Choose directory (leave blank for '$DIRNAME') :"
	read NEW_DIRNAME
	SCREENED_HOME=$(echo $HOME | sed 's/\//\\\//g')
	NEW_DIRNAME=$(echo $NEW_DIRNAME | tr -d '\n' | sed "s/~/$SCREENED_HOME/g")
	WORDS_IN_NEW_DIRNAME=$(echo $NEW_DIRNAME | wc -w)
	if (( $WORDS_IN_NEW_DIRNAME > 1 )); then
		echo "Bad directory: '$NEW_DIRNAME'"
		printf "Try again (Y/n): "
		read Q_RES
		if [[ "$Q_RES" == 'n' ]] || [[ "$Q_RES" == 'N' ]]; then
			exit 0
		fi
		get_dir_name
	else
		add_slash_to_dirname
		mkdir -p $NEW_DIRNAME 2> /dev/null
		touch "${NEW_DIRNAME}/.test_file_for_installing_colorised_norm" 2> /dev/null
		if [ ! -d "$NEW_DIRNAME" ] || [ ! -f "${NEW_DIRNAME}/.test_file_for_installing_colorised_norm" ]; then	
			echo "Bad directory: '$NEW_DIRNAME'"
			printf "Try again (Y/n): "
			read Q_RES
			if [[ "$Q_RES" == 'n' ]] || [[ "$Q_RES" == 'N' ]]; then
				exit 0
			fi
			get_dir_name
		else
			rm -f "${NEW_DIRNAME}/.test_file_for_installing_colorised_norm" 2> /dev/null
			DIRNAME=$NEW_DIRNAME
		fi
	fi
}

#########################  RM PREV ALIAS TO THIS  ###############################
function rm_prev_alias {
	set -e
	cat ~/.zshrc | grep -v "$PREV_ALIAS_TO_THIS" > ~/.zshrc.backup.colorised_norm
	cat ~/.zshrc.backup.colorised_norm > ~/.zshrc
	rm -f ~/.zshrc.backup.colorised_norm
	rm -f ${DIRNAME}colorised_norm.sh
	set +e
}

###############################  ASK MODE  ######################################
function ask_mode {
	if [[ $PREV_ALIAS_TO_THIS != "" ]]; then
		printf "Installed version found\nWould you like to Reinstall/Delete/Exit?\n[R/d/e]: "
		read Q_RES
		if [[ "$Q_RES" == 'd' ]] || [[ "$Q_RES" == 'D' ]]; then
			rm_prev_alias
			ask_reopen
			exit 0
		fi
		if [[ "$Q_RES" == 'e' ]] || [[ "$Q_RES" == 'E' ]]; then
			exit 0
		fi
		rm_prev_alias
	fi
}

################################  INSTALL  ######################################
function install_script {
	PWD=$(pwd)
	TMP_DIRNAME=~/.tmp_for_installing_norm_script
	echo "\x1B[38;5;202mInstallation in progress...\x1B[0m"
	mkdir -p $TMP_DIRNAME
	mkdir -p $DIRNAME
	cd $TMP_DIRNAME
	git init --quiet
	git remote add origin \
			https://liftchampion@bitbucket.org/liftchampion/scripts.git 2> /dev/null
	git fetch --quiet
	git checkout --quiet origin/master -- colorised_norm.sh
	mv colorised_norm.sh "${DIRNAME}colorised_norm.sh"
	cd $PWD
	rm -rf $TMP_DIRNAME
	echo "alias $ALIASNAME='${DIRNAME}colorised_norm.sh'" >> ~/.zshrc
	echo "\x1B[38;5;29mDone!\x1B[0m"
	ask_reopen
}

####################################  MAIN  ######################################
check_zshrc
find_prev_alias
ask_mode
get_alias_name
get_dir_name
install_script

echo "alias $ALIASNAME='${DIRNAME}colorised_norm.sh'"
#echo $PREV_ALIAS_TO_THIS
#echo $PREV_ALIAS_TO_THIS_COUNT






