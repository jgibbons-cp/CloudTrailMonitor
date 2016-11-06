AWS CloudTrail can be used to store AWS API calls.  AWS SNS and SQS can be used to pull the logs from S3 and Halo LIDS can be used to pick them up and alert.

Configure AWS
1) Create a trail with CloudTrail - referece - http://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-create-and-update-a-trail.html
a) Create a new SNS topic
b) Turn on CloudTrail
c) Create an Amazon S3 bucket to store the logs
2) Create an SQS Queue
3) Subscribe the SQS Queue to the SNS topic - reference http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-subscribe-queue-sns-topic.html - using the Queue Actions button.


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

5) Install the Halo agent

6) Upload the policy to Halo

7) Apply the policy to the group where the server is located (NOTE: if should be shared with sub-groups and if it is not applied to the policy root it needs to be inherited down.


Install logCollector - sudo sh INSTALL.sh

Known issues:

1) This will work on a Mac with a bit of tweaking.
2) If there are no .gz files cron will send a message to root's mail spool.
3) I don't ever remove logs so watch out for disk space (will update at some point or feel free to do so and make a pull request)
4) Not much testing - got working for a demo and didn't test further
