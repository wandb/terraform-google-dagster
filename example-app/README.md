# Example Dagster Deployment

This uses the official [Dagster Helm chart](https://artifacthub.io/packages/helm/dagster/dagster) on top of the `terraform-google-dagster` (TDG) module. The TDG module will provision all of the infrastructure needed to deploy your Dagster Kubernetes cluster; attach it to a Cloud SQL database for persistent metadata storage; and a Cloud Storage bucket for IO management, log storage, or whatever else you may need it for.

You'll likely want to enable an ingress (either through the Helm chart or by creating your own Kubernetes ingress) to enable access to the Dagit UI.

**Important note**
If you are using your own code deployment image with the private Artifact Registry repository as the source you'll need to ensure you have published your code deployment image after the repository has been created by the TDG module. If not pushed, the Terraform module will time out as the user code deployment pod will be left in a state of `imagePullBackoff` as it will not be able to find the image.

## Usage

Ensure you have terraform installed ([instructions](https://learn.hashicorp.com/tutorials/terraform/install-cli#install-terraform))

Clone the base repository and navigate to the `example-app/` directory:

```
git clone https://github.com/wandb/terraform-google-dagster
cd terraform-google-dagster/example-app
```

Either set your variables in a `terraform.tfvars` or wait for the prompts to set these when applying the configuration.

```
terraform init
terraform apply
```

## Zero-Trust IAP Example

This example also includes optional IAP (Identity-Aware Proxy) resources that demonstrate how to implement zero-trust web access to the Dagster UI. This shows how consumers can build on the custom networking foundation provided by the main module.

### Prerequisites for IAP Example

1. **OAuth 2.0 Credentials**: Create in [Google Cloud Console](https://console.cloud.google.com/apis/credentials)
2. **Enable IAP API**: `gcloud services enable iap.googleapis.com`
3. **Configure OAuth consent screen** with your domain

### Usage with IAP

Add these variables to your `terraform.tfvars`:

```hcl
# Enable the IAP example
enable_iap_example = true

# OAuth credentials (must be pre-created)
oauth_client_id     = "your-oauth-client-id"
oauth_client_secret = "your-oauth-client-secret"

# Access control
iap_allowed_domains = ["yourdomain.com"]
iap_allowed_users   = ["admin@yourdomain.com"]

# Use a real domain for SSL certificate
domain = "dagster.yourdomain.com"

# Optional: Custom networking for private cluster
custom_networking = {
  network_self_link      = "projects/host-project/global/networks/shared-vpc"
  subnetwork_self_link   = "projects/host-project/regions/us-central1/subnetworks/shared-subnet"
  enable_private_cluster = true
  master_ipv4_cidr_block = "172.16.0.0/28"
  authorized_networks = [
    {
      cidr_block   = "10.0.0.0/8"
      display_name = "Corporate Network"
    }
  ]
}
```

After deployment, point your domain to the IAP ingress IP (available in `terraform output iap_ingress_ip`) and access your Dagster UI securely at `https://dagster.yourdomain.com`.
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0, < 2.0.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 6.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.4 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.9 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 6.46.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.17.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.38.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dagster_infra"></a> [dagster\_infra](#module\_dagster\_infra) | ../ | n/a |

## Resources

| Name | Type |
|------|------|
| [google_compute_global_address.dagster_ip](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) | resource |
| [google_compute_managed_ssl_certificate.dagster_ssl_cert](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_managed_ssl_certificate) | resource |
| [google_iap_web_iam_binding.dagster_iap_binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iap_web_iam_binding) | resource |
| [helm_release.dagster_service](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.dagster_user_deployment](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_ingress_v1.dagster_ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |
| [kubernetes_manifest.dagster_backend_config](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_secret.iap_oauth_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [google_client_config.current](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_networking"></a> [custom\_networking](#input\_custom\_networking) | Custom networking configuration for shared VPC scenarios | <pre>object({<br/>    network_self_link      = optional(string)<br/>    subnetwork_self_link   = optional(string)<br/>    enable_private_cluster = optional(bool, false)<br/>    master_ipv4_cidr_block = optional(string)<br/>    authorized_networks = optional(list(object({<br/>      cidr_block   = string<br/>      display_name = string<br/>    })), [])<br/>  })</pre> | `{}` | no |
| <a name="input_dagster_deployment_image"></a> [dagster\_deployment\_image](#input\_dagster\_deployment\_image) | Image name of user code deployment | `string` | `"user-code-example"` | no |
| <a name="input_dagster_deployment_tag"></a> [dagster\_deployment\_tag](#input\_dagster\_deployment\_tag) | User code deployment tag of Dagster to deploy | `string` | `"latest"` | no |
| <a name="input_dagster_version"></a> [dagster\_version](#input\_dagster\_version) | Version of Dagster to deploy | `string` | `"0.14.3"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | The domain in which your Google Groups are defined. | `string` | `"example"` | no |
| <a name="input_iap_allowed_domains"></a> [iap\_allowed\_domains](#input\_iap\_allowed\_domains) | Domains allowed to access through IAP | `list(string)` | `[]` | no |
| <a name="input_iap_allowed_users"></a> [iap\_allowed\_users](#input\_iap\_allowed\_users) | Users allowed to access through IAP | `list(string)` | `[]` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace used as a prefix for all resources | `string` | n/a | yes |
| <a name="input_oauth_client_id"></a> [oauth\_client\_id](#input\_oauth\_client\_id) | OAuth 2.0 client ID for IAP (required if enable\_iap\_example is true) | `string` | `null` | no |
| <a name="input_oauth_client_secret"></a> [oauth\_client\_secret](#input\_oauth\_client\_secret) | OAuth 2.0 client secret for IAP (required if enable\_iap\_example is true) | `string` | `null` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Google region | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | Google zone | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dagster_service_manifest"></a> [dagster\_service\_manifest](#output\_dagster\_service\_manifest) | n/a |
| <a name="output_dagster_user_deployment_manifest"></a> [dagster\_user\_deployment\_manifest](#output\_dagster\_user\_deployment\_manifest) | n/a |
| <a name="output_iap_domain"></a> [iap\_domain](#output\_iap\_domain) | Domain for IAP-protected access (if IAP example is enabled) |
| <a name="output_iap_ingress_ip"></a> [iap\_ingress\_ip](#output\_iap\_ingress\_ip) | Global IP address for IAP-protected Dagster web UI (if IAP example is enabled) |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
