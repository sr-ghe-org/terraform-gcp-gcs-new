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

output "gcs_bucket_names" {
  description = "List of created GCS bucket names."
  value       = var.bucket_type == "non-pci" ? module.non_pci_gcs_buckets[0].gcs_bucket_names : (var.bucket_type == "pci" ? module.pci_gcs_buckets[0].gcs_bucket_names : [])
}

output "gcs_bucket_urls" {
  description = "List of created GCS bucket URLs."
  value       = var.bucket_type == "non-pci" ? module.non_pci_gcs_buckets[0].gcs_bucket_urls : (var.bucket_type == "pci" ? module.pci_gcs_buckets[0].gcs_bucket_urls : [])
}

output "regions" {
  description = "List of regions where the GCS buckets are created."
  value       = var.bucket_type == "non-pci" ? module.non_pci_gcs_buckets[0].regions : (var.bucket_type == "pci" ? module.pci_gcs_buckets[0].regions : [])
}