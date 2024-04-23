# resource "azurerm_private_endpoint" "key_vault_private_endpoint" {
#   name = "${azurerm_key_vault.key_vault.name}-pe"
#   location = var.location
#   resource_group_name = var.resource_group_name
#   custom_network_interface_name = "${azurerm_key_vault.key_vault.name}-nic"
#   private_service_connection {
#     name                           = "${azurerm_key_vault.key_vault.name}-pe"
#     is_manual_connection           = false
#     private_connection_resource_id = azurerm_key_vault.key_vault.id
#     subresource_names              = ["vault"]
#   }
#   subnet_id = var.subnet_id
# }