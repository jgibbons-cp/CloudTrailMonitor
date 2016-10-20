###############
#W. Jenks Gibbons
#August 2016
#Install and configure a CloudTrail log collector
###############

#!/bin/bash

INSTALL_DIRECTORY="/usr/local/cloud_trail_collector/";
LOGS_DIRECTORY="logs";
USER="ec2-user";
GROUP="ec2-user";
LOG_COLLECTOR="logCollector.py";
LOG_PROCESSOR="process_cloud_trail_logs.sh";
LOG_COLLECTOR_CONFIG="logCollectorConfig.json";
#if on a Mac needs to be /var/root/.aws/
ROOT_HOME="/root/";

if [ ! -d "$INSTALL_DIRECTORY" ]; then
  sudo mkdir $INSTALL_DIRECTORY;
  sudo chown $USER:$GROUP $INSTALL_DIRECTORY;
fi;

cp $LOG_COLLECTOR $INSTALL_DIRECTORY;
cp $LOG_PROCESSOR $INSTALL_DIRECTORY;
sudo cp $LOG_COLLECTOR_CONFIG $ROOT_HOME;

if [ ! -d "$INSTALL_DIRECTORY$LOGS_DIRECTORY" ]; then
  sudo mkdir $INSTALL_DIRECTORY$LOGS_DIRECTORY;
  sudo chown $USER:$GROUP $INSTALL_DIRECTORY$LOGS_DIRECTORY;
fi;

ROOT_AWS_CONFIG_DIRECTORY="$ROOT_HOME.aws/";
AWS_CONFIG_FILE="config"
CREDENTIALS_KEY="AWS_CONFIG_FILE";
CREDENTIALS_VALUE="$AWS_CONFIG_FILE";
CREDENTIALS_KV_PAIR="$CREDENTIALS_KEY=\"$ROOT_AWS_CONFIG_DIRECTORY$CREDENTIALS_VALUE\"";

#temporarily write crontab
sudo crontab -u root -l > temp_cron 2>/dev/null;
#if the command is not in crontab then write it
if ! grep $CREDENTIALS_KEY temp_cron; then echo "$CREDENTIALS_KV_PAIR" >> temp_cron; fi;
if ! grep $LOG_COLLECTOR temp_cron; then echo "*/1 * * * * python $INSTALL_DIRECTORY$LOG_COLLECTOR" >> temp_cron; fi;
if ! grep $LOG_PROCESSOR temp_cron; then echo "*/1 * * * * sh $INSTALL_DIRECTORY$LOG_PROCESSOR" >> temp_cron; fi;
#write the new crontab
sudo crontab temp_cron;
sudo rm temp_cron;

if [ ! -d "$ROOT_AWS_CONFIG_DIRECTORY" ]; then
  sudo mkdir $ROOT_AWS_CONFIG_DIRECTORY;
  sudo cp config $ROOT_AWS_CONFIG_DIRECTORY; 
fi;
