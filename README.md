# Study Buddy Infrastructure

Copyright © 2020 SomethingCode

Brian Jopling, 2019 - 2020


## Purpose

The purpose of this repository is to contain all infrastructure-related 
code for the Study Buddy project.

This repository contains or shall contain the following:

1. Infrastructure as Code (via CloudFormation templates)
2. CodePipeline configuration scripts
3. Ancillary infra-supporting scripts


## Description

```
/iac
   - Contains the Infrastructure as Code via CloudFormation templates.
   - A master / parent template exists, whose sole purpose is to deploy nested templates.

/CodePipeline
   - Contains the buildspecs used by the CICD Pipelines.
      - These buildspecs are baked into the CFN templates.

/resources
   - Contains screenshots used by documentation in this repo.

/scripts
   - Contains ancillary scripts used in supporting the infrastructure.
```


## Usage

- **Pre-requisites** (one-time setup):

   - Store the CFN templates on AWS so they can be deployed.

      1. Create an S3 bucket in your AWS account.
      2. Upload the contents of the `iac/` directory to the S3 bucket.

   - Register a hosted zone / domain name in a DNS registrar.
     - For example, I registered `somethingcode.com` as my hosted zone in AWS Route 53.

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

   - Verify domain ownership in SES to send emails as part of the chat sharing feature.
  
      1. Select "Domains" in the sidebar of AWS SES. 
      2. Click the "Verify Domain" button.
      3. Perform the steps that are then presented to you, which involve creating a TXT DNS record.

   - Request access to send emails from SES to any email address as part of the chat sharing feature.

      1. Select "Sending Statistics" in the sidebar of AWS SES.
      2. Click the "Request a Sending Limit Increase" button.
      3. Complete the Support Case form. This takes your account 
         out of "sandbox" mode, allowing you to send emails to anyone.

  
- **Deploy master template:**

   1. Go to AWS CloudFormation.
   2. Select "Create stack" > "With new resources (standard)"
   3. Paste the S3 URL that points to your `cfn-master.yaml` file.
      For example, mine is `https://studybuddy-cfn-templates.s3.amazonaws.com/cfn-master.yaml`
   4. Name your stack.
   5. Update the parameter values to match your preferences.
      You will need to update the domain names used and the bucket names, for example.
   6. Click "Next," then "Next" again.
   7. Select the two checkboxes near the bottom regarding IAM Role creation.
   8. Click "Create" and it will start deploying.
   9. Manual validation of ACM certs **(only for first-time deployment in a new account)**:
      1. When the Cognito stack is being deployed, go to AWS ACM and validate the newly created cert.
      2. When the Frontend CloudFront stack is being deployed, go to AWS ACM and validate the newly created cert.
      3. When the API GW stack is being deployed, go to AWS ACM and validate the newly created cert.

- **Post-requisites:**
  1. Create an Alias A record pointing your API subdomain to the API Gateway CloudFront.
   
        1. Go to AWS API Gateway in the AWS Console.
        2. Select "Custom Domain Names" in the sidebar.
        3. Copy the CloudFront URL.
        4. Create an Alias A record pointing your subdomain to this URL.
           - For example, in AWS Route 53, I created an `Alias` `A` record pointing `api.somethingcode.com` to `dabcdef123.cloudfront.net`.

   2. Create an Alias A record pointing your signin subdomain to the Cognito CloudFront.
   
        1. Go to AWS Cognito in the AWS Console.
        2. Select "Domain Name" in the sidebar.
        3. Copy the "Alias target" CloudFront URL.
        4. Create an Alias A record pointing your subdomain to this URL.
           - For example, in AWS Route 53, I created an `Alias` `A` record pointing `signin.somethingcode.com` to `dabcdef246.cloudfront.net`.

   3. Create an Alias A record pointing your www subdomain to the S3 CloudFront.
   
        1. Go to AWS CloudFront in the AWS Console.
        2. Select the ID of the only CloudFront distribution listed.
        3.  Copy the "Domain Name" CloudFront URL.
        4.  Create an Alias A record pointing your subdomain to this URL.
            - For example, in AWS Route 53, I created an `Alias` `A` record pointing `www.somethingcode.com` to `dabcdef468.cloudfront.net`.
