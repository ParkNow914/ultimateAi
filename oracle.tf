# Get the list of availability domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

# Get the latest Ubuntu image
data "oci_core_images" "ubuntu" {
  compartment_id   = var.compartment_id
  operating_system = "Canonical Ubuntu"
  sort_by          = "TIMECREATED"
  sort_order       = "DESC"
}

# Create compute instances for agent nodes
resource "oci_core_instance" "agent_node" {
  count               = 2
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_id
  display_name        = "agent-node-${count.index + 1}"
  shape               = "VM.Standard.A1.Flex"
  
  shape_config {
    memory_in_gbs = 6
    ocpus         = 1
  }
  
  create_vnic_details {
    subnet_id        = var.subnet_id
    assign_public_ip = true
    display_name     = "agent-vnic-${count.index + 1}"
  }
  
  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ubuntu.images[0].id
  }
  
  metadata = {
    ssh_authorized_keys = file(var.public_ssh_key_path)
    user_data = base64encode(<<-EOF
      #!/bin/bash
      # Install required packages
      apt-get update
      apt-get install -y docker.io
      systemctl enable --now docker
      curl -sL https://deb.nodesource.com/setup_16.x | bash -
      apt-get install -y nodejs
      
      # Install k3s
      curl -sfL https://get.k3s.io | sh -
      
      # Configure kubeconfig
      mkdir -p /home/ubuntu/.kube
      cp /etc/rancher/k3s/k3s.yaml /home/ubuntu/.kube/config
      chown -R ubuntu:ubuntu /home/ubuntu/.kube
      
      # Install Helm
      curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
      
      # Install GitHub Actions runner
      mkdir -p /home/ubuntu/actions-runner /home/ubuntu/work
      cd /home/ubuntu/actions-runner
      curl -o actions-runner-linux-arm64-2.311.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-linux-arm64-2.311.0.tar.gz
      tar xzf ./actions-runner-linux-arm64-2.311.0.tar.gz
      chown -R ubuntu:ubuntu /home/ubuntu/actions-runner
      
      # Configure and start GitHub Actions runner
      su - ubuntu -c "cd /home/ubuntu/actions-runner && \
                     ./config.sh --url https://github.com/my-agent-org --token ${var.github_runner_token} --name agent-${count.index + 1} --work _work --labels self-hosted,ARM64,ubuntu-22.04 --unattended && \
                     sudo ./svc.sh install && \
                     sudo ./svc.sh start"
      EOF
    )
  }
  
  agent_config {
    are_all_plugins_disabled = false
    is_management_disabled   = false
    is_monitoring_disabled   = false
    plugins_config {
      desired_state = "ENABLED"
      name          = "Bastion"
    }
  }
  
  lifecycle {
    ignore_changes = [
      defined_tags,
      freeform_tags,
      source_details[0].source_id
    ]
  }
}


