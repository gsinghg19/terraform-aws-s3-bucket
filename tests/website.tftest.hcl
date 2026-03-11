run "plan_helper_module" {
  command = plan

  module {
    source = "./tests/helpers/s3-website-helper"
  }

  variables {
    bucket_name = "tf-test-website-helper-bucket-example"
    tags = {
      Environment = "test"
      Owner       = "terraform-test"
    }
  }

  assert {
    condition     = output.helper_bucket_name == "tf-test-website-helper-bucket-example"
    error_message = "helper_bucket_name should match the test input bucket name"
  }

  assert {
    condition     = output.helper_tags["Terraform"] == "true"
    error_message = "default Terraform tag should be present"
  }

  assert {
    condition     = output.helper_tags["Owner"] == "terraform-test"
    error_message = "custom Owner tag should be preserved"
  }
}
