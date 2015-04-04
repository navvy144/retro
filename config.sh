#!/bin/bash

# Fix the timezone
  echo "$TZ" > /etc/timezone
  dpkg-reconfigure -f noninteractive tzdata
  touch /tmp/booted
exit 0
