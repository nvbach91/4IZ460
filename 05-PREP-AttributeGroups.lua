-- LISp-Miner Control Language demo script
-- Simple example of group of attributes manipulation
--			* creates a new group of attributes
-- Part of the LISp-Miner system, for details see http://lispminer.vse.cz

-- Import predefined constants
local lm= require( "Exec/Lib/LMGlobal");
local config= require( "Exec/MyDemo/00-Config");

-- Log start
--lm.log( "LMExec Script MyDemo AttributeGroup manipulation");

-- Open a metabase 
lm.metabase:open({ 
	dataSourceName= config.dataSourceName});		-- ODBC DataSourceName

-- Get Root attributeGroup
local rootAttributeGroup= lm.prepro:getRootAttributeGroup();
assert( rootAttributeGroup);


-- *** CREATING GROUPS

local groupNames= {"Item", "Transaction"};

for i, groupName in ipairs(groupNames) do
	local attributeGroup= lm.prepro.findAttributeGroup({ name= groupName});
	if ( not attributeGroup) then -- does not exists
		attributeGroup= lm.prepro.AttributeGroup( {
			name= groupName,
			pParentGroup= rootAttributeGroup
		});
	else
		-- *** lm.log( "Group of attributes "..groupName.." already exists. Try other name or do accept an automatic change -- see later");
	end;
	if (groupName == "Item" ) then
		local subGroupNames= {"Price", "Quantity"};
		for i, subGroupName in ipairs(subGroupNames) do
			local subAttributeGroup= lm.prepro.findAttributeGroup({ name= subGroupName});
			if ( not subAttributeGroup) then -- does not exists
				subAttributeGroup= lm.prepro.AttributeGroup( {
					name= subGroupName,
					pParentGroup= attributeGroup
				});
			else
				-- *** lm.log( "Group of attributes "..groupName.." already exists. Try other name or do accept an automatic change -- see later");
			end;
		end;
	elseif ( groupName == "Transaction") then	
		local subGroupNames= {"DateTime", "Basket"};
		for i, subGroupName in ipairs(subGroupNames) do
			local subAttributeGroup= lm.prepro.findAttributeGroup({ name= subGroupName});
			if ( not subAttributeGroup) then -- does not exists
				subAttributeGroup= lm.prepro.AttributeGroup( {
					name= subGroupName,
					pParentGroup= attributeGroup
				});
			else
				-- *** lm.log( "Group of attributes "..groupName.." already exists. Try other name or do accept an automatic change -- see later");
			end;
		end;
	end;
end;


--local subAttributeGroupArray= rootAttributeGroup:prepareSubAttributeGroupArray();
--lm.log( "Total number of attributeGroups: "..#subAttributeGroupArray);

-- Close the metabase
lm.metabase.markChanged();			-- inform LM Workspace that the script have made some changes to metabase
lm.metabase:close();

-- Log finish
--lm.logInfo( "LMExec Script End");
