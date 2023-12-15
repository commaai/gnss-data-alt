#!/bin/bash -e

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

for YEAR in $(seq ${START_YEAR} ${END_YEAR}); do
  DIR_PATH="/MCC/PRODUCTS/${YEAR}${DOY}/"
  echo "STARTING: ${DIR_PATH}"
  lftp -d -u anonymous, -e "set ftp:ssl-force true" -e "mirror ${LFTP_MIRROR_OPTS} --directory=${DIR_PATH} --include-glob=final/Sta${GPS_WEEK}${DOW}.sp3 --include-glob=rapid/Sta${GPS_WEEK}${DOW}.sp3 --include-glob=ultra/Sta${GPS_WEEK}${DOW}.sp3 --include-glob=ultra/Stark_1D_${YY}${MM}${DD}${HH}.sp3 --target-directory=./MCC/PRODUCTS/;exit" ftp.glonass-iac.ru
done
