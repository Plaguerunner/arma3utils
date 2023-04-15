#!/bin/bash

Help ()
{
    echo "Parses a HTML modlist and outputs a delimited (default ',') set of mod IDs."
    echo
    echo "Syntax: parse_modlist.sh [-d delim] <modlist_file>"
    echo "options:"
    echo "a       Print the list as it should be passed to the -mod or -servermod argument to Arma3"
    echo "d       Use the specified delimiter."
    echo "h|help  Print this Help."
    echo
}

if [ $# -lt 1 ]
then
    Help
    exit -1
fi

MODE="numeric"
PREFIX=''
DELIM=','
POS_ARG=""

while [[ $# -gt 0 ]]; do
	case $1 in
          -a|--arg)
            DELIM=';'
            PREFIX='@'
	    MODE="text"
	    shift
	    ;;
	  -d|--delim)
	    DELIM=$2
	    shift
	    shift
	    ;;
	  -h|--help)
	    Help
	    exit 0
	    ;;
	  -*|--*)
	    echo "Unknown option $1"
	    exit -1
	    ;;
    	  *)
	    POS_ARG=("$1")
	    shift
	    ;;
  esac
done

if [ ! -f "$POS_ARG" ]; then
    echo "Can't find $POS_ARG - are you sure you gave the correct path?"
    exit -1
fi

IFS=$'\n'
FULL=""
if [ "$MODE" = "text" ]; then
  for LINE in $(cat $POS_ARG | grep DisplayName | cut -d '>' -f 2 | cut -d '<' -f 1) 
    do
      FULL+="$PREFIX$LINE$DELIM"
    done
else
  for LINE in $(cat $POS_ARG | grep -i id | cut -d '=' -f 3 | cut -d '"' -f 1)
    do
      FULL+="$PREFIX$LINE$DELIM"
    done
fi
    echo "$FULL"

