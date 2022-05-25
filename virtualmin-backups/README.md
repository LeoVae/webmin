# Virtualmin backups disk usage checker
##### Prevent Virtualmin backups filling out your disk
A simple script that will prevent Virtualmin to start a backup if used disk space exceeds the set value (default is 75%).
It will also monitor disk usage during the backup process and interrupt the backup if disk usage gets too high.
This is especially useful for local backups, but could be tweaked to work on remote destinations nas well.

## Configuration
- Go to  Virtualmin >> Backup and Restore >> Scheduled Backups
- Click on the backup(s) name
- Expand "Schedule and reporting" section
- Put the script's location under "Command to run before backup"
- Paste the following under "Command to run after backup":
`\rm -f /tmp/disk_mon_running`

![image](https://user-images.githubusercontent.com/69854305/170172537-8754cafa-ab62-4c69-acd1-d83766e71b2f.png)
