#!/bin/bash -e

cd "$(dirname "$0")"

lftp -d -u anonymous, -e 'set ftp:ssl-force true' -e 'mirror --only-missing --no-empty-dirs --no-perms --no-umask --parallel=10 --directory=/MCC/PRODUCTS/1[8-9][0-9][0-9][0-9]/ --directory=/MCC/PRODUCTS/[2-9][0-9][0-9][0-9][0-9]/ --include-glob=final/Sta[0-9][0-9][0-9][0-9][0-9].sp3 --include-glob=rapid/Sta[0-9][0-9][0-9][0-9][0-9].sp3 --include-glob=ultra/Sta[0-9][0-9][0-9][0-9][0-9].sp3 --target-directory=./MCC/PRODUCTS/;exit' ftp.glonass-iac.ru

