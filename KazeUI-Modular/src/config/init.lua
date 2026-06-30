local ConfigModule = {}

local HttpService = game:GetService("HttpService")
local ThemesModule = require("src/themes/init")

ConfigModule.Flags = {}

function ConfigModule:RegisterFlag(flag, getFunc, setFunc)
	if flag then
		ConfigModule.Flags[flag] = { Get = getFunc, Set = setFunc }
	end
end

function ConfigModule:SaveConfig(name, notifyCallback)
	if not name or name == "" then
		if notifyCallback then notifyCallback({Title = "Config System", Content = "Config name cannot be empty.", Duration = 3}) end
		return
	end
	
	local data = {}
	for flag, obj in pairs(ConfigModule.Flags) do data[flag] = obj.Get() end
	
	if writefile then
		local success, encoded = pcall(function() return HttpService:JSONEncode(data) end)
		if success then
			writefile("KazeUI_"..name..".json", encoded)
			if notifyCallback then notifyCallback({Title = "Config Saved", Content = "Successfully saved " .. name, Duration = 3}) end
		else
			if notifyCallback then notifyCallback({Title = "Config Error", Content = "Failed to encode settings to JSON.", Duration = 3}) end
		end
	else
		if notifyCallback then notifyCallback({Title = "Config Error", Content = "Your executor does not support saving files.", Duration = 3}) end
	end
end

function ConfigModule:LoadConfig(name, notifyCallback)
	if readfile then
		local s, res = pcall(function() return readfile("KazeUI_"..name..".json") end)
		if s then
			local s2, data = pcall(function() return HttpService:JSONDecode(res) end)
			if s2 and type(data) == "table" then
				for flag, val in pairs(data) do
					if ConfigModule.Flags[flag] then ConfigModule.Flags[flag].Set(val) end
				end
				if notifyCallback then notifyCallback({Title = "Config Loaded", Content = "Successfully loaded " .. name, Duration = 3}) end
			else
				if notifyCallback then notifyCallback({Title = "Config Error", Content = "Invalid or corrupted config format.", Duration = 3}) end
			end
		else
			if notifyCallback then notifyCallback({Title = "Config Error", Content = "Config " .. name .. " not found.", Duration = 3}) end
		end
	end
end

return ConfigModule
