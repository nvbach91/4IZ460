-- LISp-Miner Control Language demo script
-- Simple example of manipulation with categories
-- Part of the LISp-Miner system, for details see http://lispminer.vse.cz

-- *** create a biary attribute to distinguish whether the item was bought as 1 piece or multiple pieces

-- Import predefined constants
local lm= require( "Exec/Lib/LMGlobal");
local config= require( "Exec/MyDemo/00-Config");

local utils= require( "Exec/MyDemo/00-Utils");

-- Log start
-- lm.log( "LMExec Script MyDemo Category manipulation");

-- Open a metabase
lm.metabase:open({ 
	dataSourceName= config.dataSourceName -- ODBC DataSourceName
});

-- Initialisation
local dataTableName= config.tableName;
local columnName= "transaction_total_price";
local attributeGroupName= "Transaction";

-- Get Root attributeGroup
--local rootAttributeGroup= lm.prepro:getRootAttributeGroup();
--assert( rootAttributeGroup);	

-- *** get Item attribute group
local attributeGroup= lm.prepro.findAttributeGroup({ name= attributeGroupName});
assert( attributeGroup);

local dataTable= lm.explore.findDataTable({ name= dataTableName});
local dataColumn= dataTable.findDataColumn({ name= columnName});

-- =========================== eds =====================================
local lengths= {100, 300, 500, 700};
for i, length in ipairs(lengths) do
	--local lengthSuffix= length < 1000 and utils.addNumericPadding(1, length) or length;
	local edAttributeName= columnName.."_ed_"..length;

	-- Deleting old
	local attribute= lm.prepro.findAttribute({ name= edAttributeName});
	if ( attribute ~= nil) then -- already exist
		--lm.log( "Deleting old attribute "..attributeName);
		attribute.onDel();
	end;

	attribute= lm.prepro.Attribute({
		name= edAttributeName,
		pAttributeGroup= attributeGroup,
		pDataColumn= dataColumn
	});

	attribute.autoCreateIntervalEquidistant( {
		dLength= length
	});
	local bOk= attribute.calcCategoryFrequencies();
	if ( not bOk) then	
		lm.logError( "Error calculating frequencies of categories");		
	end;
end;

-- =========================== edc =====================================
local counts= {2, 3, 4, 5};
for i, count in ipairs(counts) do
	local edcAttributeName= columnName.."_edc_"..utils.addNumericPadding(1, count);

	-- Deleting old
	local attribute= lm.prepro.findAttribute({ name= edcAttributeName});
	if ( attribute ~= nil) then -- already exist
		--lm.log( "Deleting old attribute "..attributeName);
		attribute.onDel();
	end;

	attribute= lm.prepro.Attribute({
		name= edcAttributeName,
		pAttributeGroup= attributeGroup,
		pDataColumn= dataColumn
	});

	attribute.autoCreateIntervalEquidistant( {
		nCount= count
	});
	local bOk= attribute.calcCategoryFrequencies();
	if ( not bOk) then	
		lm.logError( "Error calculating frequencies of categories");		
	end;
end;

-- =========================== efs =====================================
local binSizes= {2, 3, 4, 5};
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
