/**
 * Copyright 2025 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

resource "google_kms_crypto_key_iam_binding" "decrypters" {
  for_each      = { for k, v in var.kms_key_names : k => v if length(var.kms_key_names) > 0 }
  crypto_key_id = each.value
  members       = ["serviceAccount:service-${var.project_number}@gs-project-accounts.iam.gserviceaccount.com"]
  role          = "roles/cloudkms.cryptoKeyDecrypter"
}

resource "google_kms_crypto_key_iam_binding" "encrypters" {
  for_each      = { for k, v in var.kms_key_names : k => v if length(var.kms_key_names) > 0 }
  crypto_key_id = each.value
  members       = ["serviceAccount:service-${var.project_number}@gs-project-accounts.iam.gserviceaccount.com"]
  role          = "roles/cloudkms.cryptoKeyEncrypter"
}

# Module to create GCS buckets in multiple regions within the same project
module "gcs_pci_buckets" {
  for_each                 = toset(var.regions)
  source                   = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version                  = "9.0"
  project_id               = var.project_id
  name                     = "${var.bucket_name_prefix}-pci-${each.key}" # Bucket names are globally unique
  location                 = each.value
  bucket_policy_only       = true           # uniform_bucket_level_access is set to true
  versioning               = var.versioning # By default set to false
  labels                   = merge(var.labels, { bucket_type = "pci" })
  storage_class            = var.storage_class # By default storage Class of the new bucket set to "STANDARD"
  autoclass                = var.autoclass     # By default, autoclass is set to false
  lifecycle_rules          = var.lifecycle_rules
  retention_policy         = var.retention_policy
  force_destroy            = var.force_destroy
  public_access_prevention = "enforced"             # Prevent public access is "enforced" by default
  soft_delete_policy       = var.soft_delete_policy # Set to O (By default : 604800(7 days))
  encryption = {
    default_kms_key_name = length(var.kms_key_names) > 0 ? var.kms_key_names[each.key] : null
  }
  internal_encryption_config = var.internal_encryption_config
  iam_members                = var.iam_members
  depends_on                 = [google_kms_crypto_key_iam_binding.decrypters, google_kms_crypto_key_iam_binding.encrypters]
}

# Enable audit logging for the project
resource "google_project_iam_audit_config" "project_audit_config" {
  project = var.project_id
  service = "storage.googleapis.com"

  audit_log_config {
    log_type = "ADMIN_READ"
  }
  audit_log_config {
    log_type = "DATA_WRITE"
  }
  audit_log_config {
    log_type = "DATA_READ"
  }
}