#!/bin/bash

BROKER_HOST=$1
NUMBER_OF_CONTAINERS=$2
SEND_INTERVAL=$3
TEST_TIME=$4
STARTUP_TIME=$5
DATA_TYPE=$6

for i in `seq ${NUMBER_OF_CONTAINERS}`
do
   docker run -d --net=host \
    -e BROKER_HOST=${BROKER_HOST} \
    -e USERNAME=iota \
    -e PASSWORD=password \
    -e APIKEY=apikey \
    -e VM_ID=vm1 \
    -e DEVICE_ID=device`printf %05g ${i}` \
    -e SEND_INTERVAL=${SEND_INTERVAL} \
    -e MESSAGE_NUM=$((${TEST_TIME}/${SEND_INTERVAL})) \
    -e STARTUP_INTERVAL=$((${STARTUP_TIME}*${i})) \
    -e DATA_TYPE=${DATA_TYPE} \
    --name device`printf %05g ${i}` \
    --log-driver=syslog \
    dummy_device &>/dev/null
done

# 32400は9時間の秒換算(UTCをJSTに変換するために使用)
EXPECTED_FINISH_TIME=$((${NUMBER_OF_CONTAINERS}*${STARTUP_TIME}*2+${MESSAGE_NUM}+32400))

echo "Number of containers"
echo $((`docker ps |wc-l`-1))
echo ""
echo "Expected finish time"
date --date "${EXPECTED_FINISH_TIME} seconds" "+%m/%d %H:%M:%S"
echo ""
echo "Number of all MQTT messages"
echo $((${MESSAGES_NUM}*${NUMBER_OF_CONTAINERS}))
