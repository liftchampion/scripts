# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    colorised_norm_install.sh                          :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ggerardy <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/04/25 18:53:10 by ggerardy          #+#    #+#              #
#    Updated: 2019/04/27 22:57:43 by ggerardy         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/usr/bin/env bash

DIRNAME=~/.scripts
ALIASNAME=norminette

#############################  CHECK ZSHRC  ####################################

function check_zshrc {
	ISZSHRC=$(find ~ -d 1 -name '.zshrc' 2> /dev/null | wc -w)
	if (( $ISZSHRC == 0)); then
		echo "No ~/.zshrc found. Sorry"
		exit 1
	fi
}
################  CHECK PREV ALIASES TO COLORISED NORM  ########################

function find_prev_alias {
	PREV_ALIAS_TO_THIS=$(cat ~/.zshrc | grep '^alias.\+colorised_norm\.sh')
	if [[ $PREV_ALIAS_TO_THIS != "" ]]; then
		ALIASNAME=$(echo $PREV_ALIAS_TO_THIS | sed 's/alias //g' | \
						awk -F '=' '{print $1}')
		DIRNAME=$(echo $PREV_ALIAS_TO_THIS | sed 's/^.*=//g' | \
						awk -F '/' '{$NF=""; print $0}' | tr ' ' '/' | tr -d "'")
		echo "Found \x1B[38;5;202mexisting\x1B[0m alias to this script:"
		echo "alias \x1B[38;5;29m$ALIASNAME\x1B[0m='\x1B[38;5;29m$DIRNAME""colorised_norm.sh\x1B[0m'"
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

#########################  RM PREV ALIAS TO THIS  ###############################
function rm_prev_alias {
	set -e
	cat ~/.zshrc | grep -v "$PREV_ALIAS_TO_THIS" > ~/.zshrc.backup.colorised_norm
	cat ~/.zshrc.backup.colorised_norm > ~/.zshrc
	rm -f ~/.zshrc.backup.colorised_norm
	set +e
}

###############################  ASK MODE  ######################################
function ask_mode {
	if [[ $PREV_ALIAS_TO_THIS != "" ]]; then
		printf "Installed version found\nWould you like to Reinstall/Delete?\n[R/d]: "
		read Q_RES
		if [[ "$Q_RES" == 'd' ]] || [[ "$Q_RES" == 'D' ]]; then
			rm_prev_alias
			rm -f $DIRNAME"colorised_norm.sh"
			exit 0
		fi
	fi
}

################################  INSTALL  ######################################
function install_script {
	PWD=$(pwd)
	TMP_DIRNAME=~/.tmp_for_installing_norm_script
	echo "\x1B[38;5;202mInstallation in progress...\x1B[0m"
	mkdir -p $TMP_DIRNAME
	cd $TMP_DIRNAME
	git init --quiet
	git remote add origin \
			https://liftchampion@bitbucket.org/liftchampion/scripts.git 2> /dev/null
	git fetch --quiet
	git checkout --quiet origin/master -- colorised_norm.sh
	mv colorised_norm.sh $DIRNAME
	cd $PWD
	rm -rf $TMP_DIRNAME
	echo "alias $ALIASNAME='$DIRNAME""colorised_norm.sh'" >> ~/.zshrc
	source ~/.zshrc
	echo "\x1B[38;5;29mDone!\x1B[0m"
}

####################################  MAIN  ######################################
check_zshrc
find_prev_alias
ask_mode
get_alias_name
install_script

echo "alias $ALIASNAME='$DIRNAME""colorised_norm.sh'"
#echo $PREV_ALIAS_TO_THIS
#echo $PREV_ALIAS_TO_THIS_COUNT






