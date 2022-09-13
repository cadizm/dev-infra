# Get names using:
#   $ doctl compute image list-distribution
#
# Get sizes from:
#  https://registry.terraform.io/modules/terraform-digitalocean-modules/droplet/digitalocean/latest
resource "digitalocean_droplet" "digitaldev" {
  image      = "ubuntu-22-04-x64"
  name       = "digitaldev"
  region     = "sfo3"
  size       = "s-1vcpu-1gb"
  monitoring = true

  ssh_keys = [
    var.ssh_fingerprint
  ]

  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.pvt_key)
    timeout     = "2m"
  }
}

resource "digitalocean_domain" "digitaldev" {
  name       = "dev.cadizm.com"
  ip_address = digitalocean_droplet.digitaldev.ipv4_address
}

# NOTE: Commenting out resource `digitalocean_record`, since this droplet's
#       A record points to "dev" subdomain already
#
# resource "digitalocean_record" "CNAME-www" {
#   domain = digitalocean_domain.digitaldev.name
#   type   = "CNAME"
#   name   = "www"
#   value  = "@"
# }
