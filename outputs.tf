output "agent_public_ips" {
  value = {
    for instance in oci_core_instance.agent_node :
    instance.display_name => instance.public_ip
  }
  description = "Public IPs of the agent nodes"
}

output "kv_namespace_id" {
  value       = cloudflare_workers_kv_namespace.ultrashort.id
  description = "ID of the KV namespace for ultra-short term memory"
}

output "r2_bucket_name" {
  value       = cloudflare_r2_bucket.artifacts.name
  description = "Name of the R2 bucket for artifacts"
}

output "agent_endpoint" {
  value       = "https://agent.${var.domain_name}"
  description = "Endpoint URL for the agent API"
}

output "k3s_config" {
  value = <<-EOT
    To configure kubectl to connect to the k3s cluster, run:
    
    ssh -i ~/.ssh/your_private_key ubuntu@${length(oci_core_instance.agent_node) > 0 ? oci_core_instance.agent_node[0].public_ip : "<agent-ip>"} \
      "sudo cat /etc/rancher/k3s/k3s.yaml" > k3s.yaml
    
    Then set the KUBECONFIG environment variable:
    export KUBECONFIG=./k3s.yaml
    
    Verify the connection:
    kubectl get nodes
  EOT
  description = "Instructions for connecting to the k3s cluster"
}

output "github_runner_instructions" {
  value = <<-EOT
    GitHub Actions runners have been installed on each agent node.
    To register additional runners, SSH into a node and run:
    
    cd /home/ubuntu/actions-runner
    ./config.sh --url https://github.com/my-agent-org --token <RUNNER_TOKEN> --name <RUNNER_NAME> --work _work
    sudo ./svc.sh install
    sudo ./svc.sh start
  EOT
  description = "Instructions for managing GitHub Actions runners"
}
