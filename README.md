HumanGov – Docker, ECR, Terraform & ECS
(Fargate)
Hands-on DevOps Project demonstrating containerization, infrastructure provisioning, and
deployment on AWS using Docker, Amazon ECR, Terraform, and Amazon ECS (Fargate).
This repository documents a real-world, end-to-end DevOps workflow, written as a practical guide and
suitable for learning, interviews, and portfolio demonstration.
📌 Project Overview
The HumanGov application is deployed using a modern, container-based AWS architecture. The
implementation is divided into three sequential parts:
Part 01 – Containerization & Image Delivery
Dockerize the application and web server, then push images to Amazon ECR.
Part 02 – Infrastructure Provisioning
Use Terraform to provision AWS resources such as S3, DynamoDB, and ECS.
Part 03 – Deployment with ECS (Fargate)
Manually deploy the application using ECS Task Definitions and Services.⚠️
Important: Parts 2 and 3 use AWS Fargate, which may incur a small cost. Always destroy
resources after completion.
🧰 Tech Stack
Docker
Amazon ECR
Amazon ECS (Fargate)
Application Load Balancer (ALB)
Amazon S3
Amazon DynamoDB
Terraform
Python (Flask + Gunicorn)
NGINX (Reverse Proxy)
1
📂 Repository Structure
human-gov-application/
├── src/
│ ├── humangov.py
│ ├── requirements.txt
│ └── Dockerfile # Application image
├── nginx/
│ ├── nginx.conf
│ ├── proxy_params
│ └── Dockerfile # NGINX image
human-gov-infrastructure/
└── terraform/
├── main.tf
├── variables.tf
├── outputs.tf
└── modules/
🚀 Part 01 – Containerization & Image Delivery
(Docker + ECR)
Objective
Package the HumanGov application and NGINX web server into Docker images
Push images securely to Amazon ECR
Prepare images for ECS deployment
Prerequisites
Clean Old Workspace
rm -rf hands-on-tasks-terraform terraform-module-ec2 terraform-provisioners-
example
terraform-remote-state-example local-repo local-repo2 ansible-tasks
Keep only required directories:
2
find . -maxdepth 1 -type d ! -name '.' ! -name 'human-gov-application'
! -name 'human-gov-infrastructure' ! -name '.*' -exec rm -rf {} +
IAM Role for ECS Tasks
Create an IAM role with the following:
Use case: Elastic Container Service Task
Policies attached:
AmazonS3FullAccess
AmazonDynamoDBFullAccess
AmazonECSTaskExecutionRolePolicy
Role name:
HumanGovECSExecutionRole
Step 1 – Application Dockerfile
FROM python:3.8-slim-buster
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . /app
CMD ["gunicorn", "--workers", "1", "--bind", "0.0.0.0:8000", "humangov:app"]
Step 2 – Create ECR Repository (App)
Repository name:
humangov-app
Step 3 – Build & Push Image
Follow View push commands from the ECR console.
3
Docker fix if needed:
sudo yum install -y docker
sudo systemctl start docker
sudo usermod -aG docker $USER
newgrp docker
Step 4 – NGINX Configuration
nginx.conf
server {
listen 80;
server_name humangov www.humangov;
location / {
include proxy_params;
proxy_pass http://localhost:8000;
}
}
proxy_params
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
NGINX Dockerfile
FROM nginx:alpine
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d
COPY proxy_params /etc/nginx/proxy_params
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
4
Step 5 – Create ECR Repository (NGINX)
humangov-nginx
Step 6 – Push NGINX Image
Use View push commands in ECR and verify both images exist.🏗️
Part 02 – Infrastructure Provisioning
(Terraform)
Resources Created
Amazon S3 Bucket
Amazon DynamoDB Table
ECS Cluster
Terraform Apply
cd human-gov-infrastructure/terraform
terraform plan
terraform apply -auto-approve
Save outputs:
US_STATE=california
AWS_REGION=us-east-1
AWS_DYNAMODB_TABLE=humangov-california-dynamodb
AWS_BUCKET=humangov-california-s3-xxxx
Create ECS Cluster
Cluster name: humangov-cluster
Infrastructure: Amazon EC2 instances
5
🚢 Part 03 – ECS Deployment (Fargate)
Task Definition
Family: humangov-fullstack
CPU: 1 vCPU
Memory: 3 GB
Launch type: Fargate
Task Role & Execution Role: HumanGovECSExecutionRole
Containers
Application Container - Image: humangov-app - Port: 8000 - Essential: Yes
NGINX Container - Image: humangov-nginx - Port: 80 - Essential: No
ECS Service
Service name: humangov-svc
Desired tasks: 2
Launch type: Fargate
Load Balancer: Application Load Balancer
Target container: NGINX
Validation
ECS tasks running
Target group healthy
Application accessible via ALB DNS
🧹 Cleanup (IMPORTANT)
ECS
Delete ECS Service
Deregister Task Definitions
Delete ECS Cluster
AWS
Delete ECR repositories

6
Remove files from S3
Terraform
terraform destroy -auto-approve
🎯 What This Project Demonstrates
Production-grade Docker usage
Secure image storage with ECR
Infrastructure as Code with Terraform
ECS + Fargate deployment model
Manual deployment complexity (motivation for automation)
📈 Career Value
This project closely mirrors real DevOps work in production environments and is suitable for:
GitHub portfolio
DevOps interviews
Cloud certifications
Build it. Break it. Fix it. That’s how DevOps is learned. 🚀
