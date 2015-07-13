git-split-big
=============

Ever have files too big for github to upload?
Run git_splitbig.sh before commiting to make directories named after your big files.
These directories look like foo_zips/ and are filled with split zip files!
Split on a size of your choice, for example 10MB, 50MB, 100MB.
Then just remove those original files and commit!

When you want to recreate the original files from the zip directory, just run git_unsplit.sh

It works like this:

```bash
# splitting files larger than 50MB before commiting
# let git know about the big files
git add .
# split the big files
./git_splitbig.sh 50
# get the big files out of the repo - or add them to .gitignore
mv big_foo.tif large_bar.xls /tmp
# let git know about the split files
git add .
git commit
# push your split files!
git push
```

Now if you clone the repo elsewhere and want to recreate the original files just:

```bash
./git_unsplitbig.sh path/to/split_dir/ "big_foo.tif large_bar.xls"
```
