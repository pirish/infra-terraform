variable "org_enabled" {
  type        = bool
  description = "Is the account oganization enabled"
  default     = false
}

variable "is_primary_account" {
  type        = string
  description = "Is primary or parent account"
  default     = null
}

variable "base_domain" {
  type        = string
  description = "Base domain for the account"
}

variable "account_subdomain" {
  type        = string
  description = "Account subdomain for the account"
}
