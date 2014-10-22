#!/bin/bash
# split files too large for github to upload
# makes directories named after input file that contain zips according to user specified split size
# NB: directories will be named foo_zips/ where foo is the filename.  directories will be removed before the script runs!
# NB: appends to hidden md5 file. bigfile name must not whitespace
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

echo "$tosplit"|\
while read bigfile
do 
	rm -r ${bigfile}_zips/ 2>/dev/null
	tmpdir=$(mktemp -d)
	split -a 10 -b ${size}MB $bigfile $tmpdir
	mv $tmpdir* $tmpdir 2>/dev/null
	for splitfile in $( find $tmpdir -type f )
	do 
		cd $tmpdir
		zip ${splitfile}.zip $( basename $splitfile )
		cd - 1>/dev/null
	done
	mkdir ${bigfile}_zips/
	# make or append to hidden md5, ensuring that value is updated as necessary
	# remove md5s that relate to a file with this name
	# NB: really ought to ensure this goes to git root
	# NB: really ought to ensure md5s of irrelevant files are not left
	if [[ -f .gitsplitbig.md5 ]]; then
		cat .gitsplitbig.md5 |\
		awk "{ if(\$2 != \"$bigfile\") print \$0 }"|\
		sponge .gitsplitbig.md5
	fi
	# append current md5 to file
	md5sum ${bigfile} >> .gitsplitbig.md5
	cat .gitsplitbig.md5|\
	sort|\
	uniq|\
	sponge .gitsplitbig.md5
	mv $tmpdir/*.zip ${bigfile}_zips/
	rm -r $tmpdir
done
