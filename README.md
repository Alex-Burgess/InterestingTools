# InterestingTools
A collection of random scripts and tools.

## ec2_tags.sh
Script that makes use of the ec2 metadata and AWS CLI to get tag values and export them as environment variables.  Tag values for the tags Application and Environment are exported for use by a bashrc script (see ec2_bashrc below).

Deployment location: ```/etc/profile.d/ec2_tags.sh```

IAM Role and Policy:
```
{
    "Role": {
        "Path": "/",
        "RoleName": "ec2DescribeTags",
        "RoleId": "AROAJ55B77JEVTLKYLBNG",
        "AssumeRolePolicyDocument": {
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
    }
}

{
    "RoleName": "ec2DescribeTags",
    "PolicyName": "DescribeEC2TagsPolicy",
    "PolicyDocument": {
        "Statement": [
            {
                "Action": [
                    "ec2:DescribeTags"
                ],
                "Resource": "*",
                "Effect": "Allow"
            }
        ]
    }
}
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
