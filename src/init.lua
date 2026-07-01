--!strict
--[[
    Kaze UI Library Core
    High-End Desktop Roblox UI Architecture Framework - V2.1 Modularized refactor.
--]]

local KazeUI = {}
KazeUI.__index = KazeUI

-- Services requirements
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer

-- External references
local Themes = require(script.themes)
local Window = require(script.components.Window)
local Tab = require(script.components.Tab)
local Components = require(script.components)
local Tween = require(script.services.Tween)

-- Copy state values over from themes engine for compatibility layer
KazeUI.Themes = Themes.Presets
KazeUI.Flags = {} :: {[string]: {Get: () -> any, Set: (any) -> ()}}
KazeUI.ActiveWindows = {} :: {Frame}

local function RegisterFlag(flag: string?, getFunc: () -> any, setFunc: (any) -> ())
    if flag then
        KazeUI.Flags[flag] = { Get = getFunc, Set = setFunc }
    end
end

-- Core Screen GUI initialization
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KazeUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 10 

local success, parent = pcall(function() return game:GetService("CoreGui") end)
if not success or not parent then
    parent = LP:WaitForChild("PlayerGui", 15)
end
ScreenGui.Parent = parent

-- Central modal lock frame
local CameraLocker = Instance.new("TextButton")
CameraLocker.Name = "CameraLocker"
CameraLocker.Size = UDim2.fromOffset(0, 0)
CameraLocker.Position = UDim2.fromOffset(0, 0)
CameraLocker.BackgroundTransparency = 1
CameraLocker.Text = ""
CameraLocker.Modal = false
CameraLocker.Visible = true
CameraLocker.Parent = ScreenGui

-- Notifications GUI container layer
local NotifScreenGui = Instance.new("ScreenGui")
NotifScreenGui.Name = "KazeUINotifications"
NotifScreenGui.ResetOnSpawn = false
NotifScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NotifScreenGui.DisplayOrder = 999999 
NotifScreenGui.Parent = parent

local NotifContainer = Instance.new("Frame")
local notifLayout = Instance.new("UIListLayout", NotifContainer)
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notifLayout.Padding = UDim.new(0, 12)

local notifPadding = Instance.new("UIPadding", NotifContainer)
notifPadding.PaddingBottom = UDim.new(0, 24)
notifPadding.PaddingRight = UDim.new(0, 24)

NotifContainer.Name = "NotifContainer"
NotifContainer.Size = UDim2.new(0, 320, 1, 0)
NotifContainer.Position = UDim2.new(1, -340, 0, 0)
NotifContainer.BackgroundTransparency = 1
NotifContainer.Parent = NotifScreenGui

-- Adaptive Scaling logic
local UIScale = Instance.new("UIScale")
UIScale.Parent = ScreenGui

local function UpdateScale()
    local size = workspace.CurrentCamera.ViewportSize
    local width = size.X
    local height = size.Y
    local minAxis = math.min(width, height)
    
    local targetScale = 1.0

    if UserInputService.TouchEnabled then
        if minAxis < 500 then
            targetScale = 0.85
        else
            targetScale = 1.0
        end
    else
        if width >= 1920 or height >= 1080 then
            targetScale = 1.15
        elseif width <= 1366 then
            targetScale = 0.95
        else
            targetScale = 1.0
        end
    end

    UIScale.Scale = targetScale
    ScreenGui.IgnoreGuiInset = true
end

UpdateScale()
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScale)

-- Unified dynamic theme sync compatibility redirects
function KazeUI:OnGlowChanged(inst: Instance, callback: (Color3) -> ())
    Themes:OnGlowChanged(inst, callback)
end

function KazeUI:RegisterText(inst: any, isMuted: boolean)
    Themes:RegisterText(inst, isMuted)
end

function KazeUI:RegisterBorder(inst: UIStroke)
    Themes:RegisterBorder(inst)
end

function KazeUI:OnThemeChanged(inst: Instance, cb: (any) -> ())
    Themes:OnThemeChanged(inst, cb)
end

function KazeUI:AddPanel(inst: GuiObject, elevation: number, ignoreColorUpdate: boolean?)
    Themes:AddPanel(inst, elevation, ignoreColorUpdate)
end

function KazeUI:SetBackgroundColor(color: Color3)
    Themes:SetTheme(color == Themes.Presets.Obsidian.Background and "Obsidian" or "Arctic")
end

function KazeUI:SetTransparency(alpha: number)
    Themes:SetTransparency(alpha)
end

function KazeUI:SetTheme(themeName: string)
    Themes:SetTheme(themeName)
end

function KazeUI:SetGlow(color: Color3)
    Themes:SetGlow(color)
end

-- Premium System Notifications System
function KazeUI:Notify(config: {[any]: any})
    config = config or {}
    local title = tostring(config.Title or "Notification")
    local content = tostring(config.Content or "")
    local duration = tonumber(config.Duration) or 3

    local notifHolder = Instance.new("Frame")
    notifHolder.Name = "NotifHolder"
    notifHolder.Size = UDim2.new(1, 0, 0, 0)
    notifHolder.BackgroundTransparency = 1
    notifHolder.BorderSizePixel = 0
    notifHolder.ClipsDescendants = true
    notifHolder.Parent = NotifContainer

    local notifFrame = Instance.new("Frame")
    notifFrame.Name = "NotifFrame"
    notifFrame.Size = UDim2.new(1, -6, 0, 64)
    notifFrame.Position = UDim2.new(1.2, 0, 0, 0)
    notifFrame.BorderSizePixel = 0
    notifFrame.Parent = notifHolder
    Instance.new("UICorner", notifFrame).CornerRadius = UDim.new(0, 10)
    self:AddPanel(notifFrame, 0.03)

    local shadow = Instance.new("Frame", notifFrame)
    shadow.Size = UDim2.new(1, 4, 1, 4)
    shadow.Position = UDim2.fromOffset(-2, -2)
    shadow.BackgroundTransparency = 1
    shadow.ZIndex = -1
    local shCorner = Instance.new("UICorner", shadow)
    shCorner.CornerRadius = UDim.new(0, 12)
    local shStroke = Instance.new("UIStroke", shadow)
    shStroke.Thickness = 2.5
    shStroke.Color = Color3.fromRGB(0, 0, 0)
    shStroke.Transparency = 0.85

    local stroke = Instance.new("UIStroke", notifFrame)
    stroke.Thickness = 1
    self:RegisterBorder(stroke)

    local titleLab = Instance.new("TextLabel", notifFrame)
    titleLab.Size = UDim2.new(1, -40, 0, 20)
    titleLab.Position = UDim2.fromOffset(14, 10)
    titleLab.BackgroundTransparency = 1
    titleLab.Text = title
    titleLab.Font = Enum.Font.GothamBold
    titleLab.TextSize = 14
    titleLab.TextXAlignment = Enum.TextXAlignment.Left
    self:RegisterText(titleLab, false)

    local contentLab = Instance.new("TextLabel", notifFrame)
    contentLab.Size = UDim2.new(1, -40, 0, 18)
    contentLab.Position = UDim2.fromOffset(14, 30)
    contentLab.BackgroundTransparency = 1
    contentLab.Text = content
    contentLab.Font = Enum.Font.Gotham
    contentLab.TextSize = 12
    contentLab.TextXAlignment = Enum.TextXAlignment.Left
    self:RegisterText(contentLab, true)

    local progressTrack = Instance.new("Frame", notifFrame)
    progressTrack.Size = UDim2.new(1, -20, 0, 2)
    progressTrack.Position = UDim2.new(0, 10, 1, -4)
    progressTrack.BorderSizePixel = 0
    Instance.new("UICorner", progressTrack).CornerRadius = UDim.new(1, 0)
    self:OnThemeChanged(progressTrack, function(t)
        progressTrack.BackgroundColor3 = t.Border
    end)

    local progressBar = Instance.new("Frame", progressTrack)
    progressBar.Size = UDim2.new(1, 0, 1, 0)
    progressBar.BackgroundColor3 = Themes.GlowColor
    progressBar.BorderSizePixel = 0
    Instance.new("UICorner", progressBar).CornerRadius = UDim.new(1, 0)
    Themes:StartNeonLoop(progressBar)
    
    self:OnGlowChanged(progressBar, function(c)
        progressBar.BackgroundColor3 = c
    end)

    TweenService:Create(notifHolder, Tween.FAST, {Size = UDim2.new(1, 0, 0, 74)}):Play()
    TweenService:Create(notifFrame, Tween.SPRING, {Position = UDim2.new(0, 3, 0, 0)}):Play()

    task.spawn(function()
        TweenService:Create(progressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)}):Play()
        task.wait(duration)
        
        local outTween = TweenService:Create(notifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(1.3, 0, 0, 0)})
        outTween:Play()
        outTween.Completed:Wait()
        
        local shrinkTween = TweenService:Create(notifHolder, Tween.FAST, {Size = UDim2.new(1, 0, 0, 0)})
        shrinkTween:Play()
        shrinkTween.Completed:Wait()

        Themes:StopNeonLoop(progressBar)
        notifHolder:Destroy()
    end)
end

-- Config File Manager Save System
function KazeUI:SaveConfig(name: string)
    if not name or name == "" then
        self:Notify({Title = "Config System", Content = "Config name cannot be empty.", Duration = 3})
        return
    end
    
    local data = {}
    for flag, obj in pairs(self.Flags) do data[flag] = obj.Get() end
    
    if writefile then
        local successVal, encoded = pcall(function() return HttpService:JSONEncode(data) end)
        if successVal then
            writefile("KazeUI_"..name..".json", encoded)
            self:Notify({Title = "Config Saved", Content = "Successfully saved " .. name, Duration = 3})
        else
            self:Notify({Title = "Config Error", Content = "Failed to encode settings to JSON.", Duration = 3})
        end
    else
        self:Notify({Title = "Config Error", Content = "Your executor does not support saving files.", Duration = 3})
    end
end

-- Config File Manager Load System
function KazeUI:LoadConfig(name: string)
    if readfile then
        local s, res = pcall(function() return readfile("KazeUI_"..name..".json") end)
        if s then
            local s2, data = pcall(function() return HttpService:JSONDecode(res) end)
            if s2 and type(data) == "table" then
                for flag, val in pairs(data) do
                    if self.Flags[flag] then self.Flags[flag].Set(val) end
                end
                self:Notify({Title = "Config Loaded", Content = "Successfully loaded " .. name, Duration = 3})
            else
                self:Notify({Title = "Config Error", Content = "Invalid or corrupted config format.", Duration = 3})
            end
        else
            self:Notify({Title = "Config Error", Content = "Config " .. name .. " not found.", Duration = 3})
        end
    end
end

-- Central Window Builder entrypoint
function KazeUI:CreateWindow(config: {[any]: any})
    local winData = Window.Create(config, ScreenGui, UIScale, CameraLocker)
    
    local api = {
        Window = winData.Window,
        ScreenGui = ScreenGui,
        _Pages = winData.Pages,
        _TabsList = winData.TabsList,
        _Tabs = {},
        Minimize = function() winData:Minimize() end,
        Show = function() winData:Show() end,
        Maximize = function() winData:Show() end,
        Toggle = function() winData:Toggle() end
    }

    -- Standard Tab Builder wrapper
    function api:CreateTab(arg1, arg2)
        local btn, page, pageContent = Tab.Create(api, arg1, arg2)
        local tabPublic = { Button = btn, Page = page }
        
        Components.Attach(tabPublic, pageContent, RegisterFlag, CameraLocker)
        
        function tabPublic:SetText(newText)
            btn.TextLabel.Text = newText
        end
        
        return tabPublic
    end

    -- Embedded Config Layout System
    function api:CreateConfigManager(tab)
        local sec = tab:SectionUI("Config Manager")
        local cfgName = "Default"

        local function getConfigs()
            local list = {}
            if listfiles then
                local s, files = pcall(function() return listfiles("") end)
                if not s then s, files = pcall(function() return listfiles("workspace") end) end
                if s and type(files) == "table" then
                    for _, f in ipairs(files) do
                        local fileName = string.match(f, "([^/\\]+)$") or f
                        local name = string.match(fileName, "^KazeUI_(.+)%.json$")
                        if name then table.insert(list, name) end
                    end
                end
            end
            if #list == 0 then table.insert(list, "Default") end
            return list
        end

        sec:TextBox({Title = "Config Name", Default = "Default", Callback = function(v) cfgName = v end})
        
        local configDropdown
        sec:Button({Title = "Save Config", Callback = function() 
            KazeUI:SaveConfig(cfgName) 
            if configDropdown then configDropdown:Refresh(getConfigs()) end
        end})

        configDropdown = sec:Dropdown({
            Title = "Select Saved Config", 
            Options = getConfigs(), 
            Callback = function(v) cfgName = v end
        })

        sec:Button({Title = "Refresh Configs", Callback = function() if configDropdown then configDropdown:Refresh(getConfigs()) end end})
        sec:Button({Title = "Load Config", Callback = function() KazeUI:LoadConfig(cfgName) end})
        
        sec:Button({Title = "Delete Config", Callback = function()
            if delfile then
                pcall(function() delfile("KazeUI_"..cfgName..".json") end)
                KazeUI:Notify({Title = "Config System", Content = "Deleted " .. cfgName, Duration = 3})
                if configDropdown then configDropdown:Refresh(getConfigs()) end
            else
                KazeUI:Notify({Title = "Error", Content = "Your executor lacks 'delfile' support.", Duration = 3})
            end
        end})
    end

    -- Theme Manager Layout Component
    function api:CreateThemeManager(tab)
        local sec = tab:SectionUI("Theme & Visuals")
        
        local themeNames = {}
        for name, _ in pairs(Themes.Presets) do
            table.insert(themeNames, name)
        end
        table.sort(themeNames)

        sec:Dropdown({
            Title = "Interface Theme Preset",
            Options = themeNames,
            Default = Themes.CurrentTheme.Name,
            Flag = "KazeUI_Theme_Preset",
            Callback = function(val)
                Themes:SetTheme(val)
            end
        })

        sec:ColorPicker({
            Title = "Accent Glow Color",
            Default = Themes.GlowColor,
            Flag = "KazeUI_Theme_GlowColor", 
            Callback = function(color)
                Themes:SetGlow(color)
            end
        })

        sec:Slider({
            Title = "UI Background Transparency",
            Min = 0,
            Max = 10,
            Default = 0,
            Flag = "KazeUI_Theme_BackgroundTransparency", 
            Callback = function(val)
                Themes:SetTransparency(val / 10)
            end
        })
    end

    table.insert(KazeUI.ActiveWindows, winData.Window)
    if typeof(config.Callback) == "function" then pcall(config.Callback) end
    return api
end

return KazeUI
