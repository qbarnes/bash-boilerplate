#! /bin/bash

function FatalE
{
	local -i status=$1; shift
	trap - EXIT

	(( status != 0 )) || status=1

	echo -e >&2 "Fatal: $@"
	exit $status
}


function Fatal
{
	FatalE 1 "$@"
}


function ErrorHandler
{
	local -i status=$?
	local cmd=$BASH_COMMAND
	local -i line=$1
	trap - EXIT

	FatalE $status \
		"Command '$cmd' on line $line failed with error code $status."
}


function OnExit
{
	local -i ret=$?
	local cmd=$BASH_COMMAND

	if (( $ret != 0 ))
	then
		echo >&2 "Uncaught error running '$cmd' ($ret)."
		exit $ret
	fi

	exit 0
}


function Usage
{
	local usage

	trap - EXIT

	usage="Usage: "
	usage+="${0##*/} ..."

	echo -e >&2 "$usage"

	exit ${1-1}
}

set -o nounset
set -o errexit -o errtrace
shopt -s nullglob extglob

trap 'ErrorHandler $LINENO' ERR
trap 'OnExit' EXIT

# ...
