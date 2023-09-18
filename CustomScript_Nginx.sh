#!/bin/bash

# Update package list and install Nginx
sudo apt update
sudo apt install -y nginx

# Define the HTML content with "Hello World" and hostname
html_content="<html><head><title>Hello World</title></head><body><h1>Hello World</h1><p>Hostname: $(hostname)</p></body></html>"

# Create a custom HTML file with the content
echo "$html_content" | sudo tee /var/www/html/index.html

# Restart Nginx to apply changes
sudo systemctl restart nginx

# Enable Nginx to start on boot (optional)
sudo systemctl enable nginx

# Print a message indicating the setup is complete
# echo "Nginx is installed and configured. You can access the 'Hello World' page by entering your server's IP address in a web browser."