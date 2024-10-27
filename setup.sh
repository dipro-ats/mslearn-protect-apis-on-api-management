#!/bin/bash

apiappname=CensusDataAPI$(openssl rand -hex 5)

printf "Setting username and password for Git ... (1/8)\n\n"


GIT_USERNAME=gitName$Random
GIT_EMAIL=a@b.c

git config --global user.name "$GIT_USERNAME"
git config --global user.email "$GIT_EMAIL"

RESOURCE_GROUP=az-mslearn-apim-$RANDOM
LOCATION=canadacentral

#Create Resource Group
printf "\nCreating Resource Group ... (2/8)\n\n"

az group create --name $RESOURCE_GROUP --location $LOCATION

# Create App Service plan
PLAN_NAME=myPlan


printf "\nCreating App Service plan in FREE tier ... (3/8)\n\n"


az appservice plan create --name $apiappname --resource-group $RESOURCE_GROUP --sku FREE --location $LOCATION --verbose

printf "\nCreating API App ... (4/8)\n\n"

az webapp create --name $apiappname --resource-group $RESOURCE_GROUP --plan $apiappname --deployment-local-git --verbose


printf "\nSetting the account-level deployment credentials ...(5/8)\n\n"


DEPLOY_USER="myName1$(openssl rand -hex 5)"
DEPLOY_PASSWORD="Pw1$(openssl rand -hex 10)"

az webapp deployment user set --user-name $DEPLOY_USER --password $DEPLOY_PASSWORD --verbose


GIT_URL="https://$DEPLOY_USER@$apiappname.scm.azurewebsites.net/$apiappname.git"

# Create Web App with local-git deploy

REMOTE_NAME=production


# Set remote on src
printf "\nSetting Git remote...(6/8)\n\n"


git remote add $REMOTE_NAME $GIT_URL


printf "\nGit add...(7/8)\n\n"

git add .
git commit -m "initial revision"


printf "\nGit push... (8/8)\n\n"


# printf "When prompted for a password enter this: $DEPLOY_PASSWORD\n"
# git push --set-upstream $REMOTE_NAME master
git push "https://$DEPLOY_USER:$DEPLOY_PASSWORD@$apiappname.scm.azurewebsites.net/$apiappname.git"


printf "Setup complete!\n\n"

printf "***********************    IMPORTANT INFO  *********************\n\n"

printf "Swagger URL: https://$apiappname.azurewebsites.net/swagger\n"

printf "Example URL: https://$apiappname.azurewebsites.net/swagger/v1/swagger.json\n\n"

