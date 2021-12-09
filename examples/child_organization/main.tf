module "datadog_child_organization" {
  source = "../../modules/child_organization"

  organization_name = var.organization_name

  context = module.this.context
}
