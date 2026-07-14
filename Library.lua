--[[
	Kaze UI Library v4.0.0 (Ultimate Redesign & Feature Expansion)
	Inspired by: Modern Mobile Chat Bubbles, iMessage, VSCode and Discord Mobile.
	Retained: 100% Backwards Compatibility with Version 1, 2, 2.2, 2.3, and 3.0 APIs
	
	NEW ENHANCEMENTS IN v4.0.0:
	- ⭐ ANIMATED LAYOUT ENGINE: Butter-smooth dynamic widget transitions.
	- ⭐ DOCKABLE WINDOWS SYSTEM: Snap, dock, split, and transfer tabs on the fly.
	- ⭐ COMMAND PALETTE: Keyboard accessible Raycast-like searchable navigation bar.
	- ⭐ TIMELINE ANIMATION SEQUENCE: Sophisticated programmatic UI choreography.
	- ⭐ EXTENDED PLUGINS SYSTEM: Seamless custom element integration.
	- ⭐ DEV DIAGNOSTICS: Built-in Component Inspector & High-Fidelity UI Profiler.
	- ⭐ PROMISE NOTIFICATIONS: Supports action buttons, progress loaders, and updates.
--]]

local KazeUI = {}
KazeUI.__index = KazeUI

-- Roblox Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

-- Premium Bubble Themes Configuration (High-Contrast, Vivid Settings)
KazeUI.Themes = {
	Obsidian = {
		Name = "Obsidian",
		Background = Color3.fromRGB(15, 15, 22),
		Text = Color3.fromRGB(245, 245, 250),
		MutedText = Color3.fromRGB(200, 200, 215),
		Border = Color3.fromRGB(55, 55, 75),
		LightnessFactor = 1.4,
		BackgroundImage = "rbxassetid://13963496525",
		BackgroundImageTransparency = 0.85,
		OverlayTransparency = 0.20
	},
	CustomWallpaper = {
		Name = "Custom",
		Background = Color3.fromRGB(12, 12, 14),
		Text = Color3.fromRGB(255, 255, 255),
		MutedText = Color3.fromRGB(215, 210, 225),
		Border = Color3.fromRGB(55, 55, 60),
		LightnessFactor = 1,
		BackgroundImage = "https://pbs.twimg.com/media/Gu-hWtyX0AA5-5s.jpg",
		BackgroundImageTransparency = 0.1,
		OverlayTransparency = 0.65
	}
}

-- Global State (Beautifully Tuned Soft Translucent Defaults)
KazeUI.CurrentTheme = KazeUI.Themes.CustomWallpaper
KazeUI.GlowColor = Color3.fromRGB(239, 68, 68)
KazeUI.BackgroundColor = KazeUI.CurrentTheme.Background
KazeUI.BackgroundTransparency = 0.70
KazeUI.Flags = {}
KazeUI.FlagMetadata = {}
KazeUI.ActiveWindows = {}
KazeUI.IsResizing = false
KazeUI.AuthorName = "Unknown"
KazeUI.CustomElements = {}

-- Centralized Modal / Dialogue State Tracker
local activeDialogsCount = 0

-- UI element registries for theme switching
KazeUI.TextElements = {}
KazeUI.MutedTextElements = {}
KazeUI.BorderElements = {}
KazeUI.ThemeCallbacks = {}
KazeUI.WallpaperElements = {}

-- Interactive Neon controllers
KazeUI.GlowElements = {}
KazeUI.NeonTweens = {}
KazeUI.PanelElements = {}
KazeUI.GlowCallbacks = {}

-- Active Tweens Tracking for Profiler
local activeTweensCount = 0

-- Spring & Smooth Animation Configurations
local TWEEN_FAST = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TWEEN_SPRING = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local TWEEN_SMOOTH = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

-- Track Active Tweens
local function PlayTrackedTween(inst, info, props)
	local tween = TweenService:Create(inst, info, props)
	activeTweensCount = activeTweensCount + 1
	tween.Completed:Connect(function()
		activeTweensCount = math.max(0, activeTweensCount - 1)
	end)
	tween:Play()
	return tween
end

local function RegisterFlag(flag, getFunc, setFunc, metadata)
	if flag then
		KazeUI.Flags[flag] = { Get = getFunc, Set = setFunc }
		KazeUI.FlagMetadata[flag] = metadata or {}
	end
end

-- ScreenGui Setup (Supports CoreGui & PlayerGui fallback)
local success, parent = pcall(function() return game:GetService("CoreGui") end)
if not success or not parent then
	parent = LP:WaitForChild("PlayerGui", 15)
end

-- Centralized ScreenGui Setup with Precise Display Orders
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KazeUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 10
ScreenGui.Parent = parent

local OpenButtonGui = Instance.new("ScreenGui")
OpenButtonGui.Name = "KazeUI_OpenButton"
OpenButtonGui.ResetOnSpawn = false
OpenButtonGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
OpenButtonGui.DisplayOrder = 20
OpenButtonGui.Parent = parent

local DialogGui = Instance.new("ScreenGui")
DialogGui.Name = "KazeUI_Dialogs"
DialogGui.ResetOnSpawn = false
DialogGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
DialogGui.DisplayOrder = 100
DialogGui.Parent = parent

local NotifScreenGui = Instance.new("ScreenGui")
NotifScreenGui.Name = "KazeUINotifications"
NotifScreenGui.ResetOnSpawn = false
NotifScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NotifScreenGui.DisplayOrder = 300
NotifScreenGui.Parent = parent

-- Centralized Camera Locker System
local CameraLocker = Instance.new("TextButton")
CameraLocker.Name = "CameraLocker"
CameraLocker.Size = UDim2.fromOffset(0, 0)
CameraLocker.Position = UDim2.fromOffset(0, 0)
CameraLocker.BackgroundTransparency = 1
CameraLocker.Text = ""
CameraLocker.Modal = false
CameraLocker.Visible = true
CameraLocker.Parent = ScreenGui

local function LockCamera()
	CameraLocker.Modal = true
end

local function UnlockCamera()
	CameraLocker.Modal = false
end

-- Notification container
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

-- Adaptive Scaling Engine
local UIScale = Instance.new("UIScale")
UIScale.Parent = ScreenGui

local function UpdateScale()
	local size = workspace.CurrentCamera.ViewportSize
	local width, height = size.X, size.Y
	local minAxis = math.min(width, height)
	local targetScale = 1.0

	if UIS.TouchEnabled then
		targetScale = (minAxis < 500) and 0.85 or 1.0
	else
		if width >= 1920 or height >= 1080 then
			targetScale = 1.12
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

-- Lucide Icons Setup
local IconsMap = {}
pcall(function()
	if game and game.HttpGet then
		local rawIcons = game:HttpGet("https://raw.githubusercontent.com/KazeHub/UI/refs/heads/main/Icons.lua.txt")
		if rawIcons then
			local s, res = pcall(function()
				local func = loadstring(rawIcons)
				return func and func()
			end)
			if not s or type(res) ~= "table" then
				s, res = pcall(function() return HttpService:JSONDecode(rawIcons) end)
			end
			if type(res) == "table" then
				for k, v in pairs(res) do IconsMap[string.lower(tostring(k))] = tostring(v) end
			end
		end
	end
end)

local function GetCustomAssetFromURL(url)
	local getasset = (getcustomasset or getsynasset or (drawing and drawing.new and drawing.custom_asset))
	if not getasset or not writefile or not game or not game.HttpGet then
		return url 
	end
	
	local hashName = string.gsub(url, "%A", "")
	local filename = "KazeUI/Cache/" .. string.sub(hashName, 1, 30) .. ".png"
	
	if isfile and isfile(filename) then
		local s, asset = pcall(getasset, filename)
		if s and asset then return asset end
	end
	
	local success, bytes = pcall(function()
		return game:HttpGet(url)
	end)
	
	if success and bytes and string.len(bytes) > 0 then
		if makefolder then
			pcall(makefolder, "KazeUI")
			pcall(makefolder, "KazeUI/Cache")
		end
		pcall(writefile, filename, bytes)
		local s, asset = pcall(getasset, filename)
		if s and asset then return asset end
	end
	
	return url
end

local function FormatImage(id)
	if not id or id == "" then return "" end
	id = tostring(id)
	local lowerId = string.lower(id)
	if IconsMap[lowerId] then
		local mapped = IconsMap[lowerId]
		if not string.find(mapped, "rbxassetid://") and not string.find(mapped, "http") then
			local clean = string.gsub(mapped, "%D", "")
			if clean ~= "" then return "rbxassetid://" .. clean end
		end
		return mapped
	end
	
	if string.find(id, "rbxassetid://") then return id end
	
	if string.find(id, "^http://") or string.find(id, "^https://") then
		return GetCustomAssetFromURL(id)
	end
	
	local clean = string.gsub(id, "%D", "")
	if clean == "" then return id end
	return "rbxassetid://" .. clean
end

-- ==========================================
-- Dynamic Color Sync & Registries
-- ==========================================
function KazeUI:OnGlowChanged(inst, callback)
	table.insert(KazeUI.GlowCallbacks, {Inst = inst, Callback = callback})
	task.spawn(callback, KazeUI.GlowColor)
	if inst and typeof(inst) == "Instance" then
		inst.Destroying:Connect(function()
			for i = #KazeUI.GlowCallbacks, 1, -1 do
				if KazeUI.GlowCallbacks[i].Inst == inst then table.remove(KazeUI.GlowCallbacks, i) end
			end
		end)
	end
end

function KazeUI:RegisterText(inst, isMuted)
	if not inst then return end
	if isMuted then
		table.insert(KazeUI.MutedTextElements, inst)
		inst.TextColor3 = KazeUI.CurrentTheme.MutedText
		if inst:IsA("TextBox") then
			inst.PlaceholderColor3 = KazeUI.CurrentTheme.MutedText
		end
	else
		table.insert(KazeUI.TextElements, inst)
		inst.TextColor3 = KazeUI.CurrentTheme.Text
	end
	inst.Destroying:Connect(function()
		local tbl = isMuted and KazeUI.MutedTextElements or KazeUI.TextElements
		for i = #tbl, 1, -1 do
			if tbl[i] == inst then table.remove(tbl, i) end
		end
	end)
end

function KazeUI:RegisterBorder(inst)
	if not inst then return end
	table.insert(KazeUI.BorderElements, inst)
	inst.Color = KazeUI.CurrentTheme.Border
	inst.Destroying:Connect(function()
		for i = #KazeUI.BorderElements, 1, -1 do
			if KazeUI.BorderElements[i] == inst then table.remove(KazeUI.BorderElements, i) end
		end
	end)
end

function KazeUI:OnThemeChanged(inst, cb)
	if not inst then return end
	table.insert(KazeUI.ThemeCallbacks, {Inst = inst, Callback = cb})
	task.spawn(cb, KazeUI.CurrentTheme)
	inst.Destroying:Connect(function()
		for i = #KazeUI.ThemeCallbacks, 1, -1 do
			if KazeUI.ThemeCallbacks[i].Inst == inst then table.remove(KazeUI.ThemeCallbacks, i) end
		end
	end)
end

-- ==========================================
-- ⭐ Timeline Animation Engine (Sequencer)
-- ==========================================
local Timeline = {}
Timeline.__index = Timeline

function KazeUI:CreateTimeline(config)
	config = config or {}
	local self = setmetatable({
		_tweens = {},
		_status = "Stopped",
		_duration = 0,
		_loop = config.Loop or false,
		_onComplete = config.OnComplete or nil
	}, Timeline)
	return self
end

function Timeline:Add(instance, tweenInfo, properties, offsetTime)
	offsetTime = offsetTime or 0
	table.insert(self._tweens, {
		Instance = instance,
		Info = tweenInfo,
		Properties = properties,
		Offset = offsetTime
	})
	self._duration = math.max(self._duration, offsetTime + tweenInfo.Time)
	return self
end

function Timeline:Play()
	if self._status == "Playing" then return end
	self._status = "Playing"
	
	self._activeThreads = {}
	for _, anim in ipairs(self._tweens) do
		local t = task.delay(anim.Offset, function()
			if self._status ~= "Playing" then return end
			local tween = PlayTrackedTween(anim.Instance, anim.Info, anim.Properties)
			table.insert(self._activeThreads, tween)
		end)
		table.insert(self._activeThreads, t)
	end
	
	task.spawn(function()
		task.wait(self._duration)
		if self._status == "Playing" then
			self._status = "Stopped"
			if self._loop then
				self:Play()
			elseif self._onComplete then
				pcall(self._onComplete)
			end
		end
	end)
end

function Timeline:Pause()
	self._status = "Paused"
	if self._activeThreads then
		for _, item in ipairs(self._activeThreads) do
			if typeof(item) == "thread" then
				task.cancel(item)
			elseif typeof(item) == "Tween" then
				item:Pause()
			end
		end
	end
end

function Timeline:Cancel()
	self._status = "Stopped"
	if self._activeThreads then
		for _, item in ipairs(self._activeThreads) do
			if typeof(item) == "thread" then
				task.cancel(item)
			elseif typeof(item) == "Tween" then
				item:Cancel()
			end
		end
	end
	self._activeThreads = nil
end

-- ==========================================
-- ⭐ Plugin & Component Extension Engine
-- ==========================================
function KazeUI:RegisterElement(name, constructor)
	assert(type(name) == "string", "KazeUI:RegisterElement requires a string name")
	assert(type(constructor) == "function", "KazeUI:RegisterElement requires a constructor function")
	KazeUI.CustomElements[name] = constructor
end

-- ==========================================
-- ⭐ Animated Layout Engine Implementation
-- ==========================================
local function CreateAnimatedLayout(container, padding)
	padding = padding or 6
	local updating = false
	
	local function layout()
		if updating then return end
		updating = true
		
		task.spawn(function()
			task.wait() -- Buffer multiple updates
			local currentY = padding
			local elements = {}
			
			for _, child in ipairs(container:GetChildren()) do
				if child:IsA("GuiObject") and child.Visible and child.Name ~= "UIPadding" and child.Name ~= "UIListLayout" and child.Name ~= "EmptyState" then
					table.insert(elements, child)
				end
			end
			
			table.sort(elements, function(a, b)
				return (a.LayoutOrder or 0) < (b.LayoutOrder or 0)
			end)
			
			for _, child in ipairs(elements) do
				local targetPos = UDim2.new(child.Position.X.Scale, child.Position.X.Offset, 0, currentY)
				PlayTrackedTween(child, TWEEN_SMOOTH, {Position = targetPos})
				currentY = currentY + child.AbsoluteSize.Y + padding
			end
			
			if container:IsA("ScrollingFrame") then
				PlayTrackedTween(container, TWEEN_SMOOTH, {CanvasSize = UDim2.new(0, 0, 0, currentY + padding)})
			end
			updating = false
		end)
	end
	
	container.ChildAdded:Connect(function(c)
		if c:IsA("GuiObject") then
			c:GetPropertyChangedSignal("Visible"):Connect(layout)
			c:GetPropertyChangedSignal("Size"):Connect(layout)
			layout()
		end
	end)
	container.ChildRemoved:Connect(layout)
	
	-- Initial trigger
	layout()
	return layout
end

-- Premium Dragging engine with Snapping/Docking preview capabilities
local lastNormalPosition = UDim2.fromScale(0.5, 0.5)
local lastNormalAnchor = Vector2.new(0.5, 0.5)

-- ==========================================
-- ⭐ High Fidelity Docking Overlay System
-- ==========================================
local DockPreview = Instance.new("Frame")
DockPreview.Name = "KazeUIDockPreview"
DockPreview.BorderSizePixel = 0
DockPreview.BackgroundTransparency = 1
DockPreview.BackgroundColor3 = KazeUI.GlowColor
DockPreview.ZIndex = 9999
DockPreview.Visible = false
Instance.new("UICorner", DockPreview).CornerRadius = UDim.new(0, 20)
local previewStroke = Instance.new("UIStroke", DockPreview)
previewStroke.Thickness = 2
previewStroke.Color = KazeUI.GlowColor
DockPreview.Parent = ScreenGui

KazeUI:OnGlowChanged(DockPreview, function(c)
	DockPreview.BackgroundColor3 = c
	previewStroke.Color = c
end)

local function MakeDraggable(dragPart, targetPart)
	local dragging = false
	local dragInput, dragStart, startPos
	local dragActive = false
	
	dragPart.Active = true
	
	local function update(input)
		if not dragStart or not startPos then return end
		local delta = input.Position - dragStart
		local scale = UIScale.Scale
		
		if dragActive or delta.Magnitude > 8 then
			dragActive = true
			
			local viewportSize = workspace.CurrentCamera.ViewportSize
			local rawX = startPos.X.Offset + (delta.X / scale)
			local rawY = startPos.Y.Offset + (delta.Y / scale)
			
			-- Real-time Docking Snapping check
			local mousePos = UIS:GetMouseLocation()
			local snapSide = nil
			local snapWidth = viewportSize.X * 0.4
			
			if mousePos.X < 80 then
				snapSide = "Left"
				DockPreview.Size = UDim2.new(0, snapWidth, 1.0, 0)
				DockPreview.Position = UDim2.new(0, 0, 0, 0)
				DockPreview.Visible = true
				PlayTrackedTween(DockPreview, TWEEN_FAST, {BackgroundTransparency = 0.85})
			elseif mousePos.X > viewportSize.X - 80 then
				snapSide = "Right"
				DockPreview.Size = UDim2.new(0, snapWidth, 1.0, 0)
				DockPreview.Position = UDim2.new(1.0, -snapWidth, 0, 0)
				DockPreview.Visible = true
				PlayTrackedTween(DockPreview, TWEEN_FAST, {BackgroundTransparency = 0.85})
			else
				DockPreview.Visible = false
			end
			
			targetPart.Position = UDim2.new(
				startPos.X.Scale, rawX,
				startPos.Y.Scale, rawY
			)
			
			if targetPart.Name == "Frame" or targetPart:IsA("Frame") then
				lastNormalPosition = targetPart.Position
				lastNormalAnchor = targetPart.AnchorPoint
			end
			
			targetPart.AttributeChanged:Connect(function(attr)
				if attr == "SnappedSide" then
					targetPart:SetAttribute("SnappedSide", snapSide)
				end
			end)
			targetPart:SetAttribute("CurrentSnapSide", snapSide)
		end
	end
	
	dragPart.InputBegan:Connect(function(input)
		if KazeUI.IsResizing or activeDialogsCount > 0 then return end
		
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragActive = false
			dragStart = input.Position
			startPos = targetPart.Position
			
			LockCamera()
			
			local changeCon
			changeCon = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					dragInput = nil
					UnlockCamera()
					
					-- Execute snap if hovering within docking boundaries
					local snapSide = targetPart:GetAttribute("CurrentSnapSide")
					if snapSide then
						local viewportSize = workspace.CurrentCamera.ViewportSize
						local snapWidth = viewportSize.X * 0.4
						targetPart.AnchorPoint = Vector2.new(0, 0)
						if snapSide == "Left" then
							PlayTrackedTween(targetPart, TWEEN_SPRING, {
								Size = UDim2.new(0, snapWidth, 1.0, 0),
								Position = UDim2.new(0, 0, 0, 0)
							})
						elseif snapSide == "Right" then
							PlayTrackedTween(targetPart, TWEEN_SPRING, {
								Size = UDim2.new(0, snapWidth, 1.0, 0),
								Position = UDim2.new(1.0, -snapWidth, 0, 0)
							})
						end
					end
					DockPreview.Visible = false
					if changeCon then changeCon:Disconnect() end
				end
			end)
		end
	end)
	
	dragPart.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	
	local uisConn = UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragging then update(input) end
	end)
	
	if dragPart and typeof(dragPart) == "Instance" then
		dragPart.Destroying:Connect(function()
			if uisConn then uisConn:Disconnect() end
		end)
	end
end

-- ==========================================================
-- Universal Centered Lock Overlay Implementation (Input & Visual Blocker)
-- ==========================================================
local function ApplyLock(componentFrame, isLocked, parentOverride, customSize, customPos, customAnchor)
	local lockOverlay = Instance.new("TextButton")
	lockOverlay.Name = "LockOverlay"
	lockOverlay.Size = customSize or UDim2.fromScale(1, 1)
	lockOverlay.Position = customPos or UDim2.fromScale(0, 0)
	lockOverlay.AnchorPoint = customAnchor or Vector2.new(0, 0)
	lockOverlay.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
	lockOverlay.BackgroundTransparency = 0.55 
	lockOverlay.ZIndex = 9999 
	lockOverlay.Text = ""
	lockOverlay.AutoButtonColor = false
	lockOverlay.Visible = isLocked or false
	lockOverlay.Active = true
	lockOverlay.Parent = parentOverride or componentFrame

	local corner = componentFrame:FindFirstChildOfClass("UICorner")
	if corner then
		local overlayCorner = Instance.new("UICorner")
		overlayCorner.CornerRadius = corner.CornerRadius
		overlayCorner.Parent = lockOverlay
	end

	local lockIcon = Instance.new("ImageLabel")
	lockIcon.Name = "LockIcon"
	lockIcon.Size = UDim2.fromOffset(24, 24)
	lockIcon.AnchorPoint = Vector2.new(0.5, 0.5) 
	lockIcon.Position = UDim2.fromScale(0.5, 0.5) 
	lockIcon.BackgroundTransparency = 1
	lockIcon.Image = "rbxassetid://78672912777756"
	lockIcon.ZIndex = 10000
	lockIcon.Parent = lockOverlay
	
	KazeUI:OnThemeChanged(lockIcon, function(t)
		lockIcon.ImageColor3 = t.MutedText
	end)

	local function setLocked(state)
		lockOverlay.Visible = state
	end

	return {
		Overlay = lockOverlay,
		SetLocked = setLocked
	}
end

-- ==========================================
-- Theme & Transparency Engine (Translucent Bubbles)
-- ==========================================
function KazeUI.GetColor(elevation)
	local theme = KazeUI.CurrentTheme
	local h, s, v = Color3.toHSV(theme.Background)
	local factor = theme.LightnessFactor or 1
	local offset = elevation * factor * 2.2
	local targetS = math.clamp(s - (elevation * 0.5), 0, 1)
	local targetV = math.clamp(v + offset, 0, 1)
	return Color3.fromHSV(h, targetS, targetV)
end

function KazeUI:AddPanel(inst, elevation, ignoreColorUpdate, ignoreTransparencyUpdate)
	table.insert(KazeUI.PanelElements, {
		Inst = inst, 
		Elevation = elevation or 0, 
		IgnoreColor = ignoreColorUpdate,
		IgnoreTransparency = ignoreTransparencyUpdate
	})
	if inst and inst:IsA("GuiObject") then
		if not ignoreColorUpdate then
			inst.BackgroundColor3 = KazeUI.GetColor(elevation or 0)
		end
		
		if not ignoreTransparencyUpdate then
			local baseTrans = KazeUI.BackgroundTransparency or 0.70
			if elevation and elevation > 0 then
				baseTrans = math.clamp(baseTrans - (elevation * 0.25), 0.05, 1)
			elseif elevation and elevation < 0 then
				baseTrans = math.clamp(baseTrans + (math.abs(elevation) * 0.25), 0.05, 1)
			end
			inst.BackgroundTransparency = baseTrans
		end

		inst.Destroying:Connect(function()
			for i = #KazeUI.PanelElements, 1, -1 do
				if KazeUI.PanelElements[i].Inst == inst then table.remove(KazeUI.PanelElements, i) end
			end
		end)
	end
end

function KazeUI:SetBackgroundColor(color)
	for _, data in ipairs(KazeUI.PanelElements) do
		if data.Inst and data.Inst.Parent and data.Inst:IsA("GuiObject") and not data.IgnoreColor then
			data.Inst.BackgroundColor3 = KazeUI.GetColor(data.Elevation)
		end
	end
end

function KazeUI:SetTransparency(alpha)
	KazeUI.BackgroundTransparency = alpha
	for _, data in ipairs(KazeUI.PanelElements) do
		local inst = data.Inst
		local elevation = data.Elevation or 0
		if inst and inst.Parent and inst:IsA("GuiObject") and not data.IgnoreTransparency then
			local baseTrans = alpha
			if elevation > 0 then
				baseTrans = math.clamp(alpha - (elevation * 0.25), 0.05, 1)
			elseif elevation < 0 then
				baseTrans = math.clamp(alpha + (math.abs(elevation) * 0.25), 0.05, 1)
			end
			inst.BackgroundTransparency = baseTrans
		end
	end
end

function KazeUI:SetTheme(themeName)
	local targetTheme = KazeUI.Themes[themeName]
	
	if not targetTheme and type(themeName) == "string" and (string.find(themeName, "^http://") or string.find(themeName, "^https://")) then
		local success, rawTheme = pcall(function()
			return game:HttpGet(themeName)
		end)
		
		local parsedSuccessfully = false
		if success and rawTheme then
			local themeTable = nil
			local s, parsed = pcall(function()
				return HttpService:JSONDecode(rawTheme)
			end)
			if s and type(parsed) == "table" then
				themeTable = parsed
			else
				local s2, func = pcall(loadstring, rawTheme)
				if s2 and func then
					local s3, res = pcall(func)
					if s3 and type(res) == "table" then
						themeTable = res
					end
				end
			end
			
			if themeTable then
				local function parseColor(val)
					if typeof(val) == "Color3" then
						return val
					elseif type(val) == "string" then
						local cleanHex = string.gsub(val, "#", "")
						local s4, res = pcall(function() return Color3.fromHex(cleanHex) end)
						if s4 and res then return res end
					elseif type(val) == "table" then
						local r = val.r or val.R or val[1] or 0
						local g = val.g or val.G or val[2] or 0
						local b = val.b or val.B or val[3] or 0
						if r > 1 or g > 1 or b > 1 then
							return Color3.fromRGB(r, g, b)
						else
							return Color3.new(r, g, b)
						end
					end
					return nil
				end
				
				KazeUI.Themes.CustomWallpaper.Background = parseColor(themeTable.Background) or Color3.fromRGB(12, 12, 14)
				KazeUI.Themes.CustomWallpaper.Text = parseColor(themeTable.Text) or Color3.fromRGB(255, 255, 255)
				KazeUI.Themes.CustomWallpaper.MutedText = parseColor(themeTable.MutedText) or Color3.fromRGB(215, 210, 225)
				KazeUI.Themes.CustomWallpaper.Border = parseColor(themeTable.Border) or Color3.fromRGB(55, 55, 60)
				KazeUI.Themes.CustomWallpaper.LightnessFactor = tonumber(themeTable.LightnessFactor) or 1
				KazeUI.Themes.CustomWallpaper.BackgroundImage = tostring(themeTable.BackgroundImage or "")
				KazeUI.Themes.CustomWallpaper.BackgroundImageTransparency = tonumber(themeTable.BackgroundImageTransparency) or 0.1
				KazeUI.Themes.CustomWallpaper.OverlayTransparency = tonumber(themeTable.OverlayTransparency) or 0.65
				parsedSuccessfully = true
			end
		end
		
		if not parsedSuccessfully then
			KazeUI.Themes.CustomWallpaper.BackgroundImage = themeName
			KazeUI.Themes.CustomWallpaper.BackgroundImageTransparency = 0.1
			KazeUI.Themes.CustomWallpaper.OverlayTransparency = 0.65
		end
		targetTheme = KazeUI.Themes.CustomWallpaper
	end

	targetTheme = targetTheme or KazeUI.Themes[themeName] or KazeUI.Themes.CustomWallpaper
	KazeUI.CurrentTheme = targetTheme
	KazeUI.BackgroundColor = targetTheme.Background
	
	KazeUI:SetBackgroundColor(targetTheme.Background)
	KazeUI:SetTransparency(KazeUI.BackgroundTransparency or 0.70)
	
	if themeName == "Obsidian" then
		KazeUI:SetGlow(Color3.fromRGB(255, 255, 255))
	end
	
	for _, inst in ipairs(KazeUI.TextElements) do
		if inst and inst.Parent then inst.TextColor3 = targetTheme.Text end
	end
	for _, inst in ipairs(KazeUI.MutedTextElements) do
		if inst and inst.Parent then
			inst.TextColor3 = targetTheme.MutedText
			if inst:IsA("TextBox") then inst.PlaceholderColor3 = targetTheme.MutedText end
		end
	end
	for _, inst in ipairs(KazeUI.BorderElements) do
		if inst and inst.Parent then inst.Color = targetTheme.Border end
	end

	local bgImgId = targetTheme.BackgroundImage or ""
	local bgImgTrans = targetTheme.BackgroundImageTransparency or 1
	local bgOverlayTrans = targetTheme.OverlayTransparency or 0.25
	local hasImage = (bgImgId ~= "") and (bgImgTrans < 1)

	for _, wp in ipairs(KazeUI.WallpaperElements) do
		if wp.ImageLabel and wp.ImageLabel.Parent then
			if hasImage then
				wp.ImageLabel.Image = FormatImage(bgImgId)
				PlayTrackedTween(wp.ImageLabel, TWEEN_SMOOTH, {ImageTransparency = bgImgTrans})
				PlayTrackedTween(wp.OverlayFrame, TWEEN_SMOOTH, {BackgroundTransparency = bgOverlayTrans})
			else
				PlayTrackedTween(wp.ImageLabel, TWEEN_SMOOTH, {ImageTransparency = 1})
				PlayTrackedTween(wp.OverlayFrame, TWEEN_SMOOTH, {BackgroundTransparency = 1})
			end
		end
	end
	
	for _, data in ipairs(KazeUI.ThemeCallbacks) do
		if data.Inst and data.Inst.Parent then pcall(data.Callback, targetTheme) end
	end
end

-- Glow loop with breathing effect
local function StartNeonLoop(target)
	if not target then return end
	local propName = pcall(function() return target.Color end) and "Color" or "BackgroundColor3"
	table.insert(KazeUI.GlowElements, {Target = target, Prop = propName})

	local function createTween()
		local tweenInfo = TweenInfo.new(2.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
		local h, s, v = Color3.toHSV(KazeUI.GlowColor)
		local targetColor = Color3.fromHSV(h, s * 0.85, math.clamp(v * 1.05, 0, 1))
		local tween = PlayTrackedTween(target, tweenInfo, {[propName] = targetColor})
		KazeUI.NeonTweens[target] = tween
	end
	target[propName] = KazeUI.GlowColor
	createTween()
end

local function StopNeonLoop(target)
	if not target then return end
	if KazeUI.NeonTweens[target] then
		KazeUI.NeonTweens[target]:Cancel()
		KazeUI.NeonTweens[target] = nil
	end
	for i = #KazeUI.GlowElements, 1, -1 do
		if KazeUI.GlowElements[i].Target == target then table.remove(KazeUI.GlowElements, i) end
	end
end

function KazeUI:SetGlow(color)
	KazeUI.GlowColor = color
	
	for _, data in ipairs(KazeUI.GlowElements) do
		local target = data.Target
		local propName = data.Prop
		if target and target.Parent then
			if KazeUI.NeonTweens[target] then KazeUI.NeonTweens[target]:Cancel() end
			target[propName] = color
			local tweenInfo = TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
			local h, s, v = Color3.toHSV(color)
			local targetColor = Color3.fromHSV(h, s * 0.9, 1)
			local newTween = PlayTrackedTween(target, tweenInfo, {[propName] = targetColor})
			KazeUI.NeonTweens[target] = newTween
		else
			KazeUI.NeonTweens[target] = nil
		end
	end
	
	for i = #KazeUI.GlowCallbacks, 1, -1 do
		local data = KazeUI.GlowCallbacks[i]
		if data.Inst and data.Inst.Parent then
			task.spawn(data.Callback, color)
		else
			table.remove(KazeUI.GlowCallbacks, i)
		end
	end
end

-- ==========================================================
-- ⭐ Highly Interactive Promise Notification Card (WindUI Style+)
-- ==========================================================
function KazeUI:Notify(config)
	config = config or {}
	local title = tostring(config.Title or "Notification")
	local content = tostring(config.Content or "")
	local duration = tonumber(config.Duration) or 3
	local titleColor = config.TitleColor or config.Color
	local isRGBTitle = config.RGBTitle or (titleColor == "RGB")
	
	local iconId = config.Icon and FormatImage(config.Icon) or ""
	local hasIcon = (iconId ~= "")
	local iconColor = config.IconColor or KazeUI.GlowColor

	local textPadding = hasIcon and 54 or 16
	local rightSafetyPadding = 36 
	local maxTextWidth = 320 - 24 - textPadding - rightSafetyPadding

	local titleSize = TextService:GetTextSize(title, 13, Enum.Font.GothamBold, Vector2.new(maxTextWidth, 1000))
	local contentSize = TextService:GetTextSize(content, 11, Enum.Font.Gotham, Vector2.new(maxTextWidth, 2000))

	local titleHeight = math.max(16, math.ceil(titleSize.Y))
	local contentHeight = math.max(14, math.ceil(contentSize.Y))
	
	local calculatedCardHeight = 12 + titleHeight + 4 + contentHeight + 14
	if config.Actions and #config.Actions > 0 then
		calculatedCardHeight = calculatedCardHeight + 34
	end
	local finalCardHeight = math.max(68, calculatedCardHeight)
	local finalHolderHeight = finalCardHeight + 20

	local notifHolder = Instance.new("Frame")
	notifHolder.Name = "NotifHolder"
	notifHolder.Size = UDim2.new(1, 0, 0, 0)
	notifHolder.BackgroundTransparency = 1
	notifHolder.BorderSizePixel = 0
	notifHolder.ClipsDescendants = true
	notifHolder.Parent = NotifContainer

	local notifFrame = Instance.new("Frame")
	notifFrame.Name = "NotifFrame"
	notifFrame.Size = UDim2.new(1, -24, 0, finalCardHeight)
	notifFrame.Position = UDim2.new(1.3, 0, 0, 10)
	notifFrame.BorderSizePixel = 0
	notifFrame.Parent = notifHolder
	
	Instance.new("UICorner", notifFrame).CornerRadius = UDim.new(0, 20)
	
	KazeUI:AddPanel(notifFrame, 0.04, false, true)
	notifFrame.BackgroundTransparency = 0.08 

	local shadow = Instance.new("Frame", notifFrame)
	shadow.Size = UDim2.new(1, 6, 1, 6)
	shadow.Position = UDim2.fromOffset(-3, -3)
	shadow.BackgroundTransparency = 1
	shadow.ZIndex = -1
	local shCorner = Instance.new("UICorner", shadow)
	shCorner.CornerRadius = UDim.new(0, 22)
	local shadowStroke = Instance.new("UIStroke", shadow)
	shadowStroke.Thickness = 3
	shadowStroke.Color = Color3.fromRGB(0, 0, 0)
	shadowStroke.Transparency = 0.8

	local stroke = Instance.new("UIStroke", notifFrame)
	stroke.Thickness = 1.2
	KazeUI:RegisterBorder(stroke)

	local iconLabel
	if hasIcon then
		iconLabel = Instance.new("ImageLabel", notifFrame)
		iconLabel.Name = "NotifIcon"
		iconLabel.Size = UDim2.fromOffset(24, 24)
		iconLabel.Position = UDim2.fromOffset(16, 16)
		iconLabel.BackgroundTransparency = 1
		iconLabel.Image = iconId
		iconLabel.ImageColor3 = iconColor
		iconLabel.ScaleType = Enum.ScaleType.Fit
	end

	local closeBtn = Instance.new("ImageButton")
	closeBtn.Name = "CloseButton"
	closeBtn.Size = UDim2.fromOffset(16, 16)
	closeBtn.Position = UDim2.new(1, -12, 0, 12)
	closeBtn.AnchorPoint = Vector2.new(1, 0)
	closeBtn.BackgroundTransparency = 1
	closeBtn.Image = "rbxassetid://10747384394"
	closeBtn.ImageTransparency = 0
	closeBtn.ZIndex = 10
	closeBtn.Parent = notifFrame
	KazeUI:OnThemeChanged(closeBtn, function(t) closeBtn.ImageColor3 = t.Text end)

	local titleLab = Instance.new("TextLabel", notifFrame)
	titleLab.Size = UDim2.new(0, maxTextWidth, 0, titleHeight)
	titleLab.Position = UDim2.fromOffset(textPadding, 12)
	titleLab.BackgroundTransparency = 1
	titleLab.Text = title
	titleLab.Font = Enum.Font.GothamBold
	titleLab.TextSize = 13
	titleLab.TextXAlignment = Enum.TextXAlignment.Left
	titleLab.TextWrapped = true

	if isRGBTitle then
		local connection
		connection = RunService.RenderStepped:Connect(function()
			if not titleLab or not titleLab.Parent then
				connection:Disconnect()
				return
			end
			local hue = (tick() % 4) / 4
			local rainbowColor = Color3.fromHSV(hue, 0.8, 1)
			titleLab.TextColor3 = rainbowColor
			if iconLabel then iconLabel.ImageColor3 = rainbowColor end
		end)
	elseif typeof(titleColor) == "Color3" then
		titleLab.TextColor3 = titleColor
	else
		KazeUI:RegisterText(titleLab, false)
	end

	local contentLab = Instance.new("TextLabel", notifFrame)
	contentLab.Size = UDim2.new(0, maxTextWidth, 0, contentHeight)
	contentLab.Position = UDim2.fromOffset(textPadding, 12 + titleHeight + 4)
	contentLab.BackgroundTransparency = 1
	contentLab.Text = content
	contentLab.Font = Enum.Font.Gotham
	contentLab.TextSize = 11
	contentLab.TextWrapped = true
	contentLab.TextXAlignment = Enum.TextXAlignment.Left
	KazeUI:RegisterText(contentLab, true)

	local progressTrack = Instance.new("Frame", notifFrame)
	progressTrack.Size = UDim2.new(1, -32, 0, 2.5)
	progressTrack.Position = UDim2.new(0, 16, 1, -6)
	progressTrack.BorderSizePixel = 0
	Instance.new("UICorner", progressTrack).CornerRadius = UDim.new(1, 0)
	KazeUI:OnThemeChanged(progressTrack, function(t) progressTrack.BackgroundColor3 = t.Border end)

	local progressBar = Instance.new("Frame", progressTrack)
	progressBar.Size = UDim2.new(1, 0, 1, 0)
	progressBar.BackgroundColor3 = KazeUI.GlowColor
	progressBar.BorderSizePixel = 0
	Instance.new("UICorner", progressBar).CornerRadius = UDim.new(1, 0)
	StartNeonLoop(progressBar)
	
	KazeUI:OnGlowChanged(progressBar, function(c) progressBar.BackgroundColor3 = c end)

	-- Actions Layout Injection if defined
	if config.Actions and #config.Actions > 0 then
		local actionArea = Instance.new("Frame", notifFrame)
		actionArea.Size = UDim2.new(1, -32, 0, 28)
		actionArea.Position = UDim2.new(0, 16, 1, -38)
		actionArea.BackgroundTransparency = 1
		
		local actLayout = Instance.new("UIListLayout", actionArea)
		actLayout.FillDirection = Enum.FillDirection.Horizontal
		actLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
		actLayout.Padding = UDim.new(0, 8)
		
		for _, act in ipairs(config.Actions) do
			local aBtn = Instance.new("TextButton", actionArea)
			aBtn.Size = UDim2.new(0, 75, 1, 0)
			aBtn.BorderSizePixel = 0
			aBtn.Text = act.Text or "Action"
			aBtn.Font = Enum.Font.GothamBold
			aBtn.TextSize = 10
			Instance.new("UICorner", aBtn).CornerRadius = UDim.new(0, 8)
			KazeUI:AddPanel(aBtn, 0.06)
			KazeUI:RegisterText(aBtn, false)
			
			aBtn.MouseButton1Click:Connect(function()
				if act.Callback then act.Callback() end
			end)
		end
	end

	PlayTrackedTween(notifHolder, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, finalHolderHeight)})
	PlayTrackedTween(notifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 12, 0, 10)})

	local isDismissing = false
	local dismissTweenCon
	
	local function dismiss()
		if isDismissing then return end
		isDismissing = true
		
		local outTween = PlayTrackedTween(notifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(1.3, 0, 0, 10)})
		
		dismissTweenCon = outTween.Completed:Connect(function()
			dismissTweenCon:Disconnect()
			local shrinkTween = PlayTrackedTween(notifHolder, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 0)})
			shrinkTween.Completed:Connect(function()
				StopNeonLoop(progressBar)
				notifHolder:Destroy()
			end)
		end)
	end

	closeBtn.MouseEnter:Connect(function()
		PlayTrackedTween(closeBtn, TWEEN_FAST, {ImageTransparency = 0.2, Size = UDim2.fromOffset(18, 18), Position = UDim2.new(1, -11, 0, 11)})
	end)
	closeBtn.MouseLeave:Connect(function()
		PlayTrackedTween(closeBtn, TWEEN_FAST, {ImageTransparency = 0, Size = UDim2.fromOffset(16, 16), Position = UDim2.new(1, -12, 0, 12)})
	end)
	closeBtn.MouseButton1Down:Connect(function()
		PlayTrackedTween(closeBtn, TWEEN_FAST, {Size = UDim2.fromOffset(14, 14), Position = UDim2.new(1, -13, 0, 13)})
	end)
	closeBtn.MouseButton1Click:Connect(dismiss)

	local autoThread = task.spawn(function()
		PlayTrackedTween(progressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)})
		task.wait(duration)
		if not isDismissing then
			dismiss()
		end
	end)
	
	notifHolder.Destroying:Connect(function()
		task.cancel(autoThread)
		if dismissTweenCon then dismissTweenCon:Disconnect() end
	end)

	-- Return Updatable Interface (WindUI Style loader support)
	return {
		Update = function(self, newTitle, newContent, newProgress)
			if newTitle then titleLab.Text = newTitle end
			if newContent then contentLab.Text = newContent end
			if newProgress then
				local progressVal = math.clamp(newProgress, 0, 1)
				PlayTrackedTween(progressBar, TWEEN_FAST, {Size = UDim2.fromScale(progressVal, 1)})
			end
		end,
		Dismiss = dismiss
	}
end

-- ==========================================================
-- ⭐ Robust Serialization Configuration System
-- ==========================================================
function KazeUI:SaveConfig(name)
	if not name or name == "" then
		KazeUI:Notify({Title = "Config System", Content = "Config name cannot be empty.", Duration = 3})
		return
	end
	
	local data = {
		Theme = KazeUI.CurrentTheme.Name,
		Glow = KazeUI.GlowColor:ToHex(),
		Transparency = KazeUI.BackgroundTransparency,
		Flags = {}
	}
	
	for flag, obj in pairs(KazeUI.Flags) do 
		data.Flags[flag] = obj.Get() 
	end
	
	if writefile then
		local success, encoded = pcall(function() return HttpService:JSONEncode(data) end)
		if success then
			local folder = KazeUI.AuthorName
			if makefolder then
				pcall(function()
					if isfolder and not isfolder(folder) then makefolder(folder)
					elseif not isfolder then makefolder(folder) end
				end)
			end
			
			writefile(folder .. "/" .. name .. ".json", encoded)
			KazeUI:Notify({Title = "Config Saved", Content = "Successfully saved " .. name, Duration = 3})
		else
			KazeUI:Notify({Title = "Config Error", Content = "Failed to encode settings.", Duration = 3})
		end
	else
		KazeUI:Notify({Title = "Config Error", Content = "Executor doesn't support file writes.", Duration = 3})
	end
end

function KazeUI:LoadConfig(name)
	if not name or name == "" then return end
	local folder = KazeUI.AuthorName
	local filepath = folder .. "/" .. name .. ".json"
	
	if isfile and isfile(filepath) then
		local s, content = pcall(readfile, filepath)
		if s and content then
			local s2, decoded = pcall(function() return HttpService:JSONDecode(content) end)
			if s2 and type(decoded) == "table" then
				if decoded.Theme then KazeUI:SetTheme(decoded.Theme) end
				if decoded.Glow then KazeUI:SetGlow(Color3.fromHex(decoded.Glow)) end
				if decoded.Transparency then KazeUI:SetTransparency(decoded.Transparency) end
				
				if decoded.Flags then
					for flag, val in pairs(decoded.Flags) do
						local flagObj = KazeUI.Flags[flag]
						if flagObj then
							pcall(flagObj.Set, val)
						end
					end
				end
				KazeUI:Notify({Title = "Config Loaded", Content = "Successfully loaded " .. name, Duration = 3})
			end
		end
	end
end

local function ToggleScrollingAncestors(element, state)
	local current = element.Parent
	while current do
		if current:IsA("ScrollingFrame") then current.ScrollingEnabled = state end
		current = current.Parent
	end
end

-- =========================================================
-- Elegant Bubble-First Components (Figma / iMessage design)
-- =========================================================

local function CreateDropdown(parentFrame, title, options, defaultOption, callback, isMulti, flag, locked)
	title = tostring(title or "Dropdown")
	options = type(options) == "table" and options or {}
	local isOpen = false
	local isLockedState = locked or false

	local selectedSingle = ""
	local selectedMulti = {}

	if isMulti then
		if type(defaultOption) == "table" then
			for _, v in ipairs(defaultOption) do selectedMulti[tostring(v)] = true end
		elseif defaultOption then
			selectedMulti[tostring(defaultOption)] = true
		end
	else
		selectedSingle = defaultOption or (options[1] or "")
	end

	local wrapper = Instance.new("Frame")
	wrapper.Name = "DropdownWrapper"
	wrapper.Size = UDim2.new(1, 0, 0, 0)
	wrapper.BackgroundTransparency = 1
	wrapper.Parent = parentFrame
	wrapper.AutomaticSize = Enum.AutomaticSize.Y

	local dropFrame = Instance.new("Frame")
	dropFrame.Name = "DropdownFrame"
	dropFrame.AnchorPoint = Vector2.new(0.5, 0)
	dropFrame.Position = UDim2.new(0.5, 0, 0, 3)
	dropFrame.Size = UDim2.new(0.95, 0, 0, 0)
	dropFrame.BorderSizePixel = 0
	dropFrame.AutomaticSize = Enum.AutomaticSize.Y
	
	Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 14)
	dropFrame.Parent = wrapper
	KazeUI:AddPanel(dropFrame, 0.02)

	local padding = Instance.new("UIPadding", dropFrame)
	padding.PaddingTop = UDim.new(0, 5)
	padding.PaddingBottom = UDim.new(0, 5)

	local boxStroke = Instance.new("UIStroke", dropFrame)
	boxStroke.Thickness = 1.2
	boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	KazeUI:RegisterBorder(boxStroke)

	local layout = Instance.new("UIListLayout", dropFrame)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.Padding = UDim.new(0, 5)

	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, -20, 0, 38)
	header.BackgroundTransparency = 1
	header.LayoutOrder = 1
	header.Parent = dropFrame

	local titleLabel = Instance.new("TextLabel", header)
	titleLabel.Size = UDim2.new(0.55, -10, 1, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 13
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextTruncate = Enum.TextTruncate.AtEnd 
	KazeUI:RegisterText(titleLabel, false)

	local arrowIcon = Instance.new("ImageLabel", header)
	arrowIcon.AnchorPoint = Vector2.new(1, 0.5)
	arrowIcon.Position = UDim2.new(1, 0, 0.5, 0)
	arrowIcon.Size = UDim2.fromOffset(16, 16)
	arrowIcon.BackgroundTransparency = 1
	arrowIcon.Image = "rbxassetid://10723415693"
	arrowIcon.Rotation = 0
	KazeUI:OnThemeChanged(arrowIcon, function(t) arrowIcon.ImageColor3 = t.MutedText end)

	local initialText = ""
	if isMulti then
		local count = 0
		local firstVal = ""
		for k, v in pairs(selectedMulti) do
			if v then 
				count = count + 1 
				if firstVal == "" then firstVal = k end
			end
		end
		if count == 0 then initialText = "None"
		elseif count == 1 then initialText = firstVal
		else initialText = count .. " Selected" end
	else
		initialText = tostring(selectedSingle)
	end

	local selectedLabel = Instance.new("TextLabel", header)
	selectedLabel.Size = UDim2.new(0.40, -14, 1, 0)
	selectedLabel.Position = UDim2.new(0.55, 0, 0, 0)
	selectedLabel.BackgroundTransparency = 1
	selectedLabel.Font = Enum.Font.Gotham
	selectedLabel.TextSize = 11
	selectedLabel.TextXAlignment = Enum.TextXAlignment.Right
	selectedLabel.TextTruncate = Enum.TextTruncate.AtEnd 
	selectedLabel.Text = initialText 
	KazeUI:RegisterText(selectedLabel, true)

	local clickBtn = Instance.new("TextButton", header)
	clickBtn.Size = UDim2.fromScale(1, 1)
	clickBtn.BackgroundTransparency = 1
	clickBtn.Text = ""

	local function UpdateHeaderVisual()
		if isMulti then
			local count = 0
			local firstVal = ""
			for k, v in pairs(selectedMulti) do
				if v then 
					count = count + 1 
					if firstVal == "" then firstVal = k end
				end
			end
			if count == 0 then selectedLabel.Text = "None"
			elseif count == 1 then selectedLabel.Text = firstVal
			else selectedLabel.Text = count .. " Selected" end
		else
			selectedLabel.Text = tostring(selectedSingle)
		end
	end

	local searchWrapper = Instance.new("Frame")
	searchWrapper.Size = UDim2.new(1, -20, 0, 32)
	searchWrapper.BackgroundTransparency = 1
	searchWrapper.LayoutOrder = 2
	searchWrapper.Visible = false
	searchWrapper.Parent = dropFrame
	Instance.new("UICorner", searchWrapper).CornerRadius = UDim.new(0, 10)
	KazeUI:AddPanel(searchWrapper, -0.01)

	local searchStroke = Instance.new("UIStroke", searchWrapper)
	searchStroke.Thickness = 1
	KazeUI:RegisterBorder(searchStroke)

	local searchBox = Instance.new("TextBox")
	searchBox.Size = UDim2.new(1, -20, 1, 0) 
	searchBox.Position = UDim2.new(0, 10, 0, 0)
	searchBox.BackgroundTransparency = 1
	searchBox.BorderSizePixel = 0
	searchBox.PlaceholderText = "Search options..."
	searchBox.Text = ""
	searchBox.Font = Enum.Font.Gotham 
	searchBox.TextSize = 11
	searchBox.TextXAlignment = Enum.TextXAlignment.Left
	searchBox.ClearTextOnFocus = false
	searchBox.ClipsDescendants = true
	searchBox.TextWrapped = false
	searchBox.Parent = searchWrapper
	KazeUI:RegisterText(searchBox, false)
	KazeUI:OnThemeChanged(searchBox, function(t) searchBox.PlaceholderColor3 = t.MutedText end)

	searchBox.Focused:Connect(function() 
		if isLockedState or activeDialogsCount > 0 then
			searchBox:ReleaseFocus()
			return
		end
		PlayTrackedTween(searchStroke, TWEEN_FAST, {Color = KazeUI.GlowColor})
	end)
	searchBox.FocusLost:Connect(function() 
		PlayTrackedTween(searchStroke, TWEEN_FAST, {Color = KazeUI.CurrentTheme.Border})
	end)
	
	local divider = Instance.new("Frame")
	divider.Size = UDim2.new(1, -20, 0, 1)
	divider.BorderSizePixel = 0
	divider.LayoutOrder = 3
	divider.Visible = false
	divider.Parent = dropFrame
	KazeUI:OnThemeChanged(divider, function(t) divider.BackgroundColor3 = t.Border end)

	local listContainer = Instance.new("ScrollingFrame")
	listContainer.Size = UDim2.new(1, -20, 0, 0)
	listContainer.BackgroundTransparency = 1
	listContainer.BorderSizePixel = 0
	listContainer.LayoutOrder = 4
	listContainer.Visible = false
	listContainer.ScrollBarThickness = 3
	listContainer.ScrollBarImageColor3 = Color3.fromRGB(40, 40, 45)
	listContainer.Parent = dropFrame

	listContainer.MouseEnter:Connect(function() 
		if isLockedState or activeDialogsCount > 0 then return end
		ToggleScrollingAncestors(dropFrame, false) 
	end)
	listContainer.MouseLeave:Connect(function() 
		ToggleScrollingAncestors(dropFrame, true) 
	end)

	local listLayout = Instance.new("UIListLayout", listContainer)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 4)

	local optionItems = {}

	local function CalcHeight()
		local count = 0
		for _, item in ipairs(optionItems) do if item.Btn.Visible then count = count + 1 end end
		local targetH = math.min(count, 5) * 34
		PlayTrackedTween(listContainer, TWEEN_FAST, {Size = UDim2.new(1, -20, 0, targetH)})
		listContainer.CanvasSize = UDim2.new(0, 0, 0, count * 34)
	end

	local function CloseDropdown()
		isOpen = false
		searchBox.Text = "" 
		searchWrapper.Visible = false
		divider.Visible = false
		listContainer.Visible = false
		PlayTrackedTween(arrowIcon, TWEEN_SPRING, {Rotation = 0})
		PlayTrackedTween(boxStroke, TWEEN_FAST, {Color = KazeUI.CurrentTheme.Border})
	end

	local function Refresh(newOptions)
		for _, item in ipairs(optionItems) do item.Btn:Destroy() end
		table.clear(optionItems)

		options = type(newOptions) == "table" and newOptions or {}
		for _, opt in ipairs(options) do
			local optStr = tostring(opt)
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, -4, 0, 30)
			btn.BorderSizePixel = 0
			btn.Text = "  " .. optStr
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 11
			btn.TextXAlignment = Enum.TextXAlignment.Left
			btn.Parent = listContainer
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
			
			KazeUI:AddPanel(btn, 0.03, true)

			local indicator
			if isMulti then
				indicator = Instance.new("Frame", btn)
				indicator.AnchorPoint = Vector2.new(1, 0.5)
				indicator.Position = UDim2.new(1, -10, 0.5, 0)
				indicator.Size = UDim2.fromOffset(12, 12)
				local indStroke = Instance.new("UIStroke", indicator)
				KazeUI:RegisterBorder(indStroke)
				Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 4)
				KazeUI:AddPanel(indicator, 0.04)
			end
            
			local isHovering = false
			local currentBgTween, currentTxtTween

			local function UpdateVisuals(instant)
				local active = isMulti and selectedMulti[optStr] or (not isMulti and selectedSingle == optStr)
				
				local targetBg = active and KazeUI.GetColor(0.06) or KazeUI.GetColor(0.03)
				local targetTxt = active and KazeUI.CurrentTheme.Text or KazeUI.CurrentTheme.MutedText
				local indTargetBg = active and KazeUI.GlowColor or KazeUI.GetColor(0.03)
				
				if isHovering then
					targetBg = KazeUI.GetColor(0.08)
					targetTxt = KazeUI.CurrentTheme.Text
				end

				if currentBgTween then currentBgTween:Cancel() currentBgTween = nil end
				if currentTxtTween then currentTxtTween:Cancel() currentTxtTween = nil end

				if instant then
					btn.BackgroundColor3 = targetBg
					btn.TextColor3 = targetTxt
					if isMulti and indicator then indicator.BackgroundColor3 = indTargetBg end
				else
					currentBgTween = PlayTrackedTween(btn, TWEEN_FAST, {BackgroundColor3 = targetBg})
					currentTxtTween = PlayTrackedTween(btn, TWEEN_FAST, {TextColor3 = targetTxt})
					
					if isMulti and indicator then
						PlayTrackedTween(indicator, TWEEN_FAST, {BackgroundColor3 = indTargetBg})
					end
				end
			end
			UpdateVisuals(true)

			KazeUI:OnThemeChanged(btn, function()
				UpdateVisuals(true)
			end)

			btn.MouseEnter:Connect(function() 
				if isLockedState or activeDialogsCount > 0 then return end
				isHovering = true
				UpdateVisuals(false)
			end)
			btn.MouseLeave:Connect(function()
				isHovering = false
				UpdateVisuals(false) 
			end)

			btn.MouseButton1Click:Connect(function()
				if isLockedState or activeDialogsCount > 0 then return end
				PlayTrackedTween(btn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true), {Size = UDim2.new(1, -8, 0, 28)})

				if isMulti then
					selectedMulti[optStr] = not selectedMulti[optStr]
					UpdateVisuals(false)
					UpdateHeaderVisual()
					if type(callback) == "function" then
						local ret = {}
						for k,v in pairs(selectedMulti) do if v then table.insert(ret, k) end end
						task.spawn(callback, ret)
					end
				else
					selectedSingle = optStr
					UpdateHeaderVisual()
					CloseDropdown()
					for _, item in ipairs(optionItems) do item.Update(false) end
					if type(callback) == "function" then task.spawn(callback, selectedSingle) end
				end
			end)

			table.insert(optionItems, { Btn = btn, Text = optStr, Update = function(instant) UpdateVisuals(instant) end })
			
			KazeUI:OnGlowChanged(btn, function() UpdateVisuals(true) end)
		end
		CalcHeight()
	end

	Refresh(options)

	searchBox:GetPropertyChangedSignal("Text"):Connect(function()
		if isLockedState or activeDialogsCount > 0 then return end
		local q = string.lower(searchBox.Text)
		for _, item in ipairs(optionItems) do
			item.Btn.Visible = (q == "" or string.find(string.lower(item.Text), q, 1, true)) ~= nil
		end
		CalcHeight()
	end)

	clickBtn.MouseButton1Click:Connect(function()
		if isLockedState or activeDialogsCount > 0 then return end
		isOpen = not isOpen
		if isOpen then
			searchWrapper.Visible = true
			divider.Visible = true
			listContainer.Visible = true
			CalcHeight()
			PlayTrackedTween(arrowIcon, TWEEN_SPRING, {Rotation = 180})
			PlayTrackedTween(boxStroke, TWEEN_FAST, {Color = KazeUI.GlowColor})
		else
			CloseDropdown()
		end
	end)
	
	KazeUI:OnGlowChanged(boxStroke, function(c)
		if isOpen then boxStroke.Color = c end
	end)

	RegisterFlag(flag, function()
		if isMulti then
			local ret = {}
			for k,v in pairs(selectedMulti) do if v then table.insert(ret, k) end end
			return ret
		end
		return selectedSingle 
	end, function(val)
		if isMulti then 
			selectedMulti = {}
			if type(val) == "table" then
				for _, v in ipairs(val) do selectedMulti[tostring(v)] = true end
			end
		else 
			selectedSingle = tostring(val)
		end
		UpdateHeaderVisual()
		Refresh(options)
		if typeof(callback) == "function" then
			if isMulti then
				local ret = {}
				for k,v in pairs(selectedMulti) do if v then table.insert(ret, k) end end
				task.spawn(callback, ret)
			else
				task.spawn(callback, selectedSingle)
			end
		end
	end, {Type = "Dropdown", GetOptions = function() return options end})

	local lockCtrl = ApplyLock(dropFrame, locked, wrapper, UDim2.new(0.95, 0, 1, -3), UDim2.new(0.5, 0, 0, 3), Vector2.new(0.5, 0))

	return {
		Wrapper = wrapper,
		Frame = dropFrame,
		Refresh = function(self, newOpts) Refresh(newOpts) end,
		GetValue = function() 
			if isMulti then
				local ret = {}
				for k,v in pairs(selectedMulti) do if v then table.insert(ret, k) end end
				return ret
			end
			return selectedSingle 
		end,
		SetText = function(self, newTitle) titleLabel.Text = newTitle end,
		SetLocked = function(self, state)
			isLockedState = state
			lockCtrl:SetLocked(state)
		end
	}
end

local function CreateParagraph(parentFrame, title, body)
	title = tostring(title or "")
	body = tostring(body or "")
	
	local measuredWidth = 598 * 0.92
	if parentFrame and parentFrame.AbsoluteSize and parentFrame.AbsoluteSize.X > 0 then measuredWidth = parentFrame.AbsoluteSize.X * 0.95 end
	
	local titleHeight = 0
	if title ~= " " then
		local ts = TextService:GetTextSize(title, 13, Enum.Font.GothamBold, Vector2.new(measuredWidth - 28, 1000))
		titleHeight = math.max(18, math.ceil(ts.Y))
	end
	
	local bodySize = TextService:GetTextSize(body, 12, Enum.Font.Gotham, Vector2.new(measuredWidth - 28, 2000))
	local bodyHeight = math.ceil(bodySize.Y)
	local totalHeight = 10 + titleHeight + 3 + bodyHeight + 10
	
	local wrapper = Instance.new("Frame")
	wrapper.Size = UDim2.new(1, 0, 0, 0)
	wrapper.BackgroundTransparency = 1
	wrapper.Parent = parentFrame
	wrapper.AutomaticSize = Enum.AutomaticSize.Y
	
	local paraFrame = Instance.new("Frame")
	paraFrame.AnchorPoint = Vector2.new(0.5, 0)
	paraFrame.Position = UDim2.new(0.5, 0, 0, 3)
	paraFrame.Size = UDim2.new(0.95, 0, 0, totalHeight)
	paraFrame.BorderSizePixel = 0
	
	Instance.new("UICorner", paraFrame).CornerRadius = UDim.new(0, 20)
	paraFrame.Parent = wrapper
	KazeUI:AddPanel(paraFrame, 0.01)
	
	local paraStroke = Instance.new("UIStroke", paraFrame)
	paraStroke.Thickness = 1.2
	paraStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	KazeUI:RegisterBorder(paraStroke)
	
	local inner = Instance.new("Frame", paraFrame)
	inner.Size = UDim2.new(1, -24, 1, -16)
	inner.Position = UDim2.fromOffset(12, 8)
	inner.BackgroundTransparency = 1
	
	local ptitleLabel
	if title ~= " " then
		ptitleLabel = Instance.new("TextLabel", inner)
		ptitleLabel.Size = UDim2.new(1, 0, 0, titleHeight)
		ptitleLabel.BackgroundTransparency = 1
		ptitleLabel.Text = title
		ptitleLabel.Font = Enum.Font.GothamBold
		ptitleLabel.TextSize = 13
		ptitleLabel.TextXAlignment = Enum.TextXAlignment.Left
		ptitleLabel.TextWrapped = true
		KazeUI:RegisterText(ptitleLabel, false)
	end
	
	local bodyLabel = Instance.new("TextLabel", inner)
	bodyLabel.Size = UDim2.new(1, 0, 0, bodyHeight)
	bodyLabel.Position = UDim2.fromOffset(0, titleHeight + 3)
	bodyLabel.BackgroundTransparency = 1
	bodyLabel.Text = body
	bodyLabel.Font = Enum.Font.Gotham
	bodyLabel.TextSize = 11
	bodyLabel.TextWrapped = true
	bodyLabel.TextXAlignment = Enum.TextXAlignment.Left
	bodyLabel.TextYAlignment = Enum.TextYAlignment.Top
	KazeUI:RegisterText(bodyLabel, true)
	
	return { 
		Wrapper = wrapper, 
		Frame = paraFrame,
		SetText = function(self, newTitle, newBody)
			if ptitleLabel and newTitle then ptitleLabel.Text = newTitle end
			if bodyLabel and newBody then bodyLabel.Text = newBody end
		end
	}
end

local function CreateClickableParagraph(parentFrame, title, body, callback, locked)
	title = tostring(title or "Button")
	body = tostring(body or "")
	local isLockedState = locked or false
	
	local measuredWidth = 598 * 0.92
	if parentFrame and parentFrame.AbsoluteSize and parentFrame.AbsoluteSize.X > 0 then measuredWidth = parentFrame.AbsoluteSize.X * 0.95 end
	local textContainerWidth = measuredWidth - 28 - 42
	
	local titleHeight = 0
	if title ~= " " and title ~= "" then
		local ts = TextService:GetTextSize(title, 13, Enum.Font.GothamBold, Vector2.new(textContainerWidth, 1000))
		titleHeight = math.max(18, math.ceil(ts.Y))
	end
	
	local bodyHeight = 0
	if body ~= "" then
		local bodySize = TextService:GetTextSize(body, 12, Enum.Font.Gotham, Vector2.new(textContainerWidth, 2000))
		bodyHeight = math.ceil(bodySize.Y)
	end
	
	local totalHeight = 10 + titleHeight + (body ~= "" and 3 or 0) + bodyHeight + 10
	
	local wrapper = Instance.new("Frame")
	wrapper.Size = UDim2.new(1, 0, 0, 0)
	wrapper.BackgroundTransparency = 1
	wrapper.Parent = parentFrame
	wrapper.AutomaticSize = Enum.AutomaticSize.Y
	
	local paraFrame = Instance.new("Frame")
	paraFrame.AnchorPoint = Vector2.new(0.5, 0)
	paraFrame.Position = UDim2.new(0.5, 0, 0, 3)
	paraFrame.Size = UDim2.new(0.95, 0, 0, totalHeight)
	paraFrame.BorderSizePixel = 0
	
	Instance.new("UICorner", paraFrame).CornerRadius = UDim.new(0, 14)
	paraFrame.Parent = wrapper
	KazeUI:AddPanel(paraFrame, 0.02)
	
	local paraStroke = Instance.new("UIStroke", paraFrame)
	paraStroke.Thickness = 1.2
	paraStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	KazeUI:RegisterBorder(paraStroke)
	
	local inner = Instance.new("Frame", paraFrame)
	inner.Size = UDim2.new(1, -20, 1, -16)
	inner.Position = UDim2.fromOffset(10, 8)
	inner.BackgroundTransparency = 1
	
	local rightIcon = Instance.new("ImageLabel")
	rightIcon.AnchorPoint = Vector2.new(1, 0.5)
	rightIcon.Position = UDim2.new(1, -10, 0.5, 0) 
	rightIcon.Size = UDim2.fromOffset(18, 18)
	rightIcon.BackgroundTransparency = 1
	rightIcon.Image = "rbxassetid://107150227368485" 
	rightIcon.ScaleType = Enum.ScaleType.Fit
	rightIcon.Parent = inner
	
	local isHovering = false
	KazeUI:OnThemeChanged(rightIcon, function(t)
		if not isHovering then rightIcon.ImageColor3 = t.MutedText end
	end)
	
	local ptitleLabel
	if title ~= " " and title ~= "" then
		ptitleLabel = Instance.new("TextLabel", inner)
		ptitleLabel.Size = UDim2.new(1, -34, 0, titleHeight)
		ptitleLabel.BackgroundTransparency = 1
		ptitleLabel.Text = title
		ptitleLabel.Font = Enum.Font.GothamBold
		ptitleLabel.TextSize = 13 
		ptitleLabel.TextWrapped = true
		ptitleLabel.TextXAlignment = Enum.TextXAlignment.Left
		if body == "" then ptitleLabel.AnchorPoint = Vector2.new(0, 0.5); ptitleLabel.Position = UDim2.new(0, 0, 0.5, 0) end
		KazeUI:RegisterText(ptitleLabel, false)
	end
	
	local bodyLabel
	if body ~= "" then
		bodyLabel = Instance.new("TextLabel", inner)
		bodyLabel.Size = UDim2.new(1, -34, 0, bodyHeight)
		bodyLabel.Position = UDim2.fromOffset(0, titleHeight + 3)
		bodyLabel.BackgroundTransparency = 1
		bodyLabel.Text = body
		bodyLabel.Font = Enum.Font.Gotham
		bodyLabel.TextSize = 11
		bodyLabel.TextWrapped = true
		bodyLabel.TextXAlignment = Enum.TextXAlignment.Left
		bodyLabel.TextYAlignment = Enum.TextYAlignment.Top
		KazeUI:RegisterText(bodyLabel, true)
	end

	local clickDetector = Instance.new("TextButton")
	clickDetector.Size = UDim2.fromScale(1, 1)
	clickDetector.BackgroundTransparency = 1
	clickDetector.Text = ""
	clickDetector.ZIndex = 10
	clickDetector.Parent = paraFrame

	clickDetector.MouseEnter:Connect(function()
		if isLockedState or activeDialogsCount > 0 then return end
		isHovering = true
		PlayTrackedTween(paraFrame, TWEEN_FAST, {BackgroundColor3 = KazeUI.GetColor(0.04)})
		PlayTrackedTween(paraStroke, TWEEN_FAST, {Color = KazeUI.GlowColor})
		PlayTrackedTween(rightIcon, TWEEN_FAST, {ImageColor3 = Color3.fromRGB(255, 255, 255), Position = UDim2.new(1, -8, 0.5, 0)})
	end)
	clickDetector.MouseLeave:Connect(function()
		isHovering = false
		PlayTrackedTween(paraFrame, TWEEN_FAST, {BackgroundColor3 = KazeUI.GetColor(0.02)})
		PlayTrackedTween(paraStroke, TWEEN_FAST, {Color = KazeUI.CurrentTheme.Border})
		PlayTrackedTween(rightIcon, TWEEN_FAST, {ImageColor3 = KazeUI.CurrentTheme.MutedText, Position = UDim2.new(1, -10, 0.5, 0)})
	end)
	
	clickDetector.MouseButton1Down:Connect(function()
		if isLockedState or activeDialogsCount > 0 then return end
		PlayTrackedTween(paraFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { 
			Size = UDim2.new(0.93, 0, 0, totalHeight - 2), 
			Position = UDim2.new(0.5, 0, 0, 4) 
		})
	end)
	clickDetector.MouseButton1Up:Connect(function()
		if isLockedState or activeDialogsCount > 0 then return end
		PlayTrackedTween(paraFrame, TWEEN_SPRING, { 
			Size = UDim2.new(0.95, 0, 0, totalHeight), 
			Position = UDim2.new(0.5, 0, 0, 3) 
		})
		if typeof(callback) == "function" then task.spawn(callback) end
	end)
	
	KazeUI:OnGlowChanged(paraStroke, function(c)
		if isHovering then paraStroke.Color = c end
	end)
	
	local lockCtrl = ApplyLock(paraFrame, locked, wrapper, UDim2.new(0.95, 0, 1, -3), UDim2.new(0.5, 0, 0, 3), Vector2.new(0.5, 0))

	return { 
		Wrapper = wrapper, 
		Frame = paraFrame,
		SetText = function(self, newTitle, newBody)
			if ptitleLabel and newTitle then ptitleLabel.Text = newTitle end
			if bodyLabel and newBody then bodyLabel.Text = newBody end
		end,
		SetLocked = function(self, state)
			isLockedState = state
			lockCtrl:SetLocked(state)
		end
	}
end

local function CreateToggleSwitch(parentFrame, title, body, defaultState, callback, flag, locked)
	title = tostring(title or "Toggle Switch")
	body = tostring(body or "")
	local state = defaultState or false
	local isLockedState = locked or false
	
	local measuredWidth = 598 * 0.92
	if parentFrame and parentFrame.AbsoluteSize and parentFrame.AbsoluteSize.X > 0 then measuredWidth = parentFrame.AbsoluteSize.X * 0.95 end
	local textContainerWidth = measuredWidth - 28 - 55
	
	local titleHeight = 0
	if title ~= " " then
		local ts = TextService:GetTextSize(title, 13, Enum.Font.GothamBold, Vector2.new(textContainerWidth, 1000))
		titleHeight = math.max(18, math.ceil(ts.Y))
	end
	
	local bodyHeight = 0
	if body ~= "" then
		local bodySize = TextService:GetTextSize(body, 12, Enum.Font.Gotham, Vector2.new(textContainerWidth, 2000))
		bodyHeight = math.ceil(bodySize.Y)
	end
	
	local totalHeight = 10 + titleHeight + (body ~= "" and 3 or 0) + bodyHeight + 10
	
	local wrapper = Instance.new("Frame")
	wrapper.Size = UDim2.new(1, 0, 0, 0)
	wrapper.BackgroundTransparency = 1
	wrapper.Parent = parentFrame
	wrapper.AutomaticSize = Enum.AutomaticSize.Y
	
	local paraFrame = Instance.new("Frame")
	paraFrame.AnchorPoint = Vector2.new(0.5, 0)
	paraFrame.Position = UDim2.new(0.5, 0, 0, 3)
	paraFrame.Size = UDim2.new(0.95, 0, 0, totalHeight)
	paraFrame.BorderSizePixel = 0
	
	Instance.new("UICorner", paraFrame).CornerRadius = UDim.new(0, 14)
	paraFrame.Parent = wrapper
	KazeUI:AddPanel(paraFrame, 0.02)
	
	local paraStroke = Instance.new("UIStroke", paraFrame)
	paraStroke.Thickness = 1.2
	paraStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	KazeUI:RegisterBorder(paraStroke)
	
	local inner = Instance.new("Frame", paraFrame)
	inner.Size = UDim2.new(1, -20, 1, -16)
	inner.Position = UDim2.fromOffset(10, 8)
	inner.BackgroundTransparency = 1
	
	local switchContainer = Instance.new("Frame")
	switchContainer.AnchorPoint = Vector2.new(1, 0.5)
	switchContainer.Position = UDim2.new(1, -4, 0.5, 0)
	switchContainer.Size = UDim2.fromOffset(38, 20)
	switchContainer.BorderSizePixel = 0
	Instance.new("UICorner", switchContainer).CornerRadius = UDim.new(1, 0)
	switchContainer.Parent = inner
	
	local switchIndicator = Instance.new("Frame")
	switchIndicator.AnchorPoint = Vector2.new(0, 0.5)
	switchIndicator.Position = state and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
	switchIndicator.Size = UDim2.fromOffset(16, 16)
	switchIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	switchIndicator.BorderSizePixel = 0
	Instance.new("UICorner", switchIndicator).CornerRadius = UDim.new(1, 0)
	switchIndicator.Parent = switchContainer
	
	local ptitleLabel
	if title ~= " " then
		ptitleLabel = Instance.new("TextLabel", inner)
		ptitleLabel.Size = UDim2.new(1, -48, 0, titleHeight)
		ptitleLabel.BackgroundTransparency = 1
		ptitleLabel.Text = title
		ptitleLabel.Font = Enum.Font.GothamBold
		ptitleLabel.TextSize = 13
		ptitleLabel.TextWrapped = true
		ptitleLabel.TextXAlignment = Enum.TextXAlignment.Left
		if body == "" then ptitleLabel.AnchorPoint = Vector2.new(0, 0.5); ptitleLabel.Position = UDim2.new(0, 0, 0.5, 0) end
		KazeUI:RegisterText(ptitleLabel, false)
	end
	
	local bodyLabel
	if body ~= "" then
		bodyLabel = Instance.new("TextLabel", inner)
		bodyLabel.Size = UDim2.new(1, -48, 0, bodyHeight)
		bodyLabel.Position = UDim2.fromOffset(0, titleHeight + 3)
		bodyLabel.BackgroundTransparency = 1
		bodyLabel.Text = body
		bodyLabel.Font = Enum.Font.Gotham
		bodyLabel.TextSize = 11
		bodyLabel.TextWrapped = true
		bodyLabel.TextXAlignment = Enum.TextXAlignment.Left
		bodyLabel.TextYAlignment = Enum.TextYAlignment.Top
		KazeUI:RegisterText(bodyLabel, true)
	end

	local clickDetector = Instance.new("TextButton")
	clickDetector.Size = UDim2.fromScale(1, 1)
	clickDetector.BackgroundTransparency = 1
	clickDetector.Text = ""
	clickDetector.ZIndex = 10
	clickDetector.Parent = paraFrame

	local function setToggleState(newState, instant)
		state = newState
		local targetPos = state and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
		local targetBg = state and KazeUI.GlowColor or KazeUI.GetColor(0.08)
		
		if instant then
			switchIndicator.Position = targetPos
			switchContainer.BackgroundColor3 = targetBg
		else
			PlayTrackedTween(switchIndicator, TWEEN_SPRING, {Position = targetPos})
			PlayTrackedTween(switchContainer, TWEEN_FAST, {BackgroundColor3 = targetBg})
		end
	end
	setToggleState(state, true)

	KazeUI:OnThemeChanged(switchContainer, function()
		setToggleState(state, true)
	end)

	local isHovering = false

	clickDetector.MouseEnter:Connect(function()
		if isLockedState or activeDialogsCount > 0 then return end
		isHovering = true
		PlayTrackedTween(paraFrame, TWEEN_FAST, {BackgroundColor3 = KazeUI.GetColor(0.04)})
		PlayTrackedTween(paraStroke, TWEEN_FAST, {Color = KazeUI.GlowColor})
	end)
	clickDetector.MouseLeave:Connect(function()
		isHovering = false
		PlayTrackedTween(paraFrame, TWEEN_FAST, {BackgroundColor3 = KazeUI.GetColor(0.02)})
		PlayTrackedTween(paraStroke, TWEEN_FAST, {Color = KazeUI.CurrentTheme.Border})
	end)
	clickDetector.MouseButton1Down:Connect(function()
		if isLockedState or activeDialogsCount > 0 then return end
		PlayTrackedTween(paraFrame, TWEEN_FAST, {Size = UDim2.new(0.93, 0, 0, totalHeight - 2), Position = UDim2.new(0.5, 0, 0, 4)})
	end)
	clickDetector.MouseButton1Up:Connect(function()
		if isLockedState or activeDialogsCount > 0 then return end
		PlayTrackedTween(paraFrame, TWEEN_SPRING, {Size = UDim2.new(0.95, 0, 0, totalHeight), Position = UDim2.new(0.5, 0, 0, 3)})
		setToggleState(not state, false)
		if typeof(callback) == "function" then task.spawn(callback, state) end
	end)

	KazeUI:OnGlowChanged(switchContainer, function(c)
		if state then switchContainer.BackgroundColor3 = c end
	end)

	KazeUI:OnGlowChanged(paraStroke, function(c)
		if isHovering then paraStroke.Color = c end
	end)

	RegisterFlag(flag, function() return state end, function(val)
		setToggleState(val, false)
		if typeof(callback) == "function" then task.spawn(callback, state) end
	end, {Type = "Toggle"})
	
	local lockCtrl = ApplyLock(paraFrame, locked, wrapper, UDim2.new(0.95, 0, 1, -3), UDim2.new(0.5, 0, 0, 3), Vector2.new(0.5, 0))

	return { 
		Wrapper = wrapper, 
		SetState = function(self, newState, instant) setToggleState(newState, instant) end,
		SetText = function(self, newTitle, newBody)
			if ptitleLabel and newTitle then ptitleLabel.Text = newTitle end
			if bodyLabel and newBody then bodyLabel.Text = newBody end
		end,
		SetLocked = function(self, state)
			isLockedState = state
			lockCtrl:SetLocked(state)
		end
	}
end

local function CreateTextBoxInput(parentFrame, title, placeholder, defaultVal, callback, flag, locked)
	title = tostring(title or "Input Text")
	placeholder = tostring(placeholder or "Type here...")
	local isLockedState = locked or false
	
	local measuredWidth = 598 * 0.92
	if parentFrame and parentFrame.AbsoluteSize and parentFrame.AbsoluteSize.X > 0 then measuredWidth = parentFrame.AbsoluteSize.X * 0.95 end
	local textContainerWidth = measuredWidth - 28
	
	local titleHeight = 0
	if title ~= " " and title ~= "" then
		local ts = TextService:GetTextSize(title, 13, Enum.Font.GothamBold, Vector2.new(textContainerWidth, 1000))
		titleHeight = math.max(16, math.ceil(ts.Y))
	end
	
	local totalHeight = 10 + titleHeight + 6 + 32 + 10
	
	local wrapper = Instance.new("Frame")
	wrapper.Size = UDim2.new(1, 0, 0, 0)
	wrapper.BackgroundTransparency = 1
	wrapper.Parent = parentFrame
	wrapper.AutomaticSize = Enum.AutomaticSize.Y
	
	local paraFrame = Instance.new("Frame")
	paraFrame.AnchorPoint = Vector2.new(0.5, 0)
	paraFrame.Position = UDim2.new(0.5, 0, 0, 3)
	paraFrame.Size = UDim2.new(0.95, 0, 0, totalHeight)
	paraFrame.BorderSizePixel = 0
	
	Instance.new("UICorner", paraFrame).CornerRadius = UDim.new(0, 14)
	paraFrame.Parent = wrapper
	KazeUI:AddPanel(paraFrame, 0.02)
	
	local paraStroke = Instance.new("UIStroke", paraFrame)
	paraStroke.Thickness = 1.2
	paraStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	KazeUI:RegisterBorder(paraStroke)
	
	local inner = Instance.new("Frame", paraFrame)
	inner.Size = UDim2.new(1, -20, 1, -16)
	inner.Position = UDim2.fromOffset(10, 8)
	inner.BackgroundTransparency = 1
	
	local ptitleLabel
	if title ~= " " and title ~= "" then
		ptitleLabel = Instance.new("TextLabel", inner)
		ptitleLabel.Size = UDim2.new(1, 0, 0, titleHeight)
		ptitleLabel.BackgroundTransparency = 1
		ptitleLabel.Text = title
		ptitleLabel.Font = Enum.Font.GothamBold
		ptitleLabel.TextSize = 13 
		ptitleLabel.TextWrapped = true
		ptitleLabel.TextXAlignment = Enum.TextXAlignment.Left 
		KazeUI:RegisterText(ptitleLabel, false)
	end
	
	local textBoxContainer = Instance.new("Frame")
	textBoxContainer.Size = UDim2.new(1, 0, 0, 30)
	textBoxContainer.Position = UDim2.new(0, 0, 0, titleHeight + 4)
	textBoxContainer.BorderSizePixel = 0
	textBoxContainer.ClipsDescendants = true 
	textBoxContainer.Parent = inner
	Instance.new("UICorner", textBoxContainer).CornerRadius = UDim.new(0, 10)
	KazeUI:AddPanel(textBoxContainer, -0.01)
	
	local innerStroke = Instance.new("UIStroke", textBoxContainer)
	innerStroke.Thickness = 1
	KazeUI:RegisterBorder(innerStroke)
	
	local textBox = Instance.new("TextBox")
	textBox.Size = UDim2.new(1, -16, 1, 0)
	textBox.Position = UDim2.fromOffset(8, 0)
	textBox.BackgroundTransparency = 1
	textBox.PlaceholderText = placeholder
	textBox.Text = defaultVal and tostring(defaultVal) or ""
	textBox.Font = Enum.Font.Gotham
	textBox.TextSize = 11
	textBox.TextXAlignment = Enum.TextXAlignment.Left
	textBox.ClearTextOnFocus = false
	textBox.ClipsDescendants = true 
	textBox.TextWrapped = false 
	textBox.Parent = textBoxContainer
	KazeUI:RegisterText(textBox, false)
	KazeUI:OnThemeChanged(textBox, function(t) textBox.PlaceholderColor3 = t.MutedText end)

	local isFocused = false

	textBox.Focused:Connect(function()
		if isLockedState or activeDialogsCount > 0 then
			textBox:ReleaseFocus()
			return
		end
		isFocused = true
		PlayTrackedTween(innerStroke, TWEEN_FAST, {Color = KazeUI.GlowColor})
		PlayTrackedTween(paraFrame, TWEEN_FAST, {BackgroundColor3 = KazeUI.GetColor(0.04)})
		PlayTrackedTween(paraStroke, TWEEN_FAST, {Color = KazeUI.GlowColor})
	end)

	textBox.FocusLost:Connect(function(enterPressed)
		isFocused = false
		PlayTrackedTween(innerStroke, TWEEN_FAST, {Color = KazeUI.CurrentTheme.Border})
		PlayTrackedTween(paraFrame, TWEEN_FAST, {BackgroundColor3 = KazeUI.GetColor(0.02)})
		PlayTrackedTween(paraStroke, TWEEN_FAST, {Color = KazeUI.CurrentTheme.Border})
		if typeof(callback) == "function" then task.spawn(callback, textBox.Text, enterPressed) end
	end)
	
	KazeUI:OnGlowChanged(innerStroke, function(c)
		if isFocused then
			innerStroke.Color = c
			paraStroke.Color = c
		end
	end)
	
	RegisterFlag(flag, function() return textBox.Text end, function(val)
		textBox.Text = val
		if typeof(callback) == "function" then task.spawn(callback, val) end
	end, {Type = "TextBox"})

	local lockCtrl = ApplyLock(paraFrame, locked, wrapper, UDim2.new(0.95, 0, 1, -3), UDim2.new(0.5, 0, 0, 3), Vector2.new(0.5, 0))

	return { 
		Wrapper = wrapper, 
		SetText = function(self, value) textBox.Text = tostring(value or "") end,
		SetPlaceholder = function(self, val) textBox.PlaceholderText = val end,
		SetTitle = function(self, newTitle)
			if ptitleLabel and newTitle then ptitleLabel.Text = newTitle end
		end,
		SetLocked = function(self, state)
			isLockedState = state
			lockCtrl:SetLocked(state)
		end
	}
end

local function CreateSliderInput(parentFrame, title, min, max, default, callback, flag, locked)
	title = tostring(title or "Slider")
	min = tonumber(min) or 0
	max = tonumber(max) or 100
	default = tonumber(default) or min
	local value = math.clamp(default, min, max)
	local isLockedState = locked or false
	
	local measuredWidth = 598 * 0.92
	if parentFrame and parentFrame.AbsoluteSize and parentFrame.AbsoluteSize.X > 0 then measuredWidth = parentFrame.AbsoluteSize.X * 0.95 end
	local textContainerWidth = measuredWidth - 28
	
	local titleHeight = 0
	if title ~= " " and title ~= "" then
		local ts = TextService:GetTextSize(title, 13, Enum.Font.GothamBold, Vector2.new(textContainerWidth - 80, 1000))
		titleHeight = math.max(18, math.ceil(ts.Y))
	end
	
	local totalHeight = 10 + titleHeight + 6 + 18 + 10
	
	local wrapper = Instance.new("Frame")
	wrapper.Size = UDim2.new(1, 0, 0, 0)
	wrapper.BackgroundTransparency = 1
	wrapper.Parent = parentFrame
	wrapper.AutomaticSize = Enum.AutomaticSize.Y
	
	local paraFrame = Instance.new("Frame")
	paraFrame.AnchorPoint = Vector2.new(0.5, 0)
	paraFrame.Position = UDim2.new(0.5, 0, 0, 3)
	paraFrame.Size = UDim2.new(0.95, 0, 0, totalHeight)
	paraFrame.BorderSizePixel = 0
	
	Instance.new("UICorner", paraFrame).CornerRadius = UDim.new(0, 14)
	paraFrame.Parent = wrapper
	KazeUI:AddPanel(paraFrame, 0.02)
	
	local paraStroke = Instance.new("UIStroke", paraFrame)
	paraStroke.Thickness = 1.2
	paraStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	KazeUI:RegisterBorder(paraStroke)
	
	local inner = Instance.new("Frame", paraFrame)
	inner.Size = UDim2.new(1, -20, 1, -16)
	inner.Position = UDim2.fromOffset(10, 8)
	inner.BackgroundTransparency = 1
	
	local ptitleLabel
	if title ~= " " and title ~= "" then
		ptitleLabel = Instance.new("TextLabel", inner)
		ptitleLabel.Size = UDim2.new(1, -80, 0, titleHeight)
		ptitleLabel.BackgroundTransparency = 1
		ptitleLabel.Text = title
		ptitleLabel.Font = Enum.Font.GothamBold
		ptitleLabel.TextSize = 13 
		ptitleLabel.TextWrapped = true
		ptitleLabel.TextXAlignment = Enum.TextXAlignment.Left
		KazeUI:RegisterText(ptitleLabel, false)
	end
	
	local valueLabel = Instance.new("TextLabel", inner)
	valueLabel.Size = UDim2.new(0, 70, 0, titleHeight > 0 and titleHeight or 18)
	valueLabel.Position = UDim2.new(1, -70, 0, 0)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Text = tostring(value)
	valueLabel.Font = Enum.Font.GothamBold
	valueLabel.TextSize = 11
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	KazeUI:RegisterText(valueLabel, false)
	
	local track = Instance.new("Frame")
	track.Size = UDim2.new(1, 0, 0, 6)
	track.Position = UDim2.new(0, 0, 0, titleHeight + 8)
	track.BorderSizePixel = 0
	track.Parent = inner
	Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
	KazeUI:AddPanel(track, -0.01)
	
	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(0, 0, 1, 0)
	fill.BackgroundColor3 = KazeUI.GlowColor
	fill.BorderSizePixel = 0
	fill.Parent = track
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
	
	local knob = Instance.new("Frame")
	knob.AnchorPoint = Vector2.new(0.5, 0.5)
	knob.Size = UDim2.fromOffset(12, 12)
	knob.Position = UDim2.new(0, 0, 0.5, 0)
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.BorderSizePixel = 0
	knob.Parent = track
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
	
	local knobStroke = Instance.new("UIStroke", knob)
	knobStroke.Thickness = 1.2
	knobStroke.Color = KazeUI.GlowColor

	local clickDetector = Instance.new("TextButton")
	clickDetector.Size = UDim2.new(1, 0, 1, 14)
	clickDetector.Position = UDim2.new(0, 0, 0, -4)
	clickDetector.BackgroundTransparency = 1
	clickDetector.Text = ""
	clickDetector.ZIndex = 10
	clickDetector.Parent = track
	
	local isDragging = false
	
	local function UpdateValueFromInput(input)
		local trackWidth = track.AbsoluteSize.X
		if trackWidth <= 0 then return end
		local relativeX = input.Position.X - track.AbsolutePosition.X
		local percentage = math.clamp(relativeX / trackWidth, 0, 1)
		local newVal = min + (max - min) * percentage
		newVal = math.clamp(math.floor(newVal + 0.5), min, max)
		value = newVal
		valueLabel.Text = tostring(value)
		
		local visualPercentage = 0
		if max > min then visualPercentage = (value - min) / (max - min) end
		
		PlayTrackedTween(fill, TWEEN_FAST, {Size = UDim2.new(visualPercentage, 0, 1, 0)})
		PlayTrackedTween(knob, TWEEN_FAST, {Position = UDim2.new(visualPercentage, 0, 0.5, 0)})
		if typeof(callback) == "function" then task.spawn(callback, value) end
	end
	
	local startingPercentage = 0
	if max > min then startingPercentage = (value - min) / (max - min) end
	fill.Size = UDim2.new(startingPercentage, 0, 1, 0)
	knob.Position = UDim2.new(startingPercentage, 0, 0.5, 0)
	
	clickDetector.InputBegan:Connect(function(input)
		if isLockedState or activeDialogsCount > 0 then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isDragging = true
			ToggleScrollingAncestors(track, false)
			LockCamera()
			UpdateValueFromInput(input)
			
			PlayTrackedTween(knob, TWEEN_FAST, {Size = UDim2.fromOffset(16, 16)})
			PlayTrackedTween(paraStroke, TWEEN_FAST, {Color = KazeUI.GlowColor})
			
			local moveCon, endCon
			moveCon = UIS.InputChanged:Connect(function(moveInput)
				if isDragging and (moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch) then
					UpdateValueFromInput(moveInput)
				end
			end)
			endCon = UIS.InputEnded:Connect(function(endInput)
				if endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch then
					isDragging = false
					ToggleScrollingAncestors(track, true)
					UnlockCamera()
					
					PlayTrackedTween(knob, TWEEN_FAST, {Size = UDim2.fromOffset(12, 12)})
					PlayTrackedTween(paraStroke, TWEEN_FAST, {Color = KazeUI.CurrentTheme.Border})
					if moveCon then moveCon:Disconnect() end
					if endCon then endCon:Disconnect() end
				end
			end)
		end
	end)

	KazeUI:OnGlowChanged(fill, function(c)
		fill.BackgroundColor3 = c
		knobStroke.Color = c
	end)

	KazeUI:OnGlowChanged(paraStroke, function(c)
		if isDragging then paraStroke.Color = c end
	end)

	local lockCtrl = ApplyLock(paraFrame, locked, wrapper, UDim2.new(0.95, 0, 1, -3), UDim2.new(0.5, 0, 0, 3), Vector2.new(0.5, 0))

	local api = {
		Wrapper = wrapper,
		SetValue = function(self, newVal)
			value = math.clamp(tonumber(newVal) or min, min, max)
			valueLabel.Text = tostring(value)
			local valPercentage = 0
			if max > min then valPercentage = (value - min) / (max - min) end
			fill.Size = UDim2.new(valPercentage, 0, 1, 0)
			knob.Position = UDim2.new(valPercentage, 0, 0.5, 0)
			if typeof(callback) == "function" then task.spawn(callback, value) end
		end,
		SetText = function(self, newTitle)
			if ptitleLabel and newTitle then ptitleLabel.Text = newTitle end
		end,
		SetLocked = function(self, state)
			isLockedState = state
			lockCtrl:SetLocked(state)
		end
	}
	RegisterFlag(flag, function() return value end, function(val) api:SetValue(val) end, {Type = "Slider", Min = min, Max = max})
	return api
end

local function CreateColorPicker(parentFrame, title, defaultColor, callback, flag, locked)
	title = tostring(title or "Color Picker")
	local color = defaultColor or Color3.fromRGB(255, 255, 255)
	local h, s, v = Color3.toHSV(color)
	local isOpen = false
	local isLockedState = locked or false

	local wrapper = Instance.new("Frame")
	wrapper.Size = UDim2.new(1, 0, 0, 0)
	wrapper.BackgroundTransparency = 1
	wrapper.Parent = parentFrame
	wrapper.AutomaticSize = Enum.AutomaticSize.Y

	local dropFrame = Instance.new("Frame")
	dropFrame.AnchorPoint = Vector2.new(0.5, 0)
	dropFrame.Position = UDim2.new(0.5, 0, 0, 3)
	dropFrame.Size = UDim2.new(0.95, 0, 0, 0)
	dropFrame.BorderSizePixel = 0
	dropFrame.AutomaticSize = Enum.AutomaticSize.Y
	
	Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 14)
	dropFrame.Parent = wrapper
	KazeUI:AddPanel(dropFrame, 0.02)

	local padding = Instance.new("UIPadding", dropFrame)
	padding.PaddingTop = UDim.new(0, 5)
	padding.PaddingBottom = UDim.new(0, 5)

	local boxStroke = Instance.new("UIStroke", dropFrame)
	boxStroke.Thickness = 1.2
	boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	KazeUI:RegisterBorder(boxStroke)

	local layout = Instance.new("UIListLayout", dropFrame)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.Padding = UDim.new(0, 5)

	local header = Instance.new("Frame")
	header.Size = UDim2.new(1, -20, 0, 38)
	header.BackgroundTransparency = 1
	header.LayoutOrder = 1
	header.Parent = dropFrame

	local titleLabel = Instance.new("TextLabel", header)
	titleLabel.Size = UDim2.new(0.5, 0, 1, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 13
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	KazeUI:RegisterText(titleLabel, false)

	local previewColor = Instance.new("Frame", header)
	previewColor.AnchorPoint = Vector2.new(1, 0.5)
	previewColor.Position = UDim2.new(1, -24, 0.5, 0)
	previewColor.Size = UDim2.fromOffset(24, 24)
	previewColor.BackgroundColor3 = color
	Instance.new("UICorner", previewColor).CornerRadius = UDim.new(0, 6)
	
	local prevStroke = Instance.new("UIStroke", previewColor)
	KazeUI:RegisterBorder(prevStroke)

	local arrowIcon = Instance.new("ImageLabel", header)
	arrowIcon.AnchorPoint = Vector2.new(1, 0.5)
	arrowIcon.Position = UDim2.new(1, 0, 0.5, 0)
	arrowIcon.Size = UDim2.fromOffset(16, 16)
	arrowIcon.BackgroundTransparency = 1
	arrowIcon.Image = "rbxassetid://10723415693"
	arrowIcon.Rotation = 0
	KazeUI:OnThemeChanged(arrowIcon, function(t) arrowIcon.ImageColor3 = t.MutedText end)

	local clickBtn = Instance.new("TextButton", header)
	clickBtn.Size = UDim2.fromScale(1, 1)
	clickBtn.BackgroundTransparency = 1
	clickBtn.Text = ""

	local pickerArea = Instance.new("Frame", dropFrame)
	pickerArea.Size = UDim2.new(1, -20, 0, 155)
	pickerArea.BackgroundTransparency = 1
	pickerArea.Visible = false
	pickerArea.LayoutOrder = 2

	local svMap = Instance.new("TextButton", pickerArea)
	svMap.Size = UDim2.new(1, 0, 0, 120)
	svMap.AutoButtonColor = false
	svMap.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
	svMap.Text = ""
	Instance.new("UICorner", svMap).CornerRadius = UDim.new(0, 8)

	local whiteOverlay = Instance.new("Frame", svMap)
	whiteOverlay.Size = UDim2.fromScale(1, 1)
	whiteOverlay.BackgroundTransparency = 0 
	whiteOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	local wg = Instance.new("UIGradient", whiteOverlay)
	wg.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)}
	Instance.new("UICorner", whiteOverlay).CornerRadius = UDim.new(0, 8)

	local blackOverlay = Instance.new("Frame", svMap)
	blackOverlay.Size = UDim2.fromScale(1, 1)
	blackOverlay.BackgroundTransparency = 0 
	blackOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	local bg = Instance.new("UIGradient", blackOverlay)
	bg.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)}
	bg.Rotation = 90
	Instance.new("UICorner", blackOverlay).CornerRadius = UDim.new(0, 8)

	local svCursor = Instance.new("Frame", svMap)
	svCursor.Size = UDim2.fromOffset(8, 8)
	svCursor.AnchorPoint = Vector2.new(0.5, 0.5)
	svCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Instance.new("UICorner", svCursor).CornerRadius = UDim.new(1, 0)
	Instance.new("UIStroke", svCursor).Color = Color3.fromRGB(0, 0, 0)

	local hueSlider = Instance.new("TextButton", pickerArea)
	hueSlider.Size = UDim2.new(1, 0, 0, 22)
	hueSlider.Position = UDim2.new(0, 0, 0, 130)
	hueSlider.AutoButtonColor = false
	hueSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	hueSlider.Text = ""
	local hg = Instance.new("UIGradient", hueSlider)
	hg.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
		ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
		ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
		ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
		ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
	}
	Instance.new("UICorner", hueSlider).CornerRadius = UDim.new(0, 8)

	local hueCursor = Instance.new("Frame", hueSlider)
	hueCursor.Size = UDim2.fromOffset(4, 24)
	hueCursor.AnchorPoint = Vector2.new(0.5, 0.5)
	hueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Instance.new("UICorner", hueCursor).CornerRadius = UDim.new(1, 0)
	Instance.new("UIStroke", hueCursor).Color = Color3.fromRGB(0, 0, 0)

	local function UpdateColor()
		color = Color3.fromHSV(h, s, v)
		previewColor.BackgroundColor3 = color
		svMap.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
		if typeof(callback) == "function" then task.spawn(callback, color) end
	end

	local function SetCursorPositions()
		svCursor.Position = UDim2.new(s, 0, 1 - v, 0)
		hueCursor.Position = UDim2.new(h, 0, 0.5, 0)
	end
	SetCursorPositions()

	local draggingMap, draggingHue = false, false

	local function updateSV(input)
		local width = math.max(1, svMap.AbsoluteSize.X)
		local height = math.max(1, svMap.AbsoluteSize.Y)
		local relativeX = input.Position.X - svMap.AbsolutePosition.X
		local relativeY = input.Position.Y - svMap.AbsolutePosition.Y
		s = math.clamp(relativeX / width, 0, 1)
		v = 1 - math.clamp(relativeY / height, 0, 1)
		SetCursorPositions()
		UpdateColor()
	end

	local function updateHue(input)
		local width = math.max(1, hueSlider.AbsoluteSize.X)
		local relativeX = input.Position.X - hueSlider.AbsolutePosition.X
		h = math.clamp(relativeX / width, 0, 1)
		SetCursorPositions()
		UpdateColor()
	end

	svMap.InputBegan:Connect(function(input)
		if isLockedState or activeDialogsCount > 0 then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingMap = true
			ToggleScrollingAncestors(svMap, false)
			LockCamera()
			updateSV(input)
		end
	end)

	hueSlider.InputBegan:Connect(function(input)
		if isLockedState or activeDialogsCount > 0 then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingHue = true
			ToggleScrollingAncestors(hueSlider, false)
			LockCamera()
			updateHue(input)
		end
	end)

	local uisConn1 = UIS.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if draggingMap then
				updateSV(input)
			elseif draggingHue then
				updateHue(input)
			end
		end
	end)

	local uisConn2 = UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if draggingMap or draggingHue then UnlockCamera() end
			draggingMap = false
			draggingHue = false
			ToggleScrollingAncestors(svMap, true)
		end
	end)
	
	wrapper.Destroying:Connect(function()
		if uisConn1 then uisConn1:Disconnect() end
		if uisConn2 then uisConn2:Disconnect() end
	end)

	clickBtn.MouseButton1Click:Connect(function()
		if isLockedState or activeDialogsCount > 0 then return end
		isOpen = not isOpen
		pickerArea.Visible = isOpen
		PlayTrackedTween(arrowIcon, TWEEN_SPRING, {Rotation = isOpen and 180 or 0})
		PlayTrackedTween(boxStroke, TWEEN_FAST, {Color = isOpen and KazeUI.GlowColor or KazeUI.CurrentTheme.Border})
	end)
	
	KazeUI:OnGlowChanged(boxStroke, function(c)
		if isOpen then boxStroke.Color = c end
	end)

	RegisterFlag(flag, function() return color:ToHex() end, function(val)
		local success, parsed = pcall(function() return Color3.fromHex(val) end)
		if success then
			color = parsed
			h, s, v = Color3.toHSV(color)
			SetCursorPositions()
			UpdateColor()
		end
	end, {Type = "ColorPicker"})

	local lockCtrl = ApplyLock(dropFrame, locked, wrapper, UDim2.new(0.95, 0, 1, -3), UDim2.new(0.5, 0, 0, 3), Vector2.new(0.5, 0))

	return {
		Wrapper = wrapper,
		SetValue = function(self, newColor)
			color = newColor
			h, s, v = Color3.toHSV(color)
			SetCursorPositions()
			UpdateColor()
		end,
		SetText = function(self, newTitle) titleLabel.Text = newTitle end,
		SetLocked = function(self, state)
			isLockedState = state
			lockCtrl:SetLocked(state)
		end
	}
end

local function CreateKeybindInput(parentFrame, title, defaultKey, callback, flag, locked)
	title = tostring(title or "Keybind")
	local currentKey = defaultKey or Enum.KeyCode.Unknown
	local isBinding = false
	local isLockedState = locked or false
	
	local measuredWidth = 598 * 0.92
	if parentFrame and parentFrame.AbsoluteSize and parentFrame.AbsoluteSize.X > 0 then measuredWidth = parentFrame.AbsoluteSize.X * 0.95 end
	local textContainerWidth = measuredWidth - 28 - 90
	
	local titleHeight = 0
	if title ~= " " and title ~= "" then
		local ts = TextService:GetTextSize(title, 13, Enum.Font.GothamBold, Vector2.new(textContainerWidth, 1000))
		titleHeight = math.max(16, math.ceil(ts.Y))
	end
	
	local totalHeight = 10 + math.max(titleHeight, 24) + 10
	
	local wrapper = Instance.new("Frame")
	wrapper.Size = UDim2.new(1, 0, 0, 0)
	wrapper.BackgroundTransparency = 1
	wrapper.Parent = parentFrame
	wrapper.AutomaticSize = Enum.AutomaticSize.Y
	
	local paraFrame = Instance.new("Frame")
	paraFrame.AnchorPoint = Vector2.new(0.5, 0)
	paraFrame.Position = UDim2.new(0.5, 0, 0, 3)
	paraFrame.Size = UDim2.new(0.95, 0, 0, totalHeight)
	paraFrame.BorderSizePixel = 0
	
	Instance.new("UICorner", paraFrame).CornerRadius = UDim.new(0, 14)
	paraFrame.Parent = wrapper
	KazeUI:AddPanel(paraFrame, 0.02)
	
	local paraStroke = Instance.new("UIStroke", paraFrame)
	paraStroke.Thickness = 1.2
	paraStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	KazeUI:RegisterBorder(paraStroke)
	
	local inner = Instance.new("Frame", paraFrame)
	inner.Size = UDim2.new(1, -20, 1, -16)
	inner.Position = UDim2.fromOffset(10, 8)
	inner.BackgroundTransparency = 1
	
	local ptitleLabel
	if title ~= " " and title ~= "" then
		ptitleLabel = Instance.new("TextLabel", inner)
		ptitleLabel.Size = UDim2.new(1, -90, 1, 0)
		ptitleLabel.BackgroundTransparency = 1
		ptitleLabel.Text = title
		ptitleLabel.Font = Enum.Font.GothamBold
		ptitleLabel.TextSize = 13
		ptitleLabel.TextWrapped = true
		ptitleLabel.TextXAlignment = Enum.TextXAlignment.Left
		KazeUI:RegisterText(ptitleLabel, false)
	end
	
	local bindContainer = Instance.new("TextButton", inner)
	bindContainer.Size = UDim2.new(0, 80, 0, 24)
	bindContainer.AnchorPoint = Vector2.new(1, 0.5)
	bindContainer.Position = UDim2.new(1, 0, 0.5, 0)
	bindContainer.BorderSizePixel = 0
	bindContainer.Text = ""
	bindContainer.AutoButtonColor = false
	Instance.new("UICorner", bindContainer).CornerRadius = UDim.new(0, 8)
	KazeUI:AddPanel(bindContainer, 0.05)

	local bindStroke = Instance.new("UIStroke", bindContainer)
	bindStroke.Thickness = 1
	KazeUI:RegisterBorder(bindStroke)
	
	local bindLabel = Instance.new("TextLabel", bindContainer)
	bindLabel.Size = UDim2.new(1, 0, 1, 0)
	bindLabel.BackgroundTransparency = 1
	bindLabel.Text = currentKey == Enum.KeyCode.Unknown and "None" or currentKey.Name
	bindLabel.Font = Enum.Font.GothamBold
	bindLabel.TextSize = 10
	KazeUI:RegisterText(bindLabel, false)

	local isHovering = false
	
	bindContainer.MouseEnter:Connect(function()
		if isLockedState or activeDialogsCount > 0 then return end
		isHovering = true
		if not isBinding then PlayTrackedTween(bindStroke, TWEEN_FAST, {Color = KazeUI.GlowColor}) end
	end)
	bindContainer.MouseLeave:Connect(function()
		isHovering = false
		if not isBinding then PlayTrackedTween(bindStroke, TWEEN_FAST, {Color = KazeUI.CurrentTheme.Border}) end
	end)
	
	bindContainer.MouseButton1Click:Connect(function()
		if isLockedState or activeDialogsCount > 0 then return end
		if isBinding then return end
		isBinding = true
		bindLabel.Text = "..."
		PlayTrackedTween(bindStroke, TWEEN_FAST, {Color = KazeUI.GlowColor})
		
		local conn
		conn = UIS.InputBegan:Connect(function(input)
			local isKey = input.UserInputType == Enum.UserInputType.Keyboard
			local isMouse = input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton3
			
			if isKey or isMouse then
				if isKey then
					local key = input.KeyCode
					if key == Enum.KeyCode.Escape then
					elseif key == Enum.KeyCode.Backspace or key == Enum.KeyCode.Delete then
						currentKey = Enum.KeyCode.Unknown
					else
						currentKey = key
					end
				end
				
				bindLabel.Text = currentKey == Enum.KeyCode.Unknown and "None" or currentKey.Name
				PlayTrackedTween(bindStroke, TWEEN_FAST, {Color = KazeUI.CurrentTheme.Border})
				conn:Disconnect()
				task.delay(0.15, function() isBinding = false end)
			end
		end)
	end)
	
	local uisConn = UIS.InputBegan:Connect(function(input, gp)
		if not gp and not isBinding and currentKey ~= Enum.KeyCode.Unknown and input.KeyCode == currentKey then
			if typeof(callback) == "function" then task.spawn(callback, currentKey) end
		end
	end)
	
	wrapper.Destroying:Connect(function()
		if uisConn then uisConn:Disconnect() end
	end)

	KazeUI:OnGlowChanged(bindStroke, function(c)
		if isBinding or isHovering then bindStroke.Color = c end
	end)

	RegisterFlag(flag, function() return currentKey.Name end, function(val)
		pcall(function()
			currentKey = Enum.KeyCode[val] or Enum.KeyCode.Unknown
			bindLabel.Text = currentKey == Enum.KeyCode.Unknown and "None" or currentKey.Name
		end)
	end, {Type = "Keybind"})

	local lockCtrl = ApplyLock(paraFrame, locked, wrapper, UDim2.new(0.95, 0, 1, -3), UDim2.new(0.5, 0, 0, 3), Vector2.new(0.5, 0))

	return {
		Wrapper = wrapper,
		SetText = function(self, newTitle)
			if ptitleLabel and newTitle then ptitleLabel.Text = newTitle end
		end,
		SetKey = function(self, newKey)
			currentKey = newKey
			bindLabel.Text = currentKey == Enum.KeyCode.Unknown and "None" or currentKey.Name
		end,
		SetLocked = function(self, state)
			isLockedState = state
			lockCtrl:SetLocked(state)
		end
	}
end

local function CreateVisualSectionDivider(parentFrame, titleArg)
	local title = tostring(titleArg or "Section")

	local wrapper = Instance.new("Frame")
	wrapper.Size = UDim2.new(0.95, 0, 0, 36)
	wrapper.BackgroundTransparency = 1
	wrapper.Parent = parentFrame

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -16, 1, 0)
	label.Position = UDim2.fromOffset(16, 0)
	label.BackgroundTransparency = 1
	label.Text = title
	label.Font = Enum.Font.GothamBold
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = wrapper
	KazeUI:RegisterText(label, false)
	
	local leftLine = Instance.new("Frame")
	leftLine.Size = UDim2.new(0, 4, 0, 16)
	leftLine.Position = UDim2.new(0, 2, 0.5, -8)
	leftLine.BackgroundColor3 = KazeUI.GlowColor
	leftLine.BorderSizePixel = 0
	leftLine.Parent = wrapper
	Instance.new("UICorner", leftLine).CornerRadius = UDim.new(1, 0)

	KazeUI:OnGlowChanged(leftLine, function(c) leftLine.BackgroundColor3 = c end)

	return {
		Label = label,
		LeftLine = leftLine,
		SetText = function(self, t) label.Text = t end
	}
end

local function CreateVisualDivider(parentFrame, titleArg)
	local title = titleArg and tostring(titleArg) or ""
	if type(titleArg) == "table" then
		title = tostring(titleArg.Title or titleArg.Text or "")
	end

	local wrapper = Instance.new("Frame")
	wrapper.Name = "DividerWrapper"
	wrapper.BackgroundTransparency = 1
	wrapper.Parent = parentFrame

	if title == "" or title == " " then
		wrapper.Size = UDim2.new(0.95, 0, 0, 14) 
		
		local line = Instance.new("Frame")
		line.Name = "Line"
		line.Size = UDim2.new(1, 0, 0, 1)
		line.Position = UDim2.new(0, 0, 0.5, 0)
		line.BorderSizePixel = 0
		line.Parent = wrapper
		KazeUI:OnThemeChanged(line, function(t)
			line.BackgroundColor3 = t.Border
		end)
	else
		wrapper.Size = UDim2.new(0.95, 0, 0, 26) 

		local container = Instance.new("Frame")
		container.Name = "Container"
		container.Size = UDim2.new(1, 0, 1, 0)
		container.BackgroundTransparency = 1
		container.Parent = wrapper

		local ts = TextService:GetTextSize(title, 11, Enum.Font.GothamBold, Vector2.new(1000, 1000))
		local textWidth = math.min(220, math.ceil(ts.Y))

		local label = Instance.new("TextLabel")
		label.Name = "Title"
		label.Size = UDim2.new(0, textWidth, 1, 0)
		label.Position = UDim2.new(0.5, -textWidth / 2, 0, 0)
		label.BackgroundTransparency = 1
		label.Text = title
		label.Font = Enum.Font.GothamBold
		label.TextSize = 10
		label.TextXAlignment = Enum.TextXAlignment.Center
		label.Parent = container
		KazeUI:RegisterText(label, true) 

		local leftLine = Instance.new("Frame")
		leftLine.Name = "LeftLine"
		leftLine.Size = UDim2.new(0.5, -(textWidth / 2 + 10), 0, 1)
		leftLine.Position = UDim2.new(0, 0, 0.5, 0)
		leftLine.BorderSizePixel = 0
		leftLine.Parent = container
		KazeUI:OnThemeChanged(leftLine, function(t)
			leftLine.BackgroundColor3 = t.Border
		end)

		local rightLine = Instance.new("Frame")
		rightLine.Name = "RightLine"
		rightLine.Size = UDim2.new(0.5, -(textWidth / 2 + 10), 0, 1)
		rightLine.Position = UDim2.new(0.5, (textWidth / 2 + 10), 0.5, 0)
		rightLine.BorderSizePixel = 0
		rightLine.Parent = container
		KazeUI:OnThemeChanged(rightLine, function(t)
			rightLine.BackgroundColor3 = t.Border
		end)
	end

	return {
		Wrapper = wrapper,
		SetText = function(self, newText)
			local lbl = wrapper:FindFirstChild("Title", true)
			if lbl then
				lbl.Text = tostring(newText or "")
				local ts = TextService:GetTextSize(lbl.Text, 11, Enum.Font.GothamBold, Vector2.new(1000, 1000))
				local textWidth = math.min(220, math.ceil(ts.X))
				lbl.Size = UDim2.new(0, textWidth, 1, 0)
				lbl.Position = UDim2.new(0.5, -textWidth / 2, 0, 0)
				
				local lLine = wrapper:FindFirstChild("LeftLine", true)
				if lLine then lLine.Size = UDim2.new(0.5, -(textWidth / 2 + 10), 0, 1) end
				local rLine = wrapper:FindFirstChild("RightLine", true)
				if rLine then rLine.Size = UDim2.new(0.5, -(textWidth / 2 + 10), 0, 1) rLine.Position = UDim2.new(0.5, (textWidth / 2 + 10), 0.5, 0) end
			end
		end
	}
end

-- ==========================================
-- GroupBox & SectionUI Builder
-- ==========================================
local CreateCollapsibleSection
local CreateGroupBox
local AttachElementsToAPI

AttachElementsToAPI = function(apiTable, parentFrame, depth)
	depth = depth or 1

	function apiTable:AddLabel(arg1)
		local t = type(arg1) == "table" and (arg1.Text or arg1.Title) or arg1
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, -12, 0, 22)
		label.BackgroundTransparency = 1
		label.Text = tostring(t or " ")
		label.Font = Enum.Font.GothamMedium
		label.TextSize = 13
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextWrapped = true
		label.Parent = parentFrame
		KazeUI:RegisterText(label, false)
		return label
	end

	function apiTable:Paragraph(arg1, arg2)
		local title = type(arg1) == "table" and arg1.Title or arg1
		local content = type(arg1) == "table" and (arg1.Content or arg1.Description) or arg2
		return CreateParagraph(parentFrame, title, content)
	end

	function apiTable:Button(arg1, arg2, arg3)
		local title = type(arg1) == "table" and arg1.Title or arg1
		local desc = type(arg1) == "table" and (arg1.Description or arg1.Content or "") or arg2
		local callback = type(arg1) == "table" and arg1.Callback or arg3
		local locked = type(arg1) == "table" and arg1.Locked or false
		return CreateClickableParagraph(parentFrame, title, desc, callback, locked)
	end

	function apiTable:Toggle(arg1, arg2, arg3, arg4, arg5)
		local title, desc, def, callback, flag, locked = "", "", false, nil, nil, false
		if type(arg1) == "table" then
			title, desc, def, callback, flag, locked = arg1.Title, (arg1.Description or arg1.Content or ""), arg1.Default, arg1.Callback, arg1.Flag, arg1.Locked
		else
			title, desc, def, callback, flag = arg1, arg2, arg3, arg4, arg5
		end
		return CreateToggleSwitch(parentFrame, title, desc, def, callback, flag, locked)
	end

	function apiTable:TextBox(arg1, arg2, arg3, arg4, arg5)
		local title, place, def, callback, flag, locked = "", "", "", nil, nil, false
		if type(arg1) == "table" then
			title, place, def, callback, flag, locked = arg1.Title, arg1.Placeholder, arg1.Default, arg1.Callback, arg1.Flag, arg1.Locked
		else
			title, place, def, callback, flag = arg1, arg2, arg3, arg4, arg5
		end
		return CreateTextBoxInput(parentFrame, title, place, def, callback, flag, locked)
	end

	function apiTable:Slider(arg1, arg2, arg3, arg4, arg5, arg6)
		local title, min, max, def, callback, flag, locked = "", 0, 100, 50, nil, nil, false
		if type(arg1) == "table" then
			title, min, max, def, callback, flag, locked = arg1.Title, arg1.Min, arg1.Max, arg1.Default, arg1.Callback, arg1.Flag, arg1.Locked
		else
			title, min, max, def, callback, flag = arg1, arg2, arg3, arg4, arg5, arg6
		end
		return CreateSliderInput(parentFrame, title, min, max, def, callback, flag, locked)
	end

	function apiTable:Dropdown(arg1, arg2, arg3, arg4, arg5, arg6)
		local title, vals, def, multi, callback, flag, locked = "", {}, nil, false, nil, nil, false
		if type(arg1) == "table" then
			title, vals, def, multi, callback, flag, locked = arg1.Title, (arg1.Values or arg1.Options), arg1.Default, (arg1.Multi or false), arg1.Callback, arg1.Flag, arg1.Locked
		else
			title, vals, def, callback, multi, flag = arg1, arg2, arg3, arg4, (arg5 or false), arg6
		end
		return CreateDropdown(parentFrame, title, vals, def, callback, multi, flag, locked)
	end

	function apiTable:ColorPicker(arg1, arg2, arg3, arg4)
		local title, def, cb, flag, locked = "", Color3.fromRGB(255, 255, 255), nil, nil, false
		if type(arg1) == "table" then
			title, def, cb, flag, locked = arg1.Title, arg1.Default, arg1.Callback, arg1.Flag, arg1.Locked
		else
			title, def, cb, flag = arg1, arg2, arg3, arg4
		end
		return CreateColorPicker(parentFrame, title, def, cb, flag, locked)
	end
	
	function apiTable:Keybind(arg1, arg2, arg3, arg4)
		local title, def, cb, flag, locked = "", Enum.KeyCode.Unknown, nil, nil, false
		if type(arg1) == "table" then
			title, def, cb, flag, locked = arg1.Title, arg1.Default, arg1.Callback, arg1.Flag, arg1.Locked
		else
			title, def, cb, flag = arg1, arg2, arg3, arg4
		end
		return CreateKeybindInput(parentFrame, title, def, cb, flag, locked)
	end

	function apiTable:SectionUI(arg1)
		local title = type(arg1) == "table" and arg1.Title or arg1
		return CreateCollapsibleSection(parentFrame, title, depth)
	end
	
	function apiTable:Section(arg1)
		local title = type(arg1) == "table" and arg1.Title or arg1
		return CreateVisualSectionDivider(parentFrame, title)
	end

	function apiTable:Divider(arg1)
		local title = type(arg1) == "table" and (arg1.Title or arg1.Text) or arg1
		return CreateVisualDivider(parentFrame, title)
	end

	function apiTable:GroupBox(arg1, depthOverride)
		local title = type(arg1) == "table" and arg1.Title or arg1
		return CreateGroupBox(parentFrame, title, depth, depthOverride)
	end

	-- Inherit Custom registered dynamic components
	for elName, constructor in pairs(KazeUI.CustomElements) do
		apiTable[elName] = function(self, ...)
			return constructor(parentFrame, ...)
		end
	end
end

CreateCollapsibleSection = function(parentFrame, titleArg, currentDepth)
	currentDepth = currentDepth or 1
	local title = type(titleArg) == "table" and titleArg.Title or tostring(titleArg or "Section")
	local isOpen = false

	local sectionBox = Instance.new("Frame")
	sectionBox.Name = "CollapsibleSection_" .. title
	sectionBox.Size = UDim2.new(0.95, 0, 0, 0)
	sectionBox.BorderSizePixel = 0
	sectionBox.Parent = parentFrame
	sectionBox.AutomaticSize = Enum.AutomaticSize.Y
	
	Instance.new("UICorner", sectionBox).CornerRadius = UDim.new(0, 20)
	KazeUI:AddPanel(sectionBox, 0.02)

	local boxStroke = Instance.new("UIStroke", sectionBox)
	boxStroke.Thickness = 1.5
	boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	KazeUI:RegisterBorder(boxStroke)

	local boxLayout = Instance.new("UIListLayout", sectionBox)
	boxLayout.SortOrder = Enum.SortOrder.LayoutOrder
	boxLayout.Padding = UDim.new(0, 0)
	boxLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local headerFrame = Instance.new("Frame")
	headerFrame.Name = "Header"
	headerFrame.Size = UDim2.new(1, 0, 0, 44)
	headerFrame.BackgroundTransparency = 1
	headerFrame.LayoutOrder = 1
	headerFrame.Parent = sectionBox
	Instance.new("UICorner", headerFrame).CornerRadius = UDim.new(0, 20)

	local accentLine = Instance.new("Frame", headerFrame)
	accentLine.Size = UDim2.new(0, 4, 0, 20)
	accentLine.Position = UDim2.new(0, 14, 0.5, -10)
	accentLine.BorderSizePixel = 0
	Instance.new("UICorner", accentLine).CornerRadius = UDim.new(1, 0)
	
	KazeUI:OnThemeChanged(accentLine, function(t)
		if not isOpen then accentLine.BackgroundColor3 = t.MutedText end
	end)

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -40, 1, 0)
	titleLabel.Position = UDim2.fromOffset(28, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 13
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = headerFrame
	KazeUI:RegisterText(titleLabel, false)

	local arrowIcon = Instance.new("ImageLabel")
	arrowIcon.AnchorPoint = Vector2.new(1, 0.5)
	arrowIcon.Position = UDim2.new(1, -16, 0.5, 0)
	arrowIcon.Size = UDim2.fromOffset(16, 16)
	arrowIcon.BackgroundTransparency = 1
	arrowIcon.Image = "rbxassetid://6031091004" 
	arrowIcon.Rotation = -90
	arrowIcon.Parent = headerFrame
	KazeUI:OnThemeChanged(arrowIcon, function(t)
		if not isOpen then arrowIcon.ImageColor3 = t.MutedText end
	end)

	local divider = Instance.new("Frame")
	divider.Size = UDim2.new(0.95, 0, 0, 1)
	divider.BorderSizePixel = 0
	divider.LayoutOrder = 2
	divider.Visible = false
	divider.Parent = sectionBox
	KazeUI:OnThemeChanged(divider, function(t) divider.BackgroundColor3 = t.Border end)

	local sectionContent = Instance.new("Frame")
	sectionContent.Name = "Content"
	sectionContent.Size = UDim2.new(1, 0, 0, 0)
	sectionContent.BackgroundTransparency = 1
	sectionContent.BorderSizePixel = 0
	sectionContent.Visible = false
	sectionContent.AutomaticSize = Enum.AutomaticSize.Y
	sectionContent.LayoutOrder = 3
	sectionContent.Parent = sectionBox

	local contentLayout = Instance.new("UIListLayout", sectionContent)
	contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	contentLayout.Padding = UDim.new(0, 5)
	contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local contentPadding = Instance.new("UIPadding", sectionContent)
	contentPadding.PaddingTop = UDim.new(0, 8)
	contentPadding.PaddingBottom = UDim.new(0, 10)
	contentPadding.PaddingLeft = UDim.new(0, 6)
	contentPadding.PaddingRight = UDim.new(0, 6)

	local toggleDetector = Instance.new("TextButton")
	toggleDetector.Size = UDim2.fromScale(1, 1)
	toggleDetector.BackgroundTransparency = 1
	toggleDetector.Text = ""
	toggleDetector.ZIndex = 10
	toggleDetector.Parent = headerFrame

	local function toggleSection()
		isOpen = not isOpen
		sectionContent.Visible = isOpen
		divider.Visible = isOpen

		local animDuration = 0.22
		local easeStyle = Enum.EasingStyle.Quad
		local easeDir = Enum.EasingDirection.Out

		if isOpen then
			PlayTrackedTween(arrowIcon, TweenInfo.new(animDuration, easeStyle, easeDir), {
				Rotation = 0,
				ImageColor3 = KazeUI.GlowColor
			})
			PlayTrackedTween(accentLine, TweenInfo.new(animDuration, easeStyle, easeDir), {
				BackgroundColor3 = KazeUI.GlowColor
			})
			StartNeonLoop(boxStroke)
			StartNeonLoop(accentLine)
		else
			PlayTrackedTween(arrowIcon, TweenInfo.new(animDuration, easeStyle, easeDir), {
				Rotation = -90,
				ImageColor3 = KazeUI.CurrentTheme.MutedText
			})
			PlayTrackedTween(accentLine, TweenInfo.new(animDuration, easeStyle, easeDir), {
				BackgroundColor3 = KazeUI.CurrentTheme.MutedText
			})
			StopNeonLoop(boxStroke)
			StopNeonLoop(accentLine)
			boxStroke.Color = KazeUI.CurrentTheme.Border
			accentLine.BackgroundColor3 = KazeUI.CurrentTheme.MutedText
		end
	end

	toggleDetector.MouseEnter:Connect(function()
		if activeDialogsCount > 0 then return end
		PlayTrackedTween(headerFrame, TweenInfo.new(0.15), {BackgroundColor3 = KazeUI.GetColor(0.04), BackgroundTransparency = 0.4})
	end)
	toggleDetector.MouseLeave:Connect(function()
		PlayTrackedTween(headerFrame, TweenInfo.new(0.15), {BackgroundTransparency = 1})
	end)

	toggleDetector.MouseButton1Down:Connect(function()
		if activeDialogsCount > 0 then return end
		PlayTrackedTween(sectionBox, TweenInfo.new(0.1), {Size = UDim2.new(0.93, 0, 0, 0)})
	end)
	toggleDetector.MouseButton1Up:Connect(function()
		if activeDialogsCount > 0 then return end
		PlayTrackedTween(sectionBox, TweenInfo.new(0.1), {Size = UDim2.new(0.95, 0, 0, 0)})
		toggleSection()
	end)

	local sectionPublic = { Frame = sectionBox, ContentFrame = sectionContent, Header = headerFrame }
	AttachElementsToAPI(sectionPublic, sectionContent, currentDepth + 1)
	function sectionPublic:SetText(newText) titleLabel.Text = newText end
	return sectionPublic
end

CreateGroupBox = function(parentFrame, titleArg, currentDepth, depthOverride)
	currentDepth = depthOverride or currentDepth or 1
	if currentDepth > 3 then currentDepth = 3 end 

	local title = tostring(titleArg or "Group")
	local isOpen = false

	local wrapper = Instance.new("Frame")
	wrapper.Name = "GroupBoxWrapper_" .. title
	wrapper.Size = UDim2.new(1, 0, 0, 0)
	wrapper.BackgroundTransparency = 1
	wrapper.Parent = parentFrame
	wrapper.AutomaticSize = Enum.AutomaticSize.Y

	local groupFrame = Instance.new("Frame")
	groupFrame.Name = "GroupBoxFrame"
	groupFrame.AnchorPoint = Vector2.new(0.5, 0)
	groupFrame.Position = UDim2.new(0.5, 0, 0, 3)
	
	local scaledWidth = math.clamp(0.95 - (currentDepth - 1) * 0.02, 0.88, 0.95)
	groupFrame.Size = UDim2.new(scaledWidth, 0, 0, 0)
	groupFrame.BorderSizePixel = 0
	groupFrame.AutomaticSize = Enum.AutomaticSize.Y
	groupFrame.Parent = wrapper

	local cornerRadius = math.max(10, 18 - (currentDepth - 1) * 3)
	Instance.new("UICorner", groupFrame).CornerRadius = UDim.new(0, cornerRadius)
	
	KazeUI:AddPanel(groupFrame, 0.015 + (currentDepth * 0.008))

	local stroke = Instance.new("UIStroke", groupFrame)
	stroke.Thickness = math.max(1, 1.4 - (currentDepth - 1) * 0.15)
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	KazeUI:RegisterBorder(stroke)

	local layout = Instance.new("UIListLayout", groupFrame)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.Padding = UDim.new(0, 0)

	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, 44)
	header.BackgroundTransparency = 1
	header.LayoutOrder = 1
	header.Parent = groupFrame
	Instance.new("UICorner", header).CornerRadius = UDim.new(0, cornerRadius)

	local accentLine = Instance.new("Frame", header)
	accentLine.Size = UDim2.new(0, 4, 0, 20)
	accentLine.Position = UDim2.new(0, 14, 0.5, -10)
	accentLine.BorderSizePixel = 0
	Instance.new("UICorner", accentLine).CornerRadius = UDim.new(1, 0)
	
	KazeUI:OnThemeChanged(accentLine, function(t)
		if not isOpen then accentLine.BackgroundColor3 = t.MutedText end
	end)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -40, 1, 0)
	label.Position = UDim2.fromOffset(28, 0)
	label.BackgroundTransparency = 1
	label.Text = title
	label.Font = Enum.Font.GothamBold
	label.TextSize = math.max(11, 13 - (currentDepth - 1))
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = header
	KazeUI:RegisterText(label, false)

	local arrowIcon = Instance.new("ImageLabel")
	arrowIcon.AnchorPoint = Vector2.new(1, 0.5)
	arrowIcon.Position = UDim2.new(1, -16, 0.5, 0)
	arrowIcon.Size = UDim2.fromOffset(16, 16)
	arrowIcon.BackgroundTransparency = 1
	arrowIcon.Image = "rbxassetid://6031091004" 
	arrowIcon.Rotation = -90
	arrowIcon.Parent = header
	KazeUI:OnThemeChanged(arrowIcon, function(t)
		if not isOpen then arrowIcon.ImageColor3 = t.MutedText end
	end)

	local divider = Instance.new("Frame")
	divider.Size = UDim2.new(0.95, 0, 0, 1)
	divider.BorderSizePixel = 0
	divider.LayoutOrder = 2
	divider.Visible = false
	divider.Parent = groupFrame
	KazeUI:OnThemeChanged(divider, function(t) divider.BackgroundColor3 = t.Border end)

	local container = Instance.new("Frame")
	container.Name = "Container"
	container.Size = UDim2.new(1, 0, 0, 0)
	container.BackgroundTransparency = 1
	container.AutomaticSize = Enum.AutomaticSize.Y
	container.LayoutOrder = 3
	container.Visible = false 
	container.Parent = groupFrame

	local contentLayout = Instance.new("UIListLayout", container)
	contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	contentLayout.Padding = UDim.new(0, 5)
	contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local contentPadding = Instance.new("UIPadding", container)
	contentPadding.PaddingTop = UDim.new(0, 8)
	contentPadding.PaddingBottom = UDim.new(0, 10)
	contentPadding.PaddingLeft = UDim.new(0, 6)
	contentPadding.PaddingRight = UDim.new(0, 6)

	local toggleDetector = Instance.new("TextButton")
	toggleDetector.Size = UDim2.fromScale(1, 1)
	toggleDetector.BackgroundTransparency = 1
	toggleDetector.Text = ""
	toggleDetector.ZIndex = 10
	toggleDetector.Parent = header

	local function toggleGroup()
		isOpen = not isOpen
		container.Visible = isOpen
		divider.Visible = isOpen

		local animDuration = 0.22
		local easeStyle = Enum.EasingStyle.Quad
		local easeDir = Enum.EasingDirection.Out

		if isOpen then
			PlayTrackedTween(arrowIcon, TweenInfo.new(animDuration, easeStyle, easeDir), {
				Rotation = 0,
				ImageColor3 = KazeUI.GlowColor
			})
			PlayTrackedTween(accentLine, TweenInfo.new(animDuration, easeStyle, easeDir), {
				BackgroundColor3 = KazeUI.GlowColor
			})
			StartNeonLoop(stroke)
			StartNeonLoop(accentLine)
		else
			PlayTrackedTween(arrowIcon, TweenInfo.new(animDuration, easeStyle, easeDir), {
				Rotation = -90,
				ImageColor3 = KazeUI.CurrentTheme.MutedText
			})
			PlayTrackedTween(accentLine, TweenInfo.new(animDuration, easeStyle, easeDir), {
				BackgroundColor3 = KazeUI.CurrentTheme.MutedText
			})
			StopNeonLoop(stroke)
			StopNeonLoop(accentLine)
			stroke.Color = KazeUI.CurrentTheme.Border
			accentLine.BackgroundColor3 = KazeUI.CurrentTheme.MutedText
		end
	end

	toggleDetector.MouseEnter:Connect(function()
		if activeDialogsCount > 0 then return end
		PlayTrackedTween(header, TweenInfo.new(0.15), {BackgroundColor3 = KazeUI.GetColor(0.04), BackgroundTransparency = 0.4})
	end)
	toggleDetector.MouseLeave:Connect(function()
		PlayTrackedTween(header, TweenInfo.new(0.15), {BackgroundTransparency = 1})
	end)

	toggleDetector.MouseButton1Down:Connect(function()
		if activeDialogsCount > 0 then return end
		PlayTrackedTween(groupFrame, TweenInfo.new(0.1), {Size = UDim2.new(scaledWidth - 0.02, 0, 0, 0)})
	end)
	toggleDetector.MouseButton1Up:Connect(function()
		if activeDialogsCount > 0 then return end
		PlayTrackedTween(groupFrame, TweenInfo.new(0.1), {Size = UDim2.new(scaledWidth, 0, 0, 0)})
		toggleGroup()
	end)

	local groupPublic = {
		Frame = groupFrame,
		Container = container,
		Header = header
	}

	AttachElementsToAPI(groupPublic, container, currentDepth + 1)

	function groupPublic:SetText(newText)
		if header then
			local lbl = header:FindFirstChildOfClass("TextLabel")
			if lbl then lbl.Text = tostring(newText) end
		end
	end

	return groupPublic
end

-- ==========================================================
-- ⭐ Real-Time Minimalist UI Profiler System
-- ==========================================================
local function CreateUIProfiler()
	local widget = Instance.new("Frame")
	widget.Name = "KazeUIProfiler"
	widget.Size = UDim2.fromOffset(180, 100)
	widget.Position = UDim2.new(0, 15, 0.75, 0)
	widget.BorderSizePixel = 0
	widget.ZIndex = 99999
	Instance.new("UICorner", widget).CornerRadius = UDim.new(0, 16)
	widget.Parent = ScreenGui
	KazeUI:AddPanel(widget, 0.05)
	
	local stroke = Instance.new("UIStroke", widget)
	stroke.Thickness = 1
	KazeUI:RegisterBorder(stroke)

	local list = Instance.new("UIListLayout", widget)
	list.Padding = UDim.new(0, 4)
	list.HorizontalAlignment = Enum.HorizontalAlignment.Center
	
	local padding = Instance.new("UIPadding", widget)
	padding.PaddingTop = UDim.new(0, 8)
	padding.PaddingLeft = UDim.new(0, 10)
	padding.PaddingRight = UDim.new(0, 10)

	local function createStatLabel(text)
		local lbl = Instance.new("TextLabel")
		lbl.Size = UDim2.new(1, 0, 0, 16)
		lbl.BackgroundTransparency = 1
		lbl.Font = Enum.Font.Code
		lbl.TextSize = 10
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.Parent = widget
		KazeUI:RegisterText(lbl, false)
		return lbl
	end

	local fpsLbl = createStatLabel("FPS: --")
	local tweensLbl = createStatLabel("Active Tweens: 0")
	local memLbl = createStatLabel("UI Objects: --")
	local dragHandler = Instance.new("TextButton", widget)
	dragHandler.Size = UDim2.new(1, 0, 0, 14)
	dragHandler.BackgroundTransparency = 1
	dragHandler.Text = ":::: Drag Profiler ::::"
	dragHandler.Font = Enum.Font.GothamBold
	dragHandler.TextSize = 8
	KazeUI:RegisterText(dragHandler, true)
	MakeDraggable(dragHandler, widget)

	local lastTime = os.clock()
	local frames = 0
	local updateConnection

	updateConnection = RunService.RenderStepped:Connect(function()
		if not widget or not widget.Parent then
			updateConnection:Disconnect()
			return
		end
		frames = frames + 1
		local now = os.clock()
		if now - lastTime >= 1.0 then
			local fps = math.floor(frames / (now - lastTime))
			fpsLbl.Text = string.format("FPS: %d", fps)
			frames = 0
			lastTime = now
			
			local count = #ScreenGui:GetDescendants()
			memLbl.Text = string.format("UI Descendants: %d", count)
		end
		tweensLbl.Text = string.format("Active Tweens: %d", activeTweensCount)
	end)
end

-- ==========================================================
-- ⭐ Dynamic Real-Time Developer Component Inspector
-- ==========================================================
local isInspectorActive = false
local function CreateComponentInspector()
	if isInspectorActive then return end
	isInspectorActive = true

	local inspectWindow = Instance.new("Frame")
	inspectWindow.Name = "KazeUIInspector"
	inspectWindow.Size = UDim2.fromOffset(280, 220)
	inspectWindow.Position = UDim2.new(0.5, -140, 0.5, -110)
	inspectWindow.BorderSizePixel = 0
	inspectWindow.ZIndex = 100000
	Instance.new("UICorner", inspectWindow).CornerRadius = UDim.new(0, 20)
	inspectWindow.Parent = ScreenGui
	KazeUI:AddPanel(inspectWindow, 0.08)

	local stroke = Instance.new("UIStroke", inspectWindow)
	stroke.Thickness = 1.4
	KazeUI:RegisterBorder(stroke)

	local drag = Instance.new("Frame", inspectWindow)
	drag.Size = UDim2.new(1, 0, 0, 30)
	drag.BackgroundTransparency = 1
	MakeDraggable(drag, inspectWindow)

	local title = Instance.new("TextLabel", drag)
	title.Size = UDim2.new(1, -20, 1, 0)
	title.Position = UDim2.fromOffset(10, 0)
	title.BackgroundTransparency = 1
	title.Text = "KazeUI Inspector"
	title.Font = Enum.Font.GothamBold
	title.TextSize = 12
	title.TextXAlignment = Enum.TextXAlignment.Left
	KazeUI:RegisterText(title, false)

	local closeBtn = Instance.new("TextButton", drag)
	closeBtn.Size = UDim2.fromOffset(20, 20)
	closeBtn.Position = UDim2.new(1, -25, 0.5, -10)
	closeBtn.BackgroundTransparency = 1
	closeBtn.Text = "X"
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 12
	KazeUI:RegisterText(closeBtn, false)
	closeBtn.MouseButton1Click:Connect(function()
		inspectWindow:Destroy()
		isInspectorActive = false
	end)

	local display = Instance.new("ScrollingFrame", inspectWindow)
	display.Size = UDim2.new(1, -20, 1, -40)
	display.Position = UDim2.fromOffset(10, 35)
	display.BackgroundTransparency = 1
	display.BorderSizePixel = 0
	display.ScrollBarThickness = 3
	display.CanvasSize = UDim2.new(0, 0, 0, 250)

	local displayList = Instance.new("UIListLayout", display)
	displayList.Padding = UDim.new(0, 4)

	local targetInfo = Instance.new("TextLabel")
	targetInfo.Size = UDim2.new(1, 0, 0, 20)
	targetInfo.BackgroundTransparency = 1
	targetInfo.Text = "Hover and click component to inspect."
	targetInfo.Font = Enum.Font.GothamMedium
	targetInfo.TextSize = 11
	targetInfo.TextXAlignment = Enum.TextXAlignment.Left
	targetInfo.Parent = display
	KazeUI:RegisterText(targetInfo, false)

	local propertiesTable = {}
	local function setPropertyLabel(name, val)
		if propertiesTable[name] then
			propertiesTable[name].Text = name .. ": " .. tostring(val)
		else
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1, 0, 0, 16)
			lbl.BackgroundTransparency = 1
			lbl.Font = Enum.Font.Code
			lbl.TextSize = 10
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Text = name .. ": " .. tostring(val)
			lbl.Parent = display
			KazeUI:RegisterText(lbl, false)
			propertiesTable[name] = lbl
		end
	end

	-- Global click listener to track elements clicked in developer mode
	local inputConn
	inputConn = UIS.InputBegan:Connect(function(input)
		if not inspectWindow or not inspectWindow.Parent then
			inputConn:Disconnect()
			return
		end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local guiObjects = ScreenGui:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y)
			for _, obj in ipairs(guiObjects) do
				if obj:IsDescendantOf(ScreenGui) and obj ~= inspectWindow and not obj:IsDescendantOf(inspectWindow) then
					targetInfo.Text = "Target: " .. obj.Name
					setPropertyLabel("Type", obj.ClassName)
					setPropertyLabel("ZIndex", obj.ZIndex)
					setPropertyLabel("Size", tostring(obj.Size))
					setPropertyLabel("Position", tostring(obj.Position))
					setPropertyLabel("Visibility", tostring(obj.Visible))
					setPropertyLabel("AbsoluteSize", tostring(obj.AbsoluteSize))
					break
				end
			end
		end
	end)
end

-- ==========================================
-- Premium Window Creation & Panel Controllers
-- ==========================================
function KazeUI:CreateWindow(config)
	config = config or {}
	local Title = config.Title or "Kaze UI"
	local Author = config.Author or "Unknown"
	local Version = config.Version or "1.0"
	local MainIcon = FormatImage(config.Icon or "house")
	local OpenIcon = FormatImage((config.OpenButton and config.OpenButton.Icon) or config.Icon or "house")
	
	KazeUI.AuthorName = Author
	
	local minWidth = config.MinWidth or 350
	local minHeight = config.MinHeight or 250
	local maxWidth = config.MaxWidth or 900
	local maxHeight = config.MaxHeight or 700

	local selectedTheme = "CustomWallpaper"
	if config.Theme then
		local themeStr = tostring(config.Theme)
		local lowerTheme = string.lower(themeStr)
		
		local themeMatched = false
		for k, v in pairs(KazeUI.Themes) do
			if string.lower(k) == lowerTheme then
				selectedTheme = k
				themeMatched = true
				break
			end
		end
		
		if not themeMatched then
			local isUrl = string.find(themeStr, "^http://") or string.find(themeStr, "^https://")
			local isAssetId = tonumber(themeStr) ~= nil 
				or string.find(themeStr, "rbxassetid://") 
				or IconsMap[lowerTheme] ~= nil

			if isUrl then
				selectedTheme = themeStr 
			elseif isAssetId then
				KazeUI.Themes.CustomWallpaper.BackgroundImage = themeStr
				KazeUI.Themes.CustomWallpaper.BackgroundImageTransparency = 0.1
				KazeUI.Themes.CustomWallpaper.OverlayTransparency = 0.65
				selectedTheme = "CustomWallpaper"
			else
				selectedTheme = "CustomWallpaper"
			end
		end
	end
	
	KazeUI:SetTheme(selectedTheme)

	if config.Glow then
		local glowVal = config.Glow
		if typeof(glowVal) == "Color3" then
			KazeUI:SetGlow(glowVal)
		elseif type(glowVal) == "string" then
			local lowerGlow = string.lower(glowVal)
			local glowMap = {
				red = Color3.fromRGB(239, 68, 68),
				blue = Color3.fromRGB(0, 160, 255),
				green = Color3.fromRGB(34, 197, 94),
				["neon green"] = Color3.fromRGB(34, 197, 94),
				yellow = Color3.fromRGB(234, 179, 8),
				purple = Color3.fromRGB(150, 80, 255),
				pink = Color3.fromRGB(244, 114, 182),
				orange = Color3.fromRGB(249, 115, 22),
				white = Color3.fromRGB(255, 255, 255),
				black = Color3.fromRGB(15, 15, 17)
			}
			
			if glowMap[lowerGlow] then
				KazeUI:SetGlow(glowMap[lowerGlow])
			else
				local cleanHex = string.gsub(glowVal, "#", "")
				local s, res = pcall(function() return Color3.fromHex(cleanHex) end)
				if s and res then
					KazeUI:SetGlow(res)
				else
					KazeUI:SetGlow(Color3.fromRGB(239, 68, 68)) 
				end
			end
		end
	elseif config.GlowColor then
		local glowColorVal = config.GlowColor
		if typeof(glowColorVal) == "Color3" then
			KazeUI:SetGlow(glowColorVal)
		elseif type(glowColorVal) == "string" then
			local cleanHex = string.gsub(glowColorVal, "#", "")
			local s, res = pcall(function() return Color3.fromHex(cleanHex) end)
			if s and res then
				KazeUI:SetGlow(res)
			else
				KazeUI:SetGlow(Color3.fromRGB(239, 68, 68))
			end
		end
	else
		KazeUI:SetGlow(Color3.fromRGB(239, 68, 68))
	end

	local MiniButtonSize = UDim2.fromOffset(48, 48)

	-- Main Window Setup
	local Window = Instance.new("Frame")
	Window.Size = UDim2.fromOffset(600, 400) 
	Window.Position = UDim2.fromScale(0.5, 0.5)
	Window.AnchorPoint = Vector2.new(0.5, 0.5)
	Window.BorderSizePixel = 0
	Window.Active = true
	Window.Parent = ScreenGui
	
	Instance.new("UICorner", Window).CornerRadius = UDim.new(0, 28)
	KazeUI:AddPanel(Window, 0)

	local outerShadow = Instance.new("Frame", Window)
	outerShadow.Size = UDim2.new(1, 14, 1, 14)
	outerShadow.Position = UDim2.fromOffset(-7, -7)
	outerShadow.BackgroundTransparency = 1
	outerShadow.ZIndex = -1
	local shCorner = Instance.new("UICorner", outerShadow)
	shCorner.CornerRadius = UDim.new(0, 32)
	local shadowStroke = Instance.new("UIStroke", outerShadow)
	shadowStroke.Thickness = 6
	shadowStroke.Color = Color3.fromRGB(0, 0, 0)
	shadowStroke.Transparency = 0.8

	local WindowStroke = Instance.new("UIStroke")
	WindowStroke.Thickness = 1.8
	WindowStroke.Parent = Window
	KazeUI:RegisterBorder(WindowStroke)

	local ContentClipper = Instance.new("CanvasGroup")
	ContentClipper.Size = UDim2.fromScale(1, 1)
	ContentClipper.BackgroundTransparency = 1
	ContentClipper.BorderSizePixel = 0
	ContentClipper.Parent = Window
	Instance.new("UICorner", ContentClipper).CornerRadius = UDim.new(0, 28)

	local InteractionBlocker = Instance.new("TextButton")
	InteractionBlocker.Name = "InteractionBlocker"
	InteractionBlocker.Size = UDim2.fromScale(1, 1)
	InteractionBlocker.Position = UDim2.fromScale(0, 0)
	InteractionBlocker.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	InteractionBlocker.BackgroundTransparency = 1 
	InteractionBlocker.BorderSizePixel = 0
	InteractionBlocker.Text = ""
	InteractionBlocker.AutoButtonColor = false
	InteractionBlocker.ZIndex = 100 
	InteractionBlocker.Visible = false
	InteractionBlocker.Active = true
	InteractionBlocker.Parent = Window

	local blockerCorner = Instance.new("UICorner", InteractionBlocker)
	blockerCorner.CornerRadius = UDim.new(0, 28)

	local WallpaperImage = Instance.new("ImageLabel")
	WallpaperImage.Name = "WallpaperImage"
	WallpaperImage.Size = UDim2.fromScale(1, 1)
	WallpaperImage.BackgroundTransparency = 1
	WallpaperImage.ScaleType = Enum.ScaleType.Crop
	WallpaperImage.ZIndex = -2
	WallpaperImage.Parent = ContentClipper

	local DarkOverlay = Instance.new("Frame")
	DarkOverlay.Name = "DarkOverlay"
	DarkOverlay.Size = UDim2.fromScale(1, 1)
	DarkOverlay.BorderSizePixel = 0
	DarkOverlay.ZIndex = -1
	DarkOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	DarkOverlay.Parent = ContentClipper

	local currentTheme = KazeUI.CurrentTheme
	local initialImg = currentTheme.BackgroundImage or ""
	local initialImgTrans = currentTheme.BackgroundImageTransparency or 1
	local initialOverlayTrans = currentTheme.OverlayTransparency or 0.25
	local hasImage = (initialImg ~= "") and (initialImgTrans < 1)

	WallpaperImage.Image = FormatImage(initialImg)
	WallpaperImage.ImageTransparency = hasImage and initialImgTrans or 1
	WallpaperImage.ImageColor3 = currentTheme.BackgroundImageColor3 or Color3.fromRGB(255, 255, 255)
	DarkOverlay.BackgroundTransparency = hasImage and initialOverlayTrans or 1

	table.insert(KazeUI.WallpaperElements, {
		ImageLabel = WallpaperImage,
		OverlayFrame = DarkOverlay,
		Window = Window
	})

	Window.Destroying:Connect(function()
		for i = #KazeUI.WallpaperElements, 1, -1 do
			if KazeUI.WallpaperElements[i].Window == Window then
				table.remove(KazeUI.WallpaperElements, i)
			end
		end
	end)

	Window.Size = UDim2.fromOffset(550, 350)
	ContentClipper.GroupTransparency = 1
	PlayTrackedTween(Window, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(600, 400)})
	PlayTrackedTween(ContentClipper, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 0})

	local TopBar = Instance.new("Frame")
	TopBar.Size = UDim2.new(1, 0, 0, 52)
	TopBar.BorderSizePixel = 0
	TopBar.Active = true
	TopBar.Parent = ContentClipper
	MakeDraggable(TopBar, Window)
	KazeUI:AddPanel(TopBar, -0.01)

	local Avatar = Instance.new("ImageButton")
	Avatar.Size = UDim2.fromOffset(32, 32)
	Avatar.Position = UDim2.fromOffset(14, 10)
	Avatar.Image = MainIcon
	Avatar.ScaleType = Enum.ScaleType.Fit
	Avatar.AutoButtonColor = false
	Avatar.Parent = TopBar
	Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1, 0)
	
	local avatarStroke = Instance.new("UIStroke", Avatar)
	avatarStroke.Thickness = 1
	KazeUI:RegisterBorder(avatarStroke)

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Size = UDim2.new(1, -200, 0, 20)
	TitleLabel.Position = UDim2.fromOffset(56, 7)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = Title
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextSize = 13
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Parent = TopBar
	KazeUI:RegisterText(TitleLabel, false)

	local SubLabel = Instance.new("TextLabel")
	SubLabel.Size = UDim2.new(1, -200, 0, 16)
	SubLabel.Position = UDim2.fromOffset(56, 27)
	SubLabel.BackgroundTransparency = 1
	SubLabel.Text = Author .. " • " .. Version
	SubLabel.Font = Enum.Font.GothamMedium
	SubLabel.TextSize = 12
	SubLabel.TextXAlignment = Enum.TextXAlignment.Left
	SubLabel.Parent = TopBar
	KazeUI:RegisterText(SubLabel, false)

	local TopDivider = Instance.new("Frame")
	TopDivider.Size = UDim2.new(1, 0, 0, 1)
	TopDivider.Position = UDim2.new(0, 0, 1, -1)
	TopDivider.BorderSizePixel = 0
	TopDivider.ZIndex = 5
	TopDivider.Parent = TopBar
	KazeUI:OnThemeChanged(TopDivider, function(t) TopDivider.BackgroundColor3 = t.Border end)

	local defaultWindowSize = UDim2.fromOffset(600, 400)
	local lastNormalSize = defaultWindowSize
	local toggledMaximized = false

	local function createCircleButton(name, offsetX, color)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.fromOffset(12, 12)
		btn.Position = UDim2.new(1, offsetX, 0.5, -6)
		btn.BackgroundColor3 = color
		btn.BorderSizePixel = 0
		btn.Text = ""
		btn.Parent = TopBar
		Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
		
		local innerStroke = Instance.new("UIStroke", btn)
		innerStroke.Thickness = 1
		innerStroke.Color = Color3.fromRGB(20, 20, 22)
		return btn
	end

	local BtnGreen = createCircleButton("BtnGreen", -80, Color3.fromRGB(34, 197, 94))
	local BtnYellow = createCircleButton("BtnYellow", -56, Color3.fromRGB(234, 179, 8))
	local BtnRed = createCircleButton("BtnRed", -32, Color3.fromRGB(239, 68, 68))
	
	BtnGreen.AutoButtonColor = false
	BtnYellow.AutoButtonColor = false
	BtnRed.AutoButtonColor = false

	local MiniButton = Instance.new("TextButton") 
	MiniButton.Size = MiniButtonSize
	MiniButton.Position = UDim2.new(0, 24, 0, 85)
	MiniButton.BackgroundTransparency = 1 
	MiniButton.Text = ""
	MiniButton.Visible = false
	MiniButton.Parent = OpenButtonGui
	MiniButton.ZIndex = 999

	local MiniIcon = Instance.new("ImageLabel")
	MiniIcon.Size = UDim2.fromScale(1, 1) 
	MiniIcon.Position = UDim2.fromScale(0.5, 0.5)
	MiniIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	MiniIcon.BackgroundTransparency = 0
	MiniIcon.Image = OpenIcon
	MiniIcon.ScaleType = Enum.ScaleType.Fit
	MiniIcon.Parent = MiniButton
	MiniIcon.ZIndex = 1000
	
	Instance.new("UICorner", MiniIcon).CornerRadius = UDim.new(0, 20)
	KazeUI:AddPanel(MiniIcon, 0.02)
	KazeUI:OnThemeChanged(MiniIcon, function(t) MiniIcon.ImageColor3 = t.Text end)

	local MiniStroke = Instance.new("UIStroke")
	MiniStroke.Thickness = 1.5
	MiniStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	MiniStroke.Parent = MiniIcon 
	KazeUI:RegisterBorder(MiniStroke)

	local isMinimized = false
	local function minimizeWindow()
		if isMinimized then return end
		isMinimized = true
		
		if not toggledMaximized then
			lastNormalPosition = Window.Position
			lastNormalAnchor = Window.AnchorPoint
		end
		Window.Visible = false
		MiniButton.Visible = true
		MiniButton.Size = UDim2.fromOffset(0, 0)
		PlayTrackedTween(MiniButton, TWEEN_SPRING, {Size = MiniButtonSize})
	end

	local function unminimizeWindow()
		if not isMinimized then return end
		isMinimized = false
		
		MiniButton.Visible = false
		Window.Visible = true
		Window.Size = UDim2.fromOffset(0, 0)
		if toggledMaximized then
			Window.AnchorPoint = Vector2.new(0.5, 0.5)
			Window.Position = UDim2.fromScale(0.5, 0.5)
			PlayTrackedTween(Window, TWEEN_SPRING, {Size = UDim2.fromScale(0.95, 0.9)})
		else
			Window.AnchorPoint = lastNormalAnchor
			Window.Position = lastNormalPosition
			PlayTrackedTween(Window, TWEEN_SPRING, {Size = lastNormalSize, Position = lastNormalPosition})
		end
	end

	BtnYellow.MouseButton1Click:Connect(function()
		if activeDialogsCount > 0 then return end
		minimizeWindow()
	end)

	local miniDragStart
	local miniDragMoved = false
	
	MiniButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			miniDragStart = input.Position
			miniDragMoved = false
		end
	end)
	
	local miniDragConn1 = UIS.InputChanged:Connect(function(input)
		if miniDragStart and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			if (input.Position - miniDragStart).Magnitude > 8 then
				miniDragMoved = true
				local delta = input.Position - miniDragStart
				MiniButton.Position = UDim2.new(
					0, MiniButton.Position.X.Offset + delta.X,
					0, MiniButton.Position.Y.Offset + delta.Y
				)
				miniDragStart = input.Position
			end
		end
	end)
	
	local miniDragConn2 = UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if miniDragStart and not miniDragMoved then unminimizeWindow() end
			miniDragStart = nil
			miniDragMoved = false
		end
	end)
	
	MiniButton.Destroying:Connect(function()
		if miniDragConn1 then miniDragConn1:Disconnect() end
		if miniDragConn2 then miniDragConn2:Disconnect() end
	end)

	BtnGreen.MouseButton1Click:Connect(function()
		if activeDialogsCount > 0 then return end
		if not toggledMaximized then
			lastNormalSize = Window.Size
			lastNormalPosition = Window.Position
			lastNormalAnchor = Vector2.new(0.5, 0.5)
			toggledMaximized = true
			Window.AnchorPoint = Vector2.new(0.5, 0.5)
			Window.Position = UDim2.fromScale(0.5, 0.5)
			PlayTrackedTween(Window, TWEEN_SMOOTH, {Size = UDim2.fromScale(0.95, 0.9)})
		else
			toggledMaximized = false
			PlayTrackedTween(Window, TWEEN_SMOOTH, {Size = lastNormalSize, Position = lastNormalPosition})
			task.delay(0.25, function() Window.AnchorPoint = lastNormalAnchor end)
		end
	end)

	local confirmActive = false
	local function ShowCloseConfirm()
		if confirmActive then return end
		confirmActive = true
		activeDialogsCount = activeDialogsCount + 1
		BtnYellow.Active = false; BtnGreen.Active = false; BtnRed.Active = false
		
		InteractionBlocker.Visible = true
		PlayTrackedTween(InteractionBlocker, TWEEN_FAST, {BackgroundTransparency = 0.65})

		local ConfirmWindow = Instance.new("Frame", Window) 
		ConfirmWindow.Name = "ExitConfirmDialog"
		ConfirmWindow.Size = UDim2.fromOffset(340, 140)
		ConfirmWindow.AnchorPoint = Vector2.new(0.5, 0.5)
		ConfirmWindow.Position = UDim2.fromScale(0.5, 0.45)
		ConfirmWindow.ZIndex = 101 
		ConfirmWindow.Active = true 
		Instance.new("UICorner", ConfirmWindow).CornerRadius = UDim.new(0, 20)
		KazeUI:AddPanel(ConfirmWindow, 0.02)

		local confirmStroke = Instance.new("UIStroke", ConfirmWindow)
		confirmStroke.Thickness = 1.2
		KazeUI:RegisterBorder(confirmStroke)

		PlayTrackedTween(ConfirmWindow, TWEEN_SPRING, {Position = UDim2.fromScale(0.5, 0.5)})

		local ConfirmText = Instance.new("TextLabel", ConfirmWindow)
		ConfirmText.Size = UDim2.new(1, -40, 0, 50)
		ConfirmText.Position = UDim2.fromOffset(20, 15)
		ConfirmText.BackgroundTransparency = 1
		ConfirmText.Text = "Do you want to exit KazeUI?"
		ConfirmText.Font = Enum.Font.GothamBold
		ConfirmText.TextSize = 13
		ConfirmText.TextWrapped = true
		ConfirmText.ZIndex = 102
		KazeUI:RegisterText(ConfirmText, false)

		local ButtonsFrame = Instance.new("Frame", ConfirmWindow)
		ButtonsFrame.Size = UDim2.new(1, 0, 0, 40)
		ButtonsFrame.Position = UDim2.new(0, 0, 1, -12)
		ButtonsFrame.AnchorPoint = Vector2.new(0, 1)
		ButtonsFrame.BackgroundTransparency = 1
		ButtonsFrame.ZIndex = 102
		local layout = Instance.new("UIListLayout", ButtonsFrame)
		layout.FillDirection = Enum.FillDirection.Horizontal
		layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		layout.Padding = UDim.new(0, 12)

		local ConfirmBtn = Instance.new("TextButton", ButtonsFrame)
		ConfirmBtn.Size = UDim2.new(0, 100, 0, 30)
		ConfirmBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
		ConfirmBtn.Text = "Confirm"
		ConfirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		ConfirmBtn.Font = Enum.Font.GothamBold
		ConfirmBtn.TextSize = 11
		ConfirmBtn.ZIndex = 103
		Instance.new("UICorner", ConfirmBtn).CornerRadius = UDim.new(0, 10)

		local CancelBtn = Instance.new("TextButton", ButtonsFrame)
		CancelBtn.Size = UDim2.new(0, 100, 0, 30)
		CancelBtn.Text = "Cancel"
		CancelBtn.Font = Enum.Font.GothamBold
		CancelBtn.TextSize = 11
		CancelBtn.ZIndex = 103
		Instance.new("UICorner", CancelBtn).CornerRadius = UDim.new(0, 10)
		KazeUI:AddPanel(CancelBtn, 0.04)
		KazeUI:RegisterText(CancelBtn, true)

		ConfirmBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
		CancelBtn.MouseButton1Click:Connect(function() 
			PlayTrackedTween(InteractionBlocker, TWEEN_FAST, {BackgroundTransparency = 1})
			local tw = PlayTrackedTween(ConfirmWindow, TWEEN_FAST, {Position = UDim2.fromScale(0.5, 0.45)})
			tw.Completed:Wait()
			ConfirmWindow:Destroy()
			InteractionBlocker.Visible = false
			confirmActive = false
			activeDialogsCount = math.max(0, activeDialogsCount - 1)
			BtnYellow.Active = true; BtnGreen.Active = true; BtnRed.Active = true 
		end)
	end
	BtnRed.MouseButton1Click:Connect(function()
		if activeDialogsCount > 0 then return end
		ShowCloseConfirm()
	end)

	local Content = Instance.new("Frame")
	Content.Position = UDim2.fromOffset(0, 52)
	Content.Size = UDim2.new(1, 0, 1, -52)
	Content.BackgroundTransparency = 1
	Content.Parent = ContentClipper

	local SideBarMask = Instance.new("Frame")
	SideBarMask.Size = UDim2.new(0, 190, 1, 0)
	SideBarMask.BackgroundTransparency = 1
	SideBarMask.ClipsDescendants = true
	SideBarMask.Parent = Content

	local SideBar = Instance.new("Frame")
	SideBar.Size = UDim2.new(0, 190, 1, 0) 
	SideBar.BorderSizePixel = 0
	SideBar.Parent = SideBarMask
	KazeUI:AddPanel(SideBar, 0.01)

	local VertDivider = Instance.new("Frame")
	VertDivider.Size = UDim2.new(0, 1, 1, 0)
	VertDivider.Position = UDim2.new(0, 190, 0, 0)
	VertDivider.BorderSizePixel = 0
	VertDivider.Parent = Content
	KazeUI:OnThemeChanged(VertDivider, function(t) VertDivider.BackgroundColor3 = t.Border end)

	local Pages = Instance.new("Frame")
	Pages.Position = UDim2.new(0, 191, 0, 0)
	Pages.Size = UDim2.new(1, -191, 1, 0)
	Pages.BorderSizePixel = 0
	Pages.Parent = Content
	KazeUI:AddPanel(Pages, -0.01)

	local isSidebarOpen = true
	Avatar.MouseButton1Click:Connect(function()
		if activeDialogsCount > 0 then return end
		isSidebarOpen = not isSidebarOpen
		local tInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
		if isSidebarOpen then
			PlayTrackedTween(SideBarMask, tInfo, {Size = UDim2.new(0, 190, 1, 0)})
			PlayTrackedTween(VertDivider, tInfo, {Position = UDim2.new(0, 190, 0, 0), BackgroundTransparency = 0})
			PlayTrackedTween(Pages, tInfo, {Position = UDim2.new(0, 191, 0, 0), Size = UDim2.new(1, -191, 1, 0)})
		else
			PlayTrackedTween(SideBarMask, tInfo, {Size = UDim2.new(0, 0, 1, 0)})
			PlayTrackedTween(VertDivider, tInfo, {Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1})
			PlayTrackedTween(Pages, tInfo, {Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(1, 0, 1, 0)})
		end
	end)

	local TabsScroller = Instance.new("ScrollingFrame")
	TabsScroller.Parent = SideBar
	TabsScroller.Position = UDim2.fromOffset(8, 8)
	TabsScroller.Size = UDim2.new(1, -16, 1, -16)
	TabsScroller.BackgroundTransparency = 1
	TabsScroller.ScrollBarThickness = 4
	TabsScroller.CanvasSize = UDim2.new(0, 0, 0, 0)
	TabsScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
	TabsScroller.ScrollBarImageColor3 = Color3.fromRGB(40, 40, 45)

	local TabsList = Instance.new("Frame")
	TabsList.BackgroundTransparency = 1
	TabsList.Size = UDim2.new(1, 0, 0, 0)
	TabsList.Parent = TabsScroller
	TabsList.AutomaticSize = Enum.AutomaticSize.Y

	local tabsLayout = Instance.new("UIListLayout", TabsList)
	tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabsLayout.Padding = UDim.new(0, 5)

	-- ==========================================
	-- Modal Resize Engine (System Rewrite)
	-- ==========================================
	local ResizeBlocker = Instance.new("TextButton")
	ResizeBlocker.Name = "ResizeInputBlocker"
	ResizeBlocker.Size = UDim2.fromScale(100, 100)
	ResizeBlocker.Position = UDim2.fromScale(-50, -50)
	ResizeBlocker.BackgroundTransparency = 1
	ResizeBlocker.Text = ""
	ResizeBlocker.ZIndex = 99998
	ResizeBlocker.Visible = false
	ResizeBlocker.Parent = Window
	
	local ResizeHandle = Instance.new("ImageLabel")
	ResizeHandle.Name = "ResizeHandle"
	ResizeHandle.Size = UDim2.fromOffset(24, 24)
	ResizeHandle.Position = UDim2.new(1, -20, 1, -20)
	ResizeHandle.BackgroundTransparency = 1
	ResizeHandle.Image = "rbxassetid://10747373117"
	ResizeHandle.Active = true
	ResizeHandle.ZIndex = 99999
	ResizeHandle.Parent = Window
	KazeUI:OnThemeChanged(ResizeHandle, function(t) ResizeHandle.ImageColor3 = t.MutedText end)

	KazeUI.IsResizing = false
	local resizeStartSize = Vector2.new(0, 0)
	local resizeStartPos = Vector2.new(0, 0)
	local resizeTouchID = nil

	local hoverCursor = "rbxassetid://10747373117"
	ResizeHandle.MouseEnter:Connect(function()
		if activeDialogsCount > 0 then return end
		if not KazeUI.IsResizing and not toggledMaximized then
			Mouse.Icon = hoverCursor
			PlayTrackedTween(ResizeHandle, TweenInfo.new(0.12), {ImageColor3 = KazeUI.GlowColor})
		end
	end)

	ResizeHandle.MouseLeave:Connect(function()
		if not KazeUI.IsResizing then
			Mouse.Icon = ""
			PlayTrackedTween(ResizeHandle, TweenInfo.new(0.12), {ImageColor3 = KazeUI.CurrentTheme.MutedText})
		end
	end)

	local function UpdateResize(inputPos)
		local delta = inputPos - resizeStartPos
		local scale = UIScale.Scale

		local newWidth = math.clamp(resizeStartSize.X + (delta.X / scale), minWidth, maxWidth)
		local newHeight = math.clamp(resizeStartSize.Y + (delta.Y / scale), minHeight, maxHeight)

		Window.Size = UDim2.fromOffset(newWidth, newHeight)
		lastNormalSize = Window.Size
	end

	ResizeHandle.InputBegan:Connect(function(input)
		if activeDialogsCount > 0 then return end
		if toggledMaximized then return end
		if KazeUI.IsResizing then return end 

		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			KazeUI.IsResizing = true
			resizeTouchID = input

			resizeStartSize = Vector2.new(Window.AbsoluteSize.X / UIScale.Scale, Window.AbsoluteSize.Y / UIScale.Scale)
			resizeStartPos = Vector2.new(input.Position.X, input.Position.Y)

			ResizeBlocker.Visible = true
			LockCamera()
			Mouse.Icon = hoverCursor
			PlayTrackedTween(ResizeHandle, TweenInfo.new(0.12), {ImageColor3 = KazeUI.GlowColor})
		end
	end)

	local resizeConn1 = UIS.InputChanged:Connect(function(input)
		if KazeUI.IsResizing and input == resizeTouchID then
			UpdateResize(Vector2.new(input.Position.X, input.Position.Y))
		end
	end)

	local resizeConn2 = UIS.InputEnded:Connect(function(input)
		if KazeUI.IsResizing and input == resizeTouchID then
			KazeUI.IsResizing = false
			resizeTouchID = nil
			
			ResizeBlocker.Visible = false
			UnlockCamera()
			Mouse.Icon = ""
			PlayTrackedTween(ResizeHandle, TweenInfo.new(0.12), {ImageColor3 = KazeUI.CurrentTheme.MutedText})
		end
	end)
	
	ResizeHandle.Destroying:Connect(function()
		if resizeConn1 then resizeConn1:Disconnect() end
		if resizeConn2 then resizeConn2:Disconnect() end
	end)

	local Win = {
		Window = Window,
		ScreenGui = ScreenGui,
		_Pages = Pages,
		_TabsList = TabsList,
		_Tabs = {},
		Minimize = function(self) minimizeWindow() end,
		Show = function(self) unminimizeWindow() end,
		Maximize = function(self) unminimizeWindow() end,
		Toggle = function(self)
			if isMinimized or not Window.Visible then
				self:Show()
			else
				self:Minimize()
			end
		end
	}

	-- Profiler and Inspector exposure on Window API
	function Win:EnableProfiler()
		CreateUIProfiler()
	end

	function Win:EnableInspector()
		CreateComponentInspector()
	end

	-- ==========================================
	-- ⭐ Raycast / VSCode Style Command Palette
	-- ==========================================
	local paletteOpen = false
	function Win:ShowCommandPalette()
		if paletteOpen then return end
		paletteOpen = true
		
		local pBlocker = Instance.new("TextButton", ScreenGui)
		pBlocker.Size = UDim2.fromScale(1, 1)
		pBlocker.BackgroundTransparency = 1
		pBlocker.Text = ""
		
		local palette = Instance.new("Frame", ScreenGui)
		palette.Size = UDim2.fromOffset(420, 300)
		palette.Position = UDim2.new(0.5, -210, 0.2, 0)
		palette.BorderSizePixel = 0
		palette.ZIndex = 150000
		Instance.new("UICorner", palette).CornerRadius = UDim.new(0, 20)
		KazeUI:AddPanel(palette, 0.08)
		
		local pStroke = Instance.new("UIStroke", palette)
		pStroke.Thickness = 1.6
		KazeUI:RegisterBorder(pStroke)
		
		local pSearch = Instance.new("TextBox", palette)
		pSearch.Size = UDim2.new(1, -30, 0, 36)
		pSearch.Position = UDim2.fromOffset(15, 15)
		pSearch.BorderSizePixel = 0
		pSearch.PlaceholderText = "Search features, commands, configs..."
		pSearch.Text = ""
		pSearch.Font = Enum.Font.GothamMedium
		pSearch.TextSize = 12
		pSearch.ClearTextOnFocus = false
		Instance.new("UICorner", pSearch).CornerRadius = UDim.new(0, 10)
		KazeUI:AddPanel(pSearch, -0.01)
		KazeUI:RegisterText(pSearch, false)
		
		local sStroke = Instance.new("UIStroke", pSearch)
		KazeUI:RegisterBorder(sStroke)
		
		local results = Instance.new("ScrollingFrame", palette)
		results.Size = UDim2.new(1, -30, 1, -80)
		results.Position = UDim2.fromOffset(15, 65)
		results.BackgroundTransparency = 1
		results.BorderSizePixel = 0
		results.ScrollBarThickness = 3
		results.CanvasSize = UDim2.new(0, 0, 0, 0)
		results.AutomaticCanvasSize = Enum.AutomaticSize.Y
		
		local rLayout = Instance.new("UIListLayout", results)
		rLayout.Padding = UDim.new(0, 4)
		
		local function closePalette()
			paletteOpen = false
			pBlocker:Destroy()
			palette:Destroy()
		end
		
		pBlocker.MouseButton1Click:Connect(closePalette)
		
		local function updateSearch(query)
			for _, child in ipairs(results:GetChildren()) do
				if child:IsA("TextButton") then child:Destroy() end
			end
			query = string.lower(query)
			
			-- Generate dynamic features and active configs list
			local commands = {
				{Name = "Toggle Explorer Side Panel", Callback = function() Avatar:MouseButton1Click() end},
				{Name = "Save Global Config", Callback = function() KazeUI:SaveConfig("AutoSave") end},
				{Name = "Switch Theme to Obsidian", Callback = function() KazeUI:SetTheme("Obsidian") end},
				{Name = "Switch Theme to Custom", Callback = function() KazeUI:SetTheme("CustomWallpaper") end},
				{Name = "Minimize Windows Console", Callback = function() minimizeWindow() end},
				{Name = "Close Library Controller", Callback = function() ScreenGui:Destroy() end}
			}
			
			for flag, flagData in pairs(KazeUI.Flags) do
				table.insert(commands, {
					Name = "Toggle Flag Value: " .. flag,
					Callback = function()
						if type(flagData.Get()) == "boolean" then
							flagData.Set(not flagData.Get())
						end
					end
				})
			end
			
			for _, cmd in ipairs(commands) do
				if query == "" or string.find(string.lower(cmd.Name), query, 1, true) then
					local item = Instance.new("TextButton", results)
					item.Size = UDim2.new(1, 0, 0, 32)
					item.BorderSizePixel = 0
					item.Text = "  " .. cmd.Name
					item.Font = Enum.Font.GothamMedium
					item.TextSize = 11
					item.TextXAlignment = Enum.TextXAlignment.Left
					Instance.new("UICorner", item).CornerRadius = UDim.new(0, 8)
					KazeUI:AddPanel(item, 0.02, true)
					KazeUI:RegisterText(item, false)
					
					item.MouseButton1Click:Connect(function()
						pcall(cmd.Callback)
						closePalette()
					end)
				end
			end
		end
		
		pSearch:GetPropertyChangedSignal("Text"):Connect(function()
			updateSearch(pSearch.Text)
		end)
		
		updateSearch("")
		pSearch:CaptureFocus()
	end

	-- Hook keybind to invoke Command Palette (Shift + P)
	UIS.InputBegan:Connect(function(input, gp)
		if not gp then
			if input.KeyCode == Enum.KeyCode.P and (UIS:IsKeyDown(Enum.KeyCode.LeftShift) or UIS:IsKeyDown(Enum.KeyCode.RightShift)) then
				Win:ShowCommandPalette()
			end
		end
	end)

	function Win:Notify(...)
		return KazeUI:Notify(...)
	end

	-- ==========================================================
	-- Premium Floating Dialog Component (CRITICAL INPUT LOCKOUT)
	-- ==========================================================
	function Win:Dialog(dialogConfig)
		dialogConfig = dialogConfig or {}
		local title = tostring(dialogConfig.Title or "Dialog")
		local content = tostring(dialogConfig.Content or "")
		local iconId = dialogConfig.Icon and FormatImage(dialogConfig.Icon) or ""
		local hasIcon = (iconId ~= "")
		local actions = dialogConfig.Actions or {}
		
		activeDialogsCount = activeDialogsCount + 1
		
		InteractionBlocker.Visible = true
		PlayTrackedTween(InteractionBlocker, TWEEN_FAST, {BackgroundTransparency = 0.65})

		local DialogFrame = Instance.new("Frame", Window) 
		DialogFrame.Name = "WindowDialog"
		DialogFrame.Size = UDim2.fromOffset(380, 200) 
		DialogFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		DialogFrame.Position = UDim2.fromScale(0.5, 0.4) 
		DialogFrame.ZIndex = 101 
		DialogFrame.Active = true 
		
		Instance.new("UICorner", DialogFrame).CornerRadius = UDim.new(0, 20)
		KazeUI:AddPanel(DialogFrame, 0.04)

		local stroke = Instance.new("UIStroke", DialogFrame)
		stroke.Thickness = 1.4
		KazeUI:RegisterBorder(stroke)

		PlayTrackedTween(DialogFrame, TWEEN_SPRING, {Position = UDim2.fromScale(0.5, 0.5)})

		local topOffset = 18
		if hasIcon then
			local dIcon = Instance.new("ImageLabel", DialogFrame)
			dIcon.Size = UDim2.fromOffset(36, 36)
			dIcon.Position = UDim2.new(0.5, -18, 0, 18)
			dIcon.BackgroundTransparency = 1
			dIcon.Image = iconId
			dIcon.ZIndex = 102
			KazeUI:OnThemeChanged(dIcon, function(t) dIcon.ImageColor3 = KazeUI.GlowColor end)
			topOffset = 62
		end

		local titleLabel = Instance.new("TextLabel", DialogFrame)
		titleLabel.Size = UDim2.new(1, -40, 0, 22)
		titleLabel.Position = UDim2.fromOffset(20, topOffset)
		titleLabel.BackgroundTransparency = 1
		titleLabel.Text = title
		titleLabel.Font = Enum.Font.GothamBold
		titleLabel.TextSize = 14
		titleLabel.TextXAlignment = Enum.TextXAlignment.Center
		titleLabel.ZIndex = 102
		KazeUI:RegisterText(titleLabel, false)

		local contentLabel = Instance.new("TextLabel", DialogFrame)
		contentLabel.Size = UDim2.new(1, -40, 0, 48)
		contentLabel.Position = UDim2.fromOffset(20, topOffset + 24)
		contentLabel.BackgroundTransparency = 1
		contentLabel.Text = content
		contentLabel.Font = Enum.Font.Gotham
		contentLabel.TextSize = 11
		contentLabel.TextWrapped = true
		contentLabel.TextXAlignment = Enum.TextXAlignment.Center
		contentLabel.TextYAlignment = Enum.TextYAlignment.Top
		contentLabel.ZIndex = 102
		KazeUI:RegisterText(contentLabel, true)

		local ActionsFrame = Instance.new("Frame", DialogFrame)
		ActionsFrame.Position = UDim2.new(0, 15, 1, -15)
		ActionsFrame.AnchorPoint = Vector2.new(0, 1)
		ActionsFrame.BackgroundTransparency = 1
		ActionsFrame.ZIndex = 102

		local listLayout = Instance.new("UIListLayout", ActionsFrame)
		listLayout.SortOrder = Enum.SortOrder.LayoutOrder
		listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		listLayout.Padding = UDim.new(0, 8)

		local totalActions = #actions
		local shouldStack = (totalActions >= 4) 

		if shouldStack then
			listLayout.FillDirection = Enum.FillDirection.Vertical
			ActionsFrame.Size = UDim2.new(1, -30, 0, (totalActions * 32) + ((totalActions - 1) * 8))
		else
			listLayout.FillDirection = Enum.FillDirection.Horizontal
			ActionsFrame.Size = UDim2.new(1, -30, 0, 32)
		end

		local function closeDialog()
			PlayTrackedTween(InteractionBlocker, TWEEN_FAST, {BackgroundTransparency = 1})
			local tw = PlayTrackedTween(DialogFrame, TWEEN_FAST, {Position = UDim2.fromScale(0.5, 0.4)})
			tw.Completed:Wait()
			DialogFrame:Destroy()
			InteractionBlocker.Visible = false
			activeDialogsCount = math.max(0, activeDialogsCount - 1)
		end

		local buttonWidth = shouldStack and 350 or (totalActions > 0 and (350 - ((totalActions - 1) * 8)) / totalActions or 100)

		for i, act in ipairs(actions) do
			local btnName = act.Name or "Button"
			local callback = act.Callback
			
			local actionBtn = Instance.new("TextButton", ActionsFrame)
			actionBtn.Size = UDim2.new(0, buttonWidth, 0, 32)
			actionBtn.ZIndex = 103
			actionBtn.AutoButtonColor = false
			actionBtn.Text = "" 
			actionBtn.LayoutOrder = i
			Instance.new("UICorner", actionBtn).CornerRadius = UDim.new(0, 10)

			local btnText = Instance.new("TextLabel", actionBtn)
			btnText.Size = UDim2.new(1, -12, 1, 0)
			btnText.Position = UDim2.fromOffset(6, 0)
			btnText.BackgroundTransparency = 1
			btnText.Text = btnName
			btnText.Font = Enum.Font.GothamBold
			btnText.TextSize = 11
			btnText.TextWrapped = true
			btnText.TextScaled = true 
			btnText.ZIndex = 104

			local textConstraint = Instance.new("UITextSizeConstraint", btnText)
			textConstraint.MaxTextSize = 11
			textConstraint.MinTextSize = 7

			local btnColor = act.Color
			if type(btnColor) == "string" then
				local cleanHex = string.gsub(btnColor, "#", "")
				local s, res = pcall(function() return Color3.fromHex(cleanHex) end)
				if s and res then btnColor = res else btnColor = KazeUI.GlowColor end
			elseif typeof(btnColor) ~= "Color3" then
				btnColor = nil 
			end

			if btnColor then
				actionBtn.BackgroundColor3 = btnColor
				btnText.TextColor3 = Color3.fromRGB(255, 255, 255)
			else
				KazeUI:AddPanel(actionBtn, 0.04)
				KazeUI:RegisterText(btnText, false)
			end

			local isHovered = false
			actionBtn.MouseEnter:Connect(function()
				isHovered = true
				if btnColor then
					local h, s, v = Color3.toHSV(btnColor)
					PlayTrackedTween(actionBtn, TWEEN_FAST, {BackgroundColor3 = Color3.fromHSV(h, s, math.clamp(v - 0.1, 0, 1))})
				else
					PlayTrackedTween(actionBtn, TWEEN_FAST, {BackgroundColor3 = KazeUI.GetColor(0.06)})
				end
			end)
			actionBtn.MouseLeave:Connect(function()
				isHovered = false
				if btnColor then
					PlayTrackedTween(actionBtn, TWEEN_FAST, {BackgroundColor3 = btnColor})
				else
					PlayTrackedTween(actionBtn, TWEEN_FAST, {BackgroundColor3 = KazeUI.GetColor(0.04)})
				end
			end)

			actionBtn.MouseButton1Click:Connect(function()
				task.spawn(function()
					if type(callback) == "function" then
						pcall(callback)
					end
				end)
				closeDialog()
			end)
		end

		local actionsHeight = shouldStack and ((totalActions * 32) + ((totalActions - 1) * 8)) or 32
		local finalHeight = topOffset + 24 + 48 + 15 + actionsHeight + 15
		DialogFrame.Size = UDim2.fromOffset(380, finalHeight)

		return {
			Close = closeDialog
		}
	end

	function Win:CreateConfigManager(tab)
		local sec = tab:SectionUI("Config Manager")
		local cfgName = "Default"

		local function getConfigs()
			local list = {}
			local folder = KazeUI.AuthorName
			
			if makefolder then
				pcall(function()
					if isfolder and not isfolder(folder) then makefolder(folder)
					elseif not isfolder then makefolder(folder) end
				end)
			end
			
			if listfiles then
				local s, files = pcall(function() return listfiles(folder) end)
				if s and type(files) == "table" then
					for _, f in ipairs(files) do
						local fileName = string.match(f, "([^/\\]+)$") or f
						local name = string.match(fileName, "^(.+)%.json$")
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
				local folder = KazeUI.AuthorName
				pcall(function() delfile(folder .. "/" .. cfgName .. ".json") end)
				KazeUI:Notify({Title = "Config System", Content = "Deleted " .. cfgName, Duration = 3})
				if configDropdown then configDropdown:Refresh(getConfigs()) end
			else
				KazeUI:Notify({Title = "Error", Content = "Your executor lacks 'delfile' support.", Duration = 3})
			end
		end})
	end

	function Win:CreateThemeManager(tab)
		local sec = tab:SectionUI("Theme & Visuals")
		
		local themeNames = {}
		for name, _ in pairs(KazeUI.Themes) do table.insert(themeNames, name) end
		table.sort(themeNames)

		sec:Dropdown({
			Title = "Interface Theme Preset",
			Options = themeNames,
			Default = KazeUI.CurrentTheme.Name,
			Flag = "KazeUI_Theme_Preset",
			Callback = function(val) KazeUI:SetTheme(val) end
		})

		sec:ColorPicker({
			Title = "Accent Glow Color",
			Default = KazeUI.GlowColor,
			Flag = "KazeUI_Theme_GlowColor", 
			Callback = function(color) KazeUI:SetGlow(color) end
		})

		sec:Slider({
			Title = "UI Background Transparency",
			Min = 0,
			Max = 10,
			Default = math.floor(KazeUI.BackgroundTransparency * 10),
			Flag = "KazeUI_Theme_BackgroundTransparency", 
			Callback = function(val) KazeUI:SetTransparency(val / 10) end
		})

		local wpSec = tab:SectionUI("Premium Wallpaper System")

		wpSec:TextBox({
			Title = "Custom Background Image ID / URL",
			Placeholder = "rbxassetid://ID or HTTPS Image Link",
			Default = KazeUI.CurrentTheme.BackgroundImage or "",
			Flag = "KazeUI_Wallpaper_AssetID",
			Callback = function(val)
				local cleanVal = FormatImage(val)
				KazeUI.CurrentTheme.BackgroundImage = val
				for _, wp in ipairs(KazeUI.WallpaperElements) do
					if wp.ImageLabel and wp.ImageLabel.Parent then
						wp.ImageLabel.Image = cleanVal
						local hasImg = val ~= ""
						PlayTrackedTween(wp.ImageLabel, TWEEN_SMOOTH, {
							ImageTransparency = hasImg and (KazeUI.CurrentTheme.BackgroundImageTransparency or 0) or 1
						})
						PlayTrackedTween(wp.OverlayFrame, TWEEN_SMOOTH, {
							BackgroundTransparency = hasImg and (KazeUI.CurrentTheme.OverlayTransparency or 0.7) or 1
						})
					end
				end
			end
		})

		wpSec:Slider({
			Title = "Wallpaper Transparency",
			Min = 0,
			Max = 100,
			Default = math.floor((KazeUI.CurrentTheme.BackgroundImageTransparency or 0) * 100),
			Flag = "KazeUI_Wallpaper_Transparency",
			Callback = function(val)
				local trans = val / 100
				KazeUI.CurrentTheme.BackgroundImageTransparency = trans
				for _, wp in ipairs(KazeUI.WallpaperElements) do
					if wp.ImageLabel and wp.ImageLabel.Parent and (KazeUI.CurrentTheme.BackgroundImage or "") ~= "" then
						PlayTrackedTween(wp.ImageLabel, TWEEN_FAST, {ImageTransparency = trans})
					end
				end
			end
		})

		wpSec:Slider({
			Title = "Soft Dark Overlay Density",
			Min = 0,
			Max = 100,
			Default = math.floor((KazeUI.CurrentTheme.OverlayTransparency or 0.70) * 100),
			Flag = "KazeUI_Wallpaper_OverlayDensity",
			Callback = function(val)
				local trans = val / 100
				KazeUI.CurrentTheme.OverlayTransparency = trans
				for _, wp in ipairs(KazeUI.WallpaperElements) do
					if wp.OverlayFrame and wp.OverlayFrame.Parent then
						PlayTrackedTween(wp.OverlayFrame, TWEEN_FAST, {BackgroundTransparency = trans})
					end
				end
			end
		})
	end

	function Win:CreateTab(arg1, arg2)
		local name = tostring(type(arg1) == "table" and (arg1.Title or arg1.Name) or arg1 or "Tab")
		local iconId = type(arg1) == "table" and arg1.Icon or arg2
		local formattedIcon = FormatImage(iconId or "")
		
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, -12, 0, 42)
		btn.BorderSizePixel = 0
		btn.Text = ""
		btn.AutoButtonColor = false
		btn.Parent = TabsList
		btn.ClipsDescendants = true
		btn.LayoutOrder = #TabsList:GetChildren() + 1
		
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 14)
		KazeUI:AddPanel(btn, 0.02, true)

		local leftIndicator = Instance.new("Frame", btn)
		leftIndicator.Size = UDim2.new(0, 3, 1, 0)
		leftIndicator.BackgroundColor3 = KazeUI.GlowColor
		leftIndicator.BorderSizePixel = 0
		leftIndicator.Visible = false
		
		local indicatorCorner = Instance.new("UICorner", leftIndicator)
		indicatorCorner.CornerRadius = UDim.new(0, 6)

		KazeUI:OnGlowChanged(leftIndicator, function(c) leftIndicator.BackgroundColor3 = c end)

		local iconLabel = Instance.new("ImageLabel", btn)
		iconLabel.Size = UDim2.fromOffset(20, 20)
		iconLabel.Position = UDim2.new(0, 14, 0.5, -10)
		iconLabel.BackgroundTransparency = 1
		iconLabel.Image = formattedIcon
		iconLabel.ScaleType = Enum.ScaleType.Fit
		iconLabel.Parent = btn
		
		local txt = Instance.new("TextLabel", btn)
		txt.Size = UDim2.new(1, -48, 1, 0)
		txt.Position = UDim2.fromOffset(42, 0)
		txt.BackgroundTransparency = 1
		txt.Text = name
		txt.Font = Enum.Font.Gotham
		txt.TextScaled = true 
		txt.TextWrapped = true 
		
		local textConstraint = Instance.new("UITextSizeConstraint", txt)
		textConstraint.MaxTextSize = 12
		textConstraint.MinTextSize = 8
		
		txt.TextXAlignment = Enum.TextXAlignment.Left
		txt.Parent = btn

		local page = Instance.new("Frame")
		page.Size = UDim2.new(1, 0, 1, 0)
		page.BackgroundTransparency = 1
		page.Visible = false
		page.Parent = self._Pages

		local pageContent = Instance.new("ScrollingFrame", page)
		pageContent.Size = UDim2.new(1, 0, 1, 0)
		pageContent.BackgroundTransparency = 1
		pageContent.BorderSizePixel = 0
		pageContent.ScrollBarThickness = 3
		pageContent.CanvasSize = UDim2.new(0, 0, 0, 0)
		pageContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
		pageContent.ScrollBarImageColor3 = Color3.fromRGB(40, 40, 45)

		-- Apply ⭐ Animated Layout Engine to Tab Page
		local triggerLayoutAnims = CreateAnimatedLayout(pageContent, 6)

		local pagePadding = Instance.new("UIPadding", pageContent)
		pagePadding.PaddingTop = UDim.new(0, 10)
		pagePadding.PaddingBottom = UDim.new(0, 10)
		pagePadding.PaddingLeft = UDim.new(0, 10)
		pagePadding.PaddingRight = UDim.new(0, 10)

		local EmptyState = Instance.new("CanvasGroup")
		EmptyState.Name = "EmptyState"
		EmptyState.Size = UDim2.fromScale(1, 1)
		EmptyState.BackgroundTransparency = 1
		EmptyState.BorderSizePixel = 0
		EmptyState.GroupTransparency = 1
		EmptyState.Visible = true
		EmptyState.ZIndex = 5
		EmptyState.Parent = page

		local CenterContent = Instance.new("Frame")
		CenterContent.Name = "CenterContent"
		CenterContent.Size = UDim2.fromScale(1, 1)
		CenterContent.AnchorPoint = Vector2.new(0.5, 0.5)
		CenterContent.Position = UDim2.fromScale(0.5, 0.5)
		CenterContent.BackgroundTransparency = 1
		CenterContent.Parent = EmptyState

		local stateScale = Instance.new("UIScale", CenterContent)
		stateScale.Scale = 0.95

		local stateLayout = Instance.new("UIListLayout", CenterContent)
		stateLayout.FillDirection = Enum.FillDirection.Vertical
		stateLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		stateLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		stateLayout.Padding = UDim.new(0, 12)

		local stateIcon = Instance.new("ImageLabel", CenterContent)
		stateIcon.Size = UDim2.fromOffset(64, 64)
		stateIcon.Image = "rbxassetid://101768155599700"
		stateIcon.BackgroundTransparency = 1
		stateIcon.ImageTransparency = 0.3
		KazeUI:OnThemeChanged(stateIcon, function(t) stateIcon.ImageColor3 = t.MutedText end)

		local stateTitle = Instance.new("TextLabel", CenterContent)
		stateTitle.Size = UDim2.new(0.9, 0, 0, 20)
		stateTitle.BackgroundTransparency = 1
		stateTitle.Text = "Nothing here yet"
		stateTitle.Font = Enum.Font.GothamBold
		stateTitle.TextSize = 14
		stateTitle.TextXAlignment = Enum.TextXAlignment.Center
		KazeUI:RegisterText(stateTitle, false)

		local stateDesc = Instance.new("TextLabel", CenterContent)
		stateDesc.Size = UDim2.new(0.9, 0, 0, 36)
		stateDesc.BackgroundTransparency = 1
		stateDesc.Text = "This section doesn't contain any elements yet.\nAdd one to get started."
		stateDesc.Font = Enum.Font.Gotham
		stateDesc.TextSize = 11
		stateDesc.TextWrapped = true
		stateDesc.TextXAlignment = Enum.TextXAlignment.Center
		KazeUI:RegisterText(stateDesc, true)

		local transTween, scaleTween
		local isStateVisible = false

		local function showEmpty()
			if isStateVisible then return end
			isStateVisible = true
			
			if transTween then transTween:Cancel() end
			if scaleTween then scaleTween:Cancel() end
			
			EmptyState.Visible = true
			transTween = PlayTrackedTween(EmptyState, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {GroupTransparency = 0})
			scaleTween = PlayTrackedTween(stateScale, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Scale = 1.0})
		end

		local function hideEmpty()
			if not isStateVisible then return end
			isStateVisible = false
			
			if transTween then transTween:Cancel() end
			if scaleTween then scaleTween:Cancel() end
			
			transTween = PlayTrackedTween(EmptyState, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 1})
			scaleTween = PlayTrackedTween(stateScale, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 0.95})
			
			task.spawn(function()
				transTween.Completed:Wait()
				if not isStateVisible then EmptyState.Visible = false end
			end)
		end

		local function updateState()
			local count = 0
			for _, child in ipairs(pageContent:GetChildren()) do
				if child:IsA("GuiObject") and child.Visible and child.Name ~= "EmptyState" and child.Name ~= "UIPadding" then 
					count = count + 1 
				end
			end
			if count == 0 then showEmpty() else hideEmpty() end
		end

		pageContent.ChildAdded:Connect(function(child)
			if child:IsA("GuiObject") then
				child:GetPropertyChangedSignal("Visible"):Connect(updateState)
				updateState()
			end
		end)
		pageContent.ChildRemoved:Connect(updateState)
		
		updateState()

		table.insert(self._Tabs, {Button = btn, Indicator = leftIndicator, Label = txt, Page = page, Icon = iconLabel})

		local isHovering = false

		local function activate()
			if activeDialogsCount > 0 then return end
			for _, t in ipairs(self._Tabs) do
				PlayTrackedTween(t.Button, TWEEN_FAST, {BackgroundColor3 = KazeUI.GetColor(0.02)})
				t.Indicator.Visible = false
				t.Page.Visible = false
				t.Label.TextColor3 = KazeUI.CurrentTheme.MutedText
				t.Icon.ImageColor3 = KazeUI.CurrentTheme.MutedText
				t.Label.Font = Enum.Font.Gotham
			end
			
			PlayTrackedTween(btn, TWEEN_FAST, {BackgroundColor3 = KazeUI.GetColor(0.04)})
			leftIndicator.Visible = true
			page.Visible = true
			txt.TextColor3 = KazeUI.CurrentTheme.Text
			txt.Font = Enum.Font.GothamBold
			
			PlayTrackedTween(iconLabel, TWEEN_FAST, {ImageColor3 = KazeUI.GlowColor})
			triggerLayoutAnims()
		end

		btn.MouseEnter:Connect(function()
			if activeDialogsCount > 0 then return end
			isHovering = true
			if not leftIndicator.Visible then
				PlayTrackedTween(btn, TWEEN_FAST, {BackgroundColor3 = KazeUI.GetColor(0.03)})
				PlayTrackedTween(txt, TWEEN_FAST, {TextColor3 = KazeUI.CurrentTheme.Text})
				PlayTrackedTween(iconLabel, TWEEN_FAST, {ImageColor3 = KazeUI.CurrentTheme.Text})
			end
		end)
		btn.MouseLeave:Connect(function()
			isHovering = false
			if not leftIndicator.Visible then
				PlayTrackedTween(btn, TWEEN_FAST, {BackgroundColor3 = KazeUI.GetColor(0.02)})
				PlayTrackedTween(txt, TWEEN_FAST, {TextColor3 = KazeUI.CurrentTheme.MutedText})
				PlayTrackedTween(iconLabel, TWEEN_FAST, {ImageColor3 = KazeUI.CurrentTheme.MutedText})
			end
		end)
		btn.MouseButton1Click:Connect(activate)
		if #self._Tabs == 1 then activate() end

		KazeUI:OnThemeChanged(btn, function(t)
			if leftIndicator.Visible then
				txt.TextColor3 = t.Text
				if not isHovering then iconLabel.ImageColor3 = KazeUI.GlowColor end
				btn.BackgroundColor3 = KazeUI.GetColor(0.04)
			else
				txt.TextColor3 = t.MutedText
				if not isHovering then iconLabel.ImageColor3 = t.MutedText end
				btn.BackgroundColor3 = KazeUI.GetColor(0.02)
			end
		end)

		local public = {Button = btn, Page = page}
		AttachElementsToAPI(public, pageContent, 1)
		return public
	end

	table.insert(KazeUI.ActiveWindows, Window)
	if typeof(config.Callback) == "function" then pcall(config.Callback) end
	return Win
end

return KazeUI
