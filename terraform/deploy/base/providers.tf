terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 4.28"
    }
  }
}

provider "digitalocean" {
  # tokens are set in terraform cloud by setting the DIGITALOCEAN_TOKEN environment variable there
  token = var.do_token
}

provider "github" {
  # tokens are set in terraform cloud by setting the GITHUB_TOKEN environment variable there
  token = var.gh_token
}
