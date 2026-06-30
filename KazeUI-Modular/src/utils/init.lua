local UtilsModule = {}

local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- Camera Locker Management
local CameraLocker = Instance.new("TextButton")
CameraLocker.Name = "CameraLocker"
CameraLocker.Size = UDim2.fromOffset(0, 0)
CameraLocker.Position = UDim2.fromOffset(0, 0)
CameraLocker.BackgroundTransparency = 1
CameraLocker.Text = ""
CameraLocker.Modal = false
CameraLocker.Visible = true

function UtilsModule:InitCameraLocker(screenGui)
	CameraLocker.Parent = screenGui
end

function UtilsModule:LockCamera()
	CameraLocker.Modal = true
end

function UtilsModule:UnlockCamera()
	CameraLocker.Modal = false
end

-- Screen Scale Controller Setup
local UIScale = Instance.new("UIScale")

function UtilsModule:InitScale(screenGui)
	UIScale.Parent = screenGui
	local function UpdateScale()
		local size = workspace.CurrentCamera.ViewportSize
		local width = size.X
		local height = size.Y
		local minAxis = math.min(width, height)
		
		local targetScale = 1.0

		if UIS.TouchEnabled then
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
		screenGui.IgnoreGuiInset = true
	end

	UpdateScale()
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScale)
end

function UtilsModule:GetScale()
	return UIScale.Scale
end

-- Dragging Mechanics
local lastNormalPosition = UDim2.fromScale(0.5, 0.5)
local lastNormalAnchor = Vector2.new(0.5, 0.5)

function UtilsModule:MakeDraggable(dragPart, targetPart)
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
			targetPart.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + (delta.X / scale),
				startPos.Y.Scale, startPos.Y.Offset + (delta.Y / scale)
			)
			
			if targetPart.Name == "Frame" or targetPart:IsA("Frame") then
				lastNormalPosition = targetPart.Position
				lastNormalAnchor = targetPart.AnchorPoint
			end
		end
	end
	
	dragPart.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragActive = false
			dragStart = input.Position
			startPos = targetPart.Position
			
			UtilsModule:LockCamera()
			
			local changeCon
			changeCon = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					dragInput = nil
					UtilsModule:UnlockCamera()
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
	
	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragging then update(input) end
	end)
end

function UtilsModule:GetLastDragStates()
	return lastNormalPosition, lastNormalAnchor
end

function UtilsModule:SetLastDragStates(pos, anchor)
	lastNormalPosition = pos
	lastNormalAnchor = anchor
end

-- Lucide Icon Fetcher / Formatting Engine
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

function UtilsModule:FormatImage(id)
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
	
	if string.find(id, "rbxassetid://") or string.find(id, "http") then return id end
	local clean = string.gsub(id, "%D", "")
	if clean == "" then return id end
	return "rbxassetid://" .. clean
end

function UtilsModule:ToggleScrollingAncestors(element, state)
	local current = element.Parent
	while current do
		if current:IsA("ScrollingFrame") then current.ScrollingEnabled = state end
		current = current.Parent
	end
end

return UtilsModule
