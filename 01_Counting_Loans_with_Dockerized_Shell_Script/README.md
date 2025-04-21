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
ssh-keygen -C "your_email@example.com"
# -C: Adds a comment (usually your email) to help identify the key.
```
For setting up an SSH connection shortcut, refer to: [How To Create an SSH Shortcut](https://www.digitalocean.com/community/tutorials/how-to-create-an-ssh-shortcut)

#### 4. Set up public key in VM
- Copy the contents of the **public key** (e.g., `id_ed25519.pub`) into the VM’s SSH metadata field.
- Make sure the **username** in the key comment (e.g., `chihyuchang21`) matches what you use in SSH commands.

### ✅ Extra Notes & Pitfalls

#### SSH & GitHub Configuration Tips

- `cd ~/.ssh`: Navigate to your SSH directory.
- Sample SSH config for shortcut:
  ```bash
  Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_cs544_vm
    IdentitiesOnly yes
  ```

- Use this command to verify your SSH key to GitHub:
  ```bash
  ssh -T git@github.com
  ````

- If you see \`Permission denied (publickey)\`, it could be due to:
  - Wrong key being used.
  - The key isn’t added to GitHub.
  - SSH config not pointing to the correct private key.

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

# Force push clean branch to main (⚠️ use with caution)
git push -f origin clean-main:main
```


> **Reflection**: In the past, I’ve worked with AWS cloud services, so I’m already familiar with the general process of provisioning virtual machines, setting up SSH access, and working in a cloud-based development environment. I found interesting is that on GCP, the process of adding a public key to the instance metadata was slightly different compared to AWS’s use of pre-defined .pem key files. With GCP, I generated the SSH key pair manually using ssh-keygen and pasted the public key into the VM settings.

