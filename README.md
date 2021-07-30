# test-1
The following repo contains:
1. A terraform file that performs the deployment of an s3 bucket in AWS and creates two text files inside of it, each one containing the timestamp from when the terraform code was executed.
2. An automated test for the previous code, that checks if the s3 bucket and the files were created, and also if the content of the files have the following format `DD-MM-YYYY hh:mm:ss UTC`, where:
    * DD: day of month
    * MM: Month of year
    * YYYY: Year
    * hh: hour
    * mm: minute
    * ss: seconds
    * UTC: Indicates the UTC timezone

(Eg. 29-07-2021 01:00:48 +00:00)

3. A GitHub Actions workflow used to run some code validations using Super-Linter, and also to run the automated test in a personal AWS account.

## Pre-requisites
* An AWS account
* A user with Programmatic access. For the present challange the account used had `AdministratorAccess` permissions. Altough you don't need such a level of access, focus was set on developing the code and not restricting the access for the account. An access key was generated for the user.

Following code was developed and tested using
* Ubuntu 20.04
* Terraform v1.0.3
* go version go1.16.6

## Instructions to run the code manually
Following instructions explain how to execute the code manually. You should already have terraform and go installed in your environment. Instructions indicate how to run the code in a Linux environment

1. Clone the repository to your local machine
2. Get into the test1 folder by running `cd test1/`
3. If changes haven't been merged, first checkout the branch `test1-branch` by running `git checkout test1-branch`
4. Next, we need to provide the AWS credentials. Execute the following commands (Providing the requested data):
```bash
 export AWS_ACCESS_KEY_ID="<Your Access Key ID>"
 export AWS_SECRET_ACCESS_KEY="<Your Key>"
 export AWS_DEFAULT_REGION="us-east-2"
```
5. Move inside the test folder, by running `cd test/` and run `go test terraform_test.go`. After a few seconds (or about a minute), you should get a message similar to `ok     command-line-arguments     68.985s`, meaning that the test ran fine.
6. Get inside the IaC folder, by running `cd ../IaC/`
7. Before running our terraform code, let's swich to a different workspace. Using two different workspaces will allow you to run the test again witouth change or destroy your "production" resources. Just remember to swich back to the default workspace, otherwise your "production" resources will be compromised. To create a new workspace, run `terraform workspace new prod`
8. Run `terraform init` followed by `terraform apply -var='bucketName=<choose your bucket name>' -auto-approve`.
9. If everything went well, you should now have an s3 bucket with the test1.txt and test2.txt files stored on it.

## Instructions to run the code using GitHub actions
You can also test and deploy the resources using GitHub actions. Before moving to the steps to execute the workflow, you will need to create an s3 bucket in AWS. The bucket must contain a folder where terraform will store the terraform.tfstate file. Otherwise after the workflow complets it's execution, the State of your infrastructure will be lost. After you create the bucket, create a folder inside it, where your tfstate file will be stored

Follow the next steps to test and deploy your resources using GitHub actions:
1. Open the repository in your browser, and click on `Fork`.
2. Once your fork is ready, you will first need to add a few secrets. In your browser, click on `Settings` and then on `Secrets` on the left bar.
3. You can add the secrets by clicking on `New repository secret`. You will need to add the followings:
| Name                  | Value                                               |
| --------------------- | --------------------------------------------------- |
| AWS_ACCESS_KEY_ID     | Your Access Key ID                                  |
| AWS_SECRET_ACCESS_KEY | Your Key                                            |
| AWS_REGION            | us-east-2                                           |
| BUCKET                | Name of your s3 Bucket where tfstate will be stored |
| KEY                   | Path where to store your tfstate file (eg prod/terraform.tfstate) |
| BUCKET_NAME           | Name of the bucket to be deployed                   |
4. Next, click on the `Actions` tab and click on `I understand my workflows, go ahead and enable them`
5. Once you enable the workflows, create a pull request or push a small change to trigger the workflow. From now on, the pipeline should test and update your resources everytime you push a change

Hope you enjoy it running as I did when doing the challange. Any feedback is appreciated. Thanks!