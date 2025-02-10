
mock_provider "google" {}

# ----------------------------------------------------------------------------------
# Single Region : CMEK : Encryption key passed by the customer
# ----------------------------------------------------------------------------------
run "gcs_single_region" {
  command = plan
  variables {
    bucket_name_prefix = "example-1"
    project_id         = "pr-svpc"
    project_number     = "00000000000"
    location           = "northamerica-northeast1"
    versioning         = true
    soft_delete_policy = {
      retention_duration_seconds = 900000
    }
    bucket_type   = "non-pci"
    kms_key_names = "projects/pr-svpc/locations/northamerica-northeast1/keyRings/pci-ring/cryptoKeys/pci-key-mon"
  }
}


# ----------------------------------------------------------------------------------
# Multi-Region : CMEK : Internal Encryption key passed by the created by module
# ----------------------------------------------------------------------------------
run "gcs_multi_region" {
  command = plan
  variables {
    bucket_name_prefix = "example-2"
    project_id         = "pr-hvpc-1056d88565a4"
    location           = "us"
    versioning         = true
    soft_delete_policy = {
      retention_duration_seconds = 900000
    }
    bucket_type = "non-pci"
    internal_encryption_config = {
      create_encryption_key = true
      prevent_destroy       = false
    }
  }
}

# ----------------------------------------------------------------------------------
# Multi-Region : CMEK : Internal Encryption key passed by the created by module
# ----------------------------------------------------------------------------------
run "gcs_dual_region" {
  command = plan
  variables {
    bucket_name_prefix = "example-3"
    project_id         = "pr-hvpc-1056d88565a4"
    location           = "ca"
    custom_placement_config = {
      data_locations = ["northamerica-northeast1", "northamerica-northeast2"]
    }
    versioning = true
    soft_delete_policy = {
      retention_duration_seconds = 900000
    }
    bucket_type = "pci"
    internal_encryption_config = {
      create_encryption_key = true
      prevent_destroy       = false
    }
  }
}
