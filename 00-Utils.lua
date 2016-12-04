-- global utils for require

local utils= {};

function utils.addNumericPadding( padding, number)
	local res= number;
	for i=1, padding, 1 do 
		res= "0"..res;
	end;
	return res;
end;

return utils;