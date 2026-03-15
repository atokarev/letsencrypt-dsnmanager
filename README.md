# Let's Encrypt + ISPmanager DNSmanager Automation

This project provides a set of scripts to automatically issue and renew SSL/TLS certificates from **Let's Encrypt** using the **DNS-01 challenge** with **ISPmanager** DNS API. The process is fully automated via Certbot hooks.

---

## Features

- Automatic issuance of wildcard and base domain certificates.
- DNS-01 challenge via ISPmanager API.
- Automatic cleanup of TXT records after validation.
- Fully non-interactive, suitable for cron automation.

---

## Requirements

- Ubuntu or compatible Linux server
- Certbot installed
- Access to ISPmanager API with DNS management permissions
- Bash shell

---

## Dependencies

This project requires the following tools installed on your system:

- **bash** - for running the scripts  
- **certbot** - for obtaining Let's Encrypt certificates  
- **curl** - for making HTTP requests to ISPmanager API
- **jq** - for parsing JSON responses from ISPmanager API  
- **awk** - for text processing

---

## Instructions

### 1. Install Certbot

On Ubuntu:

```bash
sudo apt update
sudo apt install certbot
```

### 2. Configure scripts/config

Set your domain and ISPmanager API credentials:

```
API_HOST="dnsmanager_host"
DOMAIN_NAME="domain_name"
API_USERNAME="user_name"
API_PASSWORD="password"
EMAIL="email"
```

### 3. Run the script manually

```
./run_renew.sh
```

This will create the acme-challenge TXT records, wait for propagation, validate the challenge, and clean up after.

### 4. Add to cron for automatic renewal

Open the crontab:

```
crontab -e
```

Add a daily run at 8:00 AM:

```
0 8 * * * /home/username/certbot-ispmanager/run_renew.sh
```

### 5. Certificate storage

Certificates and private keys are stored in the config directory specified:

```
./data/config/live/$DOMAIN_NAME/
```

---

## License

This project is licensed under the **MIT License**.
