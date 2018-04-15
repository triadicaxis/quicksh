## bulk rename files, replace character _ with -
for f in *_*; do mv -v "$f" $(echo "$f" | tr '_' '-'); done

## bulk rename files to lower case (eg.1)
rename 'y/A-Z/a-z/' *

## bulk rename files to lower case (eg.1)
find <path> -depth -exec rename 's/(.*)\/([^\/]*)/$1\/\L$2/' {} \;
find /mnt/c/Users/black/Documents/Git -depth -exec rename 's/(.*)\/([^\/]*)/$1\/\L$2/' {} \;