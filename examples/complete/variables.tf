variable "region" {
  type        = string
  description = "AWS region"
}

variable "alert_tags" {
  type        = string
  description = "Space-separated string of alert tags to add to all alert messages, e.g. `@opsgenie` or `@devops`"
}
