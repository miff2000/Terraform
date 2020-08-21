terraform {
  required_providers {
    ecloud = {
      source = "ukfast/ecloud"
    }
  }
}

provider "ecloud" {
  api_key = var.apikey
}

data "ecloud_template" "centos7" {
  pod_id = data.ecloud_pod.manc-north.id
  name   = "CentOS 7 64-bit"
}

data "ecloud_solution" "uat-solution" {
  name = "UAT - Single Site"
}

data "ecloud_network" "web" {
  name        = "UKFast | UAT | Web"
  solution_id = data.ecloud_solution.uat-solution.id
}

data "ecloud_pod" "manc-north" {
  name = "Manchester North West"
}

data "ecloud_site" "site-a" {
  pod_id      = data.ecloud_pod.manc-north.id
  solution_id = data.ecloud_solution.uat-solution.id
}

data "ecloud_datastore" "site-a-datastore1" {
  name        = "Datastore Data-01"
  solution_id = data.ecloud_solution.uat-solution.id
  site_id     = data.ecloud_site.site-a.id
}

#############################################
# Terraform trial
#############################################
resource "ecloud_virtualmachine" "tf-trial" {
  solution_id  = data.ecloud_solution.uat-solution.id
  name         = "tf-trial"
  computername = "tf-trial.${local.domain_fqdn}"
  cpu          = 4
  ram          = 4

  disk {
    capacity = 40
  }

  template             = data.ecloud_template.centos7.id
  environment          = data.ecloud_solution.uat-solution.environment
  site_id              = data.ecloud_site.site-a.id
  datastore_id         = data.ecloud_datastore.site-a-datastore1.id
  network_id           = data.ecloud_network.web.id
  external_ip_required = false
}
