output BUILD_IP {
  value = yandex_compute_instance.vm-build.network_interface.0.nat_ip_address
}
output PROD_IP {
  value = yandex_compute_instance.vm-prod.network_interface.0.nat_ip_address
}