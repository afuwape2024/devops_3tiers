#!/bin/bash

# Update system
apt-get update -y

# Install Apache and curl
apt-get install -y apache2 curl

# Get metadata
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
HOSTNAME=$(hostname)

# Create test webpage
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>AZ Test</title>
    <style>
        body {
            background-color: #f4f4f4;
            font-family: Arial, sans-serif;
            text-align: center;
            margin-top: 100px;
        }
        .card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            width: 400px;
            margin: auto;
            box-shadow: 0 0 10px rgba(0,0,0,0.2);
        }
        h1 { color: #2c3e50; }
    </style>
</head>
<body>
    <div class="card">
        <h1>EC2 AZ Test</h1>
        <p><strong>Instance ID:</strong> $INSTANCE_ID</p>
        <p><strong>Availability Zone:</strong> $AZ</p>
        <p><strong>Private IP:</strong> $PRIVATE_IP</p>
        <p><strong>Hostname:</strong> $HOSTNAME</p>
    </div>
</body>
</html>
EOF

# Restart Apache
systemctl enable apache2
systemctl restart apache2