#!/bin/bash

if [[ "$1" == "redis" ]]; then
    echo "" > /etc/redis.conf
    [[ "${SLAVEOF}x" != "x" ]] && echo "slaveof $SLAVEOF" >> /etc/redis.conf
    [[ "${LISTEN_IP}x" != "x" ]] && echo "bind $LISTEN_IP" >> /etc/redis.conf
    [[ "${REDIS_PORT}x" == "x" ]] && redis-server /etc/redis.conf || redis-server /etc/redis.conf --port $REDIS_PORT
elif [[ "$1" == "sentinel" ]]; then
    [ "${SENTINEL_PORT}x" == "x" ] && { echo "SENTINEL_PORT variable is not specified"; exit 1; }
    [ "${MASTER_IP}x" == "x" ] && { echo "MASTER_IP variable is not specified"; exit 1; }
    [ "${MASTER_PORT}x" == "x" ] && { echo "MASTER_PORT variable is not specified"; exit 1; }
    [ "${QUORUM_NO}x" == "x" ] && { echo "QUORUM_NO variable is not specified"; exit 1; }
    [ "${DOWN_AFTER}x" == "x" ] && { echo "DOWN_AFTER variable is not specified"; exit 1; }
    [ "${FAILOWER_TIMEOUT}x" == "x" ] && { echo "FAILOWER_TIMEOUT variable is not specified"; exit 1; }
    [ "${PARALLEL_SYNC}x" == "x" ] && { echo "PARALLEL_SYNC variable is not specified"; exit 1; }
    echo "" >/etc/sentinel.conf
    echo "port $SENTINEL_PORT" >>/etc/sentinel.conf
    echo "sentinel monitor qrr-master $MASTER_IP $MASTER_PORT $QUORUM_NO" >>/etc/sentinel.conf
    echo "sentinel down-after-milliseconds qrr-master $DOWN_AFTER" >>/etc/sentinel.conf
    echo "sentinel failover-timeout qrr-master $FAILOWER_TIMEOUT" >>/etc/sentinel.conf
    echo "sentinel parallel-syncs qrr-master $PARALLEL_SYNC" >>/etc/sentinel.conf
    sleep 5
    redis-server /etc/sentinel.conf --sentinel
fi
