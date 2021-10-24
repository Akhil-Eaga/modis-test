# Terraform 
---

Author: [Akhil Eaga](https://github.com/Akhil-Eaga)  
Date: 24-October-2021

---
## Prerequisites:
1) Terraform CLI should be installed and configured on your local machine
2) AWS CLI should be installed and configured on your local machine
2) Access key and Secret key for your AWS account should be configured in your local machine

---
## Instructions to run the Terraform code:
1) Clone or download this code repo into your local directory
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

---

## A glimpse of technical details:
__AWS instance type used:__ Ubuntu Server 20.04 LTS (HVM), SSD Volume Type - ami-0567f647e75c7bc05 (64-bit x86)  
__Region used:__ ap-southeast-2 (Sydney)  
__Instance type:__ t2.micro  
__Web server used:__  Apache  
__Availablity Zones used:__ All 3 within the region are used  
__VPC:__ AWS Default VPC is adopted  
__Subnets:__ AWS Default Subnets are adopted  