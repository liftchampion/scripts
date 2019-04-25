# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    colorised_norm_install.sh                          :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ggerardy <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/04/25 18:53:10 by ggerardy          #+#    #+#              #
#    Updated: 2019/04/25 22:45:11 by ggerardy         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/usr/bin/env bash


DIRNAME=~/.scripts
ALIASNAME=norminette
PREV_VERSION_FOUND=$(find ~ -name 'colorised_norm.sh' 2> /dev/null)

ISZSHRC=$(find ~ -d 1 -name '.zshrc' 2> /dev/null | wc -w)

if (( $ISZSHRC == 0)); then
	echo "No ~/.zshrc found. Sorry"
	exit 1
fi

PREV_ALIASES=$(cat ~/.zshrc | grep "alias $ALIASNAME=")
PREV_ALIAS_TO_THIS=$(echo $PREV_ALIASES | grep 'colorised_norm.sh')
PREV_ALIASES_COUNT=$(echo $PREV_ALIASES | wc -w)
PREV_ALIAS_TO_THIS_COUNT=$(echo $PREV_ALIAS_TO_THIS | wc -w)

if (( $PREV_ALIAS_TO_THIS_COUNT > 1)); then
	$PREV_ALIAS_TO_THIS="alias gg=/hui"
	ALIASNAME=$(echo $PREV_ALIAS_TO_THIS | sed 's/alias //g' | awk -F '=' '{print $1}')
	DIRNAME=$(echo $PREV_ALIAS_TO_THIS | sed 's/alias //g' | awk -F '/' '{$NF=""; print $0}' | tr ' ' '/')
	echo $ALIASNAME
	echo $DIRNAME
fi


echo "Choose alias name (leave blank for '$ALIASNAME') :"
read NEW_ALIASNAME
WORDS_IN_NEW_ALIASNAME=$(echo $NEW_ALIASNAME | wc -w)
if (( $WORDS_IN_NEW_ALIASNAME > 1)); then
	echo "Bad aliasname: '$NEW_ALIASNAME'"
	exit 1
fi
if (( $WORDS_IN_NEW_ALIASNAME == 1)); then
	ALIASNAME=$NEW_ALIASNAME
fi
echo "alias $ALIASNAME"
echo $PREV_VERSION_FOUND
echo $PREV_ALIASES
echo $PREV_ALIAS_TO_THIS
echo $PREV_ALIAS_TO_THIS_COUNT
echo $PREV_ALIASES_COUNT






