resource "kubernetes_namespace" "example" {
  metadata {
    name = "sb-graphql-h2-tf"
  }
}

resource "kubernetes_deployment" "example" {
  metadata {
    name = "sb-graphql-h2"
    labels = {
      test = "sb-graphql-h2"
    }
    namespace = "sb-graphql-h2-tf"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        test = "sb-graphql-h2"
      }
    }

    template {
      metadata {
        labels = {
          test = "sb-graphql-h2"
        }
      }

      spec {
        container {
          image = "cloudmahesh/sb-graphql-h2:tag1"
          name  = "sb-graphql-h2"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}