# see below, but also..
# the ultimate command line cheat sheet:
# https://www.tecmint.com/cheat-command-line-cheat-sheet-for-linux-users/
# https://ss64.com/bash/rename.html
# https://unix.stackexchange.com/questions/159513/what-are-the-shells-control-and-redirection-operators

## Navigation:

pwd # path of present working directory
cd [dir] # change working directory to [dir]

# relative vs absolute paths
/ = root directory
./ = current directory
../ = parent directory
~/ = home directory

# example: assume you're starting in /etc/wibble, then..
cd foo/bar # go to the directory /etc/wibble/foo/bar
cd /foo/bar # go to the directory /foo/bar
cd ./foo/bar # go to the directory /etc/wibble/foo/bar
cd ../foo/bar # go to the directory /etc/foo/bar
cd ~/foo/bar # go to the directory /home/<user>/wibble/foo/bar

ls -al # list files in working directory, -h human, -R recursive, -S by size, -t by date
apropos [pattern] # search for [pattern] in the command manual
man [command] # display the manual entry for [command]
[command] --help # display help for [command]

======================================================================

# control operators
[command1] ; [command2] # THEN: command2 will run after command1, irrespective of the exit status of command1.
[command1] & [command2] # BOTH: command2 will run in the background without waiting for command1 to exit, and command1 will run in the foreground.
[command1] && [command2] # AND: command2 will only run if command1 succeeded (exit 0).
# the above is equivalent to: if command1; then command2; else false; fi
[command1] || [command2] # OR: command2 will only run if command1 failed (exit !0)
# the above is equivalent to: if command1; then true; else command2; fi
[command1] | [command2] # PIPE: passes the STDOUT of command1 as STDIN to command2
[command1] |& [command2] # PIPE: passes the STDOUT and STDERR of command1 as STDIN to command2

# redirection operators
[command] < [file]
[command] <> [file]
[command] > [file]
[command] > out.txt 2 >error.txt
[command] < file.txt > out.txt 2> error.txt
command >| out.txt
command >> out.txt

cat [file] # display the contents of [file]
cat > [file] # put keyboard STDOUT into [file]
[command] | cat > [file] # put command STDOUT into [file]
cat < [file] # display the contents of [file]
cat >> [file] # add content to [file], ctrl+Z to close
cat [file1] [file2] # display the contents of multiple files
cat [file1] [file2] > [file3] # combine contents of multiple files into [file3]

touch [file] # make new file named [file]
echo {a..z} | xargs touch # create multiple files a-z
mkdir [dir] # make new folder named [dir]
mkdir ./One/Two{1..3}
echo {01..20} | xargs mkdir # create multiple folders 01-20
ln -s [file] link # make a link to [file]

cp [file1] [file2] # copy [file1] to [file2]
cp -r [dir1] [dir2] # recursively copy folder [dir1] to [dir2]
mv [file1] [file2] # rename [file1] to [file2]
mv [file] [dir] # move [file] into [dir], create [dir] if absent
rm [file1] [file2] # delete multiple files
rm -r [dir] # recursively delete folder [dir] and its contents
ls | xargs rm -r # recursively delete everything in the working directory

more -10 [file] # display the contents of [file], first 10 lines only
less [file] # open [file] in vi editor, ctrl+Z to close

## test examples
ls -al | grep rwx | cat > file1
more file1 | grep orange | cat > file2
grep -r sometext

======================================================================

# date format
date +'%Y-%m-%d' # in YYYY-MM-DD
date +'%Y-%m-%d-%H%M%S' # in YYYY-MM-DD-HHMMSS
date +%s # number of seconds since the epoch.
date +%s%N # number of seconds + current nanoseconds.
echo $(($(date +%s%N)/1000000)) # therefore current time in miliseconds

grep -r [pattern] # display the file paths and text lines containing [pattern]
[command] | grep [pattern] # find [pattern] in the STDOUT of [command]
find -iname "*.txt" | xargs grep "abc" # find the string abc in all txt files, case insensitive
ls *.jpg | xargs -n1 -i cp {} /external-hard-drive/directory # copy all images to external drive
find / -name *.jpg -type f -print | xargs tar -cvzf images.tar.gz # find all jpg images in the system and archive them
echo 'dir1 dir2 dir3' | xargs mkdir # make multiple directories

# example1: create multiple files and multiple folders
for i in {01..12}; do touch "file`basename $i`.txt"; done # multiple file00.txt files
for i in {01..12}; do mkdir "dir`basename $i`"; done # multiple dir00 folders

# example2: make multiple files and multiple folders (alternative to above)
for i in {01..12}; do touch "file${i%}.txt"; done
for i in {01..12}; do mkdir "dir${i%}"; done

# example3: make and then rename multiple files
echo {01..20} | xargs touch # make multiple files..
for i in *; do mv "$i" "file`basename $i`.txt"; done # then rename the files

# example4: create multiple directories and multiple files within each
for i in {01..12}; do mkdir "dir${i%}"; done # make multiple directories
find . -type d -exec touch {}/file{01..04}.txt \; # make four txt files in each

# example5: create multiple directories and multiple files within each, name them with date and time
for i in {01..06}; do mkdir "`date +'%Y-%m-%d'`-MyFolder-${i%}"; done
find . -type d -exec touch {}/`date +'%Y-%m-%d-%H:%M:%S'`-my-file-{01..04}.csv \; # make four csv files in each

======================================================================

# batch rename all files to lowercase
rename 'y/A-Z/a-z/' *

## batch rename all files to lowercase (alternative)
find . -depth -exec rename 's/(.*)\/([^\/]*)/$1\/\L$2/' {} \; # from the current directory
find <path> -depth -exec rename 's/(.*)\/([^\/]*)/$1\/\L$2/' {} \; # generally

## batch rename all files to lowercase (alternative)
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

