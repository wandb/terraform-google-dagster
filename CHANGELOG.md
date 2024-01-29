# Changelog

All notable changes to this project will be documented in this file.

## [2.7.0](https://github.com/wandb/terraform-google-dagster/compare/v2.6.0...v2.7.0) (2024-01-29)


### Features

* Increase CloudSQL active connections ([#19](https://github.com/wandb/terraform-google-dagster/issues/19)) ([a26c1b5](https://github.com/wandb/terraform-google-dagster/commit/a26c1b52abe1762fc340b5d86737bb84d18c1b92))

## [2.6.0](https://github.com/wandb/terraform-google-dagster/compare/v2.5.0...v2.6.0) (2023-10-27)


### Features

* Add lifecycle policy to storage bucket ([#17](https://github.com/wandb/terraform-google-dagster/issues/17)) ([b1f9fb6](https://github.com/wandb/terraform-google-dagster/commit/b1f9fb66c298411dd8fda3da6ce2fcc15005cf9d))

## [2.5.0](https://github.com/wandb/terraform-google-dagster/compare/v2.4.1...v2.5.0) (2023-10-26)


### Features

* Public IP address ([#16](https://github.com/wandb/terraform-google-dagster/issues/16)) ([2707f50](https://github.com/wandb/terraform-google-dagster/commit/2707f50a18ec5b5325aa12521c03f2f829150989))

### [2.4.1](https://github.com/wandb/terraform-google-dagster/compare/v2.4.0...v2.4.1) (2023-09-27)


### Bug Fixes

* Dagit has been renamed Dagster webserver ([#15](https://github.com/wandb/terraform-google-dagster/issues/15)) ([d56202c](https://github.com/wandb/terraform-google-dagster/commit/d56202cf8863c8a509cb23676dd657f09df4600f))

## [2.4.0](https://github.com/wandb/terraform-google-dagster/compare/v2.3.0...v2.4.0) (2023-09-25)


### Features

* Enable Google Groups for RBAC ([#14](https://github.com/wandb/terraform-google-dagster/issues/14)) ([2bac576](https://github.com/wandb/terraform-google-dagster/commit/2bac57608f4971dc383448a432eaa369f0409bcf))

## [2.3.0](https://github.com/wandb/terraform-google-dagster/compare/v2.2.0...v2.3.0) (2023-08-18)


### Features

* Add two registry outputs ([#13](https://github.com/wandb/terraform-google-dagster/issues/13)) ([d01fcd8](https://github.com/wandb/terraform-google-dagster/commit/d01fcd8e034728b70ca8900c8e6fd99966460bf9))

## [2.2.0](https://github.com/wandb/terraform-google-dagster/compare/v2.1.0...v2.2.0) (2023-08-14)


### Features

* Migrate out of legacy module configuration ([#12](https://github.com/wandb/terraform-google-dagster/issues/12)) ([d4e256f](https://github.com/wandb/terraform-google-dagster/commit/d4e256f62027c5fd4be9ccc70be2373e7379c111))

## [2.1.0](https://github.com/wandb/terraform-google-dagster/compare/v2.0.0...v2.1.0) (2023-01-19)


### Features

* Enable Cloud SQL IAM authentication ([#11](https://github.com/wandb/terraform-google-dagster/issues/11)) ([8b08ebc](https://github.com/wandb/terraform-google-dagster/commit/8b08ebccf42bea6ab74f12c688c34f2698c80bd4))

## [2.0.0](https://github.com/wandb/terraform-google-dagster/compare/v1.1.0...v2.0.0) (2022-10-19)


### ⚠ BREAKING CHANGES

* Enable cluster auto-scaling, auto-repairs and auto-upgrades (#10)

### Features

* Enable cluster auto-scaling, auto-repairs and auto-upgrades ([#10](https://github.com/wandb/terraform-google-dagster/issues/10)) ([7b6f93e](https://github.com/wandb/terraform-google-dagster/commit/7b6f93e3ee690cabc1f789d7a1d5352ccccdda1f))

## [1.1.0](https://github.com/wandb/terraform-google-dagster/compare/v1.0.1...v1.1.0) (2022-07-29)


### Features

* Export cluster ID ([#9](https://github.com/wandb/terraform-google-dagster/issues/9)) ([a995e7a](https://github.com/wandb/terraform-google-dagster/commit/a995e7a6bf6e85e7ebbdf3fcf2c6fea18b1854eb))

### [1.0.1](https://github.com/wandb/terraform-google-dagster/compare/v1.0.0...v1.0.1) (2022-07-12)


### Bug Fixes

* Explicitly disable client certificate auth (deprecated by kubernetes) ([#6](https://github.com/wandb/terraform-google-dagster/issues/6)) ([8c57966](https://github.com/wandb/terraform-google-dagster/commit/8c579669e9b5963f22a41a09546d626d9b134e7d))

## 1.0.0 (2022-04-04)


### Features

* Any filetype changed can trigger a release ([#5](https://github.com/wandb/terraform-google-dagster/issues/5)) ([d0462e5](https://github.com/wandb/terraform-google-dagster/commit/d0462e5492516be3e5413a24bb553cb3fc299345))
* enable workload identity on cluster ([2da02c2](https://github.com/wandb/terraform-google-dagster/commit/2da02c28c0f04438da192f68fe345521176392e2))
* release v1 ([#4](https://github.com/wandb/terraform-google-dagster/issues/4)) ([e3794fc](https://github.com/wandb/terraform-google-dagster/commit/e3794fc31b836f01922c7be53b9d0998394a56fd))


### Bug Fixes

* add suffix to cloud storage bucket name ([0729d97](https://github.com/wandb/terraform-google-dagster/commit/0729d97138b5337a5191bce61446f5fcc4b29e02))
* align service account variable names ([72f6c99](https://github.com/wandb/terraform-google-dagster/commit/72f6c99abb7cdfaa2fc8968d5c7a484b736ee4a9))
* fix syntax error with random generated string ([42c73d7](https://github.com/wandb/terraform-google-dagster/commit/42c73d7c90af910cf4923e033a7757abd6efc43b))
