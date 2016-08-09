#!/bin/sh
# This is generator script.
#Creates output directory.
#Compiles Source file,Executes the monitoring_system code  and genrates log1.txt

# Check if the command line is empty or not
if [ ! -z "$1" ]&& [ "$1" != " " ];then

#create directory specified by the user
mkdir $1
echo "Compiling source code"

#compile the source code
g++ monitoring_system.cpp
echo "Compilation successful"

#Execute the code and generate the logs 
a.out $1/log1.txt
echo "Logs generatad in $1 directory"
else
echo "Please Enter Valid Data path.Example. ./generate.sh output_dir"
fi

