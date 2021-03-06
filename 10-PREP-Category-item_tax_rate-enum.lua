-- LISp-Miner Control Language demo script
-- Simple example of manipulation with categories
-- Part of the LISp-Miner system, for details see http://lispminer.vse.cz

-- Import predefined constants
local lm= require( "Exec/Lib/LMGlobal");
local config= require( "Exec/MyDemo/00-Config");

-- Log start
-- lm.log( "LMExec Script MyDemo Category manipulation");

-- Open a metabase
lm.metabase:open({ 
	dataSourceName= config.dataSourceName -- ODBC DataSourceName
});

-- Initialisation
local dataTableName= config.tableName;
local columnName= "item_tax_rate";
local attributeGroupName= "Item";

-- Get Root attributeGroup
--local rootAttributeGroup= lm.prepro:getRootAttributeGroup();
--assert( rootAttributeGroup);	

-- *** get Item attribute group
local attributeGroup= lm.prepro.findAttributeGroup({ name= attributeGroupName});
assert( attributeGroup);

local dataTable= lm.explore.findDataTable({ name= dataTableName});
local dataColumn= dataTable.findDataColumn({ name= columnName});

local attributeName= columnName.."_enum";

-- Deleting old
local attribute= lm.prepro.findAttribute({ name= attributeName});
if ( attribute ~= nil) then -- already exist
	--lm.log( "Deleting old attribute "..attributeName);
	attribute.onDel();
end;

--	New attribute
--lm.log( "Creating new attribute "..attributeName);
attribute= lm.prepro.Attribute({ 
	name= attributeName, 
	pAttributeGroup= attributeGroup,
	pDataColumn= dataColumn
});

-- Categories as an enumeration of values

attribute.autoCreateEnumeration({});

-- *** setting group names manually... 
local categoryArray = attribute.prepareCategoryArray();
for i, category in ipairs(categoryArray) do
	category.setName(category.getName().."%");
end;


-- Pre-calculating frequencies of categories
-- This is not necessary but could be a good practise to pre-calculate frequencies 
-- at once for all atributes before some further calculations based on them
-- and to check if successfully done
local bOk= attribute.calcCategoryFrequencies();
if ( not bOk) then	
	lm.logError( "Error calculating frequencies of categories");		
end;

-- List of categories
--lm.log( "List of categories of: "..attribute.Name);
--[[local categoryArray= attribute.prepareCategoryArray();

-- Write title line
lm.log( "\t\tNr.\tID\tCategoryName\tCategorySubType\tFrequency");

-- Iterate through all the categories
for i, category in ipairs( categoryArray) do		
	-- column title
	local s= string.format( "\t\t%d\t%d\t%s\t%s\t%d", 
							i,	
							category.ID,
							category.Name,
							category.getCategorySubTypeName(),
							category.Frequency
	);
	lm.log( s);
end;

lm.log( "\t\tNumber of categories: "..#categoryArray);
lm.log( "\t\tHas X-category: "..(attribute.hasXCategory() and "yes" or "no"));
--]]

-- Close the metabase
lm.metabase.markChanged(); -- inform LM Workspace that the script have made some changes to metabase
lm.metabase:close();

-- Log finish
--lm.logInfo( "LMExec Script End");
