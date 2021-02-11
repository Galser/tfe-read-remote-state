# tfe-read-remote-state
Access remote state in TFE

We have another [repo prepared](https://github.com/Galser/tfc-random-pet) and run initiated in TFE.

This repository going to demo accessing the state of the `tfc-random-pet` repo in the code.

# Code

Code in [main.tf](main.tf) :

```Terraform
data "terraform_remote_state" "tfc_random_pet" {
  backend = "remote"

  config = {
    organization = "galser-business"
    workspaces = {
      name = "tfc-random-pet"
    }
  }
}



# Terraform >= 0.12
output "remote-state-pet-demo" {
  value = data.terraform_remote_state.tfc_random_pet.outputs.demo
}

# Terraform <= 0.11
#output "remote-state-pet-demo" {
#  value = "${data.terraform_remote_state.tfc_random_pet.demo}"
#}

```

# Run example 

Below we can observer reading of the value from remote state : 

```
Terraform v0.13.5
Initializing plugins and modules...

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

remote-state-pet-demo = ample-baboon
```

And if we goign to check in the [previous repo](d](https://github.com/Galser/tfc-random-pet) : 

```bash
...
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

demo = ample-baboon
...
```
that's exactly the same value, coming from thise remote state  : 

```JSON
{
  "version": 4,
  "terraform_version": "0.13.5",
  "serial": 0,
  "lineage": "49535caf-9051-c565-c5ac-b79c3f4e870d",
  "outputs": {
    "demo": {
      "value": "ample-baboon",
      "type": "string"
    }
  },
  "resources": [
    {
      "mode": "managed",
      "type": "random_pet",
      "name": "demo",
      "provider": "provider[\"registry.terraform.io/hashicorp/random\"]",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "id": "ample-baboon",
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

