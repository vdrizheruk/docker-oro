# docker-web
Docker Container "WEB"

## build container
    sudo docker build -t web .

## start container
    sudo docker run -id -p 80 --name web1 web
## stop and remove container
    sudo docker rm -f web1
## rename existed container
    sudo docker rename web1 web2
