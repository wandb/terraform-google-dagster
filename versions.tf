terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.13"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.9"
    }
  }
}
