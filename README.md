## Leanote Docker Image

All data is in /leanote/data volume. We can mount local data folder for this volume.
More details from this [wiki](https://github.com/leanote/leanote/wiki)

### Supported tags and respective `Dockerfile` links

* latest, full-featured, full-featured-2.5 ([Dockerfile](https://github.com/jim3ma/docker-leanote/blob/2.5/Dockerfile))
* alpine, alpine-2.5 ([Dockerfile](https://github.com/jim3ma/docker-leanote/blob/2.5/Dockerfile.alpine))
* full-featured-2.4 ([Dockerfile](https://github.com/jim3ma/docker-leanote/blob/2.4/Dockerfile))
* alpine-2.4 ([Dockerfile](https://github.com/jim3ma/docker-leanote/blob/2.4/Dockerfile.alpine))
* full-featured-2.2.1 ([Dockerfile](https://github.com/jim3ma/docker-leanote/blob/2.2.1/Dockerfile))
* alpine-2.2.1 ([Dockerfile](https://github.com/jim3ma/docker-leanote/blob/2.2.1/Dockerfile.alpine))

#### About full-featured images

The latest and full-featured image contain **wkhtmltopdf** for export pdf.

### How to use this image

#### 1. Initial mongo data

[Click here](http://t.cn/Rop6ROb)

#### 2. Update mongo config in app.conf

Download app.conf from [Here](https://raw.githubusercontent.com/leanote/leanote/master/conf/app.conf)

Then update mongo section:

```
# mongdb
db.host=127.0.0.1
db.port=27017
db.dbname=leanote # required
db.username= # if not exists, please leave it blank
db.password= # if not exists, please leave it blank
# or you can set the mongodb url for more complex needs the format is:
# mongodb://myuser:mypass@localhost:40001,otherhost:40001/mydb
# db.url=mongodb://root:root123@localhost:27017/leanote
# db.urlEnv=${MONGODB_URL} # set url from env. eg. mongodb://root:root123@localhost:27017/leanote
```

#### 3. Create data folder

```
mkdir -p leanote-data/{files,mongodb_backup,public/upload}
```

#### 4. Edit docker-compose.yml

```
version: '2'
services:
  leanote:
    image: jim3ma/leanote:full-featured-2.4
    network_mode: "host"
    volumes:
      - ./leanote-data:/leanote/data
      - ./app.conf:/leanote/conf/app.conf
    restart: always
```

#### 5. docker-compose up -d


