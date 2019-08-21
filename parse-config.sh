#!/bin/bash
cd /app
envFile="";
while read -r varName
do
    varValue=`jq -r .$varName ./config.json`
    # echo "varName = $varName"
    envFile="${envFile}export $varName=\"$varValue\"\n"
done < <(jq -r 'keys[]' ./config.json)

printf "$envFile" > config.env