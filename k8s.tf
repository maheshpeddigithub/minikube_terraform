# Namespace
resource "kubernetes_namespace" "sb3-graphql-h2-ns" {
  metadata {
        name = "sb3-graphql-h2-ns"
  }
}

# Deployment
resource "kubernetes_deployment" "sb3-graphql-h2-dp" {
  metadata {
    name = "sb3-graphql-h2-dp"
    namespace = kubernetes_namespace.sb3-graphql-h2-ns.id
    labels = {
      App = "sb3-graphql-h2-h2"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "sb3-graphql-h2"
      }
    }
    template {
      metadata {
        labels = {
          App = "sb3-graphql-h2"
        }
      }
      spec {
        container {
          image = "cloudmahesh/sb3-graphql-h2:tag1"
          name  = "sb3-graphql-h2"

          port {
            container_port = 8080
          }

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


#  Service
resource "kubernetes_service" "sb3-graphql-h2-svc" {
  metadata {
    name = "sb3-graphql-h2-svc"
    namespace = kubernetes_namespace.sb3-graphql-h2-ns.id
  }
  spec {
    selector = {
      App = kubernetes_deployment.sb3-graphql-h2-dp.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 8080
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}