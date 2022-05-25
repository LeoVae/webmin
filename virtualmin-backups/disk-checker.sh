#!/bin/bash

############################ Script setup #################################
#     -> Go to  Virtualmin >> Backup and Restore >> Scheduled Backups     #
#     -> Click on the backup(s) name                                      #
#     -> Expand "Schedule and reporting section"                          #
#     -> Put the script's location under "Command to run before backup"   #
#     -> Paste the following under "Command to run after backup":         #
#               \rm -f /tmp/disk_mon_running                              #
###########################################################################

# Don't start the backup if disk usage is higher than given percentage
precheck_limit=75

# Interrupt the running backup if disk usage percentage reaches the given value
# Default value: 93
running_limit=93

# Location to check the disk space from
# Default: /
check_loc=/

calc_disk () {
        current_usage=$(df ${check_loc} | awk '{print $5}' | grep -Eo '[0-9]{1,4}')
}

calc_disk
if [[ ${current_usage} -gt ${precheck_limit} ]]; then
        echo "Unable to start backup due to precheck fail: ${current_usage}% disk used"
        date
        exit 1
fi

# Watch disk usage during the running backup
touch /tmp/disk_mon_running
monitor_disk () {
        while test -f /tmp/disk_mon_running; do
                calc_disk
                if [[ ${current_usage} -lt ${running_limit} ]]; then
                        sleep 15
                else
                        echo "Backup interrupted due to insufficient disk space: ${current_usage}% disk used"
                        date
                        rm -f /tmp/disk_mon_running
                        exit 1
                fi
        done
}
test -f /tmp/disk_mon_running && monitor_disk &
