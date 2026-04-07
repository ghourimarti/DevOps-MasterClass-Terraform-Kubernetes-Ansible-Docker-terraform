terraform {
  required_version = ">= 1.3.0"
}

locals {
  # -------------------------------------------------
  # base64encode(string)
  # Encodes a plain string into Base64
  # -------------------------------------------------
  base64_encoded = base64encode("hello terraform")

  # -------------------------------------------------
  # base64decode(string)
  # Decodes a Base64 string back to plain text
  # -------------------------------------------------
  base64_decoded = base64decode(local.base64_encoded)

  # -------------------------------------------------
  # chomp(string)
  # Removes trailing newline characters
  # -------------------------------------------------
  chomp_example = chomp("hello world\n")

  # -------------------------------------------------
  # chop(string)
  # Removes the last character from a string
  # -------------------------------------------------
  # chop_example = chop("hello!")

  # -------------------------------------------------
  # chunklist(list, size)
  # Splits a list into smaller lists of given size
  # -------------------------------------------------
  chunklist_example = chunklist([
    "a", "b", "c", "d", "e", "f"
  ], 2)

  # Result:
  # [
  #   ["a", "b"],
  #   ["c", "d"],
  #   ["e", "f"]
  # ]

  # -------------------------------------------------
  # coalesce(string1, string2, ...)
  # Returns the first non-null / non-empty string
  # -------------------------------------------------
  coalesce_example = coalesce("", null, "terraform", "backup")

  # -------------------------------------------------
  # coalescelist(list1, list2, ...)
  # Returns the first non-empty list
  # -------------------------------------------------
  coalescelist_example = coalescelist([], [], ["prod", "dev"])

  # -------------------------------------------------
  # compact(list)
  # Removes null or empty-string values from a list
  # -------------------------------------------------
  compact_example = compact([
    "web",
    "",
    null,
    "db"
  ])

  # -------------------------------------------------
  # concat(list1, list2, ...)
  # Joins multiple lists together
  # -------------------------------------------------
  concat_example = concat(
    ["web", "api"],
    ["db"],
    ["cache"]
  )

  # -------------------------------------------------
  # contains(list, element)
  # Returns true if list contains the given value
  # -------------------------------------------------
  contains_example = contains(["dev", "stage", "prod"], "prod")

  # -------------------------------------------------
  # element(list, index)
  # Returns the item at the given index
  # Supports wrap-around if index is larger than list size
  # -------------------------------------------------
  element_example = element(["us-east-1", "us-west-2", "eu-west-1"], 1)

  # Returns "us-west-2"

  wraparound_element = element(["a", "b", "c"], 5)

  # Index 5 wraps around => "c"

  # -------------------------------------------------
  # length(list/string/map)
  # Returns number of items or characters
  # -------------------------------------------------
  length_list_example   = length(["a", "b", "c"])
  length_string_example = length("terraform")

# -------------------------------------------------
  # lookup(map, key, default)
  # Reads a key from a map safely
  # -------------------------------------------------
  lookup_example = lookup(
    {
      env  = "prod"
      team = "platform"
    },
    "team",
    "unknown"
  )

  missing_lookup_example = lookup(
    {
      env = "prod"
    },
    "owner",
    "default-owner"
  )

  # -------------------------------------------------
  # timestamp()
  # Returns current UTC timestamp when apply runs
  # -------------------------------------------------
  timestamp_example = timestamp()

  # -------------------------------------------------
  # trimspace(string)
  # Removes leading and trailing spaces/newlines
  # -------------------------------------------------
  trimspace_example = trimspace("   terraform rocks   ")

  # -------------------------------------------------
  # uuid()
  # Generates a random UUID each apply
  # -------------------------------------------------
  uuid_example = uuid()

  # -------------------------------------------------
  # FOR LOOP EXAMPLE
  # Create uppercase names from a list
  # -------------------------------------------------
  names = ["alice", "bob", "charlie"]

  uppercase_names = [
    for name in local.names : upper(name)
  ]

  # -------------------------------------------------
  # FOR LOOP WITH CONDITION
  # Keep only names longer than 3 chars
  # -------------------------------------------------
  filtered_names = [
    for name in local.names : name
    if length(name) > 3
  ]

  # -------------------------------------------------
  # FOR LOOP TO CREATE MAP
  # -------------------------------------------------
  servers = {
    web = "10.0.1.10"
    db  = "10.0.1.20"
  }

  server_descriptions = {
    for name, ip in local.servers :
    name => "${name} server runs on ${ip}"
  }
}

# -------------------------------------------------
# COUNT EXAMPLE
# Creates 3 resources using count
# -------------------------------------------------
resource "null_resource" "count_example" {
  count = 3

  triggers = {
    instance_number = count.index
    name            = "server-${count.index}"
  }
}

# -------------------------------------------------
# FOR_EACH EXAMPLE
# Creates one resource for each item in the set
# -------------------------------------------------
resource "null_resource" "foreach_example" {
  for_each = toset(["web", "db", "cache"])

  triggers = {
    service = each.key
  }
}

# -------------------------------------------------
# OUTPUTS
# Use these to see all results after terraform apply
# -------------------------------------------------
output "base64_encoded" {
  value = local.base64_encoded
}

output "base64_decoded" {
  value = local.base64_decoded
}

output "chomp_example" {
  value = local.chomp_example
}

# output "chop_example" {
#   value = local.chop_example
# }

output "chunklist_example" {
  value = local.chunklist_example
}

output "coalesce_example" {
  value = local.coalesce_example
}

output "coalescelist_example" {
  value = local.coalescelist_example
}

output "compact_example" {
  value = local.compact_example
}

output "concat_example" {
  value = local.concat_example
}

output "contains_example" {
  value = local.contains_example
}

output "element_example" {
  value = local.element_example
}

output "wraparound_element" {
  value = local.wraparound_element
}

output "length_list_example" {
  value = local.length_list_example
}

output "length_string_example" {
  value = local.length_string_example
}

output "lookup_example" {
  value = local.lookup_example
}

output "missing_lookup_example" {
  value = local.missing_lookup_example
}

output "timestamp_example" {
  value = local.timestamp_example
}

output "trimspace_example" {
  value = local.trimspace_example
}

output "uuid_example" {
  value = local.uuid_example
}

output "uppercase_names" {
  value = local.uppercase_names
}

output "filtered_names" {
  value = local.filtered_names
}

output "server_descriptions" {
  value = local.server_descriptions
}

output "count_resources" {
  value = [
    for r in null_resource.count_example : r.triggers
  ]
}

output "foreach_resources" {
  value = {
    for k, r in null_resource.foreach_example :
    k => r.triggers
  }
}