terraform {
    required_providers {
         kubernetes = {
            source = "hashicorp/kubernetes"
            version = "2.3.2"
            configuration_aliases = [ kubernetes.dev ]
        }
    }
}