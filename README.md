# mini_sysadmin
Script to automate opening multiple ssh sessions using tmux. While working as assistant student administrator, I had to ssh into multiple machines to manage packages and apps. I was tired of going through the same process multiple times, so I wrote a script. 

The main script takes list of hosts to ssh into as an input. Make sure that the host you are trying to connect has a working ssh connection. The script does check if the hosts you are trying to connect are up by pinging them. 

If everything goes well, you should get a new tmux session named sshs_session with appropriate amount of panes open, with each pane connected to or prompting your to enter password to connect to unique hosts. All the panes are synchronized to begin with. 

## Assumptions 
You have an admin account with same password to login remotely to hosts. 

## Dependencies 
You need to have tmux 3.4 > and bash 3 > installed. 

## Usage 
Currently supports two functionalities: connecting via ssh and sending files with scp.
```
./open_tmux_bash3.sh ssh username hosts.txt
./open_tmux_bash3.sh scp username hosts.txt file_to_send
```

## Features 
Another problem with ssh login is that some hosts have ssh keys while some do not, which is a problem because you don't want to show others your admin password. You can prevent this by disabling panes. However, there was no builting tmux command to disable a list of panes. 

### Enable/Disable multiple panes
Utilizing the built in tmux command `run-shell`, I have written helper scripts that enable users to disable/enable panes by listing the pane numbers. To use the scripts, one must first invoke the command mode inside tmux:
```
Control-b :
<prefix> :
```

`-e` flag enables while `-d` flag disables pane(s).

Then, at the command line,
```
run-shell './pane-control -d 0 1 2'
ru './pane-control -e 5 6 7'
```
to disable pane 0, pane 1, pane 2 and enable pane 5, pane 6, pane 7. 

The helper script also supports bash range notation
```
ru './pane-control -d {0..12}'
```
will disable panes 0 to 12, or up to the maximum amount of panes in the session. 

If you do not specify any pane or ranges, every pane is enabled/disabled depending on the flag.

## To do 
- [x] Have adequate handling of cases when specified pane numbers do not exist. 
- [x] Allow users to give {1..5} to disable panes 1 through 5
- [ ] Invert pane selection
- [x] disable or enable all panes 
