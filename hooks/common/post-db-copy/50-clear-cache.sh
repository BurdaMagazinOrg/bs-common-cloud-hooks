#!/bin/sh
#
# Cloud Hook: post-db-copy
#
# The post-db-copy hook is run whenever you use the Workflow page to copy a
# database from one environment to another. See ../README.md for
# details.
#
# Usage: post-db-copy site target-env db-name source-env

site="$1"
target_env="$2"
db_name="$3"
source_env="$4"

drush_cmd="drush8 --verbose @${site}.${target_env}"

# when a db is copied, all container paths are wrong so we might as well rebuild the container
${drush_cmd} cr
