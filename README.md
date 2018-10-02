# InterestingTools
A collection of random scripts and tools.

## ec2_tags.sh
Script that makes use of the ec2 metadata and AWS CLI to get tag values and export them as environment variables.  Tag values for the tags Application and Environment are exported for use by a bashrc script (see ec2_bashrc below).

Deployment location: ```/etc/profile.d/ec2_tags.sh```

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

      ```

## ec2_bashrc
The purpose of this script is to enable easier management of terminal windows. The default /etc/bashrc script overwrites the window title every command, making it not possible to set a declarative title.  This script can be combined with ec2_tags.sh (see above) to use specific tag values to label terminal windows in an extensible fashion.  Specifically the Application and Environment tags are used to populate the terminal window title.  An example of this is:

Title: ```hello-world:test:ip-172-31-18-3```
Command prompt: ```[ec2-user: ~]$*````

Deployment location: ```/etc/bashrc```

How to deploy:
1. Copy file to instance:
      ```
      $ scp ec2_bashrc ec2-user@<public-ip>:/tmp/ec2_bashrc
      ```
1. Backup existing file:      
      ```
      $ sudo cp /etc/bashrc /etc/bashrc.orig
      ```
1. Sanity check file:
      ```
      $ sudo diff /etc/bashrc /tmp/ec2_bashrc
      ```
1. Copy over new file:
      ```
      $ sudo cp /tmp/ec2_bashrc /etc/bashrc
      ```
1. Open a new terminal window and SSH to instance.
