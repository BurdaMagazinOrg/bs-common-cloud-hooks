#!/bin/sh
#
# This sample a Cloud Hook script to update New Relic whenever there is a new code deployment

site=$1         # The site name. This is the same as the Acquia Cloud username for the site.
targetenv=$2    # The environment to which code was just deployed.
sourcebranch=$3 # The code branch or tag being deployed.  
deployedtag=$4  # The code branch or tag being deployed. 
repourl=$5      # The URL of your code repository.
repotype=$6     # The version control system your site is using; "git" or "svn".

curl -s -H "x-api-key:$APIKEY" -d "deployment[application_id]=$APPID" -d "deployment[description]=$deployedtag deployed to $site:$targetenv" -d "deployment[revision]=$deployedtag" -d "deployment[changelog]=$deployedtag deployed to $site:$targetenv" -d "deployment[user]=$username"  https://api.newrelic.com/deployments.xml
# never break deployment
exit 0