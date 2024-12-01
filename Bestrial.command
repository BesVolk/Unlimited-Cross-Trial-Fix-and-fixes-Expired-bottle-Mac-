#!/bin/bash

echo "
                _\|/_
                (o o)
 +-----------oOO-{_}-OOo------------+
 |                                  |
 |       Welcome to BesTrial!       |
 |    Do you want to reset the      |   
 |    trial for CrossOver? (Y/N)    |
 |                                  |
 +----------------------------------+
"

while true; do
    read -p "Respond: " -n 1 -s choice
    echo  # This ensures a new line is added after the user's input
    if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
        echo "Proceeding to reset the trial..."
        chmod +x Bestrial.sh
        break
    elif [[ "$choice" == "n" || "$choice" == "N" ]]; then
        echo "Trial reset canceled."
        exit 0
    else
        echo -e "\rYou need to type 'Y' or 'N'. Please try again.    "
    fi
done

original_date=$(plutil -extract FirstRunDate xml1 /Users/tomasmekonnen/Library/Preferences/com.codeweavers.CrossOver.plist -o - | sed -n 's:.*<date>\(.*\)</date>.*:\1:p')

current_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

current_year=$(date +"%Y")
current_month=$(date +"%m")
current_day=$(date +"%d")

day_minus_one=$((current_day - 1))

if [ $day_minus_one -lt 10 ]; then
    day_minus_one="0$day_minus_one"
fi

modified_date=$(echo "$original_date" | sed "s/^[0-9]\{4\}/$current_year/" | sed "s/\([0-9]\{4\}\)-[0-9]\{2\}-[0-9]\{2\}/\1-$current_month-$day_minus_one/")

plutil -convert xml1 /Users/tomasmekonnen/Library/Preferences/com.codeweavers.CrossOver.plist
sed -i '' "s|<date>.*</date>|<date>$modified_date</date>|" /Users/tomasmekonnen/Library/Preferences/com.codeweavers.CrossOver.plist

cd ~/Library/Application\ Support/CrossOver/Bottles

for dir in */; do
    if [ -d "$dir" ] && [ "$(ls -A "$dir")" ]; then
        cd "$dir"
        
        rm -f .*
        
        cd ..
    fi
done

echo "Completed! You now have a 13-day trial. Enjoy!"
