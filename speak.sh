#!/bin/bash


function speak(){
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

		notify-send "TTS speak[${myval[$num]}] " "$speech"

		for((i=0;i<${myval[$num]};i++))
		do
			spd-say "$speech"
			sleep 1;
		done
	fi

}

speak $1 

