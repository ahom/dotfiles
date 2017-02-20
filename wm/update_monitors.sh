#! /bin/sh

export DISPLAY=":0"
export XAUTHORITY="/home/ahom/.Xauthority"

LAPTOP_SCREEN=$1

CONNECTED_SCREENS=$(xrandr | grep " connected " | cut -f 1 -d " ")
DISCONNECTED_SCREENS=$(xrandr | grep " disconnected " | cut -f 1 -d " ")

COMMAND="xrandr"

if [ "$LAPTOP_SCREEN" != "" ]
then
    if [ $(echo $CONNECTED_SCREENS | sed "s/[^ ]//g" | wc -c) -gt 2 ]
    then
        COMMAND="$COMMAND --output $LAPTOP_SCREEN --off" 
    else
        COMMAND="$COMMAND --output $LAPTOP_SCREEN --auto --primary" 
        PRIMARY=$LAPTOP_SCREEN
    fi
fi

for SCREEN in $DISCONNECTED_SCREENS
do
    COMMAND="$COMMAND --output $SCREEN --off"
done

PREV_SCREEN=
for SCREEN in $CONNECTED_SCREENS
do
    if [ "$SCREEN" != "$LAPTOP_SCREEN" ]
    then
        COMMAND="$COMMAND --output $SCREEN --auto"
        if [ "$PRIMARY" = "" ]
        then
            PRIMARY=$SCREEN
            COMMAND="$COMMAND --primary"
        fi

        if [ "$PREV_SCREEN" != "" ]
        then
            COMMAND="$COMMAND --right-of $PREV_SCREEN"
        fi
        PREV_SCREEN=$SCREEN
    fi
done

echo "$COMMAND"
$COMMAND
