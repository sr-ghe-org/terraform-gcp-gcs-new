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

# -----------------------------------------------------------
#  NON-PCI Bucket
# -----------------------------------------------------------

module "non_pci_gcs_buckets" {
  count                      = var.bucket_type == "non-pci" ? 1 : 0
  source                     = "./modules/gcs-buckets-non-pci"
  project_id                 = var.project_id
  project_number             = var.project_number
  bucket_name_prefix         = var.bucket_name_prefix
  regions                    = var.regions
  versioning                 = var.versioning
  labels                     = var.labels
  storage_class              = var.storage_class
  autoclass                  = var.autoclass
  iam_members                = var.iam_members
  retention_policy           = var.retention_policy
  lifecycle_rules            = var.lifecycle_rules
  force_destroy              = var.force_destroy
  public_access_prevention   = "enforced"
  soft_delete_policy         = var.soft_delete_policy
  kms_key_names              = var.kms_key_names
  internal_encryption_config = var.internal_encryption_config
}

# ---------------------------------------------------------------------
#  PCI Bucket (Lifecycle rule and retention period is set to 7 years)
# ---------------------------------------------------------------------
module "pci_gcs_buckets" {
  count                      = var.bucket_type == "pci" ? 1 : 0
  source                     = "./modules/gcs-buckets-pci"
  project_id                 = var.project_id
  project_number             = var.project_number
  bucket_name_prefix         = var.bucket_name_prefix
  regions                    = var.regions
  versioning                 = var.versioning
  labels                     = var.labels
  storage_class              = var.storage_class
  autoclass                  = var.autoclass
  iam_members                = var.iam_members
  retention_policy           = var.retention_policy
  lifecycle_rules            = var.lifecycle_rules
  force_destroy              = var.force_destroy
  public_access_prevention   = "enforced"
  soft_delete_policy         = var.soft_delete_policy
  kms_key_names              = var.kms_key_names
  internal_encryption_config = var.internal_encryption_config
}
