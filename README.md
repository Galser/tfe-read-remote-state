# tfe-read-remote-state
Access remote state of TF 0.12.20 in TFE with TF 0.12.24

We have another [repo prepared](https://github.com/Galser/tfc-random-pet) and run initiated in TFE.

This repository going to demo accessing the state of the `tfc-random-pet` repo in the code.

# Code

Code in [main.tf](main.tf) :

```Terraform
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
```

# Run example 

Below we can observer reading of the value from remote state : 

```
Terraform v0.12.24
Initializing plugins and modules...
2021/02/11 15:38:07 [DEBUG] Using modified User-Agent: Terraform/0.12.24 TFE/v202012-2
random_pet.local-demo: Creating...
random_pet.local-demo: Creation complete after 0s [id=relevant-fawn]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

remote-state-pet-demo = strong-mudfish

```

And if we goign to check in the [previous repo](d](https://github.com/Galser/tfc-random-pet) : 

```bash
...
Terraform v0.12.20
Initializing plugins and modules...
2021/02/11 15:31:56 [DEBUG] Using modified User-Agent: Terraform/0.12.20 TFE/v202012-2
random_pet.demo: Creating...
random_pet.demo: Creation complete after 0s [id=strong-mudfish]

...
```
that's exactly the same value, coming from thise remote state  : 

```JSON
{
  "version": 4,
  "terraform_version": "0.12.20",
  "serial": 2,
  "lineage": "e390ba71-52f7-2d72-daf8-1e4143a2fc81",
  "outputs": {
    "demo": {
      "value": "strong-mudfish",
      "type": "string"
    }
  },
  "resources": [
    {
      "mode": "managed",
      "type": "random_pet",
      "name": "demo",
      "provider": "provider.random",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "id": "strong-mudfish",
            "keepers": null,
            "length": 2,
            "prefix": null,
            "separator": "-"
          },
          "private": "bnVsbA=="
        }
      ]
    }
  ]
}
```

**What is worse mentioning that the READING workspace can have Terraform HIGHER version that the source state.**
