# Adventure Works — Two-Tier Architecture on AWS (ALB + Auto Scaling + RDS + Joomla)
By Will A. Soto - Cloud DevOps Engineer ☁️

## 🧭 Architecture

A secure, scalable two-tier web application deployed on AWS — featuring an Application Load Balancer (ALB) distributing traffic across EC2 instances in an Auto Scaling Group, with a MySQL RDS backend hosted in private subnets. Joomla CMS is automatically deployed via a user-data script to enable dynamic, content-driven web services for Adventure Works, a global travel agency.

---

## 🧩 Use Case
Adventure Works needed a cloud-based platform capable of handling dynamic traffic while ensuring uptime, performance, and data isolation. The solution uses AWS native services to deliver a fault-tolerant web infrastructure supporting Joomla CMS for their customer-facing site.

---

## ⚙️ Technologies & Setup
- **Amazon VPC** – Custom 10.0.0.0/16 network with public and private subnets across multiple AZs  
- **Application Load Balancer (ALB)** – Routes HTTP traffic to EC2 web tier  
- **EC2 + Auto Scaling Group (ASG)** – Scales compute resources dynamically by CPU usage  
- **Amazon RDS (MySQL)** – Secure, persistent backend in private subnets  
- **Amazon CloudWatch** – Triggers scale-out/in policies via CPU metrics  
- **IAM Roles & Security Groups** – Granular access control between ALB → EC2 → RDS  

---

## 🧠 Launch Template (Web Tier)
The Launch Template ensures all EC2 instances deploy Joomla automatically on launch.

```bash
#!/bin/bash
# Joomla Web Server Setup Script
sudo apt update -y
sudo apt install -y apache2 php libapache2-mod-php php-mysql php-xml php-gd php-cli php-zip unzip curl
sudo systemctl enable apache2 && sudo systemctl start apache2
cd /var/www/html
sudo curl -L -o joomla.zip https://github.com/joomla/joomla-cms/releases/download/3.9.28/Joomla_3.9.28-Stable-Full_Package.zip
sudo unzip joomla.zip && sudo rm joomla.zip
echo "healthy" | sudo tee /var/www/html/health.txt
sudo chown -R www-data:www-data /var/www/html
sudo find /var/www/html -type d -exec chmod 755 {} \;
sudo find /var/www/html -type f -exec chmod 644 {} \;
sudo systemctl restart apache2

Purpose:
Automates Joomla installation, enables /health.txt endpoint for ALB health checks, and enforces secure file permissions.

📊 CloudWatch & Auto Scaling

Scale-Out Policy: Triggers when CPU > 60% for two consecutive 1-minute periods

Scale-In Policy: Triggers when CPU < 20% for five consecutive 1-minute periods

Target Tracking: Maintains 50% average CPU utilization

Validation: Verified scaling actions via CloudWatch activity history

🔐 Security Group Flow
Layer	Inbound	Source	Purpose
ALB-SG	HTTP (80)	0.0.0.0/0	Public access
APP-SG	HTTP (80)	ALB-SG	Web traffic from ALB
DB-SG	MySQL (3306)	APP-SG	Private database access
✅ Results

Joomla CMS deployed and functional through ALB DNS

EC2 instances scale dynamically with CPU demand

RDS instance isolated in private subnet (non-public)

CloudWatch confirms scaling events

100% automation of web-tier provisioning

🧩 Validation Screenshots

Screenshots confirming key milestones:
validation-screenshots/

VPC and subnet setup

Security group chaining (ALB → APP → DB)

Launch Template configuration

Joomla deployment via ALB DNS

Auto Scaling and CloudWatch activity logs
