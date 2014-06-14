#!/bin/bash


function greeshma_alarm(){
	tts=$(cat $1 | egrep -o '^;([a-zA-Z ]+)\^([0-9]+) *;$')
	if [ "$tts" ]
	then
		val=$(echo $tts | tr -d ";");
		val=$(echo $val | tr "^" ' ');
		myval=($val);
		
		num=${#myval[@]}-1;
		speech="";
		for((i=0;i<$num;i++))
		do
			speech="$speech ${myval[$i]} "
		done

		notify-send "TTS speak [${myval[$num]}] " "$speech"

		for((i=0;i<${myval[$num]};i++))
		do
			spd-say "$speech"
			sleep 1;
		done
	fi

}
function tell_her() {
	echo "telling her $1" >> /tmp/greesh.txt
	echo "/say_to -q nitheeshkl.dev@gmail.com $1" > /home/kln/.mcabber/mcabber.fifo;
}

function radha_nooo(){
	radha=$(cat $1 | egrep -o '\<[nN]+[oO]{2,}([pP]*[eE]*)\b')
	if [ "$radha" ]
	then
		# 2 on the playlist is radha's noo
		xmms2 jump 2
		xmms2 play
	fi
}

function ahal_meep(){
	ahal=$(cat $1 | egrep -o '\<[mM][eE]{2,}[pP]')
	if [ "$ahal" ]
	then
		# find appropriate sound and add to xmms 
		# for now live with this
		spd-say "meep";	
	fi
}

function rps(){
	declare -a elm=("rock" "paper" "scissor")
	rps=$(cat $1 | egrep -o '^rps=.*;$')
	if [ "$rps" ]
	then
		rps=$(echo $rps | tr -d "; " | cut -d "=" -f2);
		rand=$(( ( RANDOM % 3 ) ))
		me=${elm[$rand]}
		you=$(echo $rps |  egrep -io '(^rock$)|(paper$)|(scissor$)' | tr '[:upper:]' '[:lower:]')

		if [ "$you" ]
		then
			echo "you:$you me:$me" >> /tmp/greesh_rps.txt
			tell_her "you:$you me:$me"

			case "$me" in
				"rock")
					case "$you" in
						"rock")
							tell_her "copy cat!!...let's try again."
							;;
						"paper")
							tell_her "you were lucky!!...let's try again."
							;;
						"scissor")
							tell_her "haha...i win!!"
							;;
					esac
					;;
				"paper")
					case "$you" in
						"rock")
							tell_her "you lose....better luck next time :P"
							;;
						"paper")
							tell_her "trying to copy me eh?! cat!!...let's try again."
							;;
						"scissor")
							tell_her "damn!!...you 	wont get so lucky next 	time."
							;;
					esac
					;;
				"scissor")
					case "$you" in
						"rock")
							tell_her "its ok...enjoy now...i'll get you next time!!."
							;;
						"paper")
							tell_her
							"aww...paapa...dont worry...you've to lose sometimes."
							;;
						"scissor")
							tell_her "stop trying to copy me!!"
							;;
					esac

					;;
			esac
		else
			tell_her "this is not valid..dont you know to play?!"
		fi

        #start a recurseive bomb! :D
        tell_her "rps= $me;"
	fi
}
#
#	Radhacons
#

if [ $# -eq 4 ]
then
	#smiley=$(cat $4 | egrep -o ':\)|:D|:-\)|:-D|\^_\^|XD|xD|:o|:O|:-o|<3|</3|:P|:-P|:\(|:-\(')
	smiley=$(cat $4 | egrep -o ":\)|:\(|;\)|:D|:\'\(|:P|:O")
	smiley="$smiley "
	for face in $smiley
	do
		lastface=$face
	done
	smiley=$(echo "$lastface" | base64)

	radha_nooo $4
	ahal_meep $4
	greeshma_alarm $4
	rps $4
    rm $4
fi

#KIND=$(echo $1 | sed -e "s/'/_/g")
#FBID=$(echo $3| cut -d '-' -f2|cut -d "@" -f1)
#REAL_NAME=$(grep $FBID ~/.mcabber/friends |cut -d '"' -f4)
#STATUS=$2
#FILE_CHAT=$4

#DOMAIN=$(echo $JID|cut -d '@' -f2)
#CACHE="${HOME}/.mcabber/cache"


if [ "$smiley" == "Cg==" ] 
then
	smiley="picture"
fi

image="/home/kln/.mcabber/pictures/gmail/$3/$smiley"

#echo "mcabber_event_hook('$1',  '$2',  '$3',  '$4', '$image')" >> /tmp/mcabber.log
# finally dispaly the awesome notification 
echo "mcabber_event_hook('$1',  '$2',  '$3',  '$4', '$image')" | awesome-client

#cat frnd_list | egrep "$id" -B 1 | sed 's/"name": "//g' | sed 's/"id": "[0-9]*"//g' | grep -Poe '[a-zA-Z][a-zA-Z ]*'
