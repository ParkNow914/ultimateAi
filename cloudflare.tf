# Create a KV namespace for ultra-short term memory
resource "cloudflare_workers_kv_namespace" "ultrashort" {
  account_id = var.cloudflare_account_id
  title      = "ultrashort_memory"
}

# Create R2 bucket for artifacts
resource "cloudflare_r2_bucket" "artifacts" {
  account_id = var.cloudflare_account_id
  name       = "agent-artifacts"
  location   = "ENAM"  # Eastern North America
}

# Create a DNS zone for the agent
resource "cloudflare_zone" "agent" {
  account_id = var.cloudflare_account_id
  zone       = var.domain_name
  jump_start = false
  type       = "full"
}

# Create DNS records for the agent
resource "cloudflare_record" "agent" {
  zone_id = cloudflare_zone.agent.id
  name    = "agent"
  value   = oci_core_instance.agent_node[0].public_ip
  type    = "A"
  ttl     = 300
  proxied = true
}

# Create a worker script for the agent controller
resource "cloudflare_worker_script" "agent_controller" {
  name    = "agent-controller"
  content = file("${path.module}/edge-controller/index.js")

  kv_namespace_binding {
    name         = "AGENT_KV"
    namespace_id = cloudflare_workers_kv_namespace.ultrashort.id
  }

  r2_bucket_binding {
    name        = "AGENT_ARTIFACTS"
    bucket_name = cloudflare_r2_bucket.artifacts.name
  }

  secret_text_binding {
    name = "OPENAI_API_KEY"
    text = var.openai_api_key
  }
}

# Create a worker route
resource "cloudflare_worker_route" "agent_route" {
  zone_id     = cloudflare_zone.agent.id
  pattern     = "agent.${var.domain_name}/*"
  script_name = cloudflare_worker_script.agent_controller.name
}


