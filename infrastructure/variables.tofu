variable "cloudflare" {
  description = "Cloudflare object"
  type = object({
    api_token  = string
    account_id = string
    tunnel_id  = string
  })
}

variable "keycloak" {
  description = "keycloak object"
  type = object({
    client_secret = string
    url           = string
  })
}