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
local attributeGroupName= "DateTime";

-- Get Root attributeGroup
--local rootAttributeGroup= lm.prepro:getRootAttributeGroup();
--assert( rootAttributeGroup);	

-- *** get Item attribute group
local attributeGroup= lm.prepro.findAttributeGroup({ name= attributeGroupName});
assert( attributeGroup);

local dataTable= lm.explore.findDataTable({ name= dataTableName});

-- ========================= days of month =====================================
local columnName= "transaction_time.Day";
local dataColumn= dataTable.findDataColumn({ name= columnName});
local attributeName= "transaction_day_of_month_enum";

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

attribute.autoCreateEnumeration({});

local bOk= attribute.calcCategoryFrequencies();
if ( not bOk) then	
	lm.logError( "Error calculating frequencies of categories");		
end;

-- ========================= days of week =====================================
local columnName= "transaction_time.DayOfWeek";
local dataColumn= dataTable.findDataColumn({ name= columnName});
local attributeName= "transaction_day_of_week_enum";

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

attribute.autoCreateEnumeration({
	categoryNames= "Mon;Tue;Wed;Thu;Fri;Sat;Sun"
});

local bOk= attribute.calcCategoryFrequencies();
if ( not bOk) then	
	lm.logError( "Error calculating frequencies of categories");		
end;

-- ========================= isWeekend =====================================
local columnName= "transaction_time.DayOfWeek";
local dataColumn= dataTable.findDataColumn({ name= columnName});
local attributeName= "transaction_day_weekend_b";

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

local categoryNo= lm.prepro.CategoryEnumeration({
	name= "No",
	pAttribute= attribute
});
local workDays= {1, 2, 3, 4, 5};
for i, workDay in ipairs(workDays) do
	categoryNo.includeValue({ value= workDay });
end;

local categoryYes= lm.prepro.CategoryEnumeration({
	name= "Yes",
	pAttribute= attribute
});
categoryYes.includeValue({ value= 6 });
categoryYes.includeValue({ value= 7 });

local bOk= attribute.calcCategoryFrequencies();
if ( not bOk) then	
	lm.logError( "Error calculating frequencies of categories");		
end;

-- ========================= hours of day =====================================
local columnName= "transaction_time.Hour";
local dataColumn= dataTable.findDataColumn({ name= columnName});
local attributeName= "transaction_hours_of_day_enum";

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

attribute.autoCreateEnumeration({});

local bOk= attribute.calcCategoryFrequencies();
if ( not bOk) then	
	lm.logError( "Error calculating frequencies of categories");		
end;

-- ========================= parts of day =====================================
local columnName= "transaction_time.Hour";
local dataColumn= dataTable.findDataColumn({ name= columnName});
local attributeName= "transaction_parts_of_day_enum";

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

local partsOfDay= {};
partsOfDay["Morning"]=   {  6,  7,  8,  9, 10, 11 }; 
partsOfDay["Afternoon"]= { 12, 13, 14, 15, 16, 17 }; 
partsOfDay["Evening"]=   { 18, 19, 20, 21, 22, 23 };
partsOfDay["Night"]=     {  0,  1,  2,  3,  4,  5 };

for key, interval in pairs(partsOfDay) do
	local categorySingle= lm.prepro.CategoryEnumeration({
		name= key,
		pAttribute= attribute
	});
	for i, hour in ipairs(interval) do
		categorySingle.includeValue({ value= hour });
	end;
end;

local bOk= attribute.calcCategoryFrequencies();
if ( not bOk) then	
	lm.logError( "Error calculating frequencies of categories");		
end;

-- Close the metabase
lm.metabase.markChanged(); -- inform LM Workspace that the script have made some changes to metabase
lm.metabase:close();

-- Log finish
--lm.logInfo( "LMExec Script End");
