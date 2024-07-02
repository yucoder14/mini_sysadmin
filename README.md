# mini_sysadmin
Script to automate opening multiple ssh sessions using tmux. While working as assistant student administrator, I had to ssh into multiple machines to manage packages and apps. I was tired of going through the same process multiple times, so I wrote a script. 

The main script takes list of hosts to ssh into as an input. Make sure that the host you are trying to connect has a working ssh connection. 

## Dependencies 
You need to have tmux and bash installed. 

## Usage 
```
./open_tmux_bash3.sh ssh username hosts.txt
./open_tmux_bash3.sh scp username hosts.txt file_to_send
```
