--!strict
--[[
    Lucide.lua
    Manages fetching and parsing the external Lucide Icons directory for UI rendering.
--]]

local HttpService = game:GetService("HttpService")

local Lucide = {}
local IconsMap: {[string]: string} = {}

-- Asynchronously fetches the icon configurations from GitHub repository
task.spawn(function()
    pcall(function()
        if game and game.HttpGet then
            local rawIcons = game:HttpGet("https://raw.githubusercontent.com/KazeHub/UI/refs/heads/main/Icons.lua.txt")
            if rawIcons then
                local s, res = pcall(function()
                    local func = loadstring(rawIcons)
                    return func and func()
                end)
                if not s or type(res) ~= "table" then
                    s, res = pcall(function() 
                        return HttpService:JSONDecode(rawIcons) 
                    end)
                end
                if type(res) == "table" then
                    for k, v in pairs(res) do 
                        IconsMap[string.lower(tostring(k))] = tostring(v) 
                    end
                end
            end
        end
    end)
end)

-- Formats a given string or raw ID into a valid asset image URL
function Lucide.Format(id: string?): string
    if not id or id == "" then return "" end
    id = tostring(id)
    local lowerId = string.lower(id)
    
    if IconsMap[lowerId] then
        local mapped = IconsMap[lowerId]
        if not string.find(mapped, "rbxassetid://") and not string.find(mapped, "http") then
            local clean = string.gsub(mapped, "%D", "")
            if clean ~= "" then 
                return "rbxassetid://" .. clean 
            end
        end
        return mapped
    end
    
    if string.find(id, "rbxassetid://") or string.find(id, "http") then 
        return id 
    end
    
    local clean = string.gsub(id, "%D", "")
    if clean == "" then 
        return id 
    end
    return "rbxassetid://" .. clean
end

return Lucide
