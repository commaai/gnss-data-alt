#!/bin/bash -ex

function sync_dir
{
  if [ -z $1 ]; then
    echo "ERROR: target directory value is not set"
    exit 1
  fi
  TARGET_DIR="$1"

  if [ -z $2 ]; then
    echo "ERROR: source directory array is not set"
    exit 1
  fi
  SOURCE_DIRS=($2) # convert space separated string to array

  if [ -z $3 ]; then
    echo "ERROR: include glob array is not set"
    exit 1
  fi
  INCLUDE_GLOBS=($3) # convert space separated string to array

  SERVER_HOSTNAME="ftp.glonass-iac.ru"
  LFTP_MIRROR_OPTS="--no-empty-dirs --no-perms --no-umask --ignore-time --parallel=10"
  lftp -d -u anonymous, -e "set ftp:ssl-force true" -e "mirror ${LFTP_MIRROR_OPTS} $(echo ${SOURCE_DIRS[@]/#/--directory=}) $(echo ${INCLUDE_GLOBS[@]/#/--include-glob=}) --target-directory=${TARGET_DIR};exit" ${SERVER_HOSTNAME}
}

cd "$(dirname "$0")"
HH="[0-2][0-9]"
DD="[0-3][0-9]"
MM="[0-1][0-9]"
YY="[0-9][0-9]"
DOY="[0-9][0-9][0-9]"
DOW="[0-9]"
GPS_WEEK="[0-9][0-9][0-9][0-9]"

END_YEAR=$(date -u +%y)
START_YEAR=$(( ${END_YEAR} - 1 ))

LFTP_MIRROR_OPTS="--no-empty-dirs --no-perms --no-umask --ignore-time --parallel=10"

for CURR_YEAR in $(seq ${START_YEAR} ${END_YEAR}); do
  echo "STARTING YEAR: ${CURR_YEAR}"
  #        target dir         source dirs (space separated array)   include globs (space separated array)
  sync_dir "./MCC/PRODUCTS/"  "/MCC/PRODUCTS/${CURR_YEAR}${DOY}/"   "final/Sta${GPS_WEEK}${DOW}.sp3 rapid/Sta${GPS_WEEK}${DOW}.sp3 ultra/Sta${GPS_WEEK}${DOW}.sp3 ultra/Stark_1D_${YY}${MM}${DD}${HH}.sp3"
done
