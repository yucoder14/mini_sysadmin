# mini_sysadmin
Script to automate opening multiple ssh sessions using tmux. While working as assistant student administrator, I had to ssh into multiple machines to manage packages and apps. I was tired of going through the same process multiple times, so I wrote a script. 

The main script takes list of hosts to ssh into as an input. Make sure that the host you are trying to connect has a working ssh connection. The script does check if the hosts you are trying to connect are up by pinging them. 

If everything goes well, you should get a new tmux session named sshs_session with appropriate amount of panes open, with each pane connected to or prompting your to enter password to connect to unique hosts. All the panes are synchronized to begin with. 

## Assumptions 
You have an admin account with same password to login remotely to hosts. 

## Dependencies 
You need to have tmux and bash installed. 

## Usage 
Currently supports two functionalities: connecting via ssh and sending files with scp.
```
./open_tmux_bash3.sh ssh username hosts.txt
./open_tmux_bash3.sh scp username hosts.txt file_to_send
```

## Features 
Another problem with ssh login is that some hosts have ssh keys while some do not, which is a problem because you don't want to show others your admin password. 
