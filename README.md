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
./git_splitbig.sh 50
mv big_foo.tif large_bar.xls /tmp
git add .
git commit
git push
```

Now if you clone the repo elsewhere and want to recreate the original files just:

```bash
./git_unsplitbig.sh "big_foo.tif large_bar.xls"
```
