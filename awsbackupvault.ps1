#Establish the region and the name of the vault
$Region = Read-Host "Please provide the region name where the vault is located: "

#Get a list of the backupvaults
$Vaults = (Get-BAKBackupVaultList -Region $Region).BackupVaultName
Write-Host "The following vaults exist in the region: " $Vaults

#Get the backups in the backupvault
$Vault = Read-Host "Please provide the name of the backup vault: "
$TD = Read-Host "Type Before Date in mm-dd-yyyy formart"

$BeforeDate = [DateTime]::Parse($TD)

#Get a list of all backups in the vault that will be deleted
$arns = (Get-BAKRecoveryPointsByBackupVaultList -BackupVaultName $Vault -region $Region -ByCreatedBefore $BeforeDate | Where-Object {$_.ResourceType -Like "EC2"}).RecoveryPointARN

Write-Host "The following ARNs matched your criteria:"
foreach($arn in $arns)
{
    Write-Host $arn

}

 
 $Choice = Read-Host "Would you like to delete all the backup recovery points? (Y/N)"

 if ($Choice -eq 'Y')
 {
     foreach($arn in $arns) 
    {
        write-host "Deleting the following recovery point: " $arn
        Remove-BAKRecoveryPoint -BackupVaultName $Vault -Region $Region -RecoveryPointArn $arn -force
    }

 }
 else {write-Host "GoodBye!"}
 
 