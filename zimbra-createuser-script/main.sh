#!/bin/bash

sign=e00428a1-0c00-11d9-836a-000d93afea2a
file=./createuser.csv
date=$(date)
log=/var/log/createuser.log

if [ -s $file ]
then
    while IFS=, read email first last initials desc org position telephone
    do
        IFS=@ read USER DOMAIN <<< $email
        vara=$(sudo -u zimbra /opt/zimbra/bin/zmprov ca $email 12345678 zimbraMailHost hostname 2>&1)
        if  [ $? -ne 0 ]
        then
            echo -e "This user $email alredy use" - $date >> $log
        else
            sudo -u zimbra /opt/zimbra/bin/zmprov ma $email zimbraCOSid "$sign"
            sudo -u zimbra /opt/zimbra/bin/zmprov ma $email givenName "$last"
            sudo -u zimbra /opt/zimbra/bin/zmprov ma $email sn "$first"
            sudo -u zimbra /opt/zimbra/bin/zmprov ma $email cn "$USER"
            sudo -u zimbra /opt/zimbra/bin/zmprov ma $email initials "$initials"
            sudo -u zimbra /opt/zimbra/bin/zmprov ma $email displayName "$first $last $initials"
            sudo -u zimbra /opt/zimbra/bin/zmprov ma $email description "$desc"
            sudo -u zimbra /opt/zimbra/bin/zmprov ma $email company "$org"
            sudo -u zimbra /opt/zimbra/bin/zmprov ma $email title "$posotion"
            sudo -u zimbra /opt/zimbra/bin/zmprov ma $email telephoneNumber "$telephone"
            sudo -u zimbra /opt/zimbra/bin/zmprov ma $email zimbraPasswordMustChange TRUE
            sudo -u zimbra /opt/zimbra/bin/zmmailbox -z -m $USER cm --view contact -F# "/Address book" galsync.fow7tu2mml /_InternalGAL
            echo -e "User $email created!" - $date >> $log
        fi
    done < $file

else
    echo "No users to create in mailsystem Zimbra" - $date >> $log
fi

