#!/bin/sh

#This is the query script. Used to Query CPU usage for particular time ranges.
#Validates the command
#Displays 'help' on usage
#Any invalid data or commands are handled and Proper usage are displayed on screen.

#Navigate to DATA_PATH.If empty directory is given prompt user to provide correct DATA PATH
if [ -z "$1" ] || [ "$1" == " " ];
then
	echo "Please provide proper command.Example-  ./query.sh DATA_PATH"
	exit
fi

#Navigate to proper DATA_PATH provide in command line
cd $1 || exit 

#Valid commands
command1="QUERY"
command2="EXIT"

#while loop flag to continuously take user commands
again=1
while [ $again -eq 1 ]
do 
	echo -n ">"
	read query
	
	#Split and store the fields given in query to respective variables
	IFS=' ' read command ip cpu_id s_date s_time d_date d_time <<< "$query"

	#ignore case.Accept both QUERY,query or EXIT or exit
	shopt -s nocasematch
	
	#if query
	if [[ "$command" == "$command1" ]];
	then
		#validate the fields given in command
		if [ -z "$command" ] || [ -z "$ip" ] || [ -z "$cpu_id" ] || [ -z "$s_date" ] || [ -z "$s_time" ] || [ -z "$d_date" ] || [ -z "$d_time" ];
		then
			echo "Please enter valid command.Type help to see command usage !"
			continue
		fi
		
		#store source time and destination time in unixtime
		s_unixtime=$(date -ud "$s_date $s_time" "+%s")
		d_unixtime=$(date -ud "$d_date $d_time" "+%s")
		
		#flag variable to print CPUx usage only once on screen
		flag=1
		
		#result_found flag to display message to user if no output
		result_found=0

		#Traverse and collect cpu usage for the give range of times
		for ((i=$s_unixtime;i<$d_unixtime;i=i+60))
		do
			#find the data in the log 
			result=$(grep "$i * $ip * $cpu_id" log1.txt)
			
			#if nothing is found display message to user
			if [ -z "$result" ];
			then
				echo "No data found. Possible reasons could be either data not found for the given input or Invalid command."
				echo "Type Help to see the commands and format of query"
				break
			fi
			
			result_found=1
			IFS=' ' read r_unixtime r_ip r_cpu_id r_cpu_usage <<< "$result"
			
			#Prints the result on console
			if [ $flag -eq 1 ];
			then
				echo "CPU$r_cpu_id usage on $r_ip:"
				flag=0
			fi
	
			#convert back the unixtime to GMT
			r_date=$(date -ud @$r_unixtime  '+%Y-%m-%d %H:%M')
			echo -n "($r_date,$r_cpu_usage),"
		done

		#If invalid time stamps given or invalid dates
		if [ $result_found -eq 0 ];
		then
	        	echo "No data found. Possible reasons could be either data not found for the given input or Invalid input or Invalid Command."
	                echo "Type Help to see the commands and format of query"			
		fi
	
		echo ""
	#if EXIT
	elif [[ "$command" == "$command2" ]];
	then
		again=0

	#HELP message to user
	else
		echo "COMMANDS are QUERY or EXIT only!!Please try again "
		echo "Example- QUERY IP CPU_ID start_time end_time"
		echo "IP in the ranges 192.168.1.1 to 1.255, 192.168.2.1 to 2.255, 192.168.3.1 to 3.255, 192.168.4.1 to 4.235"
		echo "CPU_ID is 0 or 1"
		echo "start_time  and end_time are in YYYY-MM-DD HH:MM and start_time < end_time "
		echo "DATA available only for 24 hrs of CPU USAGE for the day 2014-10-31"
	fi
done
echo ""

