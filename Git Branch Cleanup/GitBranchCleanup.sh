#!/bin/bash

read -p "Enter your name ( * for all ): " name

if [[ ${name} == "*" ]]; then
    echo "---------------------------"
    echo "Displaying branches for all"
    view_all=true
else
    if [[ ${name} == "jenkins" ]] then
        echo "---------------------------------------"
        echo "!!Not advised to see jenkins branches!!"
        exit 0
    fi

    view_all=false
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
fi

# fetching the branch
echo "----------------------------"
echo "Updating branch with pruning"
git fetch --prune origin
echo "     Branch updated !!!     "
echo "----------------------------"

if $view_all; then
    git for-each-ref --format='<!> %(refname) <!> ----------- Author: %(authorname).' --sort=authorname refs/remotes/origin \
    | grep -E 'refs/remotes/origin/(bug|feature|fix)' \
    | grep -v 'Author: jenkins.'
else
    # Iterating over the branches and filtering it based on the provided name.
    git for-each-ref --format='%(authorname)|%(refname:short)' --sort=authorname refs/remotes/origin \
        | grep -E 'origin/(bug|feature|fix)' \
        | grep -iE ".*${name}.*\|" \
        | grep -v "jenkins|" \
        | while IFS='|' read -r author branch; do
        
        echo "<!> $branch to be deleted.<!> ----------- Author: $author.";
        if $to_delete; then
            read -p "Delete branch ${branch#origin/}? (y/n): " confirm
            if [[ $confirm == [yY] ]]; then
                echo "Deleting branch ${branch#origin/}..."
                git push origin --delete ${branch#origin/}
            else
                echo "Skipping deletion of branch ${branch#origin/}."
            fi
        fi
    done
fi
