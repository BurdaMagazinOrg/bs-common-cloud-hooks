#!/bin/sh
#
# Cloud Hook: post-code-deploy
#
# The post-code-deploy hook is run whenever you use the Workflow page to
# deploy new code to an environment, either via drag-drop or by selecting
# an existing branch or tag from the Code drop-down list. See
# ../README.md for details.
#
# Usage: post-code-deploy site target-env source-branch deployed-tag repo-url
#                         repo-type

site="$1"
target_env="$2"
source_branch="$3"
deployed_tag="$4"
repo_url="$5"
repo_type="$6"

# Load the Slack webhook URL (which is not stored in this repo).
. $HOME/slack_settings

SITE_STRING="${$site^} (${$target_env^^})"

if [ "$source_branch" != "$deployed_tag" ]; then
  TEXT="Auf *${SITE_STRING}* wurde *$deployed_tag* (erzeugt aus *$source_branch*) deployed."
else
  TEXT="Auf *${SITE_STRING}* wurde *$deployed_tag* deployed."
fi

# Post deployment notice to Slack
curl -X POST --data-urlencode "payload={\"text\": \"${TEXT}\"}" $SLACK_WEBHOOK_URL

# never break things
exit 0