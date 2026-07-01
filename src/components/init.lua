--!strict
--[[
    Components Router Manager
    Aggregates creation scripts for specific design layouts and maps standard backward-compat functions.
--]]

local Tab = require(script.Tab)
local Section = require(script.Section)
local Button = require(script.Button)
local Toggle = require(script.Toggle)
local Slider = require(script.Slider)
local Dropdown = require(script.Dropdown)
local TextBox = require(script.TextBox)
local Keybind = require(script.Keybind)
local ColorPicker = require(script.ColorPicker)

local Themes = require(script.Parent.themes)

local Components = {}

-- High-level dynamic component registration/binding helper
function Components.Attach(apiTable: {[any]: any}, parentFrame: GuiObject, registerFlag: (string, any, any) -> (), cameraLocker: TextButton)
    function apiTable:AddLabel(arg1)
        local t = type(arg1) == "table" and (arg1.Text or arg1.Title) or arg1
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -8, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = tostring(t or " ")
        label.Font = Enum.Font.Gotham
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextWrapped = true
        label.Parent = parentFrame
        Themes:RegisterText(label, true)
        return label
    end

    function apiTable:Paragraph(arg1, arg2)
        local title = type(arg1) == "table" and arg1.Title or arg1
        local content = type(arg1) == "table" and (arg1.Content or arg1.Description) or arg2
        return Button.CreateParagraph(parentFrame, title, content)
    end

    function apiTable:Button(arg1, arg2, arg3)
        local title = type(arg1) == "table" and arg1.Title or arg1
        local desc = type(arg1) == "table" and (arg1.Description or arg1.Content or "") or arg2
        local callback = type(arg1) == "table" and arg1.Callback or arg3
        return Button.CreateClickable(parentFrame, title, desc, callback)
    end

    function apiTable:Toggle(arg1, arg2, arg3, arg4, arg5)
        local title, desc, def, callback, flag
        if type(arg1) == "table" then
            title, desc, def, callback, flag = arg1.Title, (arg1.Description or arg1.Content or ""), arg1.Default, arg1.Callback, arg1.Flag
        else
            title, desc, def, callback, flag = arg1, arg2, arg3, arg4, arg5
        end
        return Toggle.Create(parentFrame, title, desc, def, callback, function(get, set)
            registerFlag(flag, get, set)
        end)
    end

    function apiTable:TextBox(arg1, arg2, arg3, arg4, arg5)
        local title, place, def, callback, flag
        if type(arg1) == "table" then
            title, place, def, callback, flag = arg1.Title, arg1.Placeholder, arg1.Default, arg1.Callback, arg1.Flag
        else
            title, place, def, callback, flag = arg1, arg2, arg3, arg4, arg5
        end
        return TextBox.Create(parentFrame, title, place, def, callback, function(get, set)
            registerFlag(flag, get, set)
        end)
    end

    function apiTable:Slider(arg1, arg2, arg3, arg4, arg5, arg6)
        local title, min, max, def, callback, flag
        if type(arg1) == "table" then
            title, min, max, def, callback, flag = arg1.Title, arg1.Min, arg1.Max, arg1.Default, arg1.Callback, arg1.Flag
        else
            title, min, max, def, callback, flag = arg1, arg2, arg3, arg4, arg5, arg6
        end
        return Slider.Create(parentFrame, title, min, max, def, callback, function(get, set)
            registerFlag(flag, get, set)
        end, cameraLocker)
    end

    function apiTable:Dropdown(arg1, arg2, arg3, arg4, arg5, arg6)
        local title, vals, def, callback, multi, flag
        if type(arg1) == "table" then
            title, vals, def, multi, callback, flag = arg1.Title, (arg1.Values or arg1.Options), arg1.Default, (arg1.Multi or false), arg1.Callback, arg1.Flag
        else
            title, vals, def, callback, multi, flag = arg1, arg2, arg3, arg4, (arg5 or false), arg6
        end
        return Dropdown.Create(parentFrame, title, vals, def, callback, multi, function(get, set)
            registerFlag(flag, get, set)
        end)
    end

    function apiTable:ColorPicker(arg1, arg2, arg3, arg4)
        local title, def, cb, flag
        if type(arg1) == "table" then
            title, def, cb, flag = arg1.Title, arg1.Default, arg1.Callback, arg1.Flag
        else
            title, def, cb, flag = arg1, arg2, arg3, arg4
        end
        return ColorPicker.Create(parentFrame, title, def, cb, function(get, set)
            registerFlag(flag, get, set)
        end, cameraLocker)
    end
    
    function apiTable:Keybind(arg1, arg2, arg3, arg4)
        local title, def, cb, flag
        if type(arg1) == "table" then
            title, def, cb, flag = arg1.Title, arg1.Default, arg1.Callback, arg1.Flag
        else
            title, def, cb, flag = arg1, arg2, arg3, arg4
        end
        return Keybind.Create(parentFrame, title, def, cb, function(get, set)
            registerFlag(flag, get, set)
        end)
    end

    function apiTable:SectionUI(arg1)
        local title = type(arg1) == "table" and arg1.Title or arg1
        return Section.CreateCollapsible(parentFrame, title, function(tbl, contentFrame)
            Components.Attach(tbl, contentFrame, registerFlag, cameraLocker)
        end)
    end
    
    function apiTable:Section(arg1)
        local title = type(arg1) == "table" and arg1.Title or arg1
        return Section.CreateDivider(parentFrame, title)
    end
end

return Components
