import os
from time import sleep
import datetime
import subprocess
import sys
from datetime import timedelta
import boto3
from botocore.exceptions import ClientError
import json

secret_name = "mongo_secret_1"
region = "us-east-1"

def get_secret():
    session = boto3.session.Session()
    client = session.client(
        service_name = 'secretsmanager',
        region_name=region
    )

    try:
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )
        username = json.loads(get_secret_value_response["SecretString"])['username']
        password = json.loads(get_secret_value_response["SecretString"])['pass']
        
        return {'username' : username, 'password' : password}
    except ClientError as e:
        print(e)

def floor(x, base=5):
    return int(base * round(int(x)/base))

def s3_command(year, month, day, filename, creds):
    # cmd = 'aws s3 ls s3://lecture-data/backups/' + str(year) + '/' + str(month) + '/' + str(day) + "/ | tail -n 1 | awk '{print $4}"
    output_file = '/tmp'    
    cmd1 = 'aws s3 cp s3://lecture-mongodb-us-east-1/backups/' + str(year) + '/' + str(month) + '/' + str(day) + "/" + str(filename) + ' ' + str(output_file)
    cmd2 = 'cd /tmp; tar -zxvf ' + filename
    os.system(cmd1)
    os.system(cmd2)
    restore_database(output_file, 'express-authentication', creds, filename)

def restore_database(directory, db, creds, filename):
    cmd = 'sudo mongorestore --username ' + creds['username'] + ' --password '+ creds['password'] +' --authenticationDatabase admin --db express-authentication ' + str(directory) + '/' + str(db) + ' --tlsInsecure --ssl --sslCAFile /opt/mongodb/ssl/mongod.pem'
    cmd_clean_1 = "sudo rm -rf /tmp/" + filename
    cmd_clean_2 = "sudo rm -rf /tmp/express-authentication"
    os.system(cmd)
    os.system(cmd_clean_1)
    os.system(cmd_clean_2)
    # print(directory)

# aws s3 ls s3://llecture-database/backups/2020/08/11/ | tail -n 1 | awk '{print $4}'
# 23-15-00.tar.gz

todays_date = datetime.datetime.today().strftime('%m/%d/%Y-%H:%M:%S')
hour        =       datetime.datetime.today().strftime('%H')
minute      =       floor(datetime.datetime.today().strftime('%M'))
year        =       str(datetime.datetime.today().strftime('%Y'))
month       =       str(datetime.datetime.today().strftime('%m'))
day         =       datetime.datetime.today().strftime('%d')

if minute == 00:
    if hour == 00:
        day = (datetime.datetime.today() - timedelta(days=1)).strftime('%d')
        filename = day + '-50-00.tar.gz'
        s3_command(year, month, day, filename, get_secret())
    else:
        subtracted_hour = (datetime.datetime.today() - timedelta(hours=1)).strftime('%H')
        filename = str(subtracted_hour) + '-50-00.tar.gz' 
        s3_command(year, month, day, filename, get_secret())
else:
    if minute-30 < 0:
        subtracted_hour = (datetime.datetime.today() - timedelta(hours=1)).strftime('%H')
        minute = 55
        filename = subtracted_hour + '-' + str(minute) + '-00.tar.gz' 
        s3_command(year, month, day, filename, get_secret())
    else:
        filename = str(hour) + '-' + str(minute-10) + '-00.tar.gz' 
        s3_command(year, month, day, filename, get_secret())



