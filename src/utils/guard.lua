--!strict
--[[
    Guard.lua
    Robust type assertion and validation utility for the Kaze UI framework.
--]]

local Guard = {}

-- Checks if a value is a string, otherwise returns a fallback
function Guard.string(val: any, fallback: string): string
    if type(val) == "string" then
        return val
    end
    return fallback
end

-- Checks if a value is a number, otherwise returns a fallback
function Guard.number(val: any, fallback: number): number
    if type(val) == "number" then
        return val
    end
    return fallback
end

-- Checks if a value is a boolean, otherwise returns a fallback
function Guard.boolean(val: any, fallback: boolean): boolean
    if type(val) == "boolean" then
        return val
    end
    return fallback
end

-- Checks if a value is a table, otherwise returns a fallback
function Guard.table(val: any, fallback: {[any]: any}): {[any]: any}
    if type(val) == "table" then
        return val
    end
    return fallback
end

-- Checks if a value is a function, otherwise returns a fallback
function Guard.func(val: any, fallback: (...any) -> ...any): (...any) -> ...any
    if type(val) == "function" then
        return val
    end
    return fallback
end

-- Checks if a value is a Color3, otherwise returns a fallback
function Guard.color3(val: any, fallback: Color3): Color3
    if typeof(val) == "Color3" then
        return val
    end
    return fallback
end

return Guard
