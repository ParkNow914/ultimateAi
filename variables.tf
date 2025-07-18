variable "oci_tenancy_ocid" {
  type        = string
  description = "OCID of the OCI tenancy"
}

variable "oci_user_ocid" {
  type        = string
  description = "OCID of the OCI user"
}

variable "oci_fingerprint" {
  type        = string
  description = "Fingerprint of the OCI API key"
}

variable "oci_private_key_path" {
  type        = string
  description = "Path to the private key for OCI API auth"
  default     = "~/.oci/oci_api_key.pem"
}

variable "oci_region" {
  type        = string
  description = "The OCI region to deploy to"
  default     = "sa-saopaulo-1"
}

variable "cloudflare_api_token" {
  type        = string
  description = "API token for Cloudflare"
  sensitive   = true
}

variable "cloudflare_account_id" {
  type        = string
  description = "Account ID for Cloudflare"
}

variable "github_token" {
  type        = string
  description = "GitHub personal access token"
  sensitive   = true
}

variable "upstash_redis_url" {
  type        = string
  description = "Upstash Redis URL"
  sensitive   = true
}

variable "upstash_redis_token" {
  type        = string
  description = "Upstash Redis token"
  sensitive   = true
}

# Oracle Cloud specific variables
variable "compartment_id" {
  type        = string
  description = "OCID of the compartment"
}

variable "subnet_id" {
  type        = string
  description = "OCID of the subnet"
}

variable "public_ssh_key_path" {
  type        = string
  description = "Path to the public SSH key"
  default     = "~/.ssh/id_rsa.pub"
}

# Domain name for the agent
variable "domain_name" {
  type        = string
  description = "Domain name for the agent"
  default     = "agent.example.com"
}

# OpenAI API Key for the agent
variable "openai_api_key" {
  type        = string
  description = "OpenAI API key for the agent"
  sensitive   = true
}

# GitHub Runner Token for self-hosted runners
variable "github_runner_token" {
  type        = string
  description = "GitHub token for registering self-hosted runners"
  sensitive   = true
}
