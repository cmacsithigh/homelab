variable "cloudflare" {
  description = "Cloudflare object"
  type = object({
    api_token  = string
    account_id = string
    tunnel_id  = string
  })
}