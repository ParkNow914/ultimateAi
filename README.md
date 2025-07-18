# AI Agent Infrastructure

This repository contains the infrastructure as code for deploying a scalable AI agent system on Oracle Cloud's free tier ARM instances with Cloudflare Workers for edge computing.

## Prerequisites

1. **Oracle Cloud Account** with Free Tier access
2. **Cloudflare Account** with a domain
3. **GitHub Account** with a personal access token
4. **Upstash Account** for Redis
5. **OpenAI API Key**

## Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/my-agent-org/infra-agent.git
   cd infra-agent
   ```

2. **Create a `terraform.tfvars` file** with your credentials:
   ```hcl
   # Oracle Cloud
   oci_tenancy_ocid       = "ocid1.tenancy.oc1..xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
   oci_user_ocid          = "ocid1.user.oc1..xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
   oci_fingerprint        = "xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx"
   oci_private_key_path   = "~/.oci/oci_api_key.pem"
   compartment_id         = "ocid1.compartment.oc1..xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
   subnet_id              = "ocid1.subnet.oc1.sa-saopaulo-1.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
   
   # Cloudflare
   cloudflare_api_token   = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
   cloudflare_account_id  = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
   domain_name            = "yourdomain.com"
   
   # GitHub
   github_token           = "ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
   
   # Upstash
   upstash_redis_url     = "https://xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx.upstash.io"
   upstash_redis_token   = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
   
   # OpenAI
   openai_api_key        = "sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
   ```

3. **Initialize Terraform**
   ```bash
   terraform init
   ```

4. **Review the plan**
   ```bash
   terraform plan
   ```

5. **Apply the configuration**
   ```bash
   terraform apply
   ```

## Architecture

- **Compute**: 2x Oracle Cloud ARM instances (VM.Standard.A1.Flex)
- **Edge**: Cloudflare Workers for request handling
- **Storage**: Cloudflare R2 for artifacts
- **Caching**: Upstash Redis
- **Orchestration**: k3s on Oracle Cloud instances

## Directory Structure

```
infra-agent/
├── adapters/           # Language adapters for the agent
├── edge-controller/    # Cloudflare Worker code
├── modules/            # Reusable Terraform modules
│   ├── cloudflare/     # Cloudflare resources
│   └── oracle/         # Oracle Cloud resources
├── workflows/          # GitHub Actions workflows
├── agtctl/             # CLI tool for agent management
├── main.tf             # Main Terraform configuration
├── variables.tf        # Variable definitions
├── providers.tf        # Provider configurations
├── outputs.tf          # Output values
└── README.md           # This file
```

## Outputs

After applying the Terraform configuration, the following outputs will be displayed:

- `agent_public_ips`: Public IPs of the agent nodes
- `kv_namespace_id`: ID of the KV namespace for ultra-short term memory
- `r2_bucket_name`: Name of the R2 bucket for artifacts

## Next Steps

1. Connect to the agent nodes via SSH:
   ```bash
   ssh -i ~/.ssh/your_private_key ubuntu@<agent-public-ip>
   ```

2. Verify k3s installation:
   ```bash
   kubectl get nodes
   ```

3. Access the agent dashboard at: `https://agent.yourdomain.com`

## License

MIT License - see the [LICENSE](LICENSE) file for details.
