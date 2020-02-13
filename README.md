# Study Buddy Infrastructure

Copyright © 2020 SomethingCode

Brian Jopling, 2019 - 2020


## Purpose

The purpose of this repository is to contain all infrastructure-related 
code for the Study Buddy project.

This repository contains or shall contain the following:

1. Infrastructure as Code (via CloudFormation templates)
2. CodePipeline configuration scripts
3. Ansillary infra supporting scripts

## Usage

### /iac

- Contains the Infrastructure as Code as CloudFormation templates.
- A master / parent template exists, whose sole purpose is to deploy nested templates.
- In the current configuration, templates must be saved in the S3 bucket `studybuddy-templates`.
- Pre-requisites:
  - Store the following Secrets in AWS Secrets Manager:
  
    1. Create a new secret called `db-credentials` with the following keys:
       1. `dbInstanceIdentifier` : The name of the database to be created in MySQL.
       2. `username` : The username to be created for the MySQL RDS instance.
       3. `password` : The password to be created for the MySQL RDS instance.


    2. Create a new secret called `cicd-github-access` with the following key:
       1. `token` : The [token exported from GitHub](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line) that gives the CICD Pipelines read access to the repos.


    3. Create a new secret called `idp-google-client-credentials` with the following keys:
       1. `client-id` : The client id of a client created for Google SSO in the [Google Developer Portal](https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-social-idp.html).
       2. `client-secret` : The client secret corresponding to the client id created in the Google Developer Portal.
    
  
- Deploy master template:

    `aws cloudformation deploy --template-file cfn-master.yaml --stack-name cfn-studybuddy-master-dev`


### /CodePipeline

- Contains the buildspecs used by the CICD Pipelines.
- Eventually the CodePipelines will be automated in CloudFormation, so the
    buildspecs will get baked into the CFN templates.

### /resources

- Contains screenshots used by documentation in this repo.
