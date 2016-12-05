-- global config 

local config= {};
config.dnsBase= "ProductTransactions";
config.dataSourceName= "LM "..config.dnsBase.." MB";
config.tableName= "ProdTrans";

return config;