-- LISp-Miner Control Language demo script
-- Simple example of dataTable property manipulation
--			* tries to find a database table with ID= 1 
--			* if such table exists, the LocalDataCache is enabled for it
-- Part of the LISp-Miner system, for details see http://lispminer.vse.cz

-- Import predefined constants
local lm= require( "Exec/Lib/LMGlobal");

local config= require( "Exec/MyDemo/00-Config");
-- Log start
lm.log( "LMExec Script MyDemo Matrix manipulation");

-- Open a metabase 
lm.metabase:open({
		dataSourceName= config.dataSourceName});		-- ODBC DataSourceName

-- Try to find the first table
dataTable= lm.explore.findDataTable({ nID= 1});

if ( dataTable) then
-- dataTable has been found

	if ( not dataTable.isLocalDataCacheFlag()) then
	-- not set yet
	
		lm.log( "Enabling data caching for table "..dataTable.Name);
		
		dataTable.setLocalDataCacheFlag( true);
		
		-- Store changes into metabase
		dataTable.onUpdate();

	else
	
		lm.log( "Caching already enabled for table "..dataTable.Name);
		
	end;
		
	-- dataTable title
	local s= string.format( "\tTable: %s, LocalDataCacheFlag: %s", 
							dataTable.Name,
							dataTable.isLocalDataCacheFlag()
	); 
	lm.log( s);

else

	lm.log( "No database table found!");
	
end;

-- Close the metabase
lm.metabase:close();

-- Log finish
lm.logInfo( "LMExec Script End");
