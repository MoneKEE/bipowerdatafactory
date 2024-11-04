<#
.SYNOPSIS
    Remove/Apply Resource Group Locks during release process (CICD)
.DESCRIPTION
    The script can be used to remove rg locks before deployment and reapply lock afterwards.
.PARAMETER ResourceGroupName
    Name of the target resource group
.PARAMETER LockName
    Name of the lock
.PARAMETER PreDeployment
    Default: $true
    True: Runs the script as predeployment, removing the lock from the resource group
    False: Runs the script as post-deployment, setting a non-Delete lock on the resource group
.PARAMETER LockNotes
    Default: "This resource group contains production-level resources and should not be deleted"
#>
param
(
    [parameter(Mandatory=$true)] [String] $ResourceGroupName,
    [parameter(Mandatory=$true)] [String] $LockName,
    [parameter(Mandatory=$false)] [Bool] $PreDeployment = $true,
    [parameter(Mandatory=$false)] [String] $LockNotes = "This resource group contains production-level resources and should not be deleted"
    #[parameter(Mandatory=$true)] [String] $Scope

)

if ($PreDeployment -eq $true) {
    # Remove the Lock
    $Locks = Get-AzResourceLock -ResourceGroupName $ResourceGroupName
    if ($null -ne $Locks.Name){
        Write-Host "Removing lock from $($ResourceGroupName)"
        Remove-AzResourceLock -LockName $LockName -ResourceGroupName $ResourceGroupName -Force
    }
    else {
        Write-Host "No lock found on $($ResourceGroupName)"
    }
}
else {
    # Set the Lock
    Write-Host "Setting lock $($LockName) on resource group $($ResourceGroupName)"
    Set-AzResourceLock -LockLevel CanNotDelete -LockNotes $LockNotes -LockName $LockName -ResourceGroupName $ResourceGroupName -Force
}

