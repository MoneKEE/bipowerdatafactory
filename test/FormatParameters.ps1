<#
Returns the target pipeline's parameters dictionary as a hash table of type {key = parameterName, value=DefaultValue}
#>

[CmdletBinding()]
param (
    $pipeline
)

[string] $fileStoreLocation
$parameters = @{}

# If parameter fileStoreLocation exists update fileStoreLocation = "Azure_Data_Factory_Test/<target folder>"
if ($pipeline.Parameters.fileStoreLocation) {
    $fileStoreLocation = $pipeline.Parameters.fileStoreLocation.DefaultValue
    $pipeline.Parameters.fileStoreLocation.DefaultValue = $fileStoreLocation.replace("Azure_Data_Factory","Azure_Data_Factory/Test")
}

# Create parameters hash table that will passed to the pipeline
foreach ($pair in $pipeline.Parameters.keys){
    $parameters[$pair] = $pipeline.Parameters[$pair].DefaultValue
}

$parameters