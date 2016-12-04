-- LISp-Miner Control Language demo script
-- Simple example of manipulation with categories
-- Part of the LISp-Miner system, for details see http://lispminer.vse.cz

-- *** create a biary attribute to distinguish whether the item was bought as 1 piece or multiple pieces

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
local columnName= "item_quantity";
local attributeGroupName= "Quantity";

-- Get Root attributeGroup
--local rootAttributeGroup= lm.prepro:getRootAttributeGroup();
--assert( rootAttributeGroup);	

-- *** get Item attribute group
local attributeGroup= lm.prepro.findAttributeGroup({ name= attributeGroupName});
assert( attributeGroup);

local dataTable= lm.explore.findDataTable({ name= dataTableName});
local dataColumn= dataTable.findDataColumn({ name= columnName});

local attributeName= columnName.."_b";

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


distinctValueArray, frequenciesArray= dataColumn.prepareDistinctValueArray({});

local categoryMultiple= lm.prepro.CategoryEnumeration({
	name= "Multiple",
	pAttribute= attribute
});

for i= 1, #distinctValueArray do
	if ( distinctValueArray[i] ~= 1) then		
		categoryMultiple.includeValue({ value= distinctValueArray[i]});
	end;	
end;

local categorySingle= lm.prepro.CategoryEnumeration({
	name= "Single",
	pAttribute= attribute
});				
categorySingle.includeValue({ value= 1 });

local bOk= attribute.calcCategoryFrequencies();
if ( not bOk) then	
	lm.logError( "Error calculating frequencies of categories");		
end;

-- Close the metabase
lm.metabase.markChanged(); -- inform LM Workspace that the script have made some changes to metabase
lm.metabase:close();

-- Log finish
--lm.logInfo( "LMExec Script End");
