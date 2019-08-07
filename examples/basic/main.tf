provider "digitalocean" {
}

resource "digitalocean_droplet" "example" {
  name   = "example"
  image  = "ubuntu-18-04-x64"
  region = "nyc3"
  size   = "s-1vcpu-1gb"
}

# By default, DigitalOcean's suggested default rules are defined that allow some
# fundamental traffic. Simply provide an empty value for bpth inbound_rules and
# outbound_rules if you wish to overwrite them.
# https://www.digitalocean.com/docs/networking/firewalls/how-to/create/#default-inbound-rule-ssh
# https://www.digitalocean.com/docs/networking/firewalls/how-to/create/#default-outbound-rules-permit-all-traffic
module "presets-fw" {
  source      = "../"
  name        = "example-presets-fw"
  droplet_ids = [digitalocean_droplet.example.id]
}

# Here is an example of specifying 100% custom firewall rules without defaults.
module "custom-fw" {
  source      = "../"
  name        = "example-custom-fw"
  droplet_ids = [digitalocean_droplet.example.id]

  outbound_rules = []
  inbound_rules = [{
    protocol         = "tcp"
    port_range       = "3306"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }]
}
