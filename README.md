Configration and installation instructions (Only tested on Amazon Linux):

1) Set the variables needed to execute the software
a) Open logCollectorConfig.json
b) Add the path to your python libraries to the pythonPath variable (if not /usr/local/lib/python2.7/site-packages/)
c) Add the name of your SQS to qName
d) Add the region where the S3 Bucket resides in s3Region

2) If your user and group is something other than ec2-user then open INSTALL.sh and change the USER and GROUP variables to the correct values.

3) Open config to setup your AWS credentials
a) Add the value for your aws_access_key_id
b) Add the value for your aws_secret_access_key

4) Install boto3
a) sudo pip install boto3

5) Install logCollector - sudo sh INSTALL.sh

Known issues:

1) This will work on a Mac with a bit of tweaking.
2) If there are no .gz files cron will send a message to root's mail spool.
3) I don't ever remove logs so watch out for disk space (will update at some point or feel free to do so and make a pull request)
4) Not much testing - got working for a demo and didn't test further
