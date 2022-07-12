#!/bin/bash
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
  echo -e "\nUsage: \n$0 <AWS_PROFILE> <USERNAME> <MFA_TOKEN>\n" >&2
  exit 3
else
  set -e
  AWS_PROFILE=$1
  USERNAME=$2
  MFA_TOKEN=$3
  MFA_SN=$(aws --profile $AWS_PROFILE iam list-mfa-devices \
        --user-name $USERNAME \
        --output text \
        --query 'MFADevices[].SerialNumber')
  sts=$(aws --profile $AWS_PROFILE sts get-session-token \
      --serial-number $MFA_SN \
      --token-code $MFA_TOKEN \
      --duration-seconds ${4:-3600} \
      --output text \
      --query \
      'Credentials.[AccessKeyId,SecretAccessKey,SessionToken,Expiration]')
  sts=($sts)
  export AWS_REGION=sa-east-1
  export AWS_ACCESS_KEY_ID=${sts[0]}
  export AWS_SECRET_ACCESS_KEY=${sts[1]}
  export AWS_SESSION_TOKEN=${sts[2]}
  aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID --profile mfa
  aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY --profile mfa
  aws configure set aws_session_token $AWS_SESSION_TOKEN --profile mfa
  aws configure set region $AWS_REGION --profile mfa
  EXPIRATION=$(date --iso-8601=seconds --date="${sts[3]}")
  echo -e "\nAWS Account ID: $(aws sts get-caller-identity --query Account --output text --profile mfa)"
  echo -e "AWS Profile Name: mfa"
  echo -e "Token Expiration: $EXPIRATION\n"
fi
