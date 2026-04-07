# Terraform Script: Count, For, and for_each Examples

terraform {
  required_version = ">= 1.3.0"
}

# -------------------------------------------------
# FOR LOOP EXAMPLES
# -------------------------------------------------
locals {
  names = ["alice", "bob", "charlie"]

  # Convert all names to uppercase
  upper_names = [
    for name in local.names : upper(name)
  ]

  # Keep only names longer than 3 characters
  long_names = [
    for name in local.names : name
    if length(name) > 3
  ]

  # Create a map using a for loop
  servers = {
    web = "10.0.1.10"
    db  = "10.0.1.20"
  }

  server_info = {
    for name, ip in local.servers :
    name => "${name} server IP is ${ip}"
  }
}

# -------------------------------------------------
# COUNT EXAMPLE
# Creates 3 resources
# -------------------------------------------------
resource "null_resource" "count_example" {
  count = 3

  triggers = {
    server_name = "server-${count.index}"
    index       = count.index
  }
}

# -------------------------------------------------
# FOR_EACH EXAMPLE
# Creates one resource for each service name
# -------------------------------------------------
resource "null_resource" "foreach_example" {
  for_each = toset(["web", "db", "cache"])

  triggers = {
    service = each.key
  }
}

# -------------------------------------------------
# OUTPUTS
# -------------------------------------------------
output "upper_names" {
  value = local.upper_names
}

output "long_names" {
  value = local.long_names
}

output "server_info" {
  value = local.server_info
}

output "count_result" {
  value = [
    for r in null_resource.count_example : r.triggers
  ]
}

output "foreach_result" {
  value = {
    for k, r in null_resource.foreach_example :
    k => r.triggers
  }
}
# ```

# Run:

# ```bash
# terraform init
# terraform apply -auto-approve
# ```

# Example output:

# ```bash
# upper_names = [
#   "ALICE",
#   "BOB",
#   "CHARLIE"
# ]

# long_names = [
#   "alice",
#   "charlie"
# ]

# count_result = [
#   {
#     "index" = "0"
#     "server_name" = "server-0"
#   },
#   {
#     "index" = "1"
#     "server_name" = "server-1"
#   },
#   {
#     "index" = "2"
#     "server_name" = "server-2"
#   }
# ]
# ```
