# --------------------------------------------------------------------------------------------------------------------------
# Example 1 : Single Region : Non-PCI GCS Bucket deployment in Single Region with encryption key passed by the customer
# --------------------------------------------------------------------------------------------------------------------------

# This example shows how to deploy a single region non-PCI GCS bucket with encryption key passed. For PCI - change the bucket_type = "pci".
module "single-region-non-pci-1" {
  source             = "../"
  bucket_name_prefix = "gcs-example-1"
  project_id         = "pr-hvpc-1056d88565a4"
  location           = "northamerica-northeast1"
  versioning         = true
  storage_class      = "NEARLINE"
  project_number     = "828184145025"
  soft_delete_policy = {
    retention_duration_seconds = 900000
  }
  labels = {
    "env" = "prod"
  }
  bucket_type = "non-pci"
  iam_members = [
    {
      role   = "roles/storage.objectUser"
      member = "serviceAccount:b-32-988@pr-hvpc-1056d88565a4.iam.gserviceaccount.com"
    },
    {
      role   = "roles/storage.objectCreator"
      member = "serviceAccount:a-833-223@pr-hvpc-1056d88565a4.iam.gserviceaccount.com"
    }
  ]
  retention_policy = {
    is_locked        = false
    retention_period = 220752000
  }
  lifecycle_rules = [
    {
      action = {
        type          = "SetStorageClass"
        storage_class = "ARCHIVE"
      }
      condition = {
        age              = 365 * 7
        send_age_if_zero = true
        with_state       = "LIVE"
      }
    }
  ]
  kms_key_names = "projects/pr-hvpc-1056d88565a4/locations/northamerica-northeast1/keyRings/pci-ring/cryptoKeys/pci-key-mon"
}

# --------------------------------------------------------------------------------------------------------------------------
# Example 2 : Multi Region : Non-PCI GCS Bucket deployment in Multi-Region with internal encryption (CMEK handled by module)
# --------------------------------------------------------------------------------------------------------------------------

# This example shows how to deploy a multi region non-PCI GCS bucket with internal encryption key handled by the module. For PCI - change the bucket_type = "pci".
module "multi-region-non-pci-1" {
  source             = "../terraform-gcp-gcs-new"
  bucket_name_prefix = "gcs-example-2"
  project_id         = "pr-hvpc-1056d88565a4"
  location           = "us"
  versioning         = true
  storage_class      = "COLDLINE"
  project_number     = "828184145025"
  soft_delete_policy = {
    retention_duration_seconds = 900000
  }
  labels = {
    "env" = "prod"
  }
  bucket_type = "non-pci"
  internal_encryption_config = {
    create_encryption_key = true
    prevent_destroy       = false
  }
}

# --------------------------------------------------------------------------------------------------------------------------
# Example 3 : Dual Region : NON-PCI GCS Bucket deployment in Dual Region
# --------------------------------------------------------------------------------------------------------------------------

# This example shows how to deploy a dual-region NON-PCI GCS bucket with internal encryption key handled by the module. For PCI - change the bucket_type = "pci".
module "dual-region-non-pci" {
  source             = "../terraform-gcp-gcs-new"
  bucket_name_prefix = "gcs-example-3"
  project_id         = "pr-hvpc-1056d88565a4"
  location           = "ca"
  custom_placement_config = {
    data_locations = ["northamerica-northeast1", "northamerica-northeast2"]
  }
  versioning     = true
  storage_class  = "NEARLINE"
  project_number = "828184145025"
  soft_delete_policy = {
    retention_duration_seconds = 900000
  }
  labels = {
    "env" = "prod"
  }
  bucket_type = "non-pci"
  internal_encryption_config = {
    create_encryption_key = true
    prevent_destroy       = false
  }
}

# --------------------------------------------------------------------------------------------------------------------------
# Example 4 : Single Region : PCI GCS Bucket deployment in Single Region with encryption key passed by the customer
# --------------------------------------------------------------------------------------------------------------------------

# This example shows how to deploy a single region PCI GCS bucket with encryption key passed. For NON-PCI - change the bucket_type = "non-pci".
module "single-region-pci" {
  source             = "../"
  bucket_name_prefix = "gcs-example-4"
  project_id         = "pr-hvpc-1056d88565a4"
  location           = "northamerica-northeast1"
  versioning         = true
  storage_class      = "NEARLINE"
  project_number     = "828184145025"
  soft_delete_policy = {
    retention_duration_seconds = 900000
  }
  labels = {
    "env" = "prod"
  }
  bucket_type = "non-pci"
  iam_members = [
    {
      role   = "roles/storage.objectUser"
      member = "serviceAccount:b-32-988@pr-hvpc-1056d88565a4.iam.gserviceaccount.com"
    },
    {
      role   = "roles/storage.objectCreator"
      member = "serviceAccount:a-833-223@pr-hvpc-1056d88565a4.iam.gserviceaccount.com"
    }
  ]
  retention_policy = {
    is_locked        = false
    retention_period = 220752000
  }
  lifecycle_rules = [
    {
      action = {
        type          = "SetStorageClass"
        storage_class = "ARCHIVE"
      }
      condition = {
        age              = 365 * 7
        send_age_if_zero = true
        with_state       = "LIVE"
      }
    }
  ]
  kms_key_names = "projects/pr-hvpc-1056d88565a4/locations/northamerica-northeast1/keyRings/pci-ring/cryptoKeys/pci-key-mon"
}

# --------------------------------------------------------------------------------------------------------------------------
# Example 5 : Multi Region : PCI GCS Bucket deployment in Multi-Region with internal encryption (CMEK handled by module)
# --------------------------------------------------------------------------------------------------------------------------

# This example shows how to deploy a multi region PCI GCS bucket with internal encryption key handled by the module. For NON-PCI - change the bucket_type = "non-pci".
module "multi-region-pci" {
  source             = "../terraform-gcp-gcs-new"
  bucket_name_prefix = "gcs-example-5"
  project_id         = "pr-hvpc-1056d88565a4"
  location           = "us"
  versioning         = true
  storage_class      = "COLDLINE"
  project_number     = "828184145025"
  soft_delete_policy = {
    retention_duration_seconds = 900000
  }
  labels = {
    "env" = "prod"
  }
  bucket_type = "pci"
  internal_encryption_config = {
    create_encryption_key = true
    prevent_destroy       = false
  }
}

# --------------------------------------------------------------------------------------------------------------------------
# Example 6 : Dual Region : PCI GCS Bucket deployment in Dual Region
# --------------------------------------------------------------------------------------------------------------------------

# This example shows how to deploy a dual-region PCI GCS bucket with internal encryption key handled by the module. For NON-PCI - change the bucket_type = "non-pci".
module "dual-region-pci" {
  source             = "../terraform-gcp-gcs-new"
  bucket_name_prefix = "gcs-example-6"
  project_id         = "pr-hvpc-1056d88565a4"
  location           = "ca"
  custom_placement_config = {
    data_locations = ["northamerica-northeast1", "northamerica-northeast2"]
  }
  versioning     = true
  storage_class  = "STANDARD"
  project_number = "828184145025"
  soft_delete_policy = {
    retention_duration_seconds = 900000
  }
  labels = {
    "env" = "prod"
  }
  bucket_type = "pci"
  internal_encryption_config = {
    create_encryption_key = true
    prevent_destroy       = false
  }
}