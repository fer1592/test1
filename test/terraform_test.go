package test

import (
	"fmt"
	"io/ioutil"
	"math/rand"
	"net/http"
	"regexp"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTest1(t *testing.T) {

	bucketName := fmt.Sprintf("s3-bucket-test-%d", rand.Int())

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		//Path to our terraform code
		TerraformDir: "../IaC",

		//Variables to be provided to our code
		Vars: map[string]interface{}{
			"bucketName": bucketName,
		},
	})

	//After the test all resources should be removed
	defer terraform.Destroy(t, terraformOptions)

	//Execute our terraform code
	terraform.InitAndApply(t, terraformOptions)

	//Get the bucket name to make sure it exists
	bucketNameOutput := terraform.Output(t, terraformOptions, "bucket_id")
	assert.Equal(t, bucketName, bucketNameOutput)

	//Download the test1.txt file, and validate that the content is a timestamp
	test1Url := terraform.Output(t, terraformOptions, "test1_url")
	resp1, err1 := http.Get(test1Url)
	defer resp1.Body.Close()
	content1, conterr1 := ioutil.ReadAll(resp1.Body)
	assert.Nil(t, err1)
	assert.Nil(t, conterr1)
	assert.Regexp(t, regexp.MustCompile(`[0-9]{2}-[0-9]{2}-[0-9]{4}\s[0-9]{2}:[0-9]{2}:[0-9]{2}\s\+[0-9]{2}:[0-9]{2}`), string(content1))

	//Download the test2.txt file, and validate that the content is a timestamp
	test2Url := terraform.Output(t, terraformOptions, "test2_url")
	resp2, err2 := http.Get(test2Url)
	defer resp2.Body.Close()
	content2, conterr2 := ioutil.ReadAll(resp2.Body)
	assert.Nil(t, err2)
	assert.Nil(t, conterr2)
	assert.Regexp(t, regexp.MustCompile(`[0-9]{2}-[0-9]{2}-[0-9]{4}\s[0-9]{2}:[0-9]{2}:[0-9]{2}\s\+[0-9]{2}:[0-9]{2}`), string(content2))
}
