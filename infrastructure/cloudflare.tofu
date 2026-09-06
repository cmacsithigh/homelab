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
        hostname = "status.ciansheehy.co"
        service  = "http://192.168.18.209"
      },
      {
        service = "http_status:404"
      }
    ]
  }
}
