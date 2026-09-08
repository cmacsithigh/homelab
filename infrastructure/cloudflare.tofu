resource "cloudflare_zone" "main" {
  account = {
    id = var.cloudflare.account_id
  }
  paused = false
  type   = "full"
  name   = "${local.site_name}.co"
}

resource "cloudflare_dns_record" "www" {
  zone_id = cloudflare_zone.main.id
  ttl     = 1
  name    = "www"
  content = "www.${local.site_name}.co.s3-website-${local.aws_region}.amazonaws.com"
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_dns_record" "site" {
  zone_id = cloudflare_zone.main.id
  ttl     = 1
  name    = "${local.site_name}.co"
  content = "${local.site_name}.co.s3-website-${local.aws_region}.amazonaws.com"
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "k8s" {
  account_id = var.cloudflare.account_id
  tunnel_id  = var.cloudflare.tunnel_id
  config = {
    ingress = [
      {
        hostname = "flux.ciansheehy.co"
        service  = "http://flux-operator.flux-system.svc.cluster.local:9080"
      },
      {
        hostname = "headlamp.ciansheehy.co"
        service  = "http://192.168.18.203"
      },
      {
        hostname = "home.ciansheehy.co"
        service  = "http://192.168.18.202"
      },
      {
        hostname = "keycloak.ciansheehy.co"
        service  = "http://192.168.18.208"
      },
      {
        hostname = "openbao.ciansheehy.co"
        service  = "http://192.168.18.205:8200"
      },
      {
        hostname = "ntfy.ciansheehy.co"
        service  = "http://192.168.18.211"
      },
      {
        hostname = "radio.ciansheehy.co"
        service  = "http://192.168.18.201"
      },
      {
        hostname = "ansible.ciansheehy.co"
        service  = "http://192.168.18.212"
      },
      },
      {
        hostname = "status.ciansheehy.co"
        service  = "http://192.168.18.209"
      },
      {
        service = "http_status:404"
      }
    ]
  }
}

resource "cloudflare_zero_trust_access_policy" "email" {
  name       = "email"
  account_id = var.cloudflare.account_id
  decision   = "allow"
  include = [
    {
      email = {
        email = "brennay@tcd.ie"
      }
    },
    {
      email = {
        email = "shazamjunk@gmail.com"
      }
    }
  ]
  session_duration = "6h"
}

resource "cloudflare_zero_trust_access_policy" "bypass" {
  name       = "bypass"
  account_id = var.cloudflare.account_id
  decision   = "bypass"
  include = [
    {
      everyone = {}
    }
  ]
  session_duration = "6h"
}


resource "cloudflare_zero_trust_access_application" "wildcard" {
  name                      = "ciansheehy"
  account_id                = var.cloudflare.account_id
  domain                    = "*.ciansheehy.co"
  auto_redirect_to_identity = true
  enable_binding_cookie     = false
  allowed_idps              = ["e7931f71-fd92-4e34-879c-8fc01185e2d8"]
  destinations = [{
    type = "public"
    uri  = "*.ciansheehy.co"
  }]
  policies = [{
    id         = cloudflare_zero_trust_access_policy.email.id
    precedence = 1
  }]
  http_only_cookie_attribute = false
  options_preflight_bypass   = false
  session_duration           = "6h"
  type                       = "self_hosted"
}

resource "cloudflare_zero_trust_access_application" "keycloak" {
  name                      = "keycloak"
  account_id                = var.cloudflare.account_id
  domain                    = "keycloak.ciansheehy.co/realms/*"
  auto_redirect_to_identity = true
  enable_binding_cookie     = false
  allowed_idps              = ["e7931f71-fd92-4e34-879c-8fc01185e2d8"]
  destinations = [{
    type = "public"
    uri  = "keycloak.ciansheehy.co/realms/*"
  }]
  policies = [{
    id         = cloudflare_zero_trust_access_policy.bypass.id
    precedence = 1
  }]
  http_only_cookie_attribute = false
  options_preflight_bypass   = false
  session_duration           = "6h"
  type                       = "self_hosted"
}

resource "cloudflare_zero_trust_access_application" "ntfy" {
  name                      = "ntfy"
  account_id                = var.cloudflare.account_id
  domain                    = "ntfy.ciansheehy.co/homelab"
  auto_redirect_to_identity = true
  enable_binding_cookie     = false
  allowed_idps              = ["e7931f71-fd92-4e34-879c-8fc01185e2d8"]
  destinations = [{
    type = "public"
    uri  = "ntfy.ciansheehy.co/homelab"
  }]
  policies = [{
    id         = cloudflare_zero_trust_access_policy.bypass.id
    precedence = 1
  }]
  http_only_cookie_attribute = false
  options_preflight_bypass   = false
  session_duration           = "6h"
  type                       = "self_hosted"
}