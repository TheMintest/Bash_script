#! /bin/bash

FOLDER=/Users/muttedit/Desktop/PHOTOS_TUTO

# #Get the name of folders in the folder
# FOLDERS=$(ls $FOLDER)

x=1
for entry in "$FOLDER"/*
do
  #check if the file is an image file
  if [ $entry == *.jpg ] || [ $entry == *.png ] || [ $entry == *.jpeg ]|| [ $entry == *.tiff ] ; then
    echo "File number $x is $(basename "$entry") and is valid"
    #get the dimensions of the image and put them in a variable
    HEIGHTFULL=`sips -g pixelHeight $entry`
    HEIGHT=`echo $HEIGHTFULL | cut -d ':' -f2`
    WIDTHFULL=`sips -g pixelWidth $entry`
    WIDTH=`echo $WIDTHFULL | cut -d ':' -f2`
    checkParentFolder()
    if [$PARENTFOLDER == *"/INSTAGRAM"*] ; then 
        echo "File number $x is in the INSTAGRAM folder"
        checkInstagramSize() ;
    elif [ $PARENTFOLDER == *"/HD"*] ; then
        checkHDsize() ;
    elif [ $PARENTFOLDER == *"/CULTURA.COM"* ] ; then
        checkCultura.comSize() ;
    elif
        echo "File number $x is $(basename "$entry") and is not in a valid folder"
    fi
  fi
  

     x=$((x+1))
done

checkParentFolder() {
    echo "Checking parent folder"
    PARENTFOLDER=`dirname "$entry"`
    echo "$PARENTFOLDER"
   
}

checkInstagramSize() {
    if [[ $HEIGHT -eq 1080 ]] && [[ $WIDTH -eq 1080 ]]
    then
        echo "Instagram size is correct for $(basename "$entry")"
    else
        echo "Instagram size is not correct for file $(basename "$entry")"
    fi
}

checkHDsize() {
    if [[ $HEIGHT -eq 1920 ]] && [[ $WIDTH -eq 1080 ]]
    then
        echo "HD size is correct for $(basename "$entry")"
    else
        echo "HD size is not correct for file $(basename "$entry")"
    fi
}