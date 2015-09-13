#!/bin/bash

COMMAND="$1"
SERVER_JAR="forge-1.7.10-10.13.4.1448-1.7.10-universal.jar"

if ps -ef | grep -v grep | grep $SERVER_JAR &>/dev/null; then
    STATUS="running"
else
    STATUS="stopped"
fi

if [[ "$COMMAND" == "start" ]]; then
    if [[ "$STATUS" == "stopped" ]]; then
        java -Xms2G -Xmx2G -XX:MaxPermSize=256m -jar  $SERVER_JAR nogui &>logs/server.log &
        disown %1

        echo ""
        echo "The server is starting. Press Cntl-C to stop watching the log. The server will"
        echo "continue running. The server log can be found in ./logs/server.log."
        echo ""
        tail -F ./logs/server.log
    else
        echo "The server is already running."
    fi
elif [[ "$COMMAND" == "stop" ]]; then
    if [[ "$STATUS" == "running" ]]; then
        ps -ef | grep 'java.*nogui' | grep -v grep | awk '{print $2}' | xargs kill
        sleep 1
        tail ./logs/server.log

        echo ""
        echo "Server stopped."
    else
        echo "The server is already stopped."
    fi
elif [[ "$COMMAND" == "status" ]]; then
    ps -ef | grep -v grep | grep $SERVER_JAR
    echo "The server is $STATUS."
else
    echo "Please specify a command: start | stop | status"
    exit 1
fi

echo ""
exit 0

