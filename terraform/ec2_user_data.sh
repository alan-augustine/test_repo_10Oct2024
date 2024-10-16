#!/bin/bash
sudo yum update -y
sudo yum install ruby -y
sudo yum install wget -y
cd /home/ec2-user
wget https://aws-codedeploy-us-east-2.s3.us-east-2.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
systemctl status codedeploy-agent
systemctl start codedeploy-agent
systemctl status codedeploy-agent
