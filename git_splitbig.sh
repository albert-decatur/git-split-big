#!/bin/bash
# split files too large for github to upload
# makes directories named after input file that contain zips according to user specified split size
# NB: directories will be named foo_zips/ where foo is the filename.  directories will be removed before the script runs!
# split size uses megabytes only
# output can be unsplit with git_unsplitbig.sh
# example use: ./git_splitbig.sh 50 && git add . && git commit && git push

size=$1
# get sizes of new files
newsizes=$( git status --porcelain | grep "^A" | cut -c 4- | xargs du -BM )
tosplit=$(
	echo "$newsizes" |\
	while read newsize
	do
		filesize=$( echo "$newsize" | awk '{ print $1 }' | grep -oE "[0-9]+" )
		if [[ $filesize -gt $size ]]; then
			filename=$( echo "$newsize" | awk '{ print $2 }' )
			echo $filename
		fi
	done
)

for bigfile in "$tosplit"
do 
	rm -r ${bigfile}_zips/ 2>/dev/null
	tmpdir=$(mktemp -d)
	md5sum ${bigfile} > gitsplitbig_${bigfile}.md5
	split -a 10 -b ${size}MB $bigfile $tmpdir
	mv $tmpdir* $tmpdir 2>/dev/null
	for splitfile in $( find $tmpdir -type f )
	do 
		cd $tmpdir
		zip ${splitfile}.zip $( basename $splitfile )
		cd - 1>/dev/null
	done
	mkdir ${bigfile}_zips/
	mv $tmpdir/*.zip ${bigfile}_zips/
	rm -r $tmpdir
done
