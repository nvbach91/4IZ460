-- LISp-Miner Control Language demo script
-- Simple example of manipulation with categories
-- Part of the LISp-Miner system, for details see http://lispminer.vse.cz

-- Import predefined constants
local lm= require( "Exec/Lib/LMGlobal");

local utils= require( "Exec/MyDemo/my-procedure/00-Utils");

-- Log start
-- lm.log( "LMExec Script MyDemo Category manipulation");

-- Open a metabase
lm.metabase:open({ 
	dataSourceName= "LM Exec MyDemo Transactions MB" -- ODBC DataSourceName
});

-- Initialisation
local dataTableName= "ProdTrans";
local columnName= "item_price";
local attributeGroupName= "Price";

-- Get Root attributeGroup
--local rootAttributeGroup= lm.prepro:getRootAttributeGroup();
--assert( rootAttributeGroup);	

-- *** get Item attribute group
local attributeGroup= lm.prepro.findAttributeGroup({ name= attributeGroupName});
assert( attributeGroup);

local dataTable= lm.explore.findDataTable({ name= dataTableName});
local dataColumn= dataTable.findDataColumn({ name= columnName});

-- *** loop though binSizes
local binSizes= {2, 3, 5, 7, 9};
for i, nBins in ipairs(binSizes) do
	local nBinSuffix= nBins < 10 and utils.addNumericPadding(1, nBins) or nBins;
	local attributeName= columnName.."_ef_"..nBinSuffix;

	-- Deleting old
	local attribute= lm.prepro.findAttribute({ name= attributeName});
	if ( attribute ~= nil) then -- already exist
		--lm.log( "Deleting old attribute "..attributeName);
		attribute.onDel();
	end;

	attribute= lm.prepro.Attribute({
		name= attributeName,
		pAttributeGroup= attributeGroup,
		pDataColumn= dataColumn
	});
	

	attribute.autoCreateIntervalEquifrequency({
		nCount= nBins,
		bMnemonicNames= true
	});

	local bOk= attribute.calcCategoryFrequencies();
	if ( not bOk) then	
		lm.logError( "Error calculating frequencies of categories");		
	end;
end;

-- Close the metabase
lm.metabase.markChanged(); -- inform LM Workspace that the script have made some changes to metabase
lm.metabase:close();

-- Log finish
--lm.logInfo( "LMExec Script End");
