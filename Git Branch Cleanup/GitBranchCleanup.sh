#!/bin/bash

read -p "Enter your name: " name

# Define a list of options
options=("View Branches" "View and Delete Branches" "Quit")

# Present the options to the user
PS3="Select an option: "
select opt in "${options[@]}"
do
    case $opt in
        "View Branches")
            to_delete=false
            echo ""
            echo "Displaying branches having Author name like: $name"
            break;;
        "View and Delete Branches")
            to_delete=true
            break;;
        "Quit")
            echo ""
            echo "Exiting..."
            exit 0;;
        *) echo "Invalid option";;
    esac
done

# fetching the branch
echo "----------------------------"
echo "Updating branch with pruning"
git fetch --prune origin
echo "     Branch updated !!!     "
echo "----------------------------"

# Iterating over the branches and filtering it based on the provided name.
git for-each-ref --format='%(authorname)|%(refname)' --sort=authorname refs/remotes | while IFS='|' read -r author refname; do
    if [[ ${author,,} == *${name,,}* ]] && echo $refname | grep -q '^refs/remotes/origin/\(bug\|feature\|fix\)'; then
        echo "<!> $refname to be deleted.<!> ----------- Author: $author.";
        branch_name=$(echo $refname | sed 's/^refs\/remotes\/origin\///')
        if $to_delete; then
            echo "Deleting $branch_name"
            git push origin --delete $branch_name
        fi
    fi
done