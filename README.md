# Git branch cleanup utility

This script provides options to view and manage Git branches based on the author's name. It allows you to either view
branches created by a specific author or view and delete branches created by that author.

## Usage

To run this script, you need to have **Git** and **Bash shell** installed on your machine.

1. Copy the .sh file to the location of git repository.
2. Run the script in a terminal.
   ```sh
    ./GitBranchCleanup.sh
   ```
3. Enter the author's name when prompted. ( This name is compared case-insensitively and uses a partial match (i.e.,
   checking if the input name contains the author's name ) )
4. Choose an option:
    * **View Branches**: Display branches created by the specified author.
    * **View and Delete Branches**: Display and delete branches created by the specified author.
    * **Quit**: Exit the script.

Note: Deleting branches is irreversible. Use with caution.

## Caution

* Ensure you have permission to delete branches before using the "View and Delete Branches" option.
* Always review the branches to be deleted before confirming.