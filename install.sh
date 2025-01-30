#!/bin/bash

#Create Directory
mkdir ~/.config/BashSSH
#Move Config to ~/.config/BashSSH/
mv ./BashSSH.config ~/.config/BashSSH/
#Making BashSSH Executable
chmod +x ./BashSSH
#Moving Script to /bin/
sudo mv ./BashSSH /bin/
#Making non capital alias
sudo cp /bin/BashSSH /bin/bashssh
echo "Done you may now use the command "BashSSH or bashssh""
