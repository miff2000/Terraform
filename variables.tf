variable "apikey" {
  type        = string
  description = "The API key to authenticate against the API with"
}

locals {
  domain_fqdn     = "uat.ukfast.co.uk"
  k8s_domain_fqdn = "k8s.${local.domain_fqdn}"
}
