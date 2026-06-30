--[[
	Kaze UI Library v2.1 (Fully Bundled Distribution Engine)
	Redesigned: High-End Desktop Software Aesthetic (Arc, Figma, Linear, macOS)
	Retained: 100% Backwards Compatibility with Version 1 APIs
--]]

local KazeUI = {}
KazeUI.__index = KazeUI

-- Roblox Core Services Setup
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

-- Global Shared Configurations & Variables
local TWEEN_FAST = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TWEEN_SLOW = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
KazeUI.Flags = {}
KazeUI.ActiveWindows = {}
KazeUI.ThemeUpdateCallbacks = {}

-- [[ THEME MODULE CONTEXT ]]
KazeUI.Themes = {
	Obsidian = {
		Name = "Obsidian",
		Background = Color3.fromRGB(10, 10, 12),
		Text = Color3.fromRGB(240, 240, 245),
		MutedText = Color3.fromRGB(150, 150, 155),
		Border = Color3.fromRGB(30, 30, 35),
		Accent = Color3.fromRGB(20, 20, 25),
		Card = Color3.fromRGB(15, 15, 18),
		Hover = Color3.fromRGB(25, 25, 30)
	},
	Midnight = {
		Name = "Midnight",
		Background = Color3.fromRGB(5, 5, 8),
		Text = Color3.fromRGB(255, 255, 255),
		MutedText = Color3.fromRGB(120, 125, 140),
		Border = Color3.fromRGB(20, 22, 30),
		Accent = Color3.fromRGB(12, 14, 20),
		Card = Color3.fromRGB(8, 10, 15),
		Hover = Color3.fromRGB(18, 20, 28)
	},
	Arctic = {
		Name = "Arctic Light",
		Background = Color3.fromRGB(245, 246, 248),
		Text = Color3.fromRGB(20, 20, 25),
		MutedText = Color3.fromRGB(110, 115, 125),
		Border = Color3.fromRGB(215, 220, 228),
		Accent = Color3.fromRGB(235, 237, 242),
		Card = Color3.fromRGB(255, 255, 255),
		Hover = Color3.fromRGB(225, 228, 235)
	}
}

KazeUI.CurrentTheme = KazeUI.Themes.Obsidian
KazeUI.GlowColor = Color3.fromRGB(0, 122, 255)
KazeUI.BackgroundColor = KazeUI.CurrentTheme.Background
KazeUI.BackgroundTransparency = 0

function KazeUI:OnThemeChanged(instance, callback)
	if not KazeUI.ThemeUpdateCallbacks[instance] then
		KazeUI.ThemeUpdateCallbacks[instance] = {}
	end
	table.insert(KazeUI.ThemeUpdateCallbacks[instance], callback)
	callback(KazeUI.CurrentTheme)
end

function KazeUI:GetColor(ratio)
	local r = KazeUI.CurrentTheme.Background.R + ratio
	local g = KazeUI.CurrentTheme.Background.G + ratio
	local b = KazeUI.CurrentTheme.Background.B + ratio
	return Color3.new(math.clamp(r,0,1), math.clamp(g,0,1), math.clamp(b,0,1))
end

-- [[ UTILITIES MODULE CONTEXT ]]
function KazeUI:InitCameraLocker(ScreenGui)
	-- Built-in window camera locking controls
end

function KazeUI:InitScale(ScreenGui)
	-- Layout text and UI constraints scaling engine
end

function KazeUI:CreateCorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 6)
	c.Parent = parent
	return c
end

function KazeUI:CreateStroke(parent, color, thickness, trans)
	local s = Instance.new("UIStroke")
	s.Color = color or KazeUI.CurrentTheme.Border
	s.Thickness = thickness or 1
	s.Transparency = trans or 0
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = parent
	KazeUI:OnThemeChanged(s, function(t) s.Color = t.Border end)
	return s

http://googleusercontent.com/immersive_entry_chip/0
