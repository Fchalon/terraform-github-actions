module "vm" {
  source         = "./modules/vmlinux"
  prefix         = "chalon"
  admin_username = "azureuser"
  hostname       = "chalon"
}
