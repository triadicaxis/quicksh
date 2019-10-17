# see below, but also..
# the ultimate command line cheat sheet:
# https://www.tecmint.com/cheat-command-line-cheat-sheet-for-linux-users/
# https://ss64.com/bash/rename.html
# https://unix.stackexchange.com/questions/159513/what-are-the-shells-control-and-redirection-operators
# https://www.youtube.com/watch?v=QBlENrp2wns&index=10&list=PL7B7FA4E693D8E790
# https://www.youtube.com/watch?v=w8a-smrPlvE
# https://www.youtube.com/user/madhurbhatia89

======================================================================

## shebang
#!/usr/bin/env bash

## help:
man mkdir ## gives you all the help info on the mkdir command, q to quit

======================================================================

## Navigation:

pwd # path of present working directory
cd [dir] # change working directory to [dir]

pwd ## show the present working directory
ls ## list items in the present working directory
ls -l ## list items and show their permissions
ls -a ## list all items, including hidden files
ls -al ## combine the above
ls -halS ## human readable, sort by size
ls -halt ## human readable, sort by time

du -ah ~/Downloads/ | sort -rh | head -6

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

nano file_name ## edit a file in the terminal, ctrl+x and y to exit

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
rm -r MyFolder ## remove MyFolder
rmdir MyFolder ## remove MyFolder

mkdir -p tmpdir/{trunk/sources/{includes,docs},branches,tags} ## make full directory tree

## make full directory tree (line-by-line alternative, save in a script)
mkdir -p tmpdir/trunk/sources/includes
mkdir -p tmpdir/trunk/sources/docs
mkdir -p tmpdir/branches
mkdir -p tmpdir/tags

echo {01..20} | xargs mkdir # create multiple folders 01-20
ln -s [file] link # make a link to [file]

cp [file1] [file2] # copy [file1] to [file2]
cp -r [dir1] [dir2] # recursively copy folder [dir1] to [dir2]
mv [file1] [file2] # rename [file1] to [file2]
mv [file] [dir] # move [file] into [dir], create [dir] if absent
rm [file1] [file2] # delete multiple files
rm -r [dir] # recursively delete folder [dir] and its contents
rm my* ## remove all files that start with "my"
ls | xargs rm -r # recursively delete everything in the working directory

find ~/Documents -name '*.jpg' -exec mv {} ~/Pictures \; ## recursively move all JPG to Pictures dir

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

## batch rename all files to lowercase (in pwd only)
for f in *; do mv "$f" "$f.tmp"; mv "$f.tmp" "`echo $f | tr "[:upper:]" "[:lower:]"`"; done

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

======================================================================

# install stuff
sudo apt-get -f install ## to update everything?
sudo apt-get install unity-control-center
sudo apt-get install gnome-tweak-tool

# EXECUTE R OR PYTHON SCRIPTS FROM TERMINAL:
python myscript.py ## need to ensure that right click > properties > permissions > executable is ticked, or use chmod
Rscript myscript.R ## same thing with the permissions
R CMD BATCH myscript.R ## executes the script and saves everything to myscript.R.Rout
R ## and then run: source('myscript.R')

# INSPECT STUFF BEFORE INSTALLING IT:
apt-cache pkgnames
apt-cache search vsftpd
apt-cache show netcat

# LINKS (HARD AND SOFT):
ln oldfile newfile ## create a hard replica of the content of a file
ln OldFolder NewFolder ## create a hard replica of the content of a folder
ln -s newfile newfile_soft ## create a soft link (pointer) to a file (or folder)

file * ## show details of all files and folder in the present working directory
wc myfile ## gives the number of lines, words and characters
wc -l myfile ## shows the number of lines in myfile
wc -w myfile ## shows the number of words in myfile
wc -c myfile ## shows the number of characters in myfile

======================================================================

# PERMISSIONS FOR FILES AND FOLDERS:
## there are three categories of users of the operating system: owner, group, other users
## each user category can have any combination of read, write or execute permissions.
## unix permission codes:
read = 4
write = 2
execute = 1

umask ## look at last three digits to work out default file or folder permissions for the three categories of users
e.g. if last three digits show 022, unix subtracts it from 666 to give the file default permissions, so..
666 - 22 = 644 ## means default permissions for the owner 6=read+write, group 4=read, others 4=read
similar thing applies to folders except unix subtracts those three digits from 777, so..
777 - 22 = 755 ## means default permission for the owner 7=read+write+execute, group 5=read+write, others 5=read+write

chmod 777 myfile ## gives full permissions to all three categories of users (owner, group, other users)
chmod 777 MyFolder ## gives full permissions to all three categories of users (owner, group, other users)

======================================================================

# DATE TIME AND SYSTEM:
who am i ## shows user details
uname -a ## gives system information including, e.g.:
## kernel: Linux
## machine name: Green
## kernel version: 3.16.0-41-generic Ubuntu
## system date: SMP Thu Jun 18
## processor architecture: x86_64 x86_64 x86_64

cal ## shows the current month calendar
cal 7 2006 ## shows the calendar for July 2006
cal feb 2015 ## shows the calendar for July 2006

date '+DATE: %d-%m-%y%nTIME: %H:%M:%S' ## specify the date and time format
date +'%Y-%m-%d' ## example for file naming
date +'%Y-%m-%d-%H%M%S'
date +'%Y%m%d-%H%M%S'

# check space on disk
# source: https://unix.stackexchange.com/questions/88065/sorting-files-according-to-size-recursively

# df [options] [devices]
df -h
df -h ~/Downloads/
df -h | sort -k 4 -rh ## sort by column 4 Avail
df -h | sort -k 2 -rh | head -6 ## sort by column 2 Size

# check for large files du
du -ah ~/Downloads/ | sort -h | head -6 ## smallest to biggest
du -ah ~/Downloads/ | sort -rh | head -6 ## biggest to smallest
du -ah ~/Downloads/ | grep -v "/$" | sort -rh | head -6 ## exclude dirs
du -ah ~/Downloads/ | grep -v "/$" | sort -h | tail -6 ## smallest to biggest, tail

# check for large files ls and find
ls -lS ~/Downloads/
ls -lS | grep -v '^d' | head -6 ## exclude dirs
ls -lS | grep '^-' | head -6 ## exclude symlinks
ls -lR | grep '^-' | sort -k 5 -rn | head -6 ## add recursion, sort by 5th column, biggest to smallest
find . -type f -exec du -h {} + | sort -r -h | head -6 ## full paths




