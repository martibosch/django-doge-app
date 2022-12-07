resource "digitalocean_droplet" "droplet" {
  name   = "${var.resource_prefix}-${var.env}"
  image  = var.droplet_image
  region = var.do_region
  size   = var.droplet_size
  ssh_keys = [
    var.do_ssh_key_id
  ]

  user_data = var.droplet_user_data
}

data "digitalocean_domain" "domain" {
  name = var.domain_name
}

resource "digitalocean_spaces_bucket" "bucket" {
  name          = "${var.resource_prefix}-${var.env}"
  acl           = "public-read"
  force_destroy = true
  region        = var.do_region

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = [data.digitalocean_domain.domain.name]
  }
}

resource "digitalocean_record" "a" {
  domain = data.digitalocean_domain.domain.name
  name   = var.a_record_name
  type   = "A"
  value  = digitalocean_droplet.droplet.ipv4_address
}

resource "digitalocean_record" "cname" {
  count  = var.create_cname ? 1 : 0
  domain = data.digitalocean_domain.domain.name
  name   = "www"
  type   = "CNAME"
  value  = "@"
}

resource "digitalocean_project_resources" "resources" {
  project = var.do_project_id
  resources = [
    digitalocean_droplet.droplet.urn,
    digitalocean_spaces_bucket.bucket.urn
  ]
}
