-- LISp-Miner Control Language demo script
-- Example of data import
--			* creates a MDB file with data imported from a text file
--		   * creates a new metabase and associates it with the data
--			* opens the metabase and reads metadata
--			* initializes the one and only table and sets its primary key
--			* enables data caching
-- Part of the LISp-Miner system, for details see http://lispminer.vse.cz

-- Import predefined constants
local lm= require( "Exec/Lib/LMGlobal");
local config= require( "Exec/MyDemo/00-Config");
-- Log start
--lm.log( "LMExec Script MyDemo Data Import from TXT");

-- Summary of this script input parameters
inputParams= {
	pathNameDataSrc= "Exec/MyData/ProductTransactions_Oct_ANSI.txt",		-- path and file name to source text file	
	pathNameDataDest= "Exec/MyData/ProductTransactions.DB.mdb",	-- path and file name of the database to create
	pathNameMetabase= "Exec/MyData/ProductTransactions.LM.mdb", -- path and file name of the metabase to create
	tableName= config.tableName,											-- database table name to be created 
	dsnBase= config.dnsBase,						-- base ODBC DataSourceName for both metabase and data
	pathNameBkup= "Exec/MyData/ProductTransactions.LM.mdb_bkup.mdb"
};

-- Import a text file with data and create a MDB database with a given table
importParams= {
	pathNameSrc= inputParams.pathNameDataSrc,				-- path and file name to source text file	
	pathNameDest= inputParams.pathNameDataDest,			-- path and file name of the database to create (optional)
	tableName= inputParams.tableName,						-- database table name to be created (optional)
};
lm.data.importTXT( importParams);

-- Create new metabase and associate it with the previously created database with data
-- an example of a "shorthand" without creating list of params first
lm.metabase.createAndAssociateWithDataMDB({
	pathNameMetabase= inputParams.pathNameMetabase,		-- path and file name of the metabase to create
	pathNameData= inputParams.pathNameDataDest,			-- used data
	dsnBase= inputParams.dsnBase 								-- common ODBC DataSourceName for both metabase and data
																		-- DSN for Metabase: "LM Exec Demo HotelBooking MB"
																		-- DSN for Data:	   "LM Exec Demo HotelBooking"
});

-- Open a metabase 
lm.metabase.open({
	-- *** Only 1 word allowed? LM Products Transactions MB is not a valid ODBC DataSourceName
	dataSourceName= config.dataSourceName
});		-- ODBC DataSourceName

-- Since it is the first this metabase is opened, we need to 
-- initialize the meta data (list of tables and columns in analyzed data)
-- This function needs to be called every time the structure of analyzed data changes
lm.metabase.updateMetadata();

-- Table initialization
--lm.log( "Table initialization");
--lm.logIndentUp();

-- Find the one and only table by name
local dataTable= lm.explore.findDataTable({ name= inputParams.tableName});

assert( dataTable, "Database table not found!");			-- report error and stop if not found

-- Initialize the table

--lm.log( "dataTable "..dataTable.Name.." initialization");

dataTable.init();

if ( not dataTable.isPrimaryKeyDefined()) then
-- Primary key not set yet

	-- Use the default ID column created during the text data import
	dataTable.markPrimaryKey({ 
		columnName= lm.data.IDColumnNameDefault -- name of the column to become the primary key
	});			

end;

-- Check the primary key being set properly and stop if not
assert( dataTable.checkPrimaryKey(), "Error checking the primary key");

--lm.logIndentDown();

-- Matrix title
--[[ local s= string.format( "Table: %s (ID: %d), Initialized: %s, RecordCount: %s, LocalDataCacheFlag: %s", 
						dataTable.Name, 							-- direct access through <object>.<ValueName>
						dataTable.getID(), 						-- obtaining value through <object>.get<ValueName> function
						dataTable.isInitialized(),
						dataTable.isInitialized() and dataTable.getRecordCount() or "N/A",
									--             ?                             :
									-- *** ternary logic operator
									-- Lua way of 'A ? B : C' operator (if A is true then B else C)
						dataTable.isLocalDataCacheFlag()
); 
lm.log( s);

--]]

-- Close the metabase
lm.metabase.close();

-- Make a backup copy of the metabase file
lm.metabase.backupMDB({
	pathNameSrc= inputParams.pathNameMetabase,
	pathNameDest= inputParams.pathNameBkup,		

});

-- Log finish
--lm.logInfo( "LMExec Script End");
