#!/bin/bash
# ZmEu (zmeu@whitehats.net) 04/03/2019
# -
# Notes: For educational purposes only.
# -
# Don't use them for illegal activitis.
# You are the only responsable for your actions!
# -
# License: GNU GENERAL PUBLIC LICENSE

function usage {
	echo "Usage: $0 [-s <server> -p <port> -m <string>] or [-s <server> -p <port> -l]" 1>&2;
	exit 1;
}

function nickname {
	echo "NICK ${1}$(((RANDOM%1000)+1))"
}

function username {
	echo "USER ${1} 0 * :${2}"
}

function join {
	echo "JOIN ${1}"
}

# stdin: a stream where each line is converted to a message
# $1: The user/channel to send to
function msg {
	#echo "PRIVMSG ${1} :${2}" >&3
	TARGET=$1
	sed -re "s/^(.*)\$/PRIVMSG ${TARGET} :\1/"
}

function quit {
	echo "QUIT Bye."
}

function list {
	echo "LIST"
}

namelist="
Kathyrn
Annie
Rochel
Buddy
Lawanna
Bell
Marcus
Jolanda
Gertrudis
Shizuko
Maud
Winston
Ebonie
Earnestine
Lorriane
Leanna
Terrie
Tristan
Ciara
Melonie
Faith
Reiko
Lia
Golda
Elizbeth
Tarra
Rosie
Israel
Mardell
Eufemia
Liza
Jamel
Dominick
Jillian
Demetria
Pearly
Josiah
Yulanda
Shona
Huey
Alesia
Roseanna
Cayla
Gertude
Migdalia
Trudie
Tamiko
Trina
Mara
Matilda
"
names=($namelist)
num_names=${#names[*]}

while getopts ":s:p:m:l:" flag
	do
		case $flag in
			s)
				flagy=True
				servername=${OPTARG}
			;;
			p)
				flagy=True
				port=${OPTARG}
			;;
			m)
				flagy=True
				string=${OPTARG}
				cat channelname|grep 322| cut -d\  -f2-|awk '{print $3}' > channeltemp
				channelname=$(awk NR==$((${RANDOM} % `wc -l < channeltemp` + 1)) channeltemp)
				rm -rf channeltemp
				# with proxy;
				# exec 3<>/dev/tcp/$1/$2
				# echo "CONNECT wh.irc.net:6667" >&3
				exec 3>/dev/tcp/$servername/$port
				nickname "${names[$((RANDOM%num_names))]}" >&3
				username "${names[$((RANDOM%num_names))]} ${names[$((RANDOM%num_names))]}" >&3
				join $channelname >&3
				echo "$*"|sed "s/-s $servername -p $port -m //"|msg $channelname >&3
				quit >&3
				cat <&3
			;;
			l)
				flagy=True
				echo $servername
				exec 3>/dev/tcp/$servername/$port > channelname
				nickname "${names[$((RANDOM%num_names))]}" >&3
				username "${names[$((RANDOM%num_names))]} ${names[$((RANDOM%num_names))]}" >&3
				list >&3
				quit >&3
				cat <&3
			;;
			h|?|*)
				usage
			;;
		esac
	done

	if [ -z "$flagy" ]
	then
		usage
	fi
shift $((OPTIND-1))
