-- LISp-Miner Control Language demo script
-- Simple example of dataTable manipulation
--			* iterates through all the dataTables in the metabase
--			* for each table writes a basic information and lists all of its columns
-- Part of the LISp-Miner system, for details see http://lispminer.vse.cz

-- Import predefined constants
local lm= require( "Exec/Lib/LMGlobal");

-- Log start
lm.log( "LMExec Script Demo Column manipulation");

	-- Open a metabase 
	lm.metabase.open({
			dataSourceName= "LM Exec MyDemo Transactions MB"});		-- ODBC DataSourceName

-- DataTable and DataColumn

	-- Get dataTable
	local dataTable= lm.explore.findDataTable({ name= "ProdTrans"});

	-- Get dataColumn
	local dataColumn= dataTable.findDataColumn({ name= "item_price"});

-- Basic statistics

	lm.log( "Basic statistics for column: "..dataColumn.Name);

	lm.log( "Min value: "..dataColumn.getMin());
	lm.log( "Max value: "..dataColumn.getMax());
	lm.log( "Avg value: "..dataColumn.getAvg());
	lm.log( "Standard deviation: "..dataColumn.getStDev());

-- List of frequencies

	lm.log( "Frequencies of values in column: "..dataColumn.Name);

	local frequencyArray= dataColumn.prepareHistogramArray({nSize= 10});

	-- Write title line
	lm.log( "\t\tIndex\tFrequency");

	-- Iterate through all the indexes
	for i= 1, #frequencyArray do
	
		local s= string.format( "\t\t%d\t%d", 
								i,	
								frequencyArray[i]
		); 
		lm.log( s);

	end;
	
	lm.log( "\t\tNumber of frequencies: "..#frequencyArray);

	lm.logEmptyLine();

-- Close the metabase
lm.metabase.close();

-- Log finish
lm.logInfo( "LMExec Script End");
