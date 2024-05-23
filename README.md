# Terraform AWS Infrastructure

This Terraform script sets up an AWS infrastructure for a project named "roboshop". It includes the following components:

## VPC (Virtual Private Cloud)
- **Name:** roboshop-vpc
- **CIDR Block:** 10.0.0.0/16
- **Tags:**
  - **Name:** roboshop-vpc
  - **Environment:** DEV
  - **Terraform:** true

## Subnets
- **Public Subnet**
  - **Name:** roboshop-public
  - **CIDR Block:** 10.0.1.0/24
  - **VPC Association:** roboshop-vpc
- **Private Subnet**
  - **Name:** roboshop-private
  - **CIDR Block:** 10.0.2.0/24
  - **VPC Association:** roboshop-vpc

## Internet Gateway
- **Name:** roboshop-igw
- **VPC Association:** roboshop-vpc

## Route Tables
- **Public Route Table**
  - **Name:** roboshop-public
  - **VPC Association:** roboshop-vpc
  - **Routes:**
    - Destination: 0.0.0.0/0, Target: roboshop-igw
- **Private Route Table**
  - **Name:** roboshop-private
  - **VPC Association:** roboshop-vpc

## Security Groups
- **Allow HTTP and SSH**
  - **Name:** allow_http_ssh
  - **Description:** Allow inbound traffic for SSH and HTTP
  - **Ingress Rules:**
    - SSH (TCP Port 22) from all sources
    - HTTP (TCP Port 80) from all sources
    - SSH (TCP Port 22) from specific IP: 223.185.44.163/32
  - **Egress Rule:** Allow all outbound traffic

## EC2 Instance
- **Name:** roboshop-web
- **AMI:** ami-0f3c7d07486cad139
- **Instance Type:** t2.micro
- **Subnet:** roboshop-public
- **Security Group:** allow_http_ssh
- **Public IP:** Not associated

## Author
This Terraform script was authored by Srinivas Tharun .
 This README provides an overview of the AWS infrastructure setup using Terraform for the "roboshop" project.
