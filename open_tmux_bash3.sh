#! /bin/bash 

####################################################################################################
#                                            open tmux                                             #
#                                                                                                  #
#       ssh in to multiple hosts using tmux. This version pings hosts to see if they are up.       #
#      	                                                                                           #
#      	Run command without arguments to see usuage. hosts.txt should be a list of hosts with      #
#      	each host on a line.                                                                       #
#                                                                                                  #
#       Recommended to limit up to 20 hosts for visibility                                         #
#                                                                                                  #
#       author: Changwoo Yu        last modified: 2024-06-19                                       #
#                                                                                                  #
####################################################################################################

#helper function to set up tmux window 
setup_tmux() {
	session_name=$1
	half=$2	

	tmux kill-session -t $session_name 
	tmux new-session -s $session_name \; detach

	#set up rows 
	for i in $(eval echo "{0..$(( $half - 2 ))}"); do 
		tmux attach -t $session_name \; splitw \; select-layout even-vertical \; detach 
		(( index++ ))
	done	
	
	#set up columns
	for j in $(eval echo "{0..$(( $half - 1 ))}"); do 
		(( pane_num = 2 * $j )) 
		tmux attach -t $session_name \; select-pane -t $pane_num \; splitw -h \; detach 
		(( index++ ))
	done
}

#helper function for pinging various hosts in parallel 
ping_host() {
	host=$1
	index=$2
	
	alive=$(ping -c1 $host | grep "100.0% packet loss") 
	
	if [[ -z $alive ]]; then
		echo "$index;up"
	else 
		echo "$index;down" 
	fi 
}

main() {
	#check for arguments 
	if [[ -z $1 ]] || [[ -z $2 ]] || [[ -z $3 ]] ; then 
		echo "usage: ./open_tmux ssh username hosts.txt"
		echo "       ./open_tmux scp username hosts.txt file" 
	else
		list=$3

		#check readability and emptiness of the file 
		if [[ -r $list ]] && [[ -s $list ]]; then 	 
			cmd=$1
			username=$2 
			file=$4
			
			hosts=()

			while read -r line; do 
				hosts+=($line)
			done < $list			
			
			total_hosts=${#hosts[@]} 
	
			hosts_range=$(eval echo $"{0..$(( $total_hosts - 1 ))}")
	
			#check whether hosts are up or down 
			host_status=()
			
			echo Checking Connections...	
			time while read -r line; do 
				tmp=($(echo $line | tr ";" " "))
				index=${tmp[0]}
				state=${tmp[1]} 
				host_status[$index]=$state		 
			done < <(for i in $hosts_range ; do 
						host=${hosts[$i]}
						ping_host $host $i & 
					done)
			
			#for debugging purposes 
			declare -p host_status 

			#create a separate array only with hosts that are up 	
			up_hosts=()

			for i in $hosts_range; do 
				if [[ ${host_status[$i]} == "up" ]]; then 
					up_hosts+=(${hosts[$i]}) 
				fi 
			done  
			
			total_up_hosts=${#up_hosts[@]} 
			(( half=($total_up_hosts + 1) / 2 ))
			(( total_panes=$half * 2 )) 

			#set up tmux session 
			session_name=sshs_session		
			setup_tmux $session_name $half

			#send commands to tmux panes 
			for i in $(eval echo $"{0..$(( $total_up_hosts - 1 ))}"); do 
				host=${up_hosts[$i]}
					
				#send commands 
				if [[ $cmd == "ssh" ]]; then  
					tmux send-keys -t "$session_name:0.$i" $cmd' '-o' 'StrictHostKeyChecking=no' '$username@$host Enter
				else 
					tmux send-keys -t "$session_name:0.$i" ssh' '-o' 'StrictHostKeyChecking=no' '$username@$host Enter
					tmux send-keys -t "$session_name:0.$i" C-c
					tmux send-keys -t "$session_name:0.$i" $cmd' '-o' 'StrictHostKeyChecking=no' '$file' '$username@$host:/Users/$username Enter
				fi
				
			done 
			
			if [[ $total_panes -gt $total_up_hosts ]]; then 
				tmux send-keys -t "$session_name:0.$total_up_hosts" exit Enter 
			fi
			
			#connect to tmux session
			tmux attach -t $session_name \; setw synchronize-panes
		else 
			echo "file does not exist or is empty" 
		fi
	fi
}

main $1 $2 $3 $4
