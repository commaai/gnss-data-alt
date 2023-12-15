#!/bin/bash -e

cd "$(dirname "$0")"
HH="[0-2][0-9]"
DD="[0-3][0-9]"
MM="[0-1][0-9]"
YY="[0-9][0-9]"
DOY="[0-9][0-9][0-9]"
DOW="[0-9]"
GPS_WEEK="[0-9][0-9][0-9][0-9]"

CURR_YEAR=$(date -u +%y)
PREV_YEAR=$(( ${CURR_YEAR} - 1 ))

lftp -d -u anonymous, -e "set ftp:ssl-force true" -e "mirror --no-empty-dirs --no-perms --no-umask --parallel=10 --directory=/MCC/PRODUCTS/${CURR_YEAR}${DOY}/ --directory=/MCC/PRODUCTS/${PREV_YEAR}${DOY}/ --include-glob=final/Sta${GPS_WEEK}${DOW}.sp3 --include-glob=rapid/Sta${GPS_WEEK}${DOW}.sp3 --include-glob=ultra/Sta${GPS_WEEK}${DOW}.sp3 --include-glob=ultra/Stark_1D_${YY}${MM}${DD}${HH}.sp3 --target-directory=./MCC/PRODUCTS/;exit" ftp.glonass-iac.ru
