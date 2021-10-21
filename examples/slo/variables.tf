variable "region" {
  type        = string
  description = "AWS region"
}

variable "slo_paths" {
  type        = list(string)
  description = "List of paths to Datadog slo configurations"
}
