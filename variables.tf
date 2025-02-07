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

variable "project_id" {
  type        = string
  description = "The GCP project ID where GCS bucket will be created"
}

variable "project_number" {
  type        = string
  description = "The GCP project number where GCS Service account exists"
  default     = null
}

variable "bucket_name_prefix" {
  type        = string
  description = "Prefix for the GCS bucket names"
}

variable "bucket_type" {
  type        = string
  description = "PCI bucket or Non-PCI bucket"
  validation {
    condition     = contains(["pci", "non-pci"], lower(var.bucket_type))
    error_message = "Bucket type must be 'pci' or 'non-pci' (case-insensitive)."
  }
}

# variable "environment" {
#   type        = string
#   description = "Environment for the GCS bucket"
#   validation {
#     condition     = contains(["prod", "non-prod"], lower(var.environment))
#     error_message = "Bucket type must be 'prod' or 'non-prod' (case-insensitive)."
#   }
# }

variable "iam_members" {
  description = "The list of IAM members to grant permissions on the bucket."
  type = list(object({
    role   = string
    member = string
  }))
  default = []
}

variable "regions" {
  type        = list(string)
  description = "List of regions for Non-PCI buckets"
  validation {
    condition     = alltrue([for r in var.regions : r == "northamerica-northeast1" || r == "northamerica-northeast2" || r == "us-east4"])
    error_message = "The regions list can only contain 'northamerica-northeast1', 'northamerica-northeast2', and 'us-east4'."
  }
}

variable "versioning" {
  description = "While set to true, versioning is fully enabled for this bucket."
  type        = bool
  default     = false
}

variable "public_access_prevention" {
  description = "Prevents public access to a bucket. Acceptable values are inherited or enforced. If inherited, the bucket uses public access prevention, only if the bucket is subject to the public access prevention organization policy constraint."
  type        = string
  default     = "enforced"
}

variable "labels" {
  description = "A set of key/value label pairs to assign to the bucket."
  type        = map(string)
  default     = null
}

variable "storage_class" {
  description = "The Storage Class of the new bucket."
  type        = string
  default     = "STANDARD"
}

variable "autoclass" {
  description = "While set to true, autoclass is enabled for this bucket."
  type        = bool
  default     = false
}

variable "retention_policy" {
  description = "Configuration of the bucket's data retention policy for how long objects in the bucket should be retained."
  type = object({
    is_locked        = bool
    retention_period = number
  })
  default = null
}

variable "soft_delete_policy" {
  description = "Soft delete policies to apply. Format is the same as described in provider documentation https://www.terraform.io/docs/providers/google/r/storage_bucket.html#nested_soft_delete_policy"
  type = object({
    retention_duration_seconds = optional(number, 604800)
  })
  default = {}
}

variable "lifecycle_rules" {
  description = "The bucket's Lifecycle Rules configuration."
  type = list(object({
    # Object with keys:
    # - type - The type of the action of this Lifecycle Rule. Supported values: Delete and SetStorageClass.
    # - storage_class - (Required if action type is SetStorageClass) The target Storage Class of objects affected by this Lifecycle Rule.
    action = any

    # Object with keys:
    # - age - (Optional) Minimum age of an object in days to satisfy this condition.
    # - created_before - (Optional) Creation date of an object in RFC 3339 (e.g. 2017-06-13) to satisfy this condition.
    # - with_state - (Optional) Match to live and/or archived objects. Supported values include: "LIVE", "ARCHIVED", "ANY".
    # - matches_storage_class - (Optional) Storage Class of objects to satisfy this condition. Supported values include: MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, STANDARD, DURABLE_REDUCED_AVAILABILITY.
    # - matches_prefix - (Optional) One or more matching name prefixes to satisfy this condition.
    # - matches_suffix - (Optional) One or more matching name suffixes to satisfy this condition
    # - num_newer_versions - (Optional) Relevant only for versioned objects. The number of newer versions of an object to satisfy this condition.
    condition = any
  }))
  default = []
}

variable "force_destroy" {
  description = "When deleting a bucket, this boolean option will delete all contained objects. If false, Terraform will fail to delete buckets which contain objects."
  type        = bool
  default     = false
}

variable "kms_key_names" {
  description = "Map of region names to CMEK key names. The CMEK keys must already exist in the corresponding regions."
  type        = map(string)
  default     = {}
}

variable "internal_encryption_config" {
  description = <<EOT
  Configuration for the creation of an internal Google Cloud Key Management Service (KMS) Key for use as Customer-managed encryption key (CMEK) for the GCS Bucket
  instead of creating one in advance and providing the key in the variable `encryption.default_kms_key_name`.
  create_encryption_key: If `true` a Google Cloud Key Management Service (KMS) KeyRing and a Key will be created
  prevent_destroy: Set the prevent_destroy lifecycle attribute on keys.
  key_destroy_scheduled_duration: Set the period of time that versions of keys spend in the `DESTROY_SCHEDULED` state before transitioning to `DESTROYED`.
  key_rotation_period: Generate a new key every time this period passes.
  EOT
  type = object({
    create_encryption_key          = optional(bool, false)
    prevent_destroy                = optional(bool, false)
    key_destroy_scheduled_duration = optional(string, null)
    key_rotation_period            = optional(string, "7776000s")
  })
  default = {}
}