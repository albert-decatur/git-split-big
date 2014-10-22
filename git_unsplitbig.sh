#!/bin/bash
# remake the files split by git_splitbig.sh
# user args: 1) directory where the split directories can be found, 2) double quoted list of files to unsplit
# example use: ./git_unsplitbig.sh output/ "foo.tif bar.txt"


split_parent_dir=$1
bigfiles="$2"
cd $split_parent_dir
for bigfile in $bigfiles
do 
	# go to the dir made by git_splitbig.sh for the given file
	cd ${bigfile}_zips/
	# unzip each zip and remove afterwards
	for zip in *.zip
	do 
		unzip $zip
		rm $zip
	done
	# cat together the split files in order to remake the old file
	cat $( find . -type f ! -iregex ".*${bigfile}" | sort ) > ../$bigfile
	# move up to parent dir to remove current dir
	cd ..
	# remove split dirs
	rm -r ${bigfile}_zips/
done
