##################################################################################
# DATA
##################################################################################
 data "terraform_remote_state" "registry" {

 backend = "local"
  config = {
    path = "./../registry/terraform.tfstate"
  }
}