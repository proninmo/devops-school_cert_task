terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.81.0"
    }
  }
}

// Configure the Yandex.Cloud provider
provider "yandex" {
  service_account_key_file = "./key.json"
  cloud_id                 = ""
  folder_id                = ""
  zone                     = ""
}