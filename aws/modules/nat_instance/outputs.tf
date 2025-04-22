output "http_rules" {
  value = local.http_rules
}

output "https_rules" {
  value = local.https_rules
}

output "eni_id" {
  value = module.instance_default.eni_id
}
