docker build -t porwalamit/devopsadvanced:latest -t porwalamit/devopsadvanced:$SHA .
docker build -t porwalamit/devopsadvancedredis:latest -t porwalamit/devopsadvancedredis:$SHA -f Dockerfile.redis .
docker push porwalamit/devopsadvanced:latest
docker push porwalamit/devopsadvancedredis:latest
docker push porwalamit/devopsadvanced:$SHA
docker push porwalamit/devopsadvancedredis:$SHA
kubectl apply -f k8s
kubectl set image deployments/node-server-deployment node-server-deployment=porwalamit/devopsadvanced:$SHA
kubectl set image deployments/redis-server-deployment redis-server-deployment=porwalamit/devopsadvancedredis:$SHA