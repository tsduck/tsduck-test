#!/usr/bin/env bash
# Test tsswitch with either UDP or TCP/TLS control port.
# - By default, use a UDP control port.
# - With '--args tls', use a TCP/TLS control port.

source $(dirname "$0")/../../common/testrc.sh

CONTROL_PORT=5260
PORT_IN_1=5261
PORT_IN_2=5262
PORT_OUT=5263
TOKEN=Test-Token

if [[ $1 == tls ]]; then
    USE_TLS=true
    REMOTE_OPTS="--remote-tls --remote-token $TOKEN"
    source "$COMMONDIR/setup-tls-certificate.sh"
else
    USE_TLS=false
    REMOTE_OPTS=
fi
echo "==== Using TLS control port: $USE_TLS"

# Run input sources in the background.
$(tspath tsp) -b 1,000,000 -I craft --pid 100 -P regulate -O ip -e $LOCALHOST:$PORT_IN_1 &
pid_in1=$!
$(tspath tsp) -b 1,000,000 -I craft --pid 200 -P regulate -O ip -e $LOCALHOST:$PORT_IN_2 &
pid_in2=$!

# Run output monitoring in the background.
$(tspath tsp) \
    -I ip :$PORT_OUT -l $LOCALHOST \
    -P filter --every 1000 --set-label 0 \
    -P trace --label 0 \
    -O drop &
pid_out=$!

# Run the switch test in the background.
# Shall be interrupted by user using remote command.
$(tspath tsswitch) --verbose --infinite --remote $LOCALHOST:$CONTROL_PORT $REMOTE_OPTS \
    -I ip :$PORT_IN_1 -l $LOCALHOST \
    -I ip :$PORT_IN_2 -l $LOCALHOST \
    -O ip -e $LOCALHOST:$PORT_OUT &
pid_switch=$!

# Run the scenario.
commands=(next next next 1 0 exit)
for cmd in ${commands[*]}; do
    sleep 4
    echo "==== Sending command \"$cmd\""
    if $USE_TLS; then
        curl -sSk -H "Authorization: Token $TOKEN" https://$LOCALHOST:$CONTROL_PORT/$cmd
    else
        echo >/dev/udp/127.0.0.1/$CONTROL_PORT $cmd
    fi
done

wait $pid_switch
kill -KILL $pid_in1 $pid_in2 $pid_out
