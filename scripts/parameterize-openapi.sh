#!/bin/bash
#
# parameterize-openapi.sh
# Author: Brian Jopling, 2020
#
# Takes an OpenAPI specification (API mapping) of an API GW
#   that was exported from the console, and parameterizes the 
#   hardcoded values.
#
# Usage:
#   $ ./parameterize-openapi.sh api-openapi.yaml 1234567890
#
# Post-conditions:
#   Updates the existing OpenAPI file with parameters.
#   Also generates a backup of the original file contents.
#

FILE=$1
ACCOUNT_ID=$2
BKUPFILE=bkup.api-openapi.yaml

usage(){
  echo "Sample usage:"
  echo "  $ ./parameterize-openapi.sh api-openapi.yaml 1234567890"
}

if [ ! -f $FILE ]
  then
    echo "[!] File not found!"
    usage
    exit 1
fi

if [ -z $ACCOUNT_ID ]
  then
    echo "[!] Missing account ID as argument!"
    usage
    exit 1
fi

cp $FILE $BKUPFILE
gsed -i '6,7d' $FILE
gsed -i s/us-east-1/'${AWS::Region}'/g $FILE
gsed -i s/$ACCOUNT_ID/'${AWS::AccountId}'/g $FILE
gsed -i s/'^\(\s\+\)uri:'/'\1uri:\n\1  Fn::Sub:'/g $FILE
gsed -i s,'^\(\s\+\)passthroughBehavior','\1credentials:\n\1  Fn::Sub: "arn:aws:iam::${AWS::AccountId}:role/${RoleApiGwInvokeLambda}"\n\1passthroughBehavior',g $FILE
