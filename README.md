# mini_sysadmin
Script to automate the process of opening multiple ssh sessions using tmux. While working as assistant student administrator, I had to ssh into multiple machines to manage packages and apps. I was tired of going through the same process multiple times, so I wrote a script. 

The main script takes in a list of hosts as an input. The script checks if the hosts you are trying to connect are up by pinging them. However, you should make sure that the host you are trying to connect has a working ssh connection. 

If everything goes well, you should get a new tmux session named sshs_session with appropriate amount of panes open. In each pane, you can see that it is attempting to connect to a remote host among the list of provided hosts. If you have a ssh key login set up, you will be automatically logged in upon connection. 

## Assumptions 
- You have an admin account with a same password to login to remote hosts. 
- You have a basic familiarity with tmux and its commands. 

## Dependencies 
You need to have tmux 3.4 > and bash 3 > installed. 

## Usage 
Currently supports two functionalities: connecting via ssh and sending files with scp.
```
./open_tmux_bash3.sh ssh username hosts.txt
./open_tmux_bash3.sh scp username hosts.txt file_to_send
```

## Features 
Another problem with ssh login is that some hosts have ssh keys while some do not, which is a problem because you don't want to show others your admin password. You can prevent this by disabling panes. However, there was no built in tmux command to disable a series of pane with one command. 

### Enable/Disable multiple panes
Utilizing the built in tmux command `run-shell`, I have written a helper script that enable users to disable/enable panes by listing the pane numbers. To use the script, one must first invoke the command mode inside tmux:
```
Control-b :
<prefix> :
```
To enable panes, use `-e` flag:
```
run-shell './pane-control -e 5 6 7'
```
The above command enable pane 5, pane 6, pane 7.

To disable panes, use  `-d` flag:
```
ru './pane-control -d 1 5 9
```
The above command disables pane 1, pand 5 pane 9.

The helper script also supports bash range notation:
```
ru './pane-control -d {0..12}'
```
The above command will disable panes 0 to 12. If you specify a range that goes beyond the number of initialized panes, the script will only consider numbers within the number of initialized panes. 

If you do not specify any pane or ranges, every pane is enabled/disabled depending on the flag.

## To do 
- [ ] Invert pane selection
- [x] Have adequate handling of cases when specified pane numbers do not exist. 
- [x] Allow users to give {1..5} to disable panes 1 through 5
- [x] disable or enable all panes 
