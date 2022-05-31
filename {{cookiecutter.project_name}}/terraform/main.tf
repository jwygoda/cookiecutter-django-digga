resource "digitalocean_project" "{{cookiecutter.project_name}}" {
  name        = "{{cookiecutter.project_name}}"
  description = "Django application"
  purpose     = "Web Application"
  environment = "Production"
}

data "digitalocean_image" "nixos" {
  name = "nixos.qcow2.gz"
}

resource "tls_private_key" "ssh" {
  algorithm = "ED25519"
}

resource "digitalocean_ssh_key" "default" {
  name       = "{{cookiecutter.project_name}}"
  public_key = tls_private_key.ssh.public_key_openssh
}

resource "digitalocean_droplet" "{{cookiecutter.project_name}}" {
  image  = data.digitalocean_image.nixos.id
  name   = "{{cookiecutter.project_name}}"
  region = "fra1"
  size   = "s-1vcpu-1gb"
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
}

resource "digitalocean_domain" "main" {
  name       = "{{cookiecutter.domain_name}}"
}

resource "digitalocean_record" "root" {
  domain = digitalocean_domain.main.name
  type   = "A"
  name   = "@"
  value = digitalocean_droplet.{{cookiecutter.project_name}}.ipv4_address
}
