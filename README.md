# Study Buddy Infrastructure

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
- Currently only contains automation for Cognito deployment.
  
Deploy Cognito:

`aws cloudformation deploy --template-file cfn-nested-cognito.yaml --stack-name cfn-cognito`


### /CodePipeline

- Contains the buildspecs used by the CICD Pipelines.
- Eventually the CodePipelines will be automated in CloudFormation, so the
    buildspecs will get baked into the CFN templates.

### /resources

- Contains screenshots used by documentation in this repo.
