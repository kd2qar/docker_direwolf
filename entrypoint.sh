#!/bin/sh


while [ true ]
do
  arecord -l	
  direwolf -p -t 0 -dh
  sleep 10
done
