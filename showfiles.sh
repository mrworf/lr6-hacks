#!/bin/bash

FILE=$1
OUTPUT=$2
BASEDIR=$3

if [[ -z $FILE || -z $OUTPUT || -z $BASEDIR ]]; then
	echo "Outputs a filelist where the windows drive is replaced with basedir"
	echo ""
	echo "Usage: $0 <Lightroom Catalog> <List Of Filenames> <basedir>"
	echo ""
	exit 255
fi

SQL='SELECT absolutePath || pathFromRoot || idx_filename AS file FROM AgLibraryFile LEFT JOIN AgLibraryFolder ON (AgLibraryFile.folder = AgLibraryFolder.id_local) LEFT JOIN AgLibraryRootFolder ON (AgLibraryRootFolder.id_local = AgLibraryFolder.rootFolder);'

echo "Extracting..."
sqlite3 "${FILE}" "${SQL}" | sed "s#^[A-Z]:/*#${BASEDIR}/#" | sed -E 's#/+#/#g' | sort > "${OUTPUT}" || { echo "Failed!" ; exit 255 ; }
echo "Catalog contains $(wc --lines "${OUTPUT}") photos/videos."

echo "Testing that all files exists in ${BASEDIR}..."
MISSING=false
while IFS="" read -r F || [ -n "$F" ]
do
	if [ ! -f "${F}" ]; then
		echo "File ${F} does not exist"
		MISSING=true
	fi
done < "${OUTPUT}"
if $MISSING ; then
	echo "Cannot continue, files are missing"
	exit 1
fi

echo "Locating any file NOT in catalog..."
# Easiest way to do this is to diff (exclude lightroom catalogs)
find "${BASEDIR}" -type f | grep -vi .lrcat | sed -E 's#/+#/#g' | sort > "${OUTPUT}.diff"
diff "${OUTPUT}" "${OUTPUT}.diff" | grep '>' | sed 's/^..//g' > "${OUTPUT}.extras"
rm "${OUTPUT}.diff"
echo "Found $(wc --lines "${OUTPUT}.extras") files which weren't in the catalog"
echo "Filelist can be found in ${OUTPUT} and files not in catalog are listed in ${OUTPUT}.extras"
