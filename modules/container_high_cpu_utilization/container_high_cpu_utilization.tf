resource "shoreline_notebook" "container_high_cpu_utilization" {
  name       = "container_high_cpu_utilization"
  data       = file("${path.module}/data/container_high_cpu_utilization.json")
  depends_on = [shoreline_action.invoke_container_cpu_utilization,shoreline_action.invoke_update_cpu_limits]
}

resource "shoreline_file" "container_cpu_utilization" {
  name             = "container_cpu_utilization"
  input_file       = "${path.module}/data/container_cpu_utilization.sh"
  md5              = filemd5("${path.module}/data/container_cpu_utilization.sh")
  description      = "The container has been assigned more CPU resources than it actually needs, leading to high utilization."
  destination_path = "/agent/scripts/container_cpu_utilization.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "update_cpu_limits" {
  name             = "update_cpu_limits"
  input_file       = "${path.module}/data/update_cpu_limits.sh"
  md5              = filemd5("${path.module}/data/update_cpu_limits.sh")
  description      = "Adjust the container's CPU limits to better match its actual usage."
  destination_path = "/agent/scripts/update_cpu_limits.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_container_cpu_utilization" {
  name        = "invoke_container_cpu_utilization"
  description = "The container has been assigned more CPU resources than it actually needs, leading to high utilization."
  command     = "`chmod +x /agent/scripts/container_cpu_utilization.sh && /agent/scripts/container_cpu_utilization.sh`"
  params      = ["CPU_LIMIT","CONTAINER_NAME"]
  file_deps   = ["container_cpu_utilization"]
  enabled     = true
  depends_on  = [shoreline_file.container_cpu_utilization]
}

resource "shoreline_action" "invoke_update_cpu_limits" {
  name        = "invoke_update_cpu_limits"
  description = "Adjust the container's CPU limits to better match its actual usage."
  command     = "`chmod +x /agent/scripts/update_cpu_limits.sh && /agent/scripts/update_cpu_limits.sh`"
  params      = ["CPU_LIMIT","CONTAINER_NAME"]
  file_deps   = ["update_cpu_limits"]
  enabled     = true
  depends_on  = [shoreline_file.update_cpu_limits]
}

