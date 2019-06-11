#!/bin/bash

rm -f /usr/src/app/tmp/pids/server.pid /usr/src/app/log/*.log
rails server -b 0.0.0.0 &
java -jar srv-rml-1.2.2-SNAPSHOT-jar-with-dependencies.jar -m /config/mapping.ttl -a "$1" -t json -o /config/ontology.ttl &
bash -c 'while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' localhost:3000/api/active)" != "200" ]]; do sleep 5; done'
/usr/src/app/script/init.rb "$2"
sleep infinity
