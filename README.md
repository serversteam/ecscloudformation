I have ran Docker compose file in AWS ECS with cloudformation i used AWS ECS-CLI for creation of cloudformation stack once stack created then i Ran my docker-compose file using ecs-cli compose up command. After excution of this command it created Docker container in ECS cluster. You can check in EC2 there will New server create with cluster name in which docker instance is running. Now you can access app using instance public IP address for example my app running at http://34.199.25.45:3000/.  

I have tried to found other solution to run docker-compose on AWS ECS but no other solution found so i used AWS ECS cli option to deploy docker-compose on ECS.
Below are steps to deploy docker-compose using cloudformation on ECS cluster.

cloudformation template is in repo  with name : ecs.template

Clone this repo into your system 

#git clone https://github.com/serversteam/ecscloudformation.git 

change directory to ecscloudformation

# cd ecscloudformation

Install ecs cli in server where your docker copmose file placed.


Step 1: Configure the ECS CLI

The ECS CLI requires credentials in order to make API requests on your behalf. It can pull credentials from environment variables, an AWS profile, or an Amazon ECS profile. For more information see Configuring the Amazon ECS CLI.

Create an ECS CLI Configuration

Create a cluster configuration:   (ec2-tutorial is cluster name please change if you want)

##ecs-cli configure --cluster ec2-tutorial --region us-east-1 --default-launch-type EC2 --config-name ec2-tutorial

step2.Create a profile using your access key and secret key:

please copy your AWS access-key and secret-key from IAM.

#ecs-cli configure profile --access-key access-key --secret-key secret-key --profile-name  ec2-tutorial

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

#ecs-cli compose --file docker-compose.yml up --create-log-group

This will take few mins to deploy app on ECS. 


To check container up or not
	
#ecs-cli ps 
root@ip-172-31-52-46:/opt/node-redis-docker# ecs-cli ps
Name                                                   State    Ports                        TaskDefinition
a2539d1a-047a-41c3-aaf7-ef113f1741dc/azure-vote-front  RUNNING  34.199.25.45:8080->80/tcp    node-redis-docker:2
a2539d1a-047a-41c3-aaf7-ef113f1741dc/node-app          RUNNING  34.199.25.45:3000->3000/tcp  node-redis-docker:2
a2539d1a-047a-41c3-aaf7-ef113f1741dc/redis             RUNNING  34.199.25.45:6379->6379/tcp  node-redis-docker:2



		
# now you can access your app using http://34.199.25.45:3000/		
