# InterestingTools
A collection of random scripts and tools

## ec2_bashrc
Script that makes management of terminal windows easier, which typically gets used in my AMIs.  The default /etc/bashrc script overwrites the window title every command, making it not possible to set a declarative title.  When present on an ec2 instance, it modifies the title and command prompt, for example:

Title: ```hello-world:test:ip-172-31-18-3```
Command prompt: ```[ec2-user: ~]$*````

How to deploy:
1. Copy file to instance:
      ```
      $ scp ec2_bashrc ec2-user@<public-ip>:/tmp/ec2_bashrc
      ```
1. Backup existing file:      
      ```
      $ sudo cp /etc/bashrc /etc/bashrc.bak
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
