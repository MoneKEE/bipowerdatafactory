<# 
AllFiles Test
Simulates case where a full compliment of source files are available in the blob container Azure_Data_Factory

- Iterate through pipeline list, skipping the pipelines identified in the exclusion list ($exclude)
- Issue a call to powershell script "DataFactoryPipelineRun.ps1" 
    parameters: 
    -resourceGroupName = $resourceGroupName
    -dataFactoryName = $dataFactoryName
    -DFPipelineName = $pipeline.PipelineName
#>
[CmdletBinding()]
param(
    $resourceGroupName,
    $dataFactoryName,
    $pipelines,
    $exclude,
    $include
)

foreach ($pipeline in $pipelines)
{
    # Perform conditional include or exclude
    if ($pipeline.Name -notin $exclude)
    #if ($pipeline.PipelineName -notin $exclude)
    {
        Write-Host ("Beginning allFiles test case run for pipeline: " + $pipeline.Name) -ForegroundColor "Yellow"

        # Create parameters hashtable
        # Converts pipeline parameters dictionary into a hashtable that the pipeline run command will accept
        # This is necessary after updating a parameter value
        $parameters = .\FormatParameters.ps1 -pipeline $pipeline

        # Initiate the pipeline run
        .\DataFactoryPipelineRun.ps1 -resourceGroupName $resourceGroupName -dataFactoryName $dataFactoryName -DFPipelineName $pipeline.Name -parameters $parameters[1]

    } else {
        Write-Host ("Skipping pipeline: " + $pipeline.Name)
    }
}