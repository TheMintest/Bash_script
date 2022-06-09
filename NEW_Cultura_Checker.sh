#!/bin/bash


function askForFolder {
    echo "Veuillez glisser-déposer le dossier à valider et appuyer sur entrer"
    read FOLDER
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
        echo "les dossiers sont bien présents"
        echo "Appuyer sur entrer pour continuer"
        read
    elif [ $TUTO == false ] && [ $AMBIANCE == true ] ; then 
        echo "Le dossier 'PHOTOS TUTO' est introuvable"
        echo "Appuyer sur entrer pour quitter"
        read
        exit
    elif [ $TUTO == true ] && [ $AMBIANCE == false ] ; then
        echo "Le dossier 'PHOTOS AMBIANCE' est introuvable"
        echo "Appuyer sur entrer pour quitter"
        read
        exit
    else
        echo "Les dossiers requis sont absent"
        echo "Appuyer sur entrer pour quitter"
        read
        exit
    fi  
}

function verifyAmbianceFolder {
    echo "Vérification de la présence des dossiers HD et WEB"
    echo $PWD
    if [ -d "$PWD/HD" ] ; then
        echo "Le dossier HD est présent"
    else
        echo "Le dossier HD est absent"
        echo "Appuyer sur entrer pour quitter"
        read
        exit
    fi
    if [ -d "$PWD/WEB" ] ; then
        echo "Le dossier WEB est présent"
    else
        echo "Le dossier WEB est absent"
        echo "Appuyer sur entrer pour quitter"
        read
        exit
    fi
}

function verifyAmbianceFolderContent {
    for entry in $PWD
    
}




askForFolder
checkForRequiredFolders
cd "$FOLDER/PHOTOS AMBIANCE"
verifyAmbianceFolder
cd "$FOLDER/PHOTOS AMBIANCE/HD"
verifyAmbianceFolderContent
# cd "$FOLDER/PHOTOS TUTO"
# verifyTutoFolder













# # echo $AMBIANCE
# # echo $TUTO