# Terraform Technical Test
---

Author: [Akhil Eaga](https://github.com/Akhil-Eaga)  
Date: 24-October-2021

---

## What the code results in?
This repo contains code that provisions AWS resources. Specificically it provision EC2 instances and installs Apache webserver on them. These EC2 instances are behind a Autoscaling Group. The incoming traffic is directed to these EC2 instances by Elastic Load Balancer which is also provisioned. For these components to work, other resources like security group, vpc, subnets, launch template, autoscaling attachment are also provisioned.  

The EC2 instances provisioned are free-tier eligible. Hence running these instances for the purpose of testing should not incur any significant bills (if resources are run for a short time). 
## Prerequisites:
1) Terraform CLI should be installed and configured on your local machine
2) AWS CLI should be installed and configured on your local machine
2) Access key and Secret key for your AWS account should be configured in your local machine

---
## Instructions to run the Terraform code:
1) Clone or download this code repo into your local machine
2) `cd` into the code repo
3) Run the command `terraform init` to initialize terraform
4) Then run the command `terraform apply` and when prompted type `yes`
5) Alternatively run the command `terraform apply -auto-approve` to perform step 4 through single command
6) Running the above commands will output the DNS name of the Elastic Load Balancer
7) Copy and paste the DNS name into your browser  

---
## Instructions to destroy the resources provisioned above:
1) Run the command `terraform destroy` and when prompted type `yes`
2) Alternatively run the command `terraform destroy -auto-approve` to perform step 1 through single command

## Note:
1) Even after the DNS name is printed on the console, for the website to showup you might have to wait a few seconds
2) Use `http` to load the website if your browser defaults to `https`
3) If not required, make sure to destroy the provisioned resources to avoid undesired bills
4) Terraform coding conventions are followed where possible

---

## A glimpse of technical details:
__AWS instance type used:__ Ubuntu Server 20.04 LTS (HVM), SSD Volume Type - ami-0567f647e75c7bc05 (64-bit x86)  
__AWS Region used:__ ap-southeast-2 (Sydney)  
__EC2 Instance type:__ t2.micro  
__Web server used:__  Apache  
__Availability Zones used:__ All 3 within the region are used  
__VPC:__ AWS Default VPC is adopted  
__Subnets:__ AWS Default Subnets are adopted  

## Code details:
- __[main.tf](main.tf):__ Contains the terraform code that provisions the resources   
- __[terraform.tfvars](terraform.tfvars):__ Contains the variables that can be configured to user's preferences  
- __[install_apache.sh](install_apache.sh):__ Contains the shell script that installs the apache web server and adds content to the index.html file on the EC2 instance  
- __[outputs.tf](outputs.tf):__ Contains the output values (DNS name of the load balancer) that are printed in the console upon executing the [main.tf](main.tf)
- __[index.html](index.html):__ Although this is not used by the terraform code, this html document shows a readble version of the webpage that is hosted on the Apache web server