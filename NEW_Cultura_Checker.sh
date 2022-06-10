#!/bin/bash

function askForFolder {
    echo "Veuillez glisser-déposer le dossier à valider et appuyer sur entrer"
    read -r FOLDER
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

#Checking if the folder contains th required folders
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
    echo "$PWD"
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

function verifyAmbianceFolderContent {
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
        echo $name
        read -r
        HEIGHT=0
        WIDTH=0
        case $name in
            carre)
                getImageDimensions
                echo "Largeur : $WIDTH"
                echo "Hauteur : $HEIGHT"
                read -r
                verifySquareDimensions
                ;;
            paysage)
                verifyLandscapeDimensions
                ;;
            portrait)
                verifyPortraitDimensions
        esac
    done
}

getImageDimensions() {
    HEIGHTFULL=$(sips -g pixelHeight "$entry")
    HEIGHT=$(echo $HEIGHTFULL | cut -d ':' -f2) 
    WIDTHFULL=$(sips -g pixelWidth "$entry")
    WIDTH=$(echo $WIDTHFULL | cut -d ':' -f2)
}

verifySquareDimensions() {
    echo "Vérification que l'image est un carré"
    if [[ "$HEIGHT" == "3096" ]] && [[ "$WIDTH" == "3096" ]] ; then
        echo "L'image $(basename "$entry") est valide"
    else
        echo "ERREUR ! L'image $(basename "$entry") n'est pas valide"
        echo "Appuyer sur ENTRER pour continuer"
        read -r
    fi

}

verifyLandscapeDimensions() {
    echo "Vérification que l'image est un paysage"    
}

verifyPortraitDimensions() {
    echo "Vérification que l'image est un portrait"    
}


clear  ;
askForFolder ;
checkForRequiredFolders ;
cd "$FOLDER/PHOTOS AMBIANCE" ;
verifyAmbianceFolder ;
cd "$FOLDER/PHOTOS AMBIANCE/HD" ;
verifyAmbianceFolderContent ;



# cd "$FOLDER/PHOTOS TUTO"
# verifyTutoFolder
