#!/usr/bin/env bash

# Requires aws cli to be installed
# Requires role to allow describe-tags to be run
# Script is placed in /etc/profile.d/ec2_tags.sh so that it is run at startup

INSTANCE_ID=$(ec2-metadata --instance-id | cut -f2 -d " ")
REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}')

# Grab key tag values
ENVIRONMENT_TAG_VALUE=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=Environment" --region=$REGION --output=text | cut -f5)
APPLICATION_TAG_VALUE=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=Application" --region=$REGION --output=text | cut -f5)
TYPE_TAG_VALUE=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=Type" --region=$REGION --output=text | cut -f5)

export TAG_APPLICATION=$APPLICATION_TAG_VALUE
export TAG_ENVIRONMENT=$ENVIRONMENT_TAG_VALUE
export TAG_TYPE=$TYPE_TAG_VALUE
