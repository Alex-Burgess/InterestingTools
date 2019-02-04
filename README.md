# UsefulTools
A collection of random scripts and tools.

## ec2_tags.sh
I wanted an automated way of better managing terminal windows and using the tags of an instance seemed like a natural solution.  The terminal title and command prompt are controlled by the $PROMPT_COMMAND and $PS1 environment variables, of which, the defaults are set in ```/etc/bashrc``` which is not recommended to modify.  So the idea instead, is to run a script in /etc/profile.d which will set the $PROMPT_COMMAND and $PS1 variables with tag values.

Note: it is possible to set the $PROMPT_COMMAND and $PS1 variables manually, but I found this to not be that effective.  For a start they have to be set for every SSH session and also for every user in that session. When manually setting them, I found that I would set the environment variables for the ec2-user, but the sudo to root and the title would change. So, automation!

The tag data is retrieved from an AWS CLI command, so an IAM instance profile is required to permission the ec2 instance to describe tags.

After deploying the script to ```/etc/profile.d``` I found that ssh times were impacted, but the only method of setting environment variables persisently for all users was to export the variables from a script within ```/etc/profile.d```.  So, the solution was deploy the script to ```/usr/local/bin``` and run the script from cron on start/restart which produced a very minimal script in ```/etc/profile.d``` which just performed the exports.

In this script, I make use of tags named Application, Environment and Type, but the script is extensible and different tags could be used. An example of a title and prompt is:

Title: ```hello-world:test:ip-172-31-18-3```
Command prompt: ```[ec2-user: ~]$*````

### Manual Deployment steps
1. Create IAM instance profile (below)
1. Deploy ec2_tags.sh to /usr/local/bin
1. Add line in crontab: @reboot /usr/local/bin/ec2_tags.sh
1. Reboot instance
1. SSH to instance to verify title and prompt

Procedure to create IAM instance profile:

1. Create *Role-Policy.json* with content:
      ```
      {
          "Version": "2012-10-17",
          "Statement": [
             {
                  "Effect": "Allow",
                  "Principal": {
                      "Service": "ec2.amazonaws.com"
                  },
                  "Action": "sts:AssumeRole"
             }
          ]
      }
      ```
1. Create role:
      ```
      aws iam create-role --role-name EC2-Describe-Tags --assume-role-policy-document file://Role-Policy.json
      ```
1. Create *Policy-Document.json* with content:
      ```
      {
          "Version": "2012-10-17",
          "Statement": [
              {
                  "Action": [
                      "ec2:DescribeTags"
                  ],
                  "Effect": "Allow",
                  "Resource": "*"
              }
          ]
      }
      ```
1. Create policy:
      ```
      aws iam put-role-policy --role-name EC2-Describe-Tags --policy-name EC2-Describe-Tags-Policy --policy-document file://Policy-Document.json
      ```
1. Create IAM Instance profile
      ```
      aws iam create-instance-profile --instance-profile-name EC2-Describe-Tags-Instance-Profile
      aws iam add-role-to-instance-profile --instance-profile-name EC2-Describe-Tags-Instance-Profile --role-name EC2-Describe-Tags
      ```
1. Create an EC2 Instance with profile:
      ```
      aws ec2 run-instances
       --image-id ami-xxxxxxxx \
       --count 1 \
       --instance-type t2.micro \
       --key-name MyKeyPair \
       --security-group-ids sg-xxxxxxxx \
       --subnet-id subnet-xxxxxxxx \
       --iam-instance-profile Name=EC2-Describe-Tags-Instance-Profile \
       --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=MyInstance}]'
      ```

### Cloudformation Demo Stack Deployment steps
ec2_tags_demo.template shows one common method to easily include this script into your instances with user data.

1. Create the stack:
      ```
      $ aws cloudformation create-stack \
       --stack-name ec2TagsDemo \
       --template-body file://ec2_tags_demo.template \
       --capabilities CAPABILITY_NAMED_IAM \
       --parameters ParameterKey=SecurityGroupID,ParameterValue=sg-xxxxxxxx \
        ParameterKey=ImageID,ParameterValue=ami-0eafb5ee12a2cbffc \
        ParameterKey=SubnetID,ParameterValue=subnet-xxxxxxxx \
        ParameterKey=AppName,ParameterValue=Ec2TagsDemo
      ```
