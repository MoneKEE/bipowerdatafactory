<#
This powershell script manages Test runs against a target Azure Data Factory

Test Initialization
- This script invokes a pipeline to initialize test data sources with sample files

Data Sources
- ADLS: aec360powerdev/Azure_Data_Factory_Test
- Fileshare: \\cdcfs1\Azure_Data_Factory_Test

Test Parameters
- For pipelines that read/write a file share folder(s), set the fileStoreLocation parameter to "Azure_Data_Factory_Test/<target folder>"
#>
[CmdletBinding()]
param(
    [parameter(Mandatory = $true)] [String] $resourceGroupName,
    [parameter(Mandatory = $true)] [String] $dataFactoryName
    )

# Exclude these pipelines from the test run
$exclude = "PowerBiStaplesToAzureSQL","IntegrationTestInitializer","RetrieveFiles","SendNotificationToTeamsChannel","MoveFile","MoveFile_Staples","MoveFiles","Snowflake_to_Azure_Schema_Migration", "Snowflake_to_Azure_Warehouse_Migration"
$include = "UAT_DataverseStringmapToAzureSQL" #"PowerBiAxiomToAzureSQL","PowerBiMSLicensingToAzureSQL","PowerBiDADataToAzureSQL"

# Supply the source folders with test files prior to running the tests
# If initialization fails then terminate the script
$RunId = Invoke-AzDataFactoryV2Pipeline `
    -DataFactoryName $dataFactoryName `
    -ResourceGroupName $resourceGroupName `
    -PipelineName "IntegrationTestInitializer"

Write-Host ("Beginning run for pipeline: IntegrationTestInitializer") -ForegroundColor "Yellow"

while ($true) {
    $run = Get-AzDataFactoryV2PipelineRun `
    -ResourceGroupName $resourceGroupName `
    -DataFactoryName $dataFactoryName `
    -PipelineRunId $RunId

    if ($Run) {
        if ($Run.Status -eq 'Succeeded') {
            Write-Host ("Pipeline run finished. The status is: " + $Run.Status) -ForegroundColor "Green"
            break
        }
        if ($Run.Status -eq 'Failed') {
            Write-Error ("Pipeline run failed." + $Run.message)
            return
        }
        Write-Host ("Pipeline is running...status: " +  $Run.Status) -ForegroundColor "Blue"
    }
    Start-Sleep -Seconds 10
}

# Get information about all pipelines in the target data factory
$pipelines = Get-AzDataFactoryV2Pipeline -ResourceGroupName $resourceGroupName -DataFactoryName $dataFactoryName

# All Files Test Case
# Simulates case where a full compliment of source files are available in the blob container Azure_Data_Factory
.\AllFilesTestCase.ps1 -pipelines $pipelines -exclude $exclude -include $include -resourceGroupName $resourceGroupName -dataFactoryName $dataFactoryName

# Single File Test Case
# Simulates case where a single source file is available in the blob container Azure_Data_Factory
# .\SingleFileTestCase.ps1 -pipelines $pipelines -exclude $exclude -include $include -resourceGroupName $resourceGroupName -dataFactoryName $dataFactoryName

# No File Test Case
# Simulates case where no source file is available in the blob container Azure_Data_Factory
# .\NoFileTestCase.ps1 -pipelines $pipelines -exclude $exclude -include $include -resourceGroupName $resourceGroupName -dataFactoryName $dataFactoryName

