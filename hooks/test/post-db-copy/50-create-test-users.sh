#!/usr/bin/env bash
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
# not used
db_name="$3"
source_env="$4"

drush_cmd="drush8 @${site}.${target_env}"

# TODO remove when stage bug (bazaar) has been fixed
export AH_SITE_ENVIRONMENT="${target_env}"

# this file should define TESTUSER_PASSWORD, optionally TESTUSER_PREFIX
[ -f $HOME/.burda_settings ] && . $HOME/.burda_settings
password="${TESTUSER_PASSWORD}"
prefix="${TESTUSER_PREFIX:-testuser_}"

if [ "${target_env}" = "prod" ] || [ "${password}" = "" ]; then
  echo "Missing config file or protected target environment, skipping..."
  # never break deployment
  exit 0
fi

roles=$(${drush_cmd} role-list --format=list --fields=rid 2>/dev/null | sed -E 's/^user[.]role[.]//')

for role in ${roles}; do

  # skip hard coded "virtual" roles
  if [ "${role}" = "anonymous" ] || [ "${role}" = "authenticated" ]; then
    continue
  fi

  username="${prefix}${role}"
  verb="updated"

  # create user if not exists
  ${drush_cmd} user-information "${username}" &>/dev/null
  if [ $? -ne 0 ]; then
    ${drush_cmd} user-create "${username}" --mail="${username}@example.org" &>/dev/null
    verb="created"
  fi

  # set mail, role and password
  # (these are idempotent and may be executed everytime)
  ${drush_cmd} user-password "${username}" --password="${password}" &>/dev/null
  ${drush_cmd} user-add-role "${role}" "${username}" &>/dev/null
  ${drush_cmd} user-unblock "${username}" &>/dev/null

  echo "Testuser '${username}' ${verb} with role '${username}'"

done

# TODO maybe reset flood protection
# ${drush_cmd} sql-query 'TRUNCATE `flood`;'

# never break deployment
exit 0