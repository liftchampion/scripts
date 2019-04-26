# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    colorised_norm_install.sh                          :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ggerardy <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/04/25 18:53:10 by ggerardy          #+#    #+#              #
#    Updated: 2019/04/26 20:06:05 by ggerardy         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/usr/bin/env bash

DIRNAME=~/.scripts
ALIASNAME=norminette

#############################  CHECK ZSHRC #####################################
ISZSHRC=$(find ~ -d 1 -name '.zshrc' 2> /dev/null | wc -w)
if (( $ISZSHRC == 0)); then
	echo "No ~/.zshrc found. Sorry"
	exit 1
fi

################  CHECK PREV ALIASES TO COLORISED NORM  ########################
PREV_ALIAS_TO_THIS=$(cat ~/.zshrc | grep '^alias.\+colorised_norm\.sh')
PREV_ALIAS_TO_THIS_COUNT=$(echo $PREV_ALIAS_TO_THIS | wc -w)

if (( $PREV_ALIAS_TO_THIS_COUNT > 1)); then
	ALIASNAME=$(echo $PREV_ALIAS_TO_THIS | sed 's/alias //g' | \
					awk -F '=' '{print $1}')
	DIRNAME=$(echo $PREV_ALIAS_TO_THIS | sed 's/^.*=//g' | \
					awk -F '/' '{$NF=""; print $0}' | tr ' ' '/' | tr -d "'")
	echo "Found prev alias to this"
	echo $ALIASNAME
	echo $DIRNAME
fi

#############################  GET ALIASNAME ###################################
function check_free_alias {
	$SAME_ALIASES=$(cat ~/.zshrc | grep "^alias $ALIASNAME=" | grep -v 'colorised_norm.sh')
	$SAME_ALIASES_COUNT=$(echo $SAME_ALIASES | wc -w)
}

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
	else
		ALIASNAME=$NEW_ALIASNAME
	fi
}
get_alias_name
##################  CHECK PREV ALIASES WITH SAME NAME  ########################


echo "alias $ALIASNAME='$DIRNAME""colorised_norm.sh'"
#echo $PREV_ALIAS_TO_THIS
#echo $PREV_ALIAS_TO_THIS_COUNT






