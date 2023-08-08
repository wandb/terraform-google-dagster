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
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | =1.5.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 4.13 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.4 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.9 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.77.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.10.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dagster_infra"></a> [dagster\_infra](#module\_dagster\_infra) | ../ | n/a |

## Resources

| Name | Type |
|------|------|
| [helm_release.dagster_service](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.dagster_user_deployment](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [google_client_config.current](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dagster_deployment_image"></a> [dagster\_deployment\_image](#input\_dagster\_deployment\_image) | Image name of user code deployment | `string` | `"user-code-example"` | no |
| <a name="input_dagster_deployment_tag"></a> [dagster\_deployment\_tag](#input\_dagster\_deployment\_tag) | User code deployment tag of Dagster to deploy | `string` | `"latest"` | no |
| <a name="input_dagster_version"></a> [dagster\_version](#input\_dagster\_version) | Version of Dagster to deploy | `string` | `"0.14.3"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace used as a prefix for all resources | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Google region | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | Google zone | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dagster_service_manifest"></a> [dagster\_service\_manifest](#output\_dagster\_service\_manifest) | n/a |
| <a name="output_dagster_user_deployment_manifest"></a> [dagster\_user\_deployment\_manifest](#output\_dagster\_user\_deployment\_manifest) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
