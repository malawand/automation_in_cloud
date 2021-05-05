import os
from time import sleep
import datetime
import subprocess
import sys
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

creds = get_secret()
# mongo_db_backup = 'sudo mongodump --username dmsuser --password A6E05AFDF596A8E7FD8DF7479D1919DC --db dms --out /var/backups/mongobackups/'+datetime.datetime.today().strftime('%m-%d-%Y') 
todays_date = datetime.datetime.today().strftime('%m/%d/%Y-%H:%M:%S')
hour        =       str(datetime.datetime.today().strftime('%H'))
minute      =       str(floor(datetime.datetime.today().strftime('%M')))
year        =       str(datetime.datetime.today().strftime('%Y'))
month       =       str(datetime.datetime.today().strftime('%m'))
day         =       str(datetime.datetime.today().strftime('%d'))
# second      =       str(floor(datetime.datetime.today().strftime('%S')))
backup_filename    =       str("{0:0=2d}".format(int(hour)))+'-'+str("{0:0=2d}".format(int(minute)))+'-00.tar.gz'
out_dir     =       '/var/backups/mongobackups'
output_path =       out_dir+'/'+str("{0:0=2d}".format(int(minute)))
os.system('mkdir -p ' + output_path)
database    =       'express-authentication'
backup_command =    'sudo mongodump --username ' + creds['username'] + ' --password '+ creds['password'] +' --authenticationDatabase admin --db ' + database + ' --out ' + output_path + ' --host localhost --sslCAFile /opt/mongodb/ssl/mongod.pem --tlsInsecure --ssl'
compress_command =  'cd ' + output_path + '; sudo tar -czf ' + backup_filename + ' .'
s3_upload       = 'aws s3 cp ' + output_path + '/' + backup_filename + ' s3://lecture-mongodb-us-east-1/backups/' + str(year) + '/' + str("{0:0=2d}".format(int(month))) + '/' + str("{0:0=2d}".format(int(day))) + '/'
delete_file = 'sudo rm -rf ' + output_path + '/*'
os.system(backup_command)
os.system(compress_command)
os.system(s3_upload)
os.system(delete_file)
