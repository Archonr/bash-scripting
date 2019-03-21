## Variables
sign=e00428a1-0c00-11d9-836a-000d93afea2a
file=./createuser.csv

while IFS=, read email first last initials desc
do
    IFS=@ read USER DOMAIN <<< $email
    sudo -u zimbra /opt/zimbra/bin/zmprov ca $email 12345678 zimbraMailHost mail.itftc.com
    sudo -u zimbra /opt/zimbra/bin/zmprov ma $email zimbraCOSid "$sign"
    sudo -u zimbra /opt/zimbra/bin/zmprov ma $email givenName "$last"
    sudo -u zimbra /opt/zimbra/bin/zmprov ma $email sn "$first"
    sudo -u zimbra /opt/zimbra/bin/zmprov ma $email cn "$USER"
    sudo -u zimbra /opt/zimbra/bin/zmprov ma $email initials "$initials"
    sudo -u zimbra /opt/zimbra/bin/zmprov ma $email displayName "$first $last $initials"
    sudo -u zimbra /opt/zimbra/bin/zmprov ma $email description "$desc"
    sudo -u zimbra /opt/zimbra/bin/zmprov ma $email zimbraPasswordMustChange TRUE
    sudo -u zimbra /opt/zimbra/bin/zmmailbox -z -m $USER cm --view contact -F# "/Адресная книга предприятия" galsync.fow7tu2mml /_InternalGAL

done < $file
