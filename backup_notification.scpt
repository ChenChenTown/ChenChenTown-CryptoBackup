-- AppleScript to display a notification with a "Backup Now" button
display notification "Don't forget to run the backup script to keep your data safe." with title "Backup Reminder" subtitle "Click 'Backup Now' to start the backup process."

-- Wait for the user to click the "Backup Now" button
set response to button returned of (display dialog "Click 'Backup Now' to start the backup process." buttons {"Backup Now"} default button "Backup Now")

-- Check the response
if response is "Backup Now" then
    -- Execute the backup shell script in a new terminal window
    do shell script "osascript -e 'tell application \"Terminal\" to do script \"/path/to/your/backup.sh\"'"
end if
