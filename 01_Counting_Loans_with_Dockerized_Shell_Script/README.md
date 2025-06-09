# P1 Solution Notes: Counting Loans with Dockerized Shell Script

## Part 0: VM Setup and SSH Connection (GCP)

In this section, I document the process of setting up a Google Cloud Platform (GCP) Virtual Machine (VM), reserving a static IP (Elastic IP), and connecting to the instance using SSH via key-based authentication.

> **Config Notes**:  
> - *Environment*  
>   I am not officially enrolled in CS544, so I created my own virtual environment using Google Cloud Platform (GCP) instead of using the preconfigured DoIT VM.
>
> - *SSH Access*  
>   I configured a shortcut named `cs544-server` in my `~/.ssh/config` file for quick login. I use `ssh cs544-server` to connect.
>
> - *Network Access*  
>   The GCP VM is protected by firewall rules (VPC ingress settings), allowing SSH only from the UW–Madison network. Therefore, I must connect to the university's VPN via *GlobalProtect* before using SSH.
>
> - *Terminal Choice*  
>   I use *Git Bash* instead of Git CMD or PowerShell, because it includes a built-in SSH client and offers a more stable, Unix-like interface on Windows.


### Steps:

#### 1. Create the VM on GCP
- Follow the configuration steps from the previous semester's project documentation:  
  [cs544-wisc/s24 Project 1](https://github.com/cs544-wisc/s24/tree/main/p1)

#### 2. Reserve a Static (Elastic) IP
- Navigate to **VPC Network** > **IP addresses** > **Reserve a static address**.
- Name the IP and attched to the VM you just created.

#### 3. Generate SSH key locally
```bash
ssh-keygen -C "your_email@example.com"
# -C: Adds a comment (usually your email) to help identify the key.
```

Output: two files in the `~/.ssh` directory:

- **Private key**: `~/.ssh/id_ed25519` → used on the machine, do **not** upload.
- **Public key**: `~/.ssh/id_ed25519.pub` → this is what you paste into GitHub.

For setting up an SSH connection shortcut, refer to: [How To Create an SSH Shortcut](https://www.digitalocean.com/community/tutorials/how-to-create-an-ssh-shortcut)

#### 4. Set up public key in VM
- Copy the contents of the **public key** (e.g., `id_ed25519.pub`) into the VM’s SSH metadata field.
- Make sure the **username** in the key comment matches what you use in SSH commands.

#### 5. Set up firewall configuration (just like AWS security group)
- VPC Network > Firewall 
- Then change the network tag of VM

#### 6. Set up github connection in VM
- Set up your customized user name and email
  ```bash
  git config --global user.name "Little Cat"
  git config --global user.email "lcat@gmail.com"
  ```
- Generate SSH Key on the VM (it's VM, not local!)
- Add the Public Key to GitHub
  - Settings > SSH and GPG keys > Add your public key information
- Set up your SSH config in server
  ```bash
  vim ~/.ssh/config
  ```
  Add the following:
  ```bash
  Host github.com
  HostName github.com
  User <yourusername>
  IdentityFile ~/.ssh/id_cs544_vm # the path you keep your private key
  ```

- Use this command to verify your SSH key to GitHub:
  ```bash
  ssh -T git@github.com
  ````

### ✅ Extra Notes & Pitfalls

#### Disk Usage
```bash
df -h  # Show disk usage in human-readable format
```

#### Executing Scripts
```
./download.sh  # The `./` means current directory
```

#### Git: Large File Error Recovery
If Git rejects your push due to file size (>100MB), follow this sequence:

```
# Create an orphan branch (no commit history)
git checkout --orphan clean-main

# Add files selectively, skipping large ones
git add . --all
git reset code/wi*.csv
git reset code/wi.txt

# Commit clean state
git commit -m "Clean version without large files"

# Force push clean branch to main (⚠️ Better: checkout main & merge)
git push -f origin clean-main:main
```


> **Reflection**: In the past, I’ve worked with AWS cloud services, so I’m already familiar with the general process of provisioning virtual machines, setting up SSH access, and working in a cloud-based development environment. I found interesting is that on GCP, the process of adding a public key to the instance metadata was slightly different compared to AWS’s use of pre-defined .pem key files. With GCP, I generated the SSH key pair manually using ssh-keygen and pasted the public key into the VM settings.


## Part 1 & 2: Download Script & Multi Script
> download.sh
```bash
#!/bin/bash

# Download the files
wget https://pages.cs.wisc.edu/~harter/cs544/data/wi2021.csv.gz
wget https://pages.cs.wisc.edu/~harter/cs544/data/wi2022.csv.gz
wget https://pages.cs.wisc.edu/~harter/cs544/data/wi2023.csv.gz

# Decompress the files
gunzip wi2021.csv.gz
gunzip wi2022.csv.gz
gunzip wi2023.csv.gz

# Concatenate the files into wi.txt
cat wi2021.csv wi2022.csv wi2023.csv > wi.txt
```

> multi.sh
```bash
#!/bin/bash

# Step 1: Run download.sh to get wi.txt
./download.sh

# Step 2: Count lines with "Multifamily" (case-insensitive)
count=$(grep -i "Multifamily" wi.txt | wc -l)

# Step 3: Print the result
echo "Number of lines containing 'Multifamily': $count"
```

## Part 3: Docker Install

#### 1. Install Docker ([official doc](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository))

I tried to install the specific version as course instruction mentioned but it failed, so I just use the latest version.

#### 2. Manage Docker as a non-root user ([official doc](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user))

Then user doesn't need to specify "sudo" everytime to use docker commands.



## Part 4: Docker Image
```bash
#!/bin/bash

# vim Dockerfile
FROM ubuntu:latest

COPY multi.sh /multi.sh
RUN chmod +x /multi.sh
CMD ["/multi.sh"]
```

```bash
docker build . -t p1
docker run p1
```

