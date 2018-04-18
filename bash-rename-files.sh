# batch rename all files to lowercase
rename 'y/A-Z/a-z/' *

# batch rename all files to lowercase (alternative)
find . -depth -exec rename 's/(.*)\/([^\/]*)/$1\/\L$2/' {} \; # from the current directory
find <path> -depth -exec rename 's/(.*)\/([^\/]*)/$1\/\L$2/' {} \; # generally

# batch rename all files to lowercase (alternative)
for f in `find .`; do mv -v "$f" "`echo $f | tr '[A-Z]' '[a-z]'`"; done

# batch rename replace spaces with underscores
find -name "* *" -type d | rename 's/ /_/g' # do the directories first
find -name "* *" -type f | rename 's/ /_/g'

# batch rename replace spaces with underscores (alternative)
for d in *\ *; do mv "$d" "${d// /}"; done # do the directories first
for f in *\ *; do mv "$f" "${f// /_}"; done

# batch rename replace underscores with dashes (need to test)
find -name "*_*" -type f | rename 's/ /-/g'
for f in *_*; do mv "$f" "${f// /-}"; done
for f in *_*; do mv -v "$f" $(echo "$f" | tr '_' '-'); done

# batch rename additional examples (need to test)
for i in *-doc-*.txt; do mv $i ${i/*-doc-/doc-}; done
for i in ./*.pkg ; do mv "$i" "${i/-[0-9.]*.pkg/.pkg}" ; done

