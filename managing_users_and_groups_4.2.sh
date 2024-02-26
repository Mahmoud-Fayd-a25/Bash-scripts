#!/bin/bash

function show_user_info() {
    read -p "Enter username: " username
    if id -u "$username" >/dev/null 2>&1; then
        finger "$username" | less
    else
        echo "User '$username' does not exist."
    fi
}

function search_users_groups() {
    read -p "Enter search term: " term
    echo "** Users matching '$term': **"
    grep -i "$term" /etc/passwd | cut -d: -f1,5
    echo "** Groups matching '$term': **"
    grep -i "$term" /etc/group | cut -d: -f1
}

function show_logs() {
    # Define the log file path (replace with the actual log path)
    log_file="/var/log/user_group_management.log"

    # Check if the log file exists
    if [[ -f "$log_file" ]]; then
        # Display the log file using a pager
        less "$log_file"
    else
        echo "Log file not found: $log_file"
    fi
}

function handle_user_choice() {

    read -p "Enter your choice: " choice

    select user_choice in "Add User" "Remove User" "Modify User" "Back" Quit; do

        case $REPLY in
        1)
            # Prompt for username and password
            read -p "Enter username: " username
            read -sp "Enter password: " password

            # Create user with a home directory
            useradd -m "$username"

            # Set password for the user
            echo "$username:$password" | chpasswd

            # Display success message
            echo "User $username has been created successfully."
            ;;
        2)
            # Prompt for username to remove
            read -p "Enter username to remove: " username

            # Check if user exists
            if ! id -u "$username" >/dev/null 2>&1; then
                echo "User $username does not exist."
                exit 1
            fi

            # Confirm removal
            read -p "Are you sure you want to remove user $username? (y/n): " confirmation

            if [[ $confirmation =~ ^[Yy]$ ]]; then
                # Remove user and home directory
                userdel -r "$username"
                echo "User $username has been removed successfully."
            else
                echo "User removal canceled."
            fi
            ;;
        3)

            # Prompt for username to modify
            read -p "Enter username to modify: " username

            # Check if user exists
            if ! id -u "$username" >/dev/null 2>&1; then
                echo "User $username does not exist."
                exit 1
            fi

            # Display modification options
            echo "What do you want to modify?"
            echo "1) Change username"
            echo "2) Change home directory"
            echo "3) Add user to a group"
            echo "4) Change shell"
            echo "5) Lock/unlock account"
            echo "6) Set expiry date"
            echo "7) Change password"
            echo "8) Expire password"
            echo "0) Exit"
            read -p "Enter your choice: " choice

            case $choice in
            1) # Change username
                read -p "Enter new username: " new_username
                usermod -l "$new_username" "$username"
                echo "Username for $username has been changed to $new_username."
                ;;
            2) # Change home directory
                read -p "Enter new home directory: " new_home_directory
                usermod -d "$new_home_directory" "$username"
                echo "Home directory for $username has been changed to $new_home_directory."
                ;;
            3) # Add user to a group
                read -p "Enter group name: " group_name
                usermod -aG "$group_name" "$username"
                echo "User $username has been added to group $group_name."
                ;;
            4) # Change shell
                read -p "Enter new shell: " new_shell
                usermod -s "$new_shell" "$username"
                echo "Shell for $username has been changed to $new_shell."
                ;;
            5) # Lock/unlock account
                read -p "Lock or unlock account (l/u)? " lock_unlock
                if [[ $lock_unlock =~ ^[Ll]$ ]]; then
                    usermod -L "$username"
                    echo "Account $username has been locked."
                else
                    usermod -U "$username"
                    echo "Account $username has been unlocked."
                fi
                ;;
            6) # Set expiry date
                read -p "Enter expiry date (YYYY-MM-DD): " expiry_date
                usermod -e "$expiry_date" "$username"
                echo "Expiry date for account $username has been set to $expiry_date."
                ;;
            7) # Change password
                read -sp "Enter new password: " password
                echo "$username:$password" | chpasswd
                echo "Password for $username has been changed successfully."
                ;;
            8) # Expire password
                usermod -e 1 "$username"
                echo "Password for $username has been expired."
                ;;
            0) # Exit
                echo "Exiting user modification."
                ;;
            *)
                echo "Invalid choice."
                ;;
            esac

            ;;
        4) break ;; # Back

        *) echo "Invalid choice, please try again." ;;
        esac
    done
}

function handle_group_choice() {

    read -p "Enter your choice: " choice

    select group_choice in "Add Group" "Remove Group" "Modify Group" "Back" Quit; do

        case $REPLY in
        1)
            # Prompt for username and password
            read -p "Enter username: " username
            read -rsp "Enter password: " password

            # Create user with a home directory
            useradd -m "$username"

            # Set password for the user
            echo "$username:$password" | chpasswd

            # Display success message
            echo "User $username has been created successfully."

            ;;
        2)
            # Prompt for group name to remove
            read -p "Enter group name to remove: " group_name

            # Check if group exists
            if ! getent group "$group_name" >/dev/null 2>&1; then
                echo "Group $group_name does not exist."
                exit 1
            fi

            # Confirm removal
            read -p "Are you sure you want to remove group $group_name? (y/n): " confirmation

            if [[ $confirmation =~ ^[Yy]$ ]]; then
                # Remove the group
                groupdel "$group_name"
                echo "Group $group_name has been removed successfully."
            else
                echo "Group removal canceled."
            fi

            ;;
        3)

            # Prompt for group name to modify
            read -p "Enter group name to modify: " group_name

            # Check if group exists
            if ! getent group "$group_name" >/dev/null 2>&1; then
                echo "Group $group_name does not exist."
                exit 1
            fi

            # Display modification options
            echo "What do you want to modify?"
            echo "1) Change group ID"
            echo "2) Change group name"
            echo "3) Add users to group"
            echo "4) Remove users from group"
            echo "0) Exit"
            read -p "Enter your choice: " choice

            case $choice in
            1) # Change group ID
                read -p "Enter new group ID: " new_group_id
                groupmod -g "$new_group_id" "$group_name"
                echo "Group ID for $group_name has been changed to $new_group_id."
                ;;
            2) # Change group name
                read -p "Enter new group name: " new_group_name
                groupmod -n "$new_group_name" "$group_name"
                echo "Group name has been changed to $new_group_name."
                ;;
            3) # Add users to group
                while true; do
                    read -rp "Enter username to add (or press Enter to finish): " username
                    if [[ -z "$username" ]]; then
                        break
                    fi
                    gpasswd -a "$username" "$group_name"
                    echo "User $username has been added to group $group_name."
                done
                ;;
            4) # Remove users from group
                while true; do
                    read -p "Enter username to remove (or press Enter to finish): " username
                    if [[ -z "$username" ]]; then
                        break
                    fi
                    gpasswd -d "$username" "$group_name"
                    echo "User $username has been removed from group $group_name."
                done
                ;;
            0) # Exit
                echo "Exiting group modification."
                ;;
            *)
                echo "Invalid choice."
                ;;
            esac

            ;;
        4) break ;; # Back

        *) echo "Invalid choice, please try again." ;;
        esac
    done
}

while true; do
    clear
    echo "User and Group Management Script"
    echo "------------------------------"

    PS3="Select your choice: "

    options=(
        "Display User Information"
        "Search Users/Groups"
        "Manage Users"
        "Manage Groups"
        "Logs"
        "Exit"
    )
    select option in "${options[@]}"; do
        case $REPLY in
        1)
            clear
            echo "User Information"
            echo "---------------"
            show_user_info
            break
            ;;
        2)
            clear
            echo "Search for User or Group"
            echo "---------------"
            search_users_groups
            break
            ;;
        3)
            clear
            echo "User Management"
            echo "---------------"
            handle_user_choice
            break
            ;;
        4)
            clear
            echo "Group Management"
            echo "---------------"
            handle_group_choice
            break
            ;;
        5)
            clear
            echo "Show logs"
            echo "---------------"
            show_logs
            break
            ;;
        6)
            break 2 # Exit both loops
            ;;
        *)
            echo "Invalid choice, please try again."
            ;;
        esac
    done
done

echo "Exiting User and Group Management Script"
