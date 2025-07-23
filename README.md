# AWS-Terraform-Wordpress

An automated, highly available AWS infrastructure for Web Applications, defined via Terraform.

It is currently hosting a WordPress blog as an example application. 

## Architecture and components:
- A Virtual Private Cloud (VPC)
- An Internet Gateway (IGW)
- 2 Public Subnets in 2 different Availability Zones (AZs)
  - 2 Bastion hosts, 1 in each Subnet
  - A Security Group for the Bastion Hosts for external SSH access
- 2 Private Subnets in 2 different AZs
  - An EC2 Autoscaling Group that places and manages EC2 instances in both Private Subnets
  - These EC2 instances serve as Web Servers
    - Creation of a new instance is dependent on an externally defined S3 bucket with application data
- A VPC Gateway Endpoint to allow access to S3 buckets from within Private Subnets without a NAT Gateway
- An Application Load Balancer (ALB) that directs traffic to Web Servers in the EC2 Autoscaling Group
- A Security Group for the Web Servers that allows HTTP access from the ALB and SSH access from the Bastion Hosts
- An RDS database connected to the Web Servers, which automatically manages it's credentials through AWS Secrets Manager
- A VPC Interface Endpoint to allow connection from the VPC to AWS Secrets Manager via AWS PrivateLink

<img width="721" height="801" alt="AWS-Wordpress-Infra-Diagram" src="https://github.com/user-attachments/assets/9c6850bb-2c2a-440b-9250-82d99e5f20f0" />

- An AWS Step Function that builds a fresh Golden Amazon Machine Image (AMI), triggered every night by an Amazon EventBridge Schedule
  - This fresh Golden AMI is used when new EC2 instances are created in the morning 
  - Dependent on an externally defined S3 bucket to pull code from

<img width="875" height="1254" alt="stepfunctions_graph" src="https://github.com/user-attachments/assets/831fda6a-bece-4697-a05e-c1e0764be278" />

 
- An AWS Lambda function that sets the number of instances in the EC2 Autoscaling Group to zero and stops the database instance
  - Called every evening during the week by an AWS EventBridge schedule, to make parts of the infrastructure run only during regular business hours
 
<img width="681" height="401" alt="Savings-Mode-Activation-Diagram drawio" src="https://github.com/user-attachments/assets/35137c54-aa0f-4b96-857f-de0395cbb7c8" />

- An AWS Lambda function that sets the number of instances in the EC2 Autoscaling Group to the configured size and starts the database instance
  - Called every morning during the week by an AWS EventBridge schedules to make parts of the infrastructure run only during regular business hours

<img width="681" height="401" alt="Savings-Mode-Deactivation-Diagram drawio" src="https://github.com/user-attachments/assets/74214113-67e2-4bf2-8da8-c7d95ad9cd88" />
