#!/bin/bash

set -e

chown minidlna:minidlna /data

CONFIG_PATH=/data/options.json

ENVVARS="$(jq --raw-output '.envvars | .[] | .name + "=" + .value' $CONFIG_PATH)"

echo "ENVVARS=${ENVVARS}"

#> /etc/minidlna.conf2

for VAR in $(echo "${ENVVARS}"); do
        minidlna_name=`echo "$VAR" | sed -r "s/MINIDLNA_(.*)=.*/\1/g" | tr '[:upper:]' '[:lower:]'`
        minidlna_value=`echo "$VAR" | sed -r "s/.*=(.*)/\1/g"`
        echo "${minidlna_name}=${minidlna_value}" >> /etc/minidlna.conf
done

service minidlna force-reload

tail -f /dev/null
