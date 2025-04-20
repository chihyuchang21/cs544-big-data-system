# P1 Solution Notes: Counting Loans with Dockerized Shell Script

## Part 0: VM Setup and SSH Connection (GCP)

In this section, I document the process of setting up a Google Cloud Platform (GCP) Virtual Machine (VM), reserving a static IP (Elastic IP), and connecting to the instance using SSH via key-based authentication.

> **Note**: The CS544 course provides a preconfigured DoIT VM environment for enrolled students.  
> Since I am not officially enrolled in the course, I created my own virtual environment using GCP instead.


### Steps:

#### 1. Create the VM on GCP
- Follow the configuration steps from the previous semester's project documentation:  
  [cs544-wisc/s24 Project 1](https://github.com/cs544-wisc/s24/tree/main/p1)

#### 2. Reserve a Static (Elastic) IP
- Navigate to **VPC Network** > **IP addresses** > **Reserve a static address**.
- Name the IP and attched to the VM you just created.

#### 3. Generate SSH key locally
```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"


> **Reflection**: In the past, I’ve worked with AWS cloud services, so I’m already familiar with the general process of provisioning virtual machines, setting up SSH access, and working in a cloud-based development environment.I found interesting is that on GCP, the process of adding a public key to the instance metadata was slightly different compared to AWS's use of pre-defined `.pem` key files. With GCP, I generated the SSH key pair manually using `ssh-keygen` and pasted the public key into the VM settings.