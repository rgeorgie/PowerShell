#This script creates Groups in the assignet OU from csv file.
# and alter the existing users...
#Autor W0405552, Rosen Georgiev
#For the purpose of Assig 5 NETW2500
#at:10/30/2018
$objOU=[ADSI]("LDAP://ou=Staff,dc=rbg,dc=it,dc=net172,dc=ca")

#Selects input file - Modify to point to correct file - correct delimiter
$dataSource=import-csv "C:\Sources\NETWUser.csv" -Delimiter '|';
#group the Departments
$dEpt=$dataSource | Select Dept -Unique

#uses foreach to create multiple groups
#loop
$sLdap=$objOU.distinguishedName
echo $sLdap


foreach($gRp in $dEpt) {

#define some variables
$gName=$gRp.Dept
$gRoup=$gName + "_gp"
echo "For department : $gName"
echo "Creating Group $gRoup"
New-ADGroup -Name $gRoup -GroupScope Global -Path "$sLdap"
echo "Group created"
echo "Looking in $sLdap for $gName"
$sUsers=Get-ADUser -SearchBase "$sLdap" -filter {Description -eq $gName}
$sUsername=$sUsers.SamAccountName
echo "Adding users: $sUsername to the group"
Add-ADGroupMember "$gRoup" $sUsername 
echo "Users added to group"
}
Echo "Done"
