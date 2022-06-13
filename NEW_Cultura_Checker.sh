#!/bin/bash

function askForFolder {
    echo "Veuillez glisser-déposer le dossier à valider et appuyer sur entrer"
    # read -r FOLDER
    FOLDER=/Users/muttedit/Desktop/CULTURA
    checkForFolder
}

#Checking that the file is a folder
function checkForFolder {
    if [ -d "$FOLDER" ]
    then
        echo "Merci pour le dossier"
    else
        echo "Oupsi doupsi, tu n'as pas compris ? J'ai demandé un dossier. Tu peux recommencer ?"
        askForFolder
    fi
}

#Checking if the folder contains the required folders
function checkForRequiredFolders {
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
    if [ $TUTO == true ] && [ $AMBIANCE == true ] ; then
        echo "les dossiers requis sont bien présents"
        echo "Appuyer sur entrer pour continuer"
        read -r
    elif [ $TUTO == false ] && [ $AMBIANCE == true ] ; then 
        echo "Le dossier 'PHOTOS TUTO' est introuvable"
        echo "Appuyer sur entrer pour quitter"
        read -r 
        exit
    elif [ $TUTO == true ] && [ $AMBIANCE == false ] ; then
        echo "Le dossier 'PHOTOS AMBIANCE' est introuvable"
        echo "Appuyer sur entrer pour quitter"
        read -r 
        exit
    else
        echo "Les dossiers requis sont absent"
        echo "Appuyer sur entrer pour quitter"
        read -r
        exit
    fi  
}

function verifyAmbianceFolder {
    echo "Vérification de la présence des dossiers HD et WEB"
    if [ -d "$PWD/HD" ] ; then
        echo "Le dossier HD est présent"
    else
        echo "Le dossier HD est absent"
        echo "Appuyer sur entrer pour quitter"
        read -r
        exit
    fi
    if [ -d "$PWD/WEB" ] ; then
        echo "Le dossier WEB est présent"
    else
        echo "Le dossier WEB est absent"
        echo "Appuyer sur entrer pour quitter"
        read -r
        exit
    fi
}

function verifyAmbianceHDFolderContent {
    currentFolder=$PWD
    echo "Dossier ouvert : $currentFolder"
    for entry in "$currentFolder"/*
    do
        if [[ $entry == *.jpg ]] || [[ $entry == *.png ]] || [[ $entry == *.jpeg ]] || [[ $entry == *.tiff ]]  ; then
            echo "Vérification de $(basename "$entry") en cours"
            name=$(basename "$entry")
            name=$(echo "$name" | rev | cut -d '-' -f1 | rev)
            name=$(echo "$name" | cut -d '.' -f1)
            else
            echo "ERREUR ! Le fichier "$(basename "$entry")" n'est pas une image"
            echo "Appuyer sur ENTRER pour continuer"
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
    if [ $VALIDLANDSCAPE == true ] && [ $VALIDPORTRAIT == true ] && [ $VALIDSQUARE == true ] ; then
        echo "Le dossier Ambiance/HD est valide"
        echo "Appuyer sur ENTRER pour continuer"
    else
        echo "Le dossier Ambiance/HD n'est pas valide"
        echo "Appuyer sur ENTRER pour continuer"
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
        echo "L'image $(basename "$entry") est valide"
        VALIDSQUARE=true
    else
        echo "ERREUR ! L'image $(basename "$entry") n'est pas valide"
        echo "Dimension de l'image : "$WIDTH"x"$HEIGHT""
        echo "Requis : 3096x3096"
        echo "Appuyer sur ENTRER pour continuer"
        read -r
    fi

}

function verifyLandscapeDimensions {
    if [[ "$HEIGHT" -eq "3629" ]] && [[ "$WIDTH" -eq "5443" ]] ; then
        echo "L'image $(basename "$entry") est valide"
        VALIDLANDSCAPE=true
    else
        echo "ERREUR ! L'image $(basename "$entry") n'est pas valide"
        echo "Dimension de l'image : "$WIDTH"x"$HEIGHT""
        echo "Requis : 5443x3629"
        echo "Appuyer sur ENTRER pour continuer"
        read -r
    fi
}

function verifyPortraitDimensions {
    if [[ "$HEIGHT" -eq "5568" ]] && [[ "$WIDTH" -eq "3712" ]] ; then
        echo "L'image $(basename "$entry") est valide"
        VALIDPORTRAIT=true

    else
        echo "ERREUR ! L'image $(basename "$entry") n'est pas valide"
        echo "Dimension de l'image : "$WIDTH"x"$HEIGHT""
        echo "Requis : 3712x5568"
        echo "Appuyer sur ENTRER pour continuer"
        read -r
    fi    
}

function verifyAmbianceWEBFolderContent {
    currentFolder=$PWD
    echo "Dossier ouvert : $currentFolder"
    for entry in "$currentFolder"/*
    do
        if [[ $entry == *.jpg ]] || [[ $entry == *.png ]] || [[ $entry == *.jpeg ]] || [[ $entry == *.tiff ]]  ; then
            echo "Vérification de $(basename "$entry") en cours"
            name=$(basename "$entry")
            name=$(echo "$name" | rev | cut -d '-' -f1 | rev)
            name=$(echo "$name" | cut -d '.' -f1)
            else
            echo "ERREUR ! Le fichier "$(basename "$entry")" n'est pas une image"
            echo "Appuyer sur ENTRER pour continuer"
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
    if [ $VALIDSQUARE1080 == true ] && [ $VALIDHEADER == true ] && [ $VALIDLANDSCAPE1080 == true ] && [ $VALIDPORTRAIT720 == true ] && [ $VALIDSQUARE1080 == true ] ; then
        echo "Le dossier Ambiance/WEB est valide"
        echo "Appuyer sur ENTRER pour continuer"
    else
        echo "Le dossier Ambiance/WEB n'est pas valide"
        echo "Appuyer sur ENTRER pour continuer"
        read -r
        INVALIDFOLDER=$((INVALIDFOLDER + 1))
    fi

}

function verifySquare1080Dimensions {
    if  [[ "$WIDTH" -eq "1080" ]] && [[ "$HEIGHT" -eq "1080" ]] ; then
        echo "L'image $(basename "$entry") est valide"
        VALIDSQUARE1080=true
    else
        echo "ERREUR ! L'image $(basename "$entry") n'est pas valide"
        echo "Dimension de l'image : "$WIDTH"x"$HEIGHT""
        echo "Requis : 1080x1080"
        echo "Appuyer sur ENTRER pour continuer"
        read -r
    fi
}

function verifyHeaderDimensions {
    if  [[ "$WIDTH" -eq "2000" ]] &&[[ "$HEIGHT" -eq "500" ]] ; then
        echo "L'image $(basename "$entry") est valide"
        VALIDHEADER=true
    else
        echo "ERREUR ! L'image $(basename "$entry") n'est pas valide"
        echo "Dimension de l'image : "$WIDTH"x"$HEIGHT""
        echo "Requis : 2000x500"
        echo "Appuyer sur ENTRER pour continuer"
        read -r
        WRONGDIMENSIONS=$((WRONGDIMENSIONS + 1))
    fi
}

function verifyLandscape1080Dimensions {
    if  [[ "$WIDTH" -eq "1080" ]] && [[ "$HEIGHT" -eq "720" ]] ; then
        echo "L'image $(basename "$entry") est valide"
        VALIDLANDSCAPE1080=true
    else
        echo "ERREUR ! L'image $(basename "$entry") n'est pas valide"
        echo "Dimension de l'image : "$WIDTH"x"$HEIGHT""
        echo "Requis : 1080x720"
        echo "Appuyer sur ENTRER pour continuer"
        read -r
    fi
}

function verifyPortrait720Dimensions {
    if  [[ "$WIDTH" -eq "720" ]] && [[ "$HEIGHT" -eq "1080" ]] ; then
        echo "L'image $(basename "$entry") est valide"
        VALIDPORTRAIT720=true
    else
        echo "ERREUR ! L'image $(basename "$entry") n'est pas valide"
        echo "Dimension de l'image : "$WIDTH"x"$HEIGHT""
        echo "Requis : 720x1080"
        echo "Appuyer sur ENTRER pour continuer"
        read -r
    fi
}

function verifyVignetteDimensions {
    if  [[ "$WIDTH" -eq "1027" ]]&& [[ "$HEIGHT" -eq "578" ]] ; then
        echo "L'image $(basename "$entry") est valide"
        VALIDVIGNETTE=true
    else
        echo "ERREUR ! L'image $(basename "$entry") n'est pas valide"
        echo "Dimension de l'image : "$WIDTH"x"$HEIGHT""
        echo "Requis : 578x1027"
        echo "Appuyer sur ENTRER pour continuer"
        read -r
    fi
}

function verifyInstagramDimensions {
    if  [[ "$WIDTH" -eq "1080" ]] && [[ "$HEIGHT" -eq "1350" ]] ; then
        echo "L'image $(basename "$entry") est valide"
        VALIDINSTAGRAM=true
    else
        echo "ERREUR ! L'image $(basename "$entry") n'est pas valide"
        echo "Dimension de l'image : "$WIDTH"x"$HEIGHT""
        echo "Requis : 1080x1350"
        echo "Appuyer sur ENTRER pour continuer"
        read -r
        WRONGDIMENSIONS=$((WRONGDIMENSIONS + 1))
    fi
}

function verifyTutoDimensions {
    if  [[ "$WIDTH" -eq "750" ]] && [[ "$HEIGHT" -eq "413" ]] ; then
        echo "L'image $(basename "$entry") est valide"
        VALIDTUTO=true
    else
        echo "ERREUR ! L'image $(basename "$entry") n'est pas valide"
        echo "Dimension de l'image : "$WIDTH"x"$HEIGHT""
        echo "Requis : 750x413"
        echo "Appuyer sur ENTRER pour continuer"
        read -r
    fi
}

function verifyTutoFolder {
    echo "Vérification de la présence des dossiers CULTURA.COM, HD ET INSTAGRAM"
    if [ -d "$PWD/HD" ] ; then
        echo "Le dossier HD est présent"
    else
        echo "Le dossier HD est absent"
        echo "Appuyer sur entrer pour quitter"
        read -r
        exit
    fi
    if [ -d "$PWD/INSTAGRAM" ] ; then
        echo "Le dossier INSTAGRAM est présent"
    else
        echo "Le dossier INSTAGRAM est absent"
        echo "Appuyer sur entrer pour quitter"
        read -r
        exit
    fi
        if [ -d "$PWD/CULTURA.COM" ] ; then
        echo "Le dossier CULTURA.COM est présent"
    else
        echo "Le dossier CULTURA.COM est absent"
        echo "Appuyer sur entrer pour quitter"
        read -r
        exit
    fi
}

function verifyTutoCulturaFolderContent {
    currentFolder=$PWD
    echo "Dossier ouvert : $currentFolder"
    WRONGDIMENSIONS=0
    for entry in "$currentFolder"/*
    do
        if [[ $entry == *.jpg ]] || [[ $entry == *.png ]] || [[ $entry == *.jpeg ]] || [[ $entry == *.tiff ]]  ; then
            echo "Vérification de $(basename "$entry") en cours"
            name=$(basename "$entry")
            name=$(echo "$name" | rev | cut -d '-' -f1 | rev)
            name=$(echo "$name" | cut -d '.' -f1)
            else
            echo "ERREUR ! Le fichier "$(basename "$entry")" n'est pas une image"
            echo "Appuyer sur ENTRER pour continuer"
            read -r
        fi
        HEIGHT=0
        WIDTH=0
        
        if [ $name == "header" ] ; then
            getImageDimensions
            verifyHeaderDimensions
       else 
            getImageDimensions
            verifyCultura.comDimensions
        fi
    done
    if [ $WRONGDIMENSIONS -eq 0 ] ; then
        echo "Le dossier CULTURA.COM est valide"
        echo "Appuyer sur ENTRER pour continuer"
    else
        echo "Le dossier CULTURA.COM n'est pas valide"
        echo "Il y a $WRONGDIMENSIONS images invalides"
        echo "Appuyer sur ENTRER pour continuer"
        read -r
        INVALIDFOLDER=$((INVALIDFOLDER + 1))
    fi

}

function verifyCultura.comDimensions {
    if  [[ "$WIDTH" -eq "750" ]] && [[ "$HEIGHT" -eq "413" ]] ; then
        echo "L'image $(basename "$entry") est valide"
    else
        echo "ERREUR ! L'image $(basename "$entry") n'est pas valide"
        echo "Dimension de l'image : "$WIDTH"x"$HEIGHT""
        echo "Requis : 750x413"
        echo "Appuyer sur ENTRER pour continuer"
        read -r
        WRONGDIMENSIONS=$((WRONGDIMENSIONS + 1))
    fi
}

function verifyTutoHDFolderContent {
    currentFolder=$PWD
    echo "Dossier ouvert : $currentFolder"
    WRONGDIMENSIONS=0
    for entry in "$currentFolder"/*
    do
        if [[ $entry == *.jpg ]] || [[ $entry == *.png ]] || [[ $entry == *.jpeg ]] || [[ $entry == *.tiff ]]  ; then
            echo "Vérification de $(basename "$entry") en cours"
            name=$(basename "$entry")
            name=$(echo "$name" | rev | cut -d '-' -f1 | rev)
            name=$(echo "$name" | cut -d '.' -f1)
            else
            echo "ERREUR ! Le fichier "$(basename "$entry")" n'est pas une image"
            echo "Appuyer sur ENTRER pour continuer"
            read -r
        fi
        HEIGHT=0
        WIDTH=0
        
        getImageDimensions
        verifyHDDimensions
    done
    if [ $WRONGDIMENSIONS -eq 0 ] ; then
        echo "Le dossier HD est valide"
        echo "Appuyer sur ENTRER pour continuer"
    else
        echo "Le dossier HD n'est pas valide"
        echo "Il y a $WRONGDIMENSIONS images invalides"
        echo "Appuyer sur ENTRER pour continuer"
        read -r
        INVALIDFOLDER=$((INVALIDFOLDER + 1))

    fi
}

function verifyHDDimensions {
    if  [[ "$WIDTH" -eq "5723" ]] && [[ "$HEIGHT" -eq "3167" ]] ; then
        echo "L'image $(basename "$entry") est valide"
    else
        echo "ERREUR ! L'image $(basename "$entry") n'est pas valide"
        echo "Dimension de l'image : "$WIDTH"x"$HEIGHT""
        echo "Requis : 5723x3167"
        echo "Appuyer sur ENTRER pour continuer"
        read -r
        WRONGDIMENSIONS=$((WRONGDIMENSIONS + 1))
    fi
}

function verifyTutoHDFolderContent {
    currentFolder=$PWD
    echo "Dossier ouvert : $currentFolder"
    WRONGDIMENSIONS=0
    for entry in "$currentFolder"/*
    do
        if [[ $entry == *.jpg ]] || [[ $entry == *.png ]] || [[ $entry == *.jpeg ]] || [[ $entry == *.tiff ]]  ; then
            echo "Vérification de $(basename "$entry") en cours"
            name=$(basename "$entry")
            name=$(echo "$name" | rev | cut -d '-' -f1 | rev)
            name=$(echo "$name" | cut -d '.' -f1)
            else
            echo "ERREUR ! Le fichier "$(basename "$entry")" n'est pas une image"
            echo "Appuyer sur ENTRER pour continuer"
            read -r
        fi
        HEIGHT=0
        WIDTH=0
        
        getImageDimensions
        verifyHDDimensions
    done
    if [ $WRONGDIMENSIONS -eq 0 ] ; then
        echo "Le dossier HD est valide"
        echo "Appuyer sur ENTRER pour continuer"
    else
        echo "Le dossier HD n'est pas valide"
        echo "Il y a $WRONGDIMENSIONS images invalides"
        echo "Appuyer sur ENTRER pour continuer"
        read -r
        INVALIDFOLDER=$((INVALIDFOLDER + 1))
    fi
}

function verifyTutoInstagramFolderContent {
    currentFolder=$PWD
    echo "Dossier ouvert : $currentFolder"
    WRONGDIMENSIONS=0
    for entry in "$currentFolder"/*
    do
        if [[ $entry == *.jpg ]] || [[ $entry == *.png ]] || [[ $entry == *.jpeg ]] || [[ $entry == *.tiff ]]  ; then
            echo "Vérification de $(basename "$entry") en cours"
            name=$(basename "$entry")
            name=$(echo "$name" | rev | cut -d '-' -f1 | rev)
            name=$(echo "$name" | cut -d '.' -f1)
            else
            echo "ERREUR ! Le fichier "$(basename "$entry")" n'est pas une image"
            echo "Appuyer sur ENTRER pour continuer"
            read -r
        fi
        HEIGHT=0
        WIDTH=0
        
        getImageDimensions
        verifyInstagramDimensions
    done
    if [ $WRONGDIMENSIONS -eq 0 ] ; then
        echo "Le dossier INSTAGRAM est valide"
        echo "Appuyer sur ENTRER pour continuer"
    else
        echo "Le dossier INSTAGRAM n'est pas valide"
        echo "Il y a $WRONGDIMENSIONS images invalides"
        echo "Appuyer sur ENTRER pour continuer"
        read -r
        INVALIDFOLDER=$((INVALIDFOLDER + 1))
    fi
}

function main {
    clear  ;
    askForFolder ;
    INVALIDFOLDER=0
    checkForRequiredFolders ;
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
        echo "Toutes les dossiers sont valides"
    else
        echo "Il y a $INVALIDFOLDER dossiers invalides"
    fi
    echo "Appuyer sur ENTRER pour quitter"
    read -r
    clear
}

main ;