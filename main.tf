variable "tfe_token" {
	default = ""
}

data "terraform_remote_state" "tfc_random_pet" {
  backend = "remote"

  config = {
    hostname     = "tfe-migtest-2.guselietov.com"
    organization = "migrotest"
		token				 = var.tfe_token
    workspaces = {
      name = "tfc-random-pet"
    }
  }
}



resource "random_pet" "local-demo" { }

# Terraform >= 0.12
output "remote-state-pet-demo" {
  value = data.terraform_remote_state.tfc_random_pet.outputs.demo
}
