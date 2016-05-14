function pdth_hud:GetSaveFile()
    return self.SavePath .. self.name .. "options.txt"
end

local Options = pdth_hud.Options
function pdth_hud:Save()
	local fileName = self:GetSaveFile()
    local saveOptions = deep_clone(Options)
    --[[for i, value in pairs(saveOptions) do
        if type(value) == "table" and #value == 0 then
            log(tostring(#value))
            log("Removing " .. i .. " from options because table is empty")
            saveOptions[i] = nil
        end
    end]]--
    
	local file = io.open(fileName, "w+")
	file:write(json.encode(saveOptions))
	file:close()
end

function pdth_hud:LoadOptions()
	local file = io.open(self:GetSaveFile(), 'r')
	if file == nil then
		return
	end
	local file_contents = file:read("*all")
	local data = json.decode( file_contents )
	file:close()
	if data then
		pdth_hud:OverwriteOptionValues(Options, data)
	end
end

function pdth_hud:OverwriteOptionValues(OptionTable, NewOptionTable)
	for i, data in pairs(NewOptionTable) do
		if type(data) == "table" and OptionTable[i] then
			OptionTable[i] = self:OverwriteOptionValues(OptionTable[i], data)
		else
			OptionTable[i] = data
		end
	end
	return OptionTable

end