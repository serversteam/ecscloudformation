I have ran Docker compose file in AWS ECS with cloudformation i used AWS ECS-CLI for creation of cloudformation stack once stack created then i Ran my docker-compose file using ecs-cli compose up command. After excution of this command it created Docker container in ECS cluster. You can check in EC2 there will New server create with cluster name in which docker instance is running. Now you can access app using instance public IP address for example my app running at http://34.199.25.45:3000/.  

I have tried to found other solution to run docker-compose on AWS ECS but no other solution found so i used AWS ECS cli option to deploy docker-compose on ECS.
Below are steps to deploy docker-compose using cloudformation on ECS cluster.

Install ecs cli in server where your docker copmose file placed.

Step 1: Configure the ECS CLI
The ECS CLI requires credentials in order to make API requests on your behalf. It can pull credentials from environment variables, an AWS profile, or an Amazon ECS profile. For more information see Configuring the Amazon ECS CLI.

Create an ECS CLI Configuration

Create a cluster configuration:   (ec2-tutorial is cluster name please change if you want)

##ecs-cli configure --cluster ec2-tutorial --region us-east-1 --default-launch-type EC2 --config-name ec2-tutorial

step2.Create a profile using your access key and secret key:

please copy your AWS access-key and secret-key from IAM.
#ecs-cli configure profile --access-key AKIAIYL5SPAFJWOJCPIQ --secret-key TcTIGEYThmhWipLZN4ZwEsN7YC2TkQrC2K94fiGi --profile-name  ec2-tutorial

Create Your Cluster

for ketpair use AWS key pair.   for example mykey pair name is "mykey"  
and provide instance-type and number of instances you want to launch in ECS.

#ecs-cli up --keypair mykey --capability-iam --size 1 --instance-type t2.small --force

INFO[0000] Created cluster                               cluster=mycl region=us-east-1
INFO[0000] Waiting for your CloudFormation stack resources to be deleted...
INFO[0000] Cloudformation stack status                   stackStatus="DELETE_IN_PROGRESS"
INFO[0030] Waiting for your cluster resources to be created...
INFO[0030] Cloudformation stack status                   stackStatus="CREATE_IN_PROGRESS"
INFO[0091] Cloudformation stack status                   stackStatus="CREATE_IN_PROGRESS"
INFO[0151] Cloudformation stack status                   stackStatus="CREATE_IN_PROGRESS"
VPC created: vpc-12876469
Security Group created: sg-f305ad84
Subnet created: subnet-994635c4
Subnet created: subnet-80b698e4
Cluster creation succeeded.


Deploy your docker compose in ECS : 
Change directory where your docker-compose file placed. 

#ecs-cli compose --file docker-compose.yml up --create-log-groups


==============================================compose file===============================
version: '2'
services:
  node:
    image: wh01server/node
    cpu_shares: 100
    mem_limit: 524288000
    ports:
      - "3000:3000"
    links:
      - redis
    logging:
      driver: awslogs
      options:
        awslogs-group: tutorial-node
        awslogs-region: us-east-1
        awslogs-stream-prefix: node
  redis:
    image: redis
    ports:
        - "6379:6379"
    logging:
      driver: awslogs
      options:
        awslogs-group: tutorial-redis
        awslogs-region: us-east-1
        awslogs-stream-prefix: redis
  azure-vote-front:
    image: wh01server/azure
    container_name: azure-vote-front
    environment:
      REDIS: redis
    ports:
        - "8080:80"
    logging:
      driver: awslogs
      options:
        awslogs-group: tutorial-azure
        awslogs-region: us-east-1
        awslogs-stream-prefix: azure
		
==================================================
to check container up or not
	
#ecs-cli ps 
root@ip-172-31-52-46:/opt/node-redis-docker# ecs-cli ps
Name                                                   State    Ports                        TaskDefinition
a2539d1a-047a-41c3-aaf7-ef113f1741dc/azure-vote-front  RUNNING  34.199.25.45:8080->80/tcp    node-redis-docker:2
a2539d1a-047a-41c3-aaf7-ef113f1741dc/node-app          RUNNING  34.199.25.45:3000->3000/tcp  node-redis-docker:2
a2539d1a-047a-41c3-aaf7-ef113f1741dc/redis             RUNNING  34.199.25.45:6379->6379/tcp  node-redis-docker:2



		
# now you can access your app using http://34.199.25.45:3000/		
