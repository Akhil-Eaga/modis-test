# Terraform 
---
## Instructions to run the Terraform code;
1) Clone or download this code repo into your local directory
2) `cd` into the code repo
3) Run the command `terraform init` to initialize terraform
4) Then run the command `terraform apply` and then when prompted type `yes`
5) Alternatively run the command `terraform apply -auto-approve` to perform step 4 through just one command
6) Running the above commands will output the DNS name of the Elastic Load Balancer
7) Copy and paste the DNS name into your browser


## Note:
1) Even after the DNS name is printed on the console, for the website to showup you might have to wait a few seconds
2) Use `http` to load the website if your browser defaults to `https`