#!/bin/bash

echo "Script name is : $0"
echo "Number of variables passed to script: $#"
echo "All variables passed to script: $@"
echo "User home directory: $HOME"
echo "PID of the script: $$"
echo "Present working directory of the script: $PWD"
echo "User running the script: $USER"
sleep 10 &
echo "Back ground process instance ID of a script: $!"
echo "Exit status of previous command: $?"