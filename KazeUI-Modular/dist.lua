--[[
	Kaze UI Library v2.1 (Modular Edition)
	Redesigned: High-End Desktop Software Aesthetic (Arc, Figma, Linear, macOS)
	Retained: 100% Backwards Compatibility with Version 1 APIs
--]]

local KazeUI = {}
KazeUI.__index = KazeUI

-- Load internal core sub-modules via require
local ThemesModule = require("src/themes/init")
local UtilsModule = require("src/utils/init")
local ConfigModule = require("src/config/init")
local NotificationModule = require("src/components/Notification")
local WindowModule = require("src/components/Window")

-- Expose configurations
KazeUI.Themes = ThemesModule.Themes
KazeUI.CurrentTheme = ThemesModule.CurrentTheme
KazeUI.GlowColor = ThemesModule.GlowColor
KazeUI.BackgroundColor = ThemesModule.CurrentTheme.Background
KazeUI.BackgroundTransparency = ThemesModule.BackgroundTransparency
KazeUI.Flags = ConfigModule.Flags
KazeUI.ActiveWindows = {} 

-- ScreenGui Setup (Supports CoreGui & PlayerGui Fallback)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KazeUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 10 

local success, parent = pcall(function() return game:GetService("CoreGui") end)
if not success or not parent then
	parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui", 15)
end
ScreenGui.Parent = parent

-- Init global utilities
UtilsModule:InitCameraLocker(ScreenGui)
UtilsModule:InitScale(ScreenGui)

-- Separate Notification screen layer
local NotifScreenGui = Instance.new("ScreenGui")
NotifScreenGui.Name = "KazeUINotifications"
NotifScreenGui.ResetOnSpawn = false
NotifScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NotifScreenGui.DisplayOrder = 999999 
NotifScreenGui.Parent = parent

-- Init notifications
NotificationModule:Init(NotifScreenGui)

-- API Merging to match backward compatibility expectations
function KazeUI:Notify(config)
	NotificationModule:Notify(config)
end

function KazeUI:SaveConfig(name)
	ConfigModule:SaveConfig(name, function(conf) NotificationModule:Notify(conf) end)
end

function KazeUI:LoadConfig(name)
	ConfigModule:LoadConfig(name, function(conf) NotificationModule:Notify(conf) end)
end

function KazeUI:SetTheme(themeName)
	ThemesModule:SetTheme(themeName)
	KazeUI.CurrentTheme = ThemesModule.CurrentTheme
	KazeUI.BackgroundColor = ThemesModule.CurrentTheme.Background
end

function KazeUI:SetGlow(color)
	ThemesModule:SetGlow(color)
	KazeUI.GlowColor = ThemesModule.GlowColor
end

function KazeUI:SetTransparency(alpha)
	ThemesModule:SetTransparency(alpha)
	KazeUI.BackgroundTransparency = ThemesModule.BackgroundTransparency
end

function KazeUI:CreateWindow(config)
	local winInstance = WindowModule:CreateWindow(config, ScreenGui)
	table.insert(KazeUI.ActiveWindows, winInstance.Window)
	return winInstance
end

return KazeUI
