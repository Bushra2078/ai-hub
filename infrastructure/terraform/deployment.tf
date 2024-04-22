module "azure_managed_identity" {
  source                      = "./modules/managedidentity"
  location                    = local.location
  user_assigned_identity_name = local.azure_managed_identity_name
  resource_group_name         = azurerm_resource_group.ingestion.name
}

module "azure_log_analytics" {
  source                            = "./modules/loganalytics"
  location                          = local.location
  log_analytics_name                = var.log_analytics_name
  log_analytics_sku                 = var.log_analytics_sku
  log_analytics_retention_in_days   = 30
  log_analytics_resource_group_name = azurerm_resource_group.observability.name
}

module "azure_key_vault" {
  source                     = "./modules/keyvault"
  key_vault_name             = local.azure_key_vault_name
  location                   = local.location
  resource_group_name        = azurerm_resource_group.ingestion.name
  key_vault_sku_name         = var.key_vault_sku
  log_analytics_workspace_id = module.azure_log_analytics.log_analytics_id
  cmk_uai_id                 = module.azure_managed_identity.user_assigned_identity_id
  subnet_id                  = var.subnet_id
}

module "azure_storage_account" {
  source                     = "./modules/storageaccount"
  location                   = local.location
  storage_account_name       = local.storage_account_name
  resource_group_name        = azurerm_resource_group.ingestion.name
  log_analytics_workspace_id = module.azure_log_analytics.log_analytics_id
  cmk_uai_id                 = module.azure_managed_identity.user_assigned_identity_id
  subnet_id                  = var.subnet_id
  cmk_key_vault_id           = module.azure_key_vault.key_vault_id
  cmk_key_name               = module.azure_key_vault.key_vault_key_storage_name
  depends_on                 = [module.azure_key_vault]
}

module "videoindexer" {
  source = "./modules/videoindexer"
  videoindexer_name   = local.videoindexer_name
  resource_group_id   = azurerm_resource_group.ingestion.id
  location            = local.location
  storage_account_id  = module.azure_storage_account.storage_account_id
}

module "azure_open_ai" {
  source                     = "./modules/aoai"
  location                   = local.location
  resource_group_name        = azurerm_resource_group.ingestion.name
  cognitive_service_name     = local.azure_open_ai_name
  cognitive_service_kind     = "OpenAI"
  cognitive_service_sku      = "S0"
  log_analytics_workspace_id = module.azure_log_analytics.log_analytics_id
  cmk_uai_id                 = module.azure_managed_identity.user_assigned_identity_id
  cmk_key_vault_id           = module.azure_key_vault.key_vault_id
  cmk_key_name               = module.azure_key_vault.key_vault_cmk_name
  key_vault_uri              = module.azure_key_vault.key_vault_uri
  subnet_id                  = var.subnet_id
}


# Commented out module "azure_search_service" block
# module "azure_search_service" {
#   source                     = "./modules/aisearch"
#   location                   = var.location
#   resource_group_name        = azurerm_resource_group.azureOpenAiWorkload_rg.name
#   search_service_name        = var.search_service_name
#   sku                        = "standard"
#   partition_count            = var.partition_count
#   replica_count              = var.replica_count
#   log_analytics_workspace_id = module.azure_log_analytics.log_analytics_id
#   cmk_uai_id                 = module.azure_managed_identity.user_assigned_identity_id
#   cmk_key_vault_id           = module.azure_key_vault.key_vault_id
#   subnet_id                  = var.subnet_id
#   cmk_key_name               = module.azure_key_vault.key_vault_cmk_name
# }



# Commented out module "data_factory" block
# module "data_factory" {
#   source                     = "./modules/datafactory"
#   location                   = var.location
#   resource_group_name        = azurerm_resource_group.azureOpenAiWorkload_rg.name
#   adf_service_name           = var.adf_service_name
#   sku                        = "Standard"
#   log_analytics_workspace_id = module.azure_log_analytics.log_analytics_id
#   subnet_id                  = var.subnet_id
# }

# Commented out module "document_intelligence" block
# module "document_intelligence" {
#   source                = "./modules/documentintel"
#   location              = var.location
#   resource_group_name   = azurerm_resource_group.azureOpenAiWorkload_rg.name
#   docintel_service_name = var.docintel_service_name
# }