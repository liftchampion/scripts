# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    colorised_norm_install.sh                          :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ggerardy <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/04/25 18:53:10 by ggerardy          #+#    #+#              #
#    Updated: 2019/04/25 21:52:57 by ggerardy         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/usr/bin/env bash


DIRNAME=~/.scripts
ALIASNAME=norminette
PREV_VERSION_FOUND=$(find ~ -name 'colorised_norm.sh' 2> /dev/null)

#set -e

PREV_ALIASES=$(cat ~/.zshrc | grep "alias $ALIASNAME=")
PREV_ALIAS_TO_THIS=$(echo $PREV_ALIASES | grep 'colorised_norm.sh')
PREV_ALIASES_COUNT=$(echo $PREV_ALIASES | wc -w)
PREV_ALIAS_TO_THIS_COUNT=$(echo $PREV_ALIAS_TO_THIS | wc -w)

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






