resource "kubernetes_manifest" "traitdefinition_https_route" {
  manifest = {
    "apiVersion" = "core.oam.dev/v1beta1"
    "kind" = "TraitDefinition"
    "metadata" = {
      "annotations" = {
        "definition.oam.dev/description" = "defines HTTPS rules for mapping requests from a Gateway to Application."
      }
      "name" = "https-route"
      "namespace" = var.namespace
    }
    "spec" = {
      "appliesToWorkloads" = [
        "*",
      ]
      "conflictsWith" = []
      "podDisruptive" = false
      "schematic" = {
        "cue" = {
          "template" = file("${path.module}/https-route.cue")
        }
      }
    }
  }
}

resource "kubernetes_manifest" "traitdefinition_http_route" {
  manifest = {
    "apiVersion" = "core.oam.dev/v1beta1"
    "kind" = "TraitDefinition"
    "metadata" = {
      "annotations" = {
        "definition.oam.dev/description" = "defines HTTP rules for mapping requests from a Gateway to Application."
      }
      "name" = "http-route"
      "namespace" = var.namespace
    }
    "spec" = {
      "appliesToWorkloads" = [
        "*",
      ]
      "conflictsWith" = []
      "podDisruptive" = false
      "schematic" = {
        "cue" = {
          "template" = file("${path.module}/http-route.cue")
        }
      }
    }
  }
}

resource "kubectl_manifest" "traitdefinition_resource" {
  force_new = true
  yaml_body = yamlencode({
    "apiVersion" = "core.oam.dev/v1beta1"
    "kind" = "TraitDefinition"
    "metadata" = {
      "annotations" = {
        "definition.oam.dev/description" = "Add resource requests and limits on K8s pod for your workload which follows the pod spec in path 'spec.template."
      }
      "name" = "resource"
      "namespace" = var.namespace
    }
    "spec" = {
      "appliesToWorkloads" = [
        "deployments.apps", "statefulsets.apps", "daemonsets.apps", "jobs.batch"
      ]
      "conflictsWith" = []
      "podDisruptive" = true
      "schematic" = {
        "cue" = {
          "template" = file("${path.module}/resource.cue")
        }
      }
    }
  })
}
