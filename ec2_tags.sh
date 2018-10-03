#!/usr/bin/env bash

# Description: Is an automated method of using ec2 tags to set the terminal window title and command prompt.
# Location: /usr/local/bin/ec2_tags.sh
# Requires aws cli to be installed
# Requires role to allow describe-tags to be run
# Requires line in crontab to execute at startup: @reboot /usr/local/bin/ec2_tags.sh

INSTANCE_ID=$(ec2-metadata --instance-id | cut -f2 -d " ")
REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}')

# Grab key tag values
ENVIRONMENT_TAG_VALUE=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=Environment" --region=$REGION --output=text | cut -f5)
APPLICATION_TAG_VALUE=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=Application" --region=$REGION --output=text | cut -f5)
TYPE_TAG_VALUE=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=Type" --region=$REGION --output=text | cut -f5)

cat >/etc/profile.d/ec2_tag_env_export.sh << EOL
#!/usr/bin/env bash

export TAG_APPLICATION=$APPLICATION_TAG_VALUE
export TAG_ENVIRONMENT=$ENVIRONMENT_TAG_VALUE
export TAG_TYPE=$TYPE_TAG_VALUE

export PROMPT_COMMAND='printf "\033]0;%s:%s:%s:%s\007" "\${TAG_APPLICATION}" "\${TAG_TYPE}" "\${TAG_ENVIRONMENT}" "\${HOSTNAME%%.*}"'
export PS1="[\u: \W]\\$ "
EOL

chmod 644 /etc/profile.d/ec2_tag_env_export.sh
