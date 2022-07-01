#!/bin/bash


#echo a centerd text
function print_centered {
     [[ $# = 0 ]] && return 1

     declare -i TERM_COLS="$(tput cols)"
     declare -i str_len="${#1}"
     [[ $str_len -ge $TERM_COLS ]] && {
          echo "$1";
          return 0;
     }

     declare -i filler_len="$(( (TERM_COLS - str_len) / 2 ))"
     [[ $# -ge 2 ]] && ch="${2:0:1}" || ch=" "
     filler=""
     for (( i = 0; i < filler_len; i++ )); do
          filler="${filler}${ch}"
     done

     printf "%s%s%s" "$filler" "$1" "$filler"
     [[ $(( (TERM_COLS - str_len) % 2 )) -ne 0 ]] && printf "%s" "${ch}"
     printf "\n"

     return 0
}

#echo a green text
function echoGreen {
    echo -e "\033[32m$1\033[0m"
}
function echoRed {
    echo -e "\033[31m"$1"\033[0m"
}

function echolightbluebackground {
    echo -e "\033[104m$1\033[0m"
}

function askForFolder {
    echolightbluebackground "Veuillez glisser-déposer le dossier à valider et appuyer sur entrer"
    read -r FOLDER
    FOLDERCLEAN="${FOLDER}"
    echo $FOLDERCLEAN
    # FOLDER=/Users/muttedit/Desktop/CULTURA
    checkForFolder
}



#Checking that the file is a folder
function checkForFolder {
    if [ -d "$FOLDER" ]
    then
       checkForRequiredFolders
    else
        echoRed "Impossible de détecter un dossier. Essayez de verifiez qu'il n'y a pas d'espaces dans le nom du dossier"
        echo $FOLDER
        askForFolder
    fi
}

#Checking if the folder contains the required folders
function checkForRequiredFolders {
    echo " "
    if [ -d "$FOLDER/PHOTOS AMBIANCE" ] ; then
        AMBIANCE=true
    else
        AMBIANCE=false
    fi

    if [ -d "$FOLDER/PHOTOS TUTO" ] ; then
        TUTO=true
    else
        TUTO=false
    fi
    if [ $TUTO = true ] && [ $AMBIANCE = true ] ; then
        VALID=$(echoGreen "Les dossiers requis sont bien présents")
        print_centered "$VALID"
        echo " "
        echolightbluebackground "Appuyer sur ENTRER pour continuer"
        read -r
    elif [ $TUTO = false ] && [ $AMBIANCE = true ] ; then 
        echoRed "Le dossier 'PHOTOS TUTO' est introuvable"
        echolightbluebackground "Appuyer sur ENTRER pour quitter"
        read -r 
        exit
    elif [ $TUTO = true ] && [ $AMBIANCE = false ] ; then
        echoRed "Le dossier 'PHOTOS AMBIANCE' est introuvable"
        echolightbluebackground "Appuyer sur ENTRER pour quitter"
        read -r 
        exit
    else
        echoRed "Les dossiers requis sont absent"
        echolightbluebackground "Appuyer sur ENTRER pour quitter"
        read -r
        exit
    fi  
}

function verifyAmbianceFolder {
    echo "Vérification de la présence des dossiers HD et WEB"
    echo " "
    if [ -d "$PWD/HD" ] ; then
        HD=$(echoGreen "Le dossier HD est présent")
        print_centered "$HD"
    else
        echoRed "Le dossier HD est absent"
        echolightbluebackground "Appuyer sur ENTRER pour quitter"
        read -r
        exit
    fi
    if [ -d "$PWD/WEB" ] ; then
        WEB=$(echoGreen "Le dossier WEB est présent")
        print_centered "$WEB"
        echo " "
    else
        echoRed "Le dossier WEB est absent"
        echolightbluebackground "Appuyer sur ENTRER pour quitter"
        read -r
        exit
    fi
}

function verifyAmbianceHDFolderContent {
    currentFolder=$PWD
    for entry in "$currentFolder"/*
    do
        if [[ $entry = *.jpg ]] || [[ $entry = *.png ]] || [[ $entry = *.jpeg ]] || [[ $entry = *.tiff ]]  ; then
            name=$(basename "$entry")
            name=$(echo "$name" | rev | cut -d '-' -f1 | rev)
            name=$(echo "$name" | cut -d '.' -f1)
            else
            echoRed "ERREUR ! Le fichier "$(basename "$entry")" n'est pas une image"
            read -r
        fi
        HEIGHT=0
        WIDTH=0
        case $name in
            carre)
                getImageDimensions
                verifySquareDimensions
                ;;
            paysage)
                getImageDimensions
                verifyLandscapeDimensions
                ;;
            portrait)
                getImageDimensions
                verifyPortraitDimensions
                ;;
        esac
    done
    if [ $VALIDLANDSCAPE = true ] && [ $VALIDPORTRAIT = true ] && [ $VALIDSQUARE = true ] ; then
        echo " "
        AHD=$(echoGreen "Le dossier Ambiance/HD est valide")
        print_centered "$AHD"
        echo " "
        echolightbluebackground "Appuyer sur ENTRER pour continuer"
        read -r
    else
        AHD=$(echoRed "Le dossier Ambiance/HD n'est pas valide")
        print_centered "$AHD"
        echo " "
        echolightbluebackground "Appuyer sur ENTRER pour continuer"
        read -r
        INVALIDFOLDER=$((INVALIDFOLDER + 1))
    fi
}

function getImageDimensions {
    HEIGHTFULL=$(sips -g pixelHeight "$entry")
    HEIGHT=$(echo $HEIGHTFULL | cut -d ':' -f2) 
    WIDTHFULL=$(sips -g pixelWidth "$entry")
    WIDTH=$(echo $WIDTHFULL | cut -d ':' -f2)
}

function verifySquareDimensions {
    if  [[ "$WIDTH" -eq "3096" ]] && [[ "$HEIGHT" -eq "3096" ]]; then
        echoGreen "L'image $(basename "$entry") est valide"
        VALIDSQUARE=true
    else
        echoRed "ERREUR ! L'image $(basename "$entry") n'est pas valide"
        CURRENTDIMENSION="$WIDTH"x"$HEIGHT"
        echoRed "Dimension de l'image : $CURRENTDIMENSION"
        echoRed "Requis : 3096x3096"
        echolightbluebackground "Appuyer sur ENTRER pour continuer"
        read -r
    fi

}

function verifyLandscapeDimensions {
    if [[ "$HEIGHT" -eq "3629" ]] && [[ "$WIDTH" -eq "5443" ]] ; then
        echoGreen "L'image $(basename "$entry") est valide"     
        VALIDLANDSCAPE=true
    else
        echoRed "ERREUR ! L'image $(basename "$entry") n'est pas valide"
        CURRENTDIMENSION="$WIDTH"x"$HEIGHT"
        echoRed "Dimension de l'image : $CURRENTDIMENSION"        
        echoRed "Requis : 5443x3629"
        echolightbluebackground "Appuyer sur ENTRER pour continuer"
        read -r
    fi
}

function verifyPortraitDimensions {
    if [[ "$HEIGHT" -eq "5568" ]] && [[ "$WIDTH" -eq "3712" ]] ; then
        echoGreen "L'image $(basename "$entry") est valide"
        VALIDPORTRAIT=true

    else
        echoRed "ERREUR ! L'image $(basename "$entry") n'est pas valide"
        CURRENTDIMENSION="$WIDTH"x"$HEIGHT"
        echoRed "Dimension de l'image : $CURRENTDIMENSION"       
        echoRed "Requis : 3712x5568"
        echolightbluebackground "Appuyer sur ENTRER pour continuer"
        read -r
    fi    
}

function verifyAmbianceWEBFolderContent {
    currentFolder=$PWD
    for entry in "$currentFolder"/*
    do
        if [[ $entry = *.jpg ]] || [[ $entry = *.png ]] || [[ $entry = *.jpeg ]] || [[ $entry = *.tiff ]]  ; then
            name=$(basename "$entry")
            name=$(echo "$name" | rev | cut -d '-' -f1 | rev)
            name=$(echo "$name" | cut -d '.' -f1)
            else
            echoRed "ERREUR ! Le fichier "$(basename "$entry")" n'est pas une image"
            echolightbluebackground "Appuyer sur ENTRER pour continuer"
            read -r
        fi
        HEIGHT=0
        WIDTH=0
        case $name in
            carre)
                getImageDimensions
                verifySquare1080Dimensions
                ;;
            header)
                getImageDimensions
                verifyHeaderDimensions
                ;;
            paysage)
                getImageDimensions
                verifyLandscape1080Dimensions
                ;;
            portrait)
                getImageDimensions
                verifyPortrait720Dimensions
                ;;
            vignette)
                getImageDimensions
                verifyVignetteDimensions
                ;;
            instagram)
                getImageDimensions
                verifyInstagramDimensions
                ;;
            tuto)
                getImageDimensions
                verifyTutoDimensions
                ;;
        esac
    done
    if [ "$VALIDSQUARE1080" = true ] && [ "$VALIDHEADER" = true ] && [ "$VALIDLANDSCAPE1080" = true ] && [ "$VALIDPORTRAIT720" = true ] && [ "$VALIDSQUARE1080" = true ] ; then
        echo " "
        AWEB=$(echoGreen "Le dossier Ambiance/WEB est valide")
        print_centered "$AWEB"
        echo " "
        echolightbluebackground "Appuyer sur ENTRER pour continuer"
        read -r
    else
        echo " "
        AWEB=$(echoRed "Le dossier Ambiance/WEB n'est pas valide")
        print_centered "$AWEB"
        echo " "
        echolightbluebackground "Appuyer sur ENTRER pour continuer"
        read -r
        INVALIDFOLDER=$((INVALIDFOLDER + 1))
    fi

}

function verifySquare1080Dimensions {
    if  [[ "$WIDTH" -eq "1080" ]] && [[ "$HEIGHT" -eq "1080" ]] ; then
        echoGreen "L'image $(basename "$entry") est valide"
        VALIDSQUARE1080=true
    else
        echoRed "ERREUR ! L'image $(basename "$entry") n'est pas valide"
        CURRENTDIMENSION="$WIDTH"x"$HEIGHT"
        echoRed "Dimension de l'image : $CURRENTDIMENSION"       
        echoRed "Requis : 1080x1080"
        echolightbluebackground "Appuyer sur ENTRER pour continuer"
        read -r
    fi
}

function verifyHeaderDimensions {
    if  [[ "$WIDTH" -eq "2000" ]] &&[[ "$HEIGHT" -eq "500" ]] ; then
        echoGreen "L'image $(basename "$entry") est valide"
        VALIDHEADER=true
    else
        echoRed "ERREUR ! L'image $(basename "$entry") n'est pas valide"
        CURRENTDIMENSION="$WIDTH"x"$HEIGHT"
        echoRed "Dimension de l'image : $CURRENTDIMENSION"
        echoRed "Requis : 2000x500"
        echolightbluebackground "Appuyer sur ENTRER pour continuer"
        read -r
        WRONGDIMENSIONS=$((WRONGDIMENSIONS + 1))
    fi
}

function verifyLandscape1080Dimensions {
    if  [[ "$WIDTH" -eq "1080" ]] && [[ "$HEIGHT" -eq "720" ]] ; then
        echoGreen "L'image $(basename "$entry") est valide"
        VALIDLANDSCAPE1080=true
    else
        echoRed "ERREUR ! L'image $(basename "$entry") n'est pas valide"
        CURRENTDIMENSION="$WIDTH"x"$HEIGHT"
        echoRed "Dimension de l'image : $CURRENTDIMENSION"      
        echoRed "Requis : 1080x720"
        echolightbluebackground "Appuyer sur ENTRER pour continuer"
        read -r
    fi
}

function verifyPortrait720Dimensions {
    if  [[ "$WIDTH" -eq "720" ]] && [[ "$HEIGHT" -eq "1080" ]] ; then
        echoGreen "L'image $(basename "$entry") est valide"
        VALIDPORTRAIT720=true
    else
        echoRed "ERREUR ! L'image $(basename "$entry") n'est pas valide"
        CURRENTDIMENSION="$WIDTH"x"$HEIGHT"
        echoRed "Dimension de l'image : $CURRENTDIMENSION"
        echoRed "Requis : 720x1080"
        echolightbluebackground "Appuyer sur ENTRER pour continuer"
        read -r
    fi
}

function verifyVignetteDimensions {
    if  [[ "$WIDTH" -eq "1027" ]]&& [[ "$HEIGHT" -eq "578" ]] ; then
        echoGreen "L'image $(basename "$entry") est valide"
        VALIDVIGNETTE=true
    else
        echoRed "ERREUR ! L'image $(basename "$entry") n'est pas valide"
        CURRENTDIMENSION="$WIDTH"x"$HEIGHT"
        echoRed "Dimension de l'image : $CURRENTDIMENSION"        
        echoRed "Requis : 1027x578"
        echolightbluebackground "Appuyer sur ENTRER pour continuer"
        read -r
    fi
}

function verifyInstagramDimensions {
    if  [[ "$WIDTH" -eq "1080" ]] && [[ "$HEIGHT" -eq "1350" ]] ; then
        echoGreen "L'image $(basename "$entry") est valide"
        VALIDINSTAGRAM=true
    else
        echoRed "ERREUR ! L'image $(basename "$entry") n'est pas valide"
        CURRENTDIMENSION="$WIDTH"x"$HEIGHT"
        echoRed "Dimension de l'image : $CURRENTDIMENSION"
        echoRed "Requis : 1080x1350"
        echolightbluebackground "Appuyer sur ENTRER pour continuer"
        read -r
        WRONGDIMENSIONS=$((WRONGDIMENSIONS + 1))
    fi
}

function verifyTutoDimensions {
    if  [[ "$WIDTH" -eq "750" ]] && [[ "$HEIGHT" -eq "413" ]] ; then
        echoGreen "L'image $(basename "$entry") est valide"
        VALIDTUTO=true
    else
        echoRed "ERREUR ! L'image $(basename "$entry") n'est pas valide"
        CURRENTDIMENSION="$WIDTH"x"$HEIGHT"
        echoRed "Dimension de l'image : $CURRENTDIMENSION"
        echoRed "Requis : 750x413"
        echolightbluebackground "Appuyer sur ENTRER pour continuer"
        read -r
    fi
}

function verifyTutoFolder {
    echo "Vérification de la présence des dossiers CULTURA.COM, HD ET INSTAGRAM"
    echo " "
    if [ -d "$PWD/HD" ] ; then
        HD=$(echoGreen "Le dossier HD est présent")
        print_centered "$HD"
    else
        HD=$(echoRed "Le dossier HD est absent")
        print_centered "$HD"
        echolightbluebackground "Appuyer sur entrer pour quitter"
        read -r
        exit
    fi
    if [ -d "$PWD/INSTAGRAM" ] ; then
        INSTA=$(echoGreen "Le dossier INSTAGRAM est présent")
        print_centered "$INSTA"
    else
        INSTA=$(echoRed "Le dossier INSTAGRAM est absent")
        print_centered "$INSTA"
        echolightbluebackground "Appuyer sur entrer pour quitter"
        read -r
        exit
    fi
        if [ -d "$PWD/CULTURA.COM" ] ; then
        CULTU=$(echoGreen "Le dossier CULTURA.COM est présent")
        print_centered "$CULTU"
        echo " "
    else
        CULTU=$(echoRed "Le dossier CULTURA.COM est absent")
        print_centered "$CULTU"
        echolightbluebackground "Appuyer sur entrer pour quitter"
        read -r
        exit
    fi
}

function verifyTutoCulturaFolderContent {
    currentFolder=$PWD
    WRONGDIMENSIONS=0
    for entry in "$currentFolder"/*
    do
        if [[ $entry = *.jpg ]] || [[ $entry = *.png ]] || [[ $entry = *.jpeg ]] || [[ $entry = *.tiff ]]  ; then
            name=$(basename "$entry")
            name=$(echo "$name" | rev | cut -d '-' -f1 | rev)
            name=$(echo "$name" | cut -d '.' -f1)
            else
            echoRed "ERREUR ! Le fichier "$(basename "$entry")" n'est pas une image"
            echo " "
            WRONGDIMENSIONS=$((WRONGDIMENSIONS + 1))
            
            read -r
        fi
        HEIGHT=0
        WIDTH=0
        
        if [ $name = "header" ] ; then
            getImageDimensions
            verifyHeaderDimensions
       else 
            getImageDimensions
            verifyCultura.comDimensions
        fi
    done
    if [ $WRONGDIMENSIONS -eq 0 ] ; then
        echo " "
        CULTUVALID=$(echoGreen "Le dossier CULTURA.COM est valide")
        print_centered "$CULTUVALID"
        echo " "
        echolightbluebackground "Appuyer sur ENTRER pour continuer"
        read -r
    else
        echoRed "Le dossier CULTURA.COM n'est pas valide"
        echoRed "Il y a $WRONGDIMENSIONS images invalides"
        echolightbluebackground "Appuyer sur ENTRER pour continuer"
        read -r
        INVALIDFOLDER=$((INVALIDFOLDER + 1))
    fi

}

function verifyCultura.comDimensions {
    if  [[ "$WIDTH" -eq "750" ]] && [[ "$HEIGHT" -eq "413" ]] ; then
        echoGreen "L'image $(basename "$entry") est valide"
    else
        echoRed "ERREUR ! L'image $(basename "$entry") n'est pas valide"
        CURRENTDIMENSION="$WIDTH"x"$HEIGHT"
        echoRed "Dimension de l'image : $CURRENTDIMENSION"
        echoRed "Requis : 750x413"
        echolightbluebackground "Appuyer sur ENTRER pour continuer"
        read -r
        WRONGDIMENSIONS=$((WRONGDIMENSIONS + 1))
    fi
}

function verifyTutoHDFolderContent {
    currentFolder=$PWD
    WRONGDIMENSIONS=0
    for entry in "$currentFolder"/*
    do
        if [[ $entry = *.jpg ]] || [[ $entry = *.png ]] || [[ $entry = *.jpeg ]] || [[ $entry = *.tiff ]]  ; then
            name=$(basename "$entry")
            name=$(echo "$name" | rev | cut -d '-' -f1 | rev)
            name=$(echo "$name" | cut -d '.' -f1)
            else
            echoRed "ERREUR ! Le fichier "$(basename "$entry")" n'est pas une image"
            echolightbluebackground "Appuyer sur ENTRER pour continuer"
            read -r
        fi
        HEIGHT=0
        WIDTH=0
        
        getImageDimensions
        verifyHDDimensions
    done
    if [ $WRONGDIMENSIONS -eq 0 ] ; then
        echo " "
        HDV=$(echoGreen "Le dossier HD est valide")
        print_centered "$HDV"
        echo " "
        echolightbluebackground "Appuyer sur ENTRER pour continuer"
        read -r
    else
        HDV=$(echoRed "Le dossier HD n'est pas valide")
        print_centered "$HDV"
        echoRed "Il y a $WRONGDIMENSIONS images invalides"
        echolightbluebackground "Appuyer sur ENTRER pour continuer"
        read -r
        INVALIDFOLDER=$((INVALIDFOLDER + 1))

    fi
}

function verifyHDDimensions {
    if  [[ "$WIDTH" -eq "5723" ]] && [[ "$HEIGHT" -eq "3167" ]] ; then
        echoGreen "L'image $(basename "$entry") est valide"
    else
        echoRed "ERREUR ! L'image $(basename "$entry") n'est pas valide"
        CURRENTDIMENSION="$WIDTH"x"$HEIGHT"
        echoRed "Dimension de l'image : $CURRENTDIMENSION"    
        echoRed "Requis : 5723x3167"
        echolightbluebackground "Appuyer sur ENTRER pour continuer"
        read -r
        WRONGDIMENSIONS=$((WRONGDIMENSIONS + 1))
    fi
}



function verifyTutoInstagramFolderContent {
    currentFolder=$PWD
    WRONGDIMENSIONS=0
    for entry in "$currentFolder"/*
    do
        if [[ $entry = *.jpg ]] || [[ $entry = *.png ]] || [[ $entry = *.jpeg ]] || [[ $entry = *.tiff ]]  ; then
            name=$(basename "$entry")
            name=$(echo "$name" | rev | cut -d '-' -f1 | rev)
            name=$(echo "$name" | cut -d '.' -f1)
            else
            echoRed "ERREUR ! Le fichier "$(basename "$entry")" n'est pas une image"
            echolightbluebackground "Appuyer sur ENTRER pour continuer"
            read -r
        fi
        HEIGHT=0
        WIDTH=0
        
        getImageDimensions
        verifyInstagramDimensions
    done
    if [ $WRONGDIMENSIONS -eq 0 ] ; then
        echo " "
        IGV=$(echoGreen "Le dossier INSTAGRAM est valide")
        print_centered "$IGV"
        echo " "
        echolightbluebackground "Appuyer sur ENTRER pour continuer"
        read -r
    else
        echoRed "Le dossier INSTAGRAM n'est pas valide"
        echoRed "Il y a $WRONGDIMENSIONS images invalides"
        echolightbluebackground "Appuyer sur ENTRER pour continuer"
        read -r
        INVALIDFOLDER=$((INVALIDFOLDER + 1))
    fi
}

function main {
    clear  ;
    print_centered "======================"
    print_centered "Mutt's Cultura Tuto Checker V1.0 By Guillaume d'Harcourt" 
    print_centered "======================"
    echo " "
    askForFolder ;
    INVALIDFOLDER=0
    cd "$FOLDER/PHOTOS AMBIANCE" ;
    verifyAmbianceFolder ;
    cd "$FOLDER/PHOTOS AMBIANCE/HD" ;
    verifyAmbianceHDFolderContent ;
    cd "$FOLDER/PHOTOS AMBIANCE/WEB" ;
    verifyAmbianceWEBFolderContent ;
    cd "$FOLDER/PHOTOS TUTO" ;
    verifyTutoFolder ;
    cd "$FOLDER/PHOTOS TUTO/CULTURA.COM" ;
    verifyTutoCulturaFolderContent ;
    cd "$FOLDER/PHOTOS TUTO/HD" ;
    verifyTutoHDFolderContent ;
    cd "$FOLDER/PHOTOS TUTO/INSTAGRAM" ;
    verifyTutoInstagramFolderContent ;
    if [ "$INVALIDFOLDER" -eq 0 ] ; then
        VALID=$(echoGreen "Toutes les dossiers sont valides")
        print_centered "$VALID"
    else
        INVALID=$(echoRed "Il y a $INVALIDFOLDER dossiers invalides")
        print_centered "$INVALID"
    fi
    echo " "
    echolightbluebackground "Appuyer sur ENTRER pour quitter"
    read -r
    clear
}

main ;
