# terraform-google-dagster
Terraform module to provision required GCP infrastructure necessary for a Dagster Kubernetes-based deployment.

**Note: this configuration does not bundle the Dagster application but rather all of its required services. A reference implementation may be found in the `example-app` directory.**

## Overview
The `terraform-google-dagster` module does not attempt to make any assumptions about how your Dagster deployment should look as this can vary widely and will not actually create a Dagster deployment. It _will_ create all of the core foundational components necessary for running a Dagster cluster which should be easily pluggable into the [Dagster Helm chart](https://artifacthub.io/packages/helm/dagster/dagster) or your own Dagster Kubernetes resources.

The module will provision:
- **Service account**: This will manage all of the resources associated with your application
- **Private network**: Private network from which your resources connect to one another (specifically Kubernetes and Postgres)
- **CloudSQL Postgres Instance**: A Cloud SQL Postgres instance
- **Kubernetes Cluster**: Primary cluster from which you can run dagit, the dagster-daemon and user code deployments
- **Cloud Storage Bucket**: Can be used as an IOManager, for log storage, asset materializations, or as a staging layer for data
- **Artifact Registry Docker Repository**: This can be used for for private code deployment images

# Example

You can find an example deployment utilizing the official [Dagster Helm chart](https://artifacthub.io/packages/helm/dagster/dagster) inside of the `example-app/` directory.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0, < 2.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cluster"></a> [cluster](#module\_cluster) | ./modules/cluster | n/a |
| <a name="module_database"></a> [database](#module\_database) | ./modules/database | n/a |
| <a name="module_networking"></a> [networking](#module\_networking) | ./modules/networking | n/a |
| <a name="module_project_factory_project_services"></a> [project\_factory\_project\_services](#module\_project\_factory\_project\_services) | terraform-google-modules/project-factory/google//modules/project_services | ~> 18.0 |
| <a name="module_registry"></a> [registry](#module\_registry) | ./modules/registry | n/a |
| <a name="module_service_account"></a> [service\_account](#module\_service\_account) | ./modules/service_account | n/a |
| <a name="module_storage"></a> [storage](#module\_storage) | ./modules/storage | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_storage_bucket_location"></a> [cloud\_storage\_bucket\_location](#input\_cloud\_storage\_bucket\_location) | Location to create cloud storage bucket in. | `string` | `"US"` | no |
| <a name="input_cloudsql_availability_type"></a> [cloudsql\_availability\_type](#input\_cloudsql\_availability\_type) | The availability type of the Cloud SQL instance. | `string` | `"ZONAL"` | no |
| <a name="input_cloudsql_postgres_version"></a> [cloudsql\_postgres\_version](#input\_cloudsql\_postgres\_version) | The postgres version of the CloudSQL instance. | `string` | `"POSTGRES_14"` | no |
| <a name="input_cloudsql_tier"></a> [cloudsql\_tier](#input\_cloudsql\_tier) | The machine type to use | `string` | `"db-f1-micro"` | no |
| <a name="input_cluster_compute_machine_type"></a> [cluster\_compute\_machine\_type](#input\_cluster\_compute\_machine\_type) | Compute machine type to deploy cluster nodes on. | `string` | `"e2-standard-2"` | no |
| <a name="input_cluster_monitoring_components"></a> [cluster\_monitoring\_components](#input\_cluster\_monitoring\_components) | Components to enable in the GKE monitoring stack. | `list(string)` | <pre>[<br/>  "SYSTEM_COMPONENTS"<br/>]</pre> | no |
| <a name="input_cluster_node_pool_max_node_count"></a> [cluster\_node\_pool\_max\_node\_count](#input\_cluster\_node\_pool\_max\_node\_count) | Max number of nodes cluster can scale up to. | `number` | `2` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Indicates whether or not storage and databases have deletion protection enabled | `bool` | `true` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | The domain in which your Google Groups are defined. | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace used as a prefix for all resources | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Google region | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudsql_database"></a> [cloudsql\_database](#output\_cloudsql\_database) | Object containing connection parameters for provisioned CloudSQL database |
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | Cluster certificate of provisioned Kubernetes cluster |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | Endpoint of provisioned Kubernetes cluster |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | Id of provisioned Kubernetes cluster |
| <a name="output_network_name"></a> [network\_name](#output\_network\_name) | Name of provisioned VPC network |
| <a name="output_registry_image_path"></a> [registry\_image\_path](#output\_registry\_image\_path) | Docker image path of provisioned Artifact Registry |
| <a name="output_registry_image_pull_secret"></a> [registry\_image\_pull\_secret](#output\_registry\_image\_pull\_secret) | Name of Kubernetes secret containing Docker config with permissions to pull from private Artifact Registry repository |
| <a name="output_registry_location"></a> [registry\_location](#output\_registry\_location) | Location of provisioned Artifact Registry |
| <a name="output_registry_name"></a> [registry\_name](#output\_registry\_name) | Name of provisioned Artifact Registry |
| <a name="output_service_account"></a> [service\_account](#output\_service\_account) | Service account created to manage and authenticate services. |
| <a name="output_storage_bucket_name"></a> [storage\_bucket\_name](#output\_storage\_bucket\_name) | Name of provisioned Cloud Storage bucket |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

# Development

If you'd like to contribute to this repository you'll have a few dependencies you'll need to install before committing. We use `pre-commit` to ensure standards are adhered to by running Terraform validations via git hooks. We specifically use the following packages:

- `conventional-pre-commit`: No additional dependencies needed for this
- `terraform_validate`: No additional dependencies needed for this
- `terraform_fmt`: No additional depenencies needed for this
- `terraform_docs`: Installation instructions [here](https://github.com/terraform-docs/terraform-docs)
- `terraform_tflint`: Installation instructions [here](https://github.com/terraform-linters/tflint)

You'll also need to install [`pre-commit`](https://pre-commit.com/#installation).

Once you have these dependencies installed you can execute the following:

```
pre-commit install
pre-commit install --hook-type commit-msg  # installs the hook for commit messages to enforce conventional commits
pre-commit run -a  # this will run pre-commit across all files in the project to validate installation
```

Now after creating git commits these commit hooks will execute and ensure your
changes adhere to the project standards. In general, we've followed the
guidelines for best-practices laid out in [Terraform Best
Practices](https://www.terraform-best-practices.com/), it would be recommended
to follow these guidelines when submitting any contributions of your own.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0, < 2.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cluster"></a> [cluster](#module\_cluster) | ./modules/cluster | n/a |
| <a name="module_database"></a> [database](#module\_database) | ./modules/database | n/a |
| <a name="module_networking"></a> [networking](#module\_networking) | ./modules/networking | n/a |
| <a name="module_project_factory_project_services"></a> [project\_factory\_project\_services](#module\_project\_factory\_project\_services) | terraform-google-modules/project-factory/google//modules/project_services | ~> 18.0 |
| <a name="module_registry"></a> [registry](#module\_registry) | ./modules/registry | n/a |
| <a name="module_service_account"></a> [service\_account](#module\_service\_account) | ./modules/service_account | n/a |
| <a name="module_storage"></a> [storage](#module\_storage) | ./modules/storage | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_storage_bucket_location"></a> [cloud\_storage\_bucket\_location](#input\_cloud\_storage\_bucket\_location) | Location to create cloud storage bucket in. | `string` | `"US"` | no |
| <a name="input_cloudsql_availability_type"></a> [cloudsql\_availability\_type](#input\_cloudsql\_availability\_type) | The availability type of the Cloud SQL instance. | `string` | `"ZONAL"` | no |
| <a name="input_cloudsql_postgres_version"></a> [cloudsql\_postgres\_version](#input\_cloudsql\_postgres\_version) | The postgres version of the CloudSQL instance. | `string` | `"POSTGRES_14"` | no |
| <a name="input_cloudsql_tier"></a> [cloudsql\_tier](#input\_cloudsql\_tier) | The machine type to use | `string` | `"db-f1-micro"` | no |
| <a name="input_cluster_compute_machine_type"></a> [cluster\_compute\_machine\_type](#input\_cluster\_compute\_machine\_type) | Compute machine type to deploy cluster nodes on. | `string` | `"e2-standard-2"` | no |
| <a name="input_cluster_monitoring_components"></a> [cluster\_monitoring\_components](#input\_cluster\_monitoring\_components) | Components to enable in the GKE monitoring stack. | `list(string)` | <pre>[<br/>  "SYSTEM_COMPONENTS"<br/>]</pre> | no |
| <a name="input_cluster_node_pool_max_node_count"></a> [cluster\_node\_pool\_max\_node\_count](#input\_cluster\_node\_pool\_max\_node\_count) | Max number of nodes cluster can scale up to. | `number` | `2` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Indicates whether or not storage and databases have deletion protection enabled | `bool` | `true` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | The domain in which your Google Groups are defined. | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace used as a prefix for all resources | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Google region | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudsql_database"></a> [cloudsql\_database](#output\_cloudsql\_database) | Object containing connection parameters for provisioned CloudSQL database |
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | Cluster certificate of provisioned Kubernetes cluster |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | Endpoint of provisioned Kubernetes cluster |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | Id of provisioned Kubernetes cluster |
| <a name="output_network_name"></a> [network\_name](#output\_network\_name) | Name of provisioned VPC network |
| <a name="output_registry_image_path"></a> [registry\_image\_path](#output\_registry\_image\_path) | Docker image path of provisioned Artifact Registry |
| <a name="output_registry_image_pull_secret"></a> [registry\_image\_pull\_secret](#output\_registry\_image\_pull\_secret) | Name of Kubernetes secret containing Docker config with permissions to pull from private Artifact Registry repository |
| <a name="output_registry_location"></a> [registry\_location](#output\_registry\_location) | Location of provisioned Artifact Registry |
| <a name="output_registry_name"></a> [registry\_name](#output\_registry\_name) | Name of provisioned Artifact Registry |
| <a name="output_service_account"></a> [service\_account](#output\_service\_account) | Service account created to manage and authenticate services. |
| <a name="output_storage_bucket_name"></a> [storage\_bucket\_name](#output\_storage\_bucket\_name) | Name of provisioned Cloud Storage bucket |
<!-- END_TF_DOCS -->
