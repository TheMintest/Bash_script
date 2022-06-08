#! /bin/bash

FOLDER=/Users/muttedit/Desktop/PHOTOS_TUTO

# #Get the name of folders in the folder
# FOLDERS=$(ls $FOLDER)

x=1
for entry in "$FOLDER"/*

do
    # echo "Processing $entry"
    #check if the file is an image file
    if [[ $entry == *.jpg ]] || [[ $entry == *.png ]] || [[ $entry == *.jpeg ]]|| [[ $entry == *.tiff ]]
    then
        echo "File number $x is $(basename "$entry") and is valid"
        HEIGHTFULL=`sips -g pixelHeight $entry`
        HEIGHT=`echo $HEIGHTFULL | cut -d ':' -f2`
        checkParentFolder()
         if [[ $PARENTFOLDER == *"/INSTAGRAM"* ]]
    then
        checkInstagramSize()
    else
      if [[ $PARENTFOLDER == *"/HD"* ]]
      then
        checkHDsize()
      else
        if [[ $PARENTFOLDER == *"/CULTURA.COM"* ]]
        then
          checkCultura.comSize()
        fi
      fi
    fi


       
      fi
     x=$((x+1))
done

checkParentFolder {
    echo "Checking parent folder"
    PARENTFOLDER=`dirname "$entry"`
    echo "$PARENTFOLDER"
   
}

checkInstagramSize() {
    if [[ $HEIGHT -gt 1080 ]]
    then
        echo "File is too big"
    else
        echo "File is not too big"
    fi
}