
-- Run full procedure

local lm= require( "Exec/Lib/LMGlobal");
local scriptFolder= lm.getScriptDirectory();

dofile(scriptFolder.."00-Utils.lua");
dofile(scriptFolder.."01-IMPORT.lua");
-- dofile(scriptFolder.."02-EXPL-LocalDataCache.lua");
-- dofile(scriptFolder.."03-EXPL-DataTable.lua");
-- dofile(scriptFolder.."04-EXPL-DataColumn.lua");
dofile(scriptFolder.."05-PREP-AttributeGroups.lua");
dofile(scriptFolder.."06-PREP-Category-item_groups-enum.lua");
dofile(scriptFolder.."07-PREP-Category-item_price-eds.lua");
dofile(scriptFolder.."08-PREP-Category-item_price-edcs.lua");
dofile(scriptFolder.."09-PREP-Category-item_price-efs.lua");
dofile(scriptFolder.."10-PREP-Category-item_tax_rate-enum.lua");
dofile(scriptFolder.."11-PREP-Category-item_quantity-eds.lua");
dofile(scriptFolder.."12-PREP-Category-item_quantity-edcs.lua");
dofile(scriptFolder.."13-PREP-Category-item_quantity-b.lua");
dofile(scriptFolder.."14-PREP-Category-item_quantity-efs.lua");
dofile(scriptFolder.."15-PREP-Category-transaction_basket_cnt.lua");
dofile(scriptFolder.."16-PREP-Category-transaction_date_time.lua");
dofile(scriptFolder.."17-PREP-Category-transaction_total_price.lua");

lm.logInfo( "Procedure ended");