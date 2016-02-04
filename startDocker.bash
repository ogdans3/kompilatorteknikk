# docker build -t ogdans3/kompilatorteknikk .

# docker run -it -v /home/ubuntu/kompilatorteknikk/pencil -w /usr/src/app cdev /bin/bash

docker run -it -v "$PWD":/usr/src/app -w /usr/src/app cdev /bin/bash

