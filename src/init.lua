--[[
	Kaze UI Library v2.1 (Modular Framework Core)
	Path: src/init.lua
--]]

local KazeUI = {}
KazeUI.__index = KazeUI

-- Base Repository URL for Modular Fetching
local BASE_URL = "https://raw.githubusercontent.com/KazeHub/UI/refs/heads/main/"

-- Roblox Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer

-- Theme Presets Configuration
KazeUI.Themes = {
	Obsidian = { Name = "Obsidian", Background = Color3.fromRGB(10, 10, 12), Text = Color3.fromRGB(240, 240, 245), MutedText = Color3.fromRGB(150, 150, 155), Border = Color3.fromRGB(45, 45, 50), LightnessFactor = 1 },
	Arctic = { Name = "Arctic", Background = Color3.fromRGB(245, 247, 250), Text = Color3.fromRGB(20, 20, 25), MutedText = Color3.fromRGB(110, 115, 125), Border = Color3.fromRGB(215, 220, 228), LightnessFactor = -1 },
	Amethyst = { Name = "Amethyst", Background = Color3.fromRGB(15, 10, 22), Text = Color3.fromRGB(240, 235, 250), MutedText = Color3.fromRGB(160, 145, 175), Border = Color3.fromRGB(50, 40, 65), LightnessFactor = 1 },
	Emerald = { Name = "Emerald", Background = Color3.fromRGB(8, 15, 12), Text = Color3.fromRGB(235, 245, 240), MutedText = Color3.fromRGB(145, 165, 155), Border = Color3.fromRGB(38, 55, 45), LightnessFactor = 1 },
	Midnight = { Name = "Midnight", Background = Color3.fromRGB(5, 7, 15), Text = Color3.fromRGB(235, 240, 255), MutedText = Color3.fromRGB(135, 145, 165), Border = Color3.fromRGB(30, 38, 55), LightnessFactor = 1 }
}

-- Global State & Registries (Fixed & Completed Tables)
KazeUI.CurrentTheme = KazeUI.Themes.Obsidian
KazeUI.GlowColor = Color3.fromRGB(0, 160, 255)
KazeUI.BackgroundColor = KazeUI.CurrentTheme.Background
KazeUI.BackgroundTransparency = 0
KazeUI.Flags = {}
KazeUI.ActiveWindows = {} 
KazeUI.TextElements = {}
KazeUI.MutedTextElements = {}
KazeUI.BorderElements = {}
KazeUI.PanelElements = {} 
KazeUI.ThemeCallbacks = {}

-- Setup Core ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KazeUI_Modular"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local success, parent = pcall(function() return game:GetService("CoreGui") end)
if not success or not parent then parent = LP:WaitForChild("PlayerGui", 15) end
ScreenGui.Parent = parent

-- Cross-Platform Scale Engine
local UIScale = Instance.new("UIScale", ScreenGui)
local function UpdateScale()
	local size = workspace.CurrentCamera.ViewportSize
	local minAxis = math.min(size.X, size.Y)
	UIScale.Scale = UIS.TouchEnabled and ((minAxis < 500) and 0.85 or 1.0) or (size.X >= 1920 and 1.15 or (size.X <= 1366 and 0.95 or 1.0))
end
UpdateScale()
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScale)

-- Theme Utility Functions
function KazeUI.GetColor(elevation)
	local theme = KazeUI.CurrentTheme
	local h, s, v = Color3.toHSV(theme.Background)
	return Color3.fromHSV(h, s, math.clamp(v + (elevation * theme.LightnessFactor), 0, 1))
end

function KazeUI:AddPanel(inst, elevation, ignoreColorUpdate)
	table.insert(KazeUI.PanelElements, {Inst = inst, Elevation = elevation or 0, IgnoreColor = ignoreColorUpdate})
	if inst and inst:IsA("GuiObject") then
		if not ignoreColorUpdate then inst.BackgroundColor3 = KazeUI.GetColor(elevation or 0) end
		inst.BackgroundTransparency = KazeUI.BackgroundTransparency or 0
	end
end

function KazeUI:RegisterText(inst, isMuted)
	if not inst then return end
	table.insert(isMuted and KazeUI.MutedTextElements or KazeUI.TextElements, inst)
	inst.TextColor3 = isMuted and KazeUI.CurrentTheme.MutedText or KazeUI.CurrentTheme.Text
end

function KazeUI:RegisterBorder(inst)
	if not inst then return end
	table.insert(KazeUI.BorderElements, inst)
	inst.Color = KazeUI.CurrentTheme.Border
end

function KazeUI:OnThemeChanged(inst, callback)
	if not KazeUI.ThemeCallbacks[inst] then KazeUI.ThemeCallbacks[inst] = {} end
	table.insert(KazeUI.ThemeCallbacks[inst], callback)
end

function KazeUI:SetTheme(themeName)
	local targetTheme = KazeUI.Themes[themeName] or KazeUI.Themes.Obsidian
	KazeUI.CurrentTheme = targetTheme
	KazeUI.BackgroundColor = targetTheme.Background
	
	-- Update normal and muted text elements
	for _, inst in ipairs(KazeUI.TextElements) do if inst.Parent then inst.TextColor3 = targetTheme.Text end end
	for _, inst in ipairs(KazeUI.MutedTextElements) do if inst.Parent then inst.TextColor3 = targetTheme.MutedText end end
	for _, inst in ipairs(KazeUI.BorderElements) do if inst.Parent then inst.Color = targetTheme.Border end end
	
	-- Update physical layout panels tracking elevations
	for _, p in ipairs(KazeUI.PanelElements) do
		if p.Inst and p.Inst.Parent and not p.IgnoreColor then
			p.Inst.BackgroundColor3 = KazeUI.GetColor(p.Elevation)
		end
	end
	
	-- Fire inline component functional signals
	for inst, callbacks in pairs(KazeUI.ThemeCallbacks) do
		if inst.Parent then
			for _, cb in ipairs(callbacks) do task.spawn(cb, targetTheme) end
		end
	end
	print("[KazeUI] Theme successfully shifted globally to: " .. themeName)
end

-- Modular Component Loader (The bridge function to route buttons, sliders, etc.)
function KazeUI.new(config)
	print("[KazeUI] Core engine loaded via GitHub raw link successfully.")
	
	-- Dito natin idadownload at i-bi-bridge yung components routing file kapag isinulat na natin
	local componentRegistrySuccess, ComponentRegistry = pcall(function()
		return loadstring(game:HttpGet(BASE_URL .. "src/components/init.lua"))()
	end)
	
	if componentRegistrySuccess and ComponentRegistry then
		ComponentRegistry:Init(KazeUI)
	else
		warn("[KazeUI Error] Failed to load components sub-module registry.")
	end

	return KazeUI
end

return KazeUI
