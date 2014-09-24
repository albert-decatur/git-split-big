#!/bin/bash
# remake the files split by git_splitbig.sh
# leaves the file inside its split directory made by git_splitbig.sh, which looks like foo_zips/
# example use: ./git_unsplitbig.sh "foo.tif bar.txt"


bigfiles="$1"
for bigfile in $bigfiles
do 
	# go to the dir made by git_splitbig.sh for the given file
	cd ${bigfile}_zips
	# unzip each zip and remove afterwards
	for zip in *.zip
	do 
		unzip $zip
		rm $zip
	done
	# cat together the split files in order to remake the old file
	cat $( find . -type f ! -iregex ".*${bigfile}" | sort ) > $bigfile
	# remove the tmp files made by split
	find . -type f ! -iregex ".*${bigfile}" | xargs rm
	# return to previous dir
	cd - 1>/dev/null
done
