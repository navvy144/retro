#!/bin/bash

# Fix the timezone
  echo "$TZ" > /etc/timezone
  dpkg-reconfigure -f noninteractive tzdata
exit 0
