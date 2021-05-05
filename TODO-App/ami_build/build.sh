#!/bin/bash
vi /etc/yum.repos.d/mongodb-org-4.4.repo
[mongodb-org-4.4]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/4.4/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.4.asc

sudo yum install -y mongodb-org
exclude=mongodb-org,mongodb-org-server,mongodb-org-shell,mongodb-org-mongos,mongodb-org-tools
mkdir /data/db
mkdir -p /opt/mongodb/ssl
mkdir -p /opt/mongodb/data/db
cd /opt/mongodb/ssl

openssl genrsa -out CA.key 2048
openssl req -x509 -new -nodes -key CA.key -sha256 -days 1024 -out CA.pem
openssl genrsa -out mongod.key 2048
openssl req -new -key mongod.key -out mongod.csr
openssl x509 -req -in mongod.csr -CA CA.pem -CAkey CA.key -CAcreateserial -out mongod.crt -days 500 -sha256
cat mongod.key mongod.crt > mongod.pem

Certificate Details
US
TEXAS
DALLAS
LUMIFILE
SECURITY
LOCALHOST
security@lumifile.com

systemctl start mongod

mongo

db.createUser({
  user: "lumifileApi",
  pwd: "Mt@X3JKN!cC8vTCRZnAa9nxD!TmweFL",
  roles: [
    { role: "readWrite", db: "categories_books" },
    { role: "readWrite", db: "categories" },
    { role: "readWrite", db: "category_permissions" },
    { role: "readWrite", db: "contacts" },
    { role: "readWrite", db: "document_permissions" },
    { role: "readWrite", db: "document" },
    { role: "readWrite", db: "documents_books" },
    { role: "readWrite", db: "documents" },
    { role: "readWrite", db: "documentset_permissions" },
    { role: "readWrite", db: "documentsets_books" },
    { role: "readWrite", db: "documentsets" },
    { role: "readWrite", db: "platformconnections" },
    { role: "readWrite", db: "sessions" },
    { role: "readWrite", db: "shareds" },
    { role: "readWrite", db: "users" }
  ]
})

db.createUser({
  user: "lumifileApi",
  pwd: "Mt@X3JKN!cC8vTCRZnAa9nxD!TmweFL",
  roles: [
    { role: "readWrite", db: "express-authentication" }
  ]
})

mongo admin --eval 'db.createUser({user: "lumifileApi", pwd: "Mt@X3JKN!cC8vTCRZnAa9nxD!TmweFL", roles: [ {role: "readWrite", db: "express-authentication" }]})' --tls --tlsCAFile /opt/mongodb/ssl/mongod.pem --host localhost
mongo admin --eval 'db.createUser({user: "lumifileAccountRootAdministrator", pwd: "sABxbYwRTLaxgG@!DcfRbV_P8D.QAsb", roles: [ {role: "userAdminAnyDatabase", db: "admin" }, "readWriteAnyDatabase" ]})' --tls --tlsCAFile /opt/mongodb/ssl/mongod.pem --host localhost

db.updateUser(
  "lumifile2",
  {roles: [
      { role: "readWrite", db: "admin" }
  ]}
)


db.createUser( 
    { user: "lumifileAccountRootAdministrator",
        pwd:  "sABxbYwRTLaxgG@!DcfRbV_P8D.QAsb",
        roles: [ 
            { role: "userAdminAnyDatabase", db: "admin" },
            "readWriteAnyDatabase"
        ]
    }
)

db.auth({user: "lumifileApi", pwd: passwordPrompt()})
db.auth({user: "lumifileAccountRootAdministrator", pwd: "sABxbYwRTLaxgG@!DcfRbV_P8D.QAsb"})

# Make sure there are right permissions so that mongod will start with tls

mongo --tls --tlsCAFile /opt/mongodb/ssl/mongod.pem --host localhost