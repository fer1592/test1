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

Following code was developed and tested using
* Ubuntu 20.04
* Terraform v1.0.3
* go version go1.16.6

# Instructions to run the code manually
