#! /bin/bash

FOLDER=/Users/muttedit/Desktop/PHOTOS_TUTO/INSTAGRAM

x=1
for entry in "$FOLDER"/*
do
    echo "FILE number $x is $(basename "$entry")"
    HEIGHT=`sips -g pixelHeight $entry`
    WIDTH=`sips -g pixelWidth $entry`
    echo $WIDTH $HEIGHT
     x=$((x+1))
done
# echo "File: $FILES"
# HEIGHT=`sips -g pixelHeight $FILE`
# WIDHT=`sips -g pixelWidth $FILE`git remote add origin git@github.com:TheMintest/Bash_script.git
# echo "Height: $HEIGHT"