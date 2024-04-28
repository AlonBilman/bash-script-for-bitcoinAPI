#!/bin/bash


#In order to get the main block
MAIN_API="https://api.blockcypher.com/v1/btc/main"

#get the latest url form the main api before the loop.

TEMP_BLOCK_ADDRESS=$(wget -qO- "$MAIN_API"| grep "previous_url" | awk -F' ' '{print $2}' | sed 's/[,"]//g')


#counter is for the loop. $1 is provided by the user of the script 
COUNTER=1
NUMBER=$1   

#check if the user forgot to give us input.
if [ -z "$1" ]; then 
	echo "In order to use this script you need to provide input(int)...:P"
	sleep 1 
	exit 1
fi


while [ $COUNTER -le $NUMBER ]; do

	#download the block   
	TEMP=$(wget -qO- "$TEMP_BLOCK_ADDRESS")

	#print all relevant lines.using sed and grep. 
	echo $TEMP |sed 's/,/\n/g'|grep "hash\|time\|height\|total\|received_time\|relayed_by\|prev_block"| grep -v "prev_block_url"|sed 's/["{]//g'

	#get next block address. 
	TEMP_BLOCK_ADDRESS=$(echo "$TEMP"| grep prev_block_url | awk -F' ' '{print $2}' | sed 's/[,"]//g')
	
	#using -e with echo enable backslash. we didnt use it before beacuse there was no need to.
	if [ "$COUNTER" -ne "$NUMBER" ]; then
		echo -e "       |\n       |\n       |\n       |\n       V"
	fi

	((++COUNTER))

done
