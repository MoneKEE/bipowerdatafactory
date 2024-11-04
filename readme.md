# Dynamics BI Integrations Azure Data Factory Repository


----
| Development| Testing | Production |  
|:-----------:|:-----------:|:-----------:|  
| ![](https://vsrm.dev.azure.com/powereng-appsdev/_apis/public/Release/badge/a28286b5-4936-44f9-878e-7ca95a663ee3/7/12) | ![](https://vsrm.dev.azure.com/powereng-appsdev/_apis/public/Release/badge/a28286b5-4936-44f9-878e-7ca95a663ee3/7/13) | ![](https://vsrm.dev.azure.com/powereng-appsdev/_apis/public/Release/badge/a28286b5-4936-44f9-878e-7ca95a663ee3/7/14) |  

Azure Data Factory is a cloud-based data integration service that allows you to create, schedule, and manage data pipelines.  It enables organizations  
to collect, transform, and move data frm various sources to different targets, such as data warehouses, databases, and data lakes.  
With Azure Data Factory, you can extract data from multiple sources, transform it according to your business needs, and load it into your target  
data stores for analysis, reporting, and other purposes.

To streamline the development, deployment, and management of your Azure Data Factory pipelines, you can use a version control system like Git to manage  
your code and configurations.  By creating a repository for your Azure Data Factory pipelines, you can collaborate with other team members, track  
changes, and manage deployments in a more efficient manner.  This allows you to have a more organized and secure approach to managing your data pipelines,  
ensuring they are scalable, reliable, and easy to maintain.

This repository contains the code for the bipowerdatafactory Data Factory resource including ARM templates and associated config and pipeline configuration  
YML files used to facilitate automated publishing and release pipeline runs.

## Development Steps
1. Create a new branch (feature branch) and name it something unique to the developer, work item, or feature intended to be developed.  See the project [Wiki](https://dev.azure.com/powereng-appsdev/Dynamics%20BI%20Integrations/_wiki/wikis/Dynamics-BI-Integrations.wiki/44/Welcome-to-Dynamics-BI-Integrations-Wiki)  
for more information on creating branches.
1. Use the development ADF enviroment, bipowerdatafactory-dev to perform your development against the new feature branch.
1. After you are satisfied with your changes, create a pull request from the branch dropdown in the ADF UI, or from the DevOps project UI.  See the project [Wiki](https://dev.azure.com/powereng-appsdev/Dynamics%20BI%20Integrations/_wiki/wikis/Dynamics-BI-Integrations.wiki/44/Welcome-to-Dynamics-BI-Integrations-Wiki)  
for more information on creating pull requests.
1. After the pull request is approved and changes are merged in the master branch, the resulting build is published to the DEV ADF environment and the  
feature branch is deleted.
1. Approval notifications will be delivered to key personnel. Approval must be received in order to propagate these changes to the TEST and PROD environments.

## Artifacts Description
- **azure-pipelines.yml**: Continuous integration configuration file that governs the run characteristics for the bipowerdatafactory build pipeline.
- **package.json**: Contains references to the npm packages required to run the CI build pipeline.

## Pipelines
- **Build Pipeline**: CI build pipeline
- **Release Pipeline**: ADF Auto DEV Publish, Multistage Deploy

## Automated CI/CD flow
1. Each user makes changes in their private branches
1. Push to master isn't allowed. Users must create a pull request to make changes
1. The Azure DevOps pipeline build is triggered every time a new commit is made to master.  It validates the resources and generates an ARM template as an artifact  
if validation succeeds
1. The DevOps Release pipeline is configured to create a new release and deploy the ARM template each time a new build is available

![](https://learn.microsoft.com/en-us/azure/data-factory/media/continuous-integration-delivery-improvements/new-ci-cd-flow.png)

## Additional Information
- Production Self-hosted Integration Runtime install location: DDC-SQL02
- [Pipeline related documentation in Teams](https://powereng0.sharepoint.com/:f:/r/sites/AppsDevelopment/Shared%20Documents/EBS%20Developers/Documentation/Azure%20Data%20Factory?csf=1&web=1&e=cjufh8)
- [Self-hosted Integration Runtime install program and instructions](https://powereng0.sharepoint.com/:f:/r/sites/AppsDevelopment/Shared%20Documents/EBS%20Developers/Documentation/Azure%20Data%20Factory/ADF%20Utils?csf=1&web=1&e=F7LRdN) 