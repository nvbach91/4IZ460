-- LMExec.Demo.Task.lua
-- Simple example of taskGroup manipulation
--			* ???
-- Part of the LISp-Miner system, for details see http://lispminer.vse.cz

-- Import predefined constants
local lm= require( "Exec/Lib/LMGlobal");

-- Log start
--lm.log( "LMExec Script Demo TaskGroup manipulation");

-- Open a metabase 
lm.metabase:open({
	dataSourceName= "LM Exec MyDemo Transactions MB" -- ODBC DataSourceName
});

local taskGroupNames= {
	"01) Item price vs. transaction characteristics",
	"02) Basket article count vs. item transactions",
	"03) Time periods of single and multiple purchases vs. purchased items",
	"04) Item (tax)groups vs. items characteristics and their transactions"
};

for i, taskGroupName in ipairs( taskGroupNames) do
	-- find existing taskgroup
	local tg= lm.tasks.findTaskGroup( {
		name= taskGroupName
	});

	-- create taskgroup if not found
	if ( not tg) then
		lm.tasks.TaskGroup( {
			name= taskGroupName
		});
	else 
		--lm.log( "task group "..taskGroupName.." already exists");
	end;
end;

-- Prepare taskGroups
--[[
local taskGroupArray= lm.tasks:prepareTaskGroupArray();

-- Write title line
lm.log( "\tNr.\tTaskGroupID\tTaskGroupName\t#Tasks");

-- Iterate through all the taskGroups
for i, taskGroup in ipairs( taskGroupArray) do

	local taskArray= taskGroup:prepareTaskArray();
	
	-- Compose information about a single task
	local s= string.format( "\t%d\t%d\t%s\t%d", 
							i,	taskGroup:getID(), taskGroup:getName(), 
							#taskArray);
	lm.log( s);

end;

lm.log( "\tTotal number of taskGroups: "..#taskGroupArray);
--]]
-- Close the metabase
lm.metabase.markChanged(); -- inform LM Workspace that the script have made some changes to metabase
lm.metabase:close();

-- Log finish
--lm.logInfo( "LMExec Script End");
