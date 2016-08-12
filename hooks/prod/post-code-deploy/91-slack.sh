#!/usr/bin/env bash

set +e

site="$1"
target_env="$2"
source_branch="$3"
deployed_tag="$4"
repo_url="$5"
repo_type="$6"

# Load the Slack webhook URL (which is not stored in this repo).
[ -f $HOME/slack_settings ] && . $HOME/slack_settings

SITE_STRING="${site^} (${target_env^^})"

if [ "$source_branch" != "$deployed_tag" ]; then
  TEXT="Auf *${SITE_STRING}* wurde *$deployed_tag* (erzeugt aus *$source_branch*) deployed."
else
  TEXT="Auf *${SITE_STRING}* wurde *$deployed_tag* deployed."
fi

# Post deployment notice to Slack
curl -X POST --data-urlencode "payload={\"text\": \"${TEXT}\"}" $SLACK_WEBHOOK_URL

# never break things
exit 0