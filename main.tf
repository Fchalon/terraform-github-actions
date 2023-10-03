module "vm" {
  source         = "./modules/vmlinux"
  prefix         = "chalon1"
  admin_username = "azureuser"
  hostname       = "chalon1"
}
