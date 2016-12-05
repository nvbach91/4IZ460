-- LISp-Miner Control Language demo script
-- Simple example of dataTable manipulation
--			* iterates through all the dataTables in the metabase
--			* for each table writes a basic information and lists all of its columns
-- Part of the LISp-Miner system, for details see http://lispminer.vse.cz

-- Import predefined constants
local lm= require( "Exec/Lib/LMGlobal");
local config= require( "Exec/MyDemo/00-Config");

-- Log start
lm.log( "LMExec Script MyDemo Database Table manipulation");

-- Open a metabase 
lm.metabase.open({
		dataSourceName= config.dataSourceName});		-- ODBC DataSourceName

-- Get dataTables
local dataTableArray= lm.explore.prepareDataTableArray();

-- Write title line
lm.log( "\tDetail description of database tables");

-- Iterate through all the dataTables
for i, dataTable in ipairs( dataTableArray) do

	-- dataTable title
	local s= string.format( "\t%d: Table: %s (ID: %d), Initialized: %s, RecordCount: %s, LocalDataCache: %s", 
							i,	
							dataTable.getName(),
							dataTable.getID(),
							dataTable.isInitialized(),
							dataTable.isInitialized() and dataTable:getRecordCount() or "N/A",
										-- Lua way of the 'A ? B : C' operator (if A is true then B else C)
							dataTable.isLocalDataCacheFlag()
	); 
	lm.log( s);
	
	-- Columns
	
	local dataColumnArray= dataTable.prepareDataColumnArray();

	-- Write title line
	lm.log( "\t\tNr.\tID\tColumnName\tDataType\tDatePartType\tMin\tMax\tAvg");

	-- Iterate through all the columns
	for i, column in ipairs( dataColumnArray) do
	
		-- column title
		local s= string.format( "\t\t%d\t%d\t%s\t%s\t%s\t%.3f\t%.3f\t%.3f", 
								i,	
								column.ID,
								column.Name,
								column.getValueSubTypeName(),
								column.getDatePartSubTypeName(),
								column.getMin(),
								column.getMax(),
								column.getAvg()
		); 
		lm.log( s);

	end;
	
	lm.log( "\t\tNumber of columns: "..#dataColumnArray);

	lm.logEmptyLine();
	
end;

lm.log( "\tTotal number of dataTables: "..#dataTableArray);

-- Close the metabase
lm.metabase.close();

-- Log finish
lm.logInfo( "LMExec Script End");
