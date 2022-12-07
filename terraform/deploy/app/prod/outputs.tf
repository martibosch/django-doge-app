output "droplet_host" {
  description = "Public IPv4 address of the droplet."
  value       = module.app.ipv4_address
}
