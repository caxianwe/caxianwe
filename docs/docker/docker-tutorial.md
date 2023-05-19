# Pushing and Pulling to and from Docker Hub

```bash
docker build -t <imagename> -f Dockerfile .
docker run -it --rm <imagename> <parameters>
docker ps -a
docker stop <container_id>
docker rm <container_id>
docker exec -it <container_id> /bin/bash

docker login
docker login <server> --username <username> --password <password>
docker images
docker tag <image_id> yourhubusername/verse_gapminder:firsttry
docker push yourhubusername/verse_gapminder
docker pull yourhubusername/verse_gapminder

docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi $(docker images -a -q)
```