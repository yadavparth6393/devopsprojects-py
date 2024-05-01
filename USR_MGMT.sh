#!/bin/bash

<<Comment_1
This script is for the user Management and Backup.
Comment_1


function display_options {

 echo "The below are all the options you can use to perform the tasks"
 echo " " 
 echo " -c , --create,    create a new user account "
 echo " -d , --delete,    delete an existing user account "
 echo " -r , --reset ,    reset password for the existing user account "
 echo " -g , --group ,    changes the user group "
 echo " -l , --list ,     lists all the user accounts present in the system "
 echo " -b , --backup,    takes the backup of the specified files" 
 
}

function create_user {
	read -p "Enter the username: " username

        if id $username &> /dev/null; then
        
         echo "Error the user $username already exists"

        else 

         read -p "Enter the password for the user: " password
         
	  while [ -z "$password" ]; do
            echo "Error: Password cannot be empty"
            read -p "Enter the password for the user: " password
          done
         
	  
	 useradd -m -p "$password" "$username"  
         echo "User account $username is successfully created" 
        
	fi

}


function delete_user {
 read -p "Enter the user to be deleted" usertodelete
 
 if id $usertodelete &> /dev/null; then
	echo "Deleting the user"
       userdel -r $usertodelete
 else
    echo "the user does not exists"

 fi    

}

function password_change {
 read -p "Enter the user to change the password" userforpass
 if id $userforpass &> /dev/null; then
	 echo "Changing the password"
         read -p "Enter the password for the $userforpass to change" password
         echo "$userforpass:$password" | sudo chpasswd
	 echo "password changes successfully"

 else 
	echo "user does not exist so password cannot be changed"

 fi
}


function list_users {

 echo "user accounts on the system are as mentioned below." 
 cat /etc/passwd | awk -F ':' '{print "name: "$1 "" " UID : "$3" "}' 

}

function user_group {

 
read -p "Enter the username to change the group" group_user
 if id $group_user &> /dev/null; then
	 read -p "enter the group to be added" group
         usermod -aG $group $group_user 
 else 
	 echo "the user does not exist"
 fi
 
}

function backup {

 read -p "Enter the directorypath to be backedup " $src_dir
 read -p "Enter the target path to store the backup " $dst_dir

 filename="Backupfile$(date +%Y-%m-%d-%H-%M-%S).tar.gz"

 tar -czvf "${dst_dir}/${filename}" "$src_dir" 

}



if [ $# -eq 0 ] || [ $1 = "-h" ] || [ $1 = "--help" ]; then

	display_options
	
	exit 0
fi

while [ $# -gt 0 ]; do
	case "$1" in

		-c | --create)
			create_user
		        ;;

		-d | --delete)
			delete_user
			;;
                -r | --reset)
			password_change
			;;
		-g | --group)
			user_group
			;;
		-l | --list)
			list_users
			;;
		-b | --backup)
			backup
			;;

		*)
			echo"Error invalid option. Use --help to see available options"
			exit 1
			;;
	esac
	shift

done



