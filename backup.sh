#!/bin/bash
/usr/bin/inotifywait -mrq --format '%w%f' -e close_write,delete /backup \
|while read file
  do
  rsync -az ./ --delete rsync_backup@192.168.2.7
  done
