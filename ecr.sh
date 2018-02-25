#!/bin/sh

eval $(aws ecr get-login --no-include-email --region ap-northeast-1)

docker build . -t $1.dkr.ecr.ap-northeast-1.amazonaws.com/fastladder-prod-rails
docker push $1.dkr.ecr.ap-northeast-1.amazonaws.com/fastladder-prod-rails:latest
