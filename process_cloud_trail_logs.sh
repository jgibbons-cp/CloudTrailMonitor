##################
#W. Jenks Gibbons
#August 2016
#Aggregrate zipped logs into a log file that can be monitored by LIDS
##################

INSTALL_DIRECTORY="/usr/local/cloud_trail_collector/";
LOGS_DIRECTORY="logs/";
FILES="$INSTALL_DIRECTORY$LOGS_DIRECTORY*";
CLOUD_TRAIL_LOG="cloud_trail.log";
EXIST=0;

ls $INSTALL_DIRECTORY$LOGS_DIRECTORY | grep .gz &>/dev/null;
retval=$?;

if [ $retval -eq $EXIST ]; then
  gunzip $INSTALL_DIRECTORY$LOGS_DIRECTORY*.gz;
fi

for f in $FILES
do
  
  if [ "$f" != "$INSTALL_DIRECTORY$LOGS_DIRECTORY$CLOUD_TRAIL_LOG" ]; then
    ls $f | grep .gz &>/dev/null;
    retval=$?;
    if [ $retval -ne $EXIST ]; then
      cat $f >> $INSTALL_DIRECTORY$LOGS_DIRECTORY$CLOUD_TRAIL_LOG;
      rm $f;
    fi
  fi
done
