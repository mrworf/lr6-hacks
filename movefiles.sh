#!/bin/bash

SRC=$1
DST=$2

if [[ -z $SRC || -z $DST ]]; then
	echo ""
	echo "Usage: $0 <output from showfiles.sh> <new dir for extras>"
	echo ""
	exit 255
fi

if [ ! -d "${DST}" ]; then
	mkdir -p "${DST}" || { echo "Cannot create $DST" ; exit 255 ; }
fi

echo "Moving files..."
while IFS="" read -r F || [ -n "$F" ]
do
	if [ ! -f "${F}" ]; then
		echo "File ${F} does not exist"
	else
		DIR="$(dirname "$F")"
		FILE="$(basename "$F")"
		if [ ! -d  "${DST}/${DIR}" ]; then
			mkdir -p "${DST}/${DIR}" || { echo "Cannot create $DIR in $DST" ; exit 1 ; }
		fi
		mv "$F" "${DST}/${DIR}" || { echo "Cannot move $F into $DST/$DIR" ; exit 2 ; }
	fi
done < "${SRC}"
echo "Done"
