<#
This PowerShell script triggers and monitors an Azure data factory pipeline outcome. 
#>  
[CmdletBinding()]
param(
    $resourceGroupName = "dynamics-bi-integrations-dev",
    $dataFactoryName = "bipowerdatafactory-dev",
    $DFPipelineName = "PowerBiMarketInfoToAzureSQL",
    [hashtable] $parameters
    )

if ($parameters.count -gt 0) {
    $RunId = Invoke-AzDataFactoryV2Pipeline `
        -DataFactoryName $DataFactoryName `
        -ResourceGroupName $ResourceGroupName `
        -PipelineName $DFPipeLineName `
        -Parameter $parameters
} else {
    $RunId = Invoke-AzDataFactoryV2Pipeline `
        -DataFactoryName $DataFactoryName `
        -ResourceGroupName $ResourceGroupName `
        -PipelineName $DFPipeLineName `
}

$timer = [Diagnostics.StopWatch]::StartNew()

      while ($True) {
          $Run = Get-AzDataFactoryV2PipelineRun `
              -ResourceGroupName $ResourceGroupName `
              -DataFactoryName $DataFactoryName `
              -PipelineRunId $RunId

          $RunLastUpdate = ($Run.RunStart).AddMilliseconds($timer.ElapsedMilliseconds)

          $Fault = Get-AzDataFactoryV2PipelineRun `
              -ResourceGroupName $ResourceGroupName `
              -DataFactoryName $DataFactoryName `
              -PipelineName "SendNotificationToTeamsChannel" `
              -LastUpdatedAfter $Run.RunStart `
              -LastUpdatedBefore $RunLastUpdate

            if ($Run) {
                    if ($run.Status -eq 'Succeeded') {
                        Write-Host ("Pipeline run finished. The status is: " +  $Run.Status) -ForegroundColor "Green"
                        $Run
                        $timer.stop()
                        break
                    }
                    if ($run.Status -eq 'Failed') {
                        Write-Error ("Pipeline run failed. " + $Run.Message )
                        $Run
                        $timer.stop()
                        break 
                    }
                    if ($Fault) {
                        Write-Error ("Pipeline activity failed. " + $Run.Message )

                        Stop-AzDataFactoryV2PipelineRun `
                        -ResourceGroupName $ResourceGroupName `
                        -DataFactoryName $DataFactoryName `
                        -PipelineRunId $RunId
                        $Fault
                        $timer.stop()
                        break 
                    }
                    Write-Host ("Pipeline is running...status: " +  $Run.Status) -ForegroundColor "Blue"
                }

                Start-Sleep -Seconds 20
            }