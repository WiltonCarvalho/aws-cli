# Install AWS CLI
```
curl -fsSL https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip -o /tmp/awscliv2.zip
sudo unzip -q /tmp/awscliv2.zip -d /opt
sudo /opt/aws/install -i /usr/local/aws-cli -b /usr/local/bin --update
rm /tmp/awscliv2.zip
sudo rm -rf /opt/aws
aws --version
```

# Configure AWS CLI
```
aws configure set aws_access_key_id <<AWS_ACCESS_KEY_ID>> --profile my-account-1
aws configure set aws_secret_access_key <<AWS_SECRET_ACCESS_KEY>> --profile my-account-1
aws configure set region sa-est-1 --profile my-account-1
```

# Test AWS CLI
```
aws --profile my-account-1 sts get-caller-identity --query Account --output text
```

# Install Git CodeCommit Helper
```
sudo pip3 install git-remote-codecommit
```

# Get AWS MFA STS Token
```
sudo cp sts-token.sh /usr/local/bin/sts-token.sh
```
```
sts-token.sh my-accout-1 wilton.carvalho 123321
```

# Git Clone CodeCommit with AWS CLI Profile
```
git clone codecommit://mfa@demo-repo demo-repo
```
