import json;
import sys;
import os

#load configuration variables
cwd = os.getcwd();
logCollectorConfig=cwd + '/logCollectorConfig.json';
with open(logCollectorConfig) as configFile:    
    configData = json.load(configFile);

#get the python libary path
pythonPath='pythonPath';
pythonPath=configData[pythonPath];
sys.path.append(pythonPath)

#Python AWS SDK
import boto3;

qName='qName';
#The name of the AWS SQS
qName=configData[qName];

s3Region='s3Region';
#S3 region where the SQS is located
s3Region=configData[s3Region];

#Get the S3 resource
resourceType='s3';
s3 = boto3.resource(resourceType);

# Get the service resource
resourceType='sqs';
sqs = boto3.resource(resourceType, s3Region);

# Create the queue if it does not exist or get the queue
try:
    queue = sqs.get_queue_by_name(QueueName=qName);
except Exception as err:
    print("Error: %s... Creating queue %s..." % (err, qName));
    queue = sqs.create_queue(QueueName=qName, Attributes={'DelaySeconds': '5'});

#pull the notifications from the queue
notifications = queue.receive_messages(
    AttributeNames=['All'],
    MessageAttributeNames=[
        'string',
    ],
    MaxNumberOfMessages=10,
    VisibilityTimeout=5,
    WaitTimeSeconds=5
)

messageKey='Message';
bucketKey='s3Bucket';
s3ObjectKey='s3ObjectKey'
messageIDKey='MessageId';
remoteLogPath="/usr/local/cloud_trail_collector/logs/";
messageID='MessageId';
remoteFileNameExtension='.gz';
notificationBody='';

#process notifications
for notification in notifications:
    #pull the body of the message and load into a Python object
    notificationBody = json.loads(notification.body);
    #pull the message from the notification and put into a Python object
    notificationMessage = json.loads(notificationBody[messageKey]);
    #get the bucket name from the message and set bucket
    bucketName = notificationMessage[bucketKey];
    s3Bucket = s3.Bucket(bucketName);
    #for each key in the message download the log
    for key in notificationMessage[s3ObjectKey]:
        remoteFileName=notificationBody[messageID]
        compressedFileName=remoteLogPath + remoteFileName + remoteFileNameExtension;
        s3Bucket.download_file(key, compressedFileName);
    #clear the notification
    notification.delete();