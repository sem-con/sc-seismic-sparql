#!/bin/bash

rm -f /usr/src/app/tmp/pids/server.pid /usr/src/app/log/*.log
rails server -b 0.0.0.0 &
export RAILS_PID=$!
/usr/src/app/script/parse_init.rb "$1"
java -jar srv-rml-1.3.0-SNAPSHOT-jar-with-dependencies.jar -m /usr/src/app/config/mapping.ttl -c /usr/src/app/config/constraint.ttl -a "$(< /usr/src/app/config/data_url)" -t json -o /usr/src/app/config/ontology.ttl &
bash -c 'while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' localhost:3000/api/active)" != "200" ]]; do sleep 5; done'
/usr/src/app/script/init.rb "$1"
kill $RAILS_PID
rails s puma -b 'ssl://0000:3000?key=/certs/vownyourdata.zamg.ac.at.key&cert=/certs/vownyourdata.zamg.ac.at.crt&verify_mode=none' &
sleep infinity
