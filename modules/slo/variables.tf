variable "datadog_slos" {
  type = map(object({
    name = string
    type = string

    thresholds = list(any)

    query = map(any)

    groups      = list(string)
    monitor_ids = list(number)

    description  = string
    force_delete = bool
    validate     = bool

    tags = list(string)
  }))
  description = "Map of Datadog SLO configurations. See catalog for examples"
}
