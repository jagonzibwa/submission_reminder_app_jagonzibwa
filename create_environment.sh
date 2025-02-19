#!/bin/bash
echo -e "What is your name?"
read student_name
mkdirsub="submissions_reminder_$name"
mkdir $mkdirsub
mkdir -p $mkdirsub/{app,models,config,assets}
cat <<'EOF' > $mkdirsub/models/functions.sh
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
'EOF'
cat <<'EOF' > $mkdirsub/app/reminder.sh
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
'EOF'
cat <<'EOF' > $mkdirsub/assets/submissions.txt
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Joshua, Shell Basics, not submitted
Harmony, Shell Basics, not submitted
Habeeb, Shell Basics, not submitted
Towi, Git, submitted
Larry, Git, submitted
'EOF'
cat <<'EOF' > $mkdirsub/config/config.env
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
'EOF'
cat <<'EOF' > $mkirsub/startup.sh
#!/bin/bash
bash ./app/reminder.sh
