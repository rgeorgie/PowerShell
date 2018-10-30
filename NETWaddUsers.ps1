#This script was modifyed by W0405552, Rosen Georgiev
#For the purpose of Assig 5 NETW2500
#at:10/30/2018
#Selects domain and identifies path - modify to match exisiting domain structure
$objOU=[ADSI]("LDAP://ou=Staff,dc=rbg,dc=it,dc=net172,dc=ca")
#Selects input file - Modify to point to correct file
$dataSource=import-csv "C:\Sources\NETWUser.csv" -Delimiter '|';
#uses foreach to create multiple users
#loop
foreach($dataRecord in $dataSource) {
#define some variables
#Given Name
$givenName=$dataRecord.FirstName
#Surname
$sn=$dataRecord.LastName
#Initials
$iNits=$dataRecord.MiddleInitial
#First Initial
$fIn=$dataRecord.FirstInitial
#Department
$dept=$dataRecord.Dept
#Domain name
$fQDn=$env:USERDNSDOMAIN
#turn the variable to lowercase
$fQDn=$fQDn.ToLower()
#Modify this section to create the required convention for your Common Name
$cn=$fIn + “ ” + $sn
#Modify this section to create your SAM account name to follow guidelines of naming convention
$sAMAccountName=$fIn + $sn
#turn the variable to lowercase
$sAMAccountName=$sAMAccountName.ToLower()
#Modify this section to create the require convention for your Display Name
$displayName=$sn + “, ” + $givenName
#Principal
$userPrincipalName=$sAMAccountName + “@” + $fQDn;
#Additional Attributes
$objUser=$objOU.Create(“user”,”CN=”+$cn)
#$objUser.Put(“path”,$OU)
$objUser.Put(“sAMAccountName”,$sAMAccountName)
$objUser.Put(“userPrincipalName”,$userPrincipalName)
$objUser.Put(“displayName”,$displayName)
$objUser.Put(“givenName”,$givenName)
$objUser.Put(“sn”,$sn)
$objUser.Put(“Initials”,$iNits)
$objUser.Put(“description”,$dept)
$objUser.Put(“department”,$dept)
#Places the additional attributes into the record
$objUser.SetInfo()
$objUser.SetPassword(“Netw@2500”) ;
$objUser.psbase.InvokeSet(“AccountDisabled”,$false)
$objUser.SetInfo()
}
