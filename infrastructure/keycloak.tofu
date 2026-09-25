locals {
  groups = ["headlamp-admins", "headlamp-readers"]
  users = {
    "csheehy" = {
      first_name = "C"
      last_name  = "S"
      email      = "cs@homelab.com"
      groups     = ["headlamp-admins"]
    }
    "brennay" = {
      first_name = "Y"
      last_name  = "B"
      email      = "by@homelab.com"
      groups     = ["headlamp-readers"]
    }
  }
}

resource "keycloak_realm" "homelab" {
  realm   = "homelab"
  enabled = true
}

resource "keycloak_openid_client" "headlamp" {
  realm_id                     = keycloak_realm.homelab.id
  client_id                    = "headlamp"
  name                         = "headlamp"
  enabled                      = true
  access_type                  = "CONFIDENTIAL"
  standard_flow_enabled        = true
  direct_access_grants_enabled = false
  valid_redirect_uris = [
    "https://headlamp.ciansheehy.co/oidc-callback"
  ]
  web_origins = [
    "https://headlamp.ciansheehy.co"
  ]
}

resource "keycloak_openid_client_scope" "groups_scope" {
  realm_id = keycloak_realm.homelab.id
  name     = "groups"
}

resource "keycloak_openid_group_membership_protocol_mapper" "group_mapper" {
  realm_id            = keycloak_realm.homelab.id
  client_scope_id     = keycloak_openid_client_scope.groups_scope.id
  name                = "groups"
  claim_name          = "groups"
  full_path           = false
  add_to_id_token     = true
  add_to_access_token = true
  add_to_userinfo     = true
}

resource "keycloak_openid_client_default_scopes" "headlamp_default_scopes" {
  realm_id  = keycloak_realm.homelab.id
  client_id = keycloak_openid_client.headlamp.id
  default_scopes = [
    "profile",
    "email",
    keycloak_openid_client_scope.groups_scope.name
  ]
}

resource "keycloak_openid_user_property_protocol_mapper" "username_mapper" {
  realm_id            = keycloak_realm.homelab.id
  client_id           = keycloak_openid_client.headlamp.id
  name                = "username"
  user_property       = "username"
  claim_name          = "username"
  add_to_id_token     = true
  add_to_access_token = true
  add_to_userinfo     = true
}

resource "keycloak_group" "this" {
  for_each = toset(local.groups)
  realm_id = keycloak_realm.homelab.id
  name     = each.value
}

resource "keycloak_user" "this" {
  for_each   = local.users
  realm_id   = keycloak_realm.homelab.id
  username   = each.key
  first_name = each.value.first_name
  last_name  = each.value.last_name
  email      = each.value.email
  enabled    = true
}

resource "keycloak_user_groups" "this" {
  for_each = local.users
  realm_id = keycloak_realm.homelab.id
  user_id  = keycloak_user.this[each.key].id
  group_ids = [
    for g in each.value.groups : keycloak_group.this[g].id
  ]
  depends_on = [keycloak_group.this]
}
