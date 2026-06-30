
local Keybind = {}

local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local ThemesModule = require("src/themes/init")
local ConfigModule = require("src/config/init")

local TWEEN_FAST = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

function Keybind.new(parentFrame, title, defaultKey, callback, flag)
	title = tostring(title or "Keybind")
	local currentKey = defaultKey or Enum.KeyCode.Unknown
	local isBinding = false
	
	local measuredWidth = 598 * 0.92
	if parentFrame and parentFrame.AbsoluteSize and parentFrame.AbsoluteSize.X > 0 then measuredWidth = parentFrame.AbsoluteSize.X * 0.95 end
	local textContainerWidth = measuredWidth - 24 - 90
	
	local titleHeight = 0
	if title ~= " " and title ~= "" then
		local ts = TextService:GetTextSize(title, 14, Enum.Font.GothamBold, Vector2.new(textContainerWidth, 1000))
		titleHeight = math.max(16, math.ceil(ts.Y))
	end
	
	local totalHeight = 8 + math.max(titleHeight, 24) + 8
	
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
	Instance.new("UICorner", paraFrame).CornerRadius = UDim.new(0, 8)
	paraFrame.Parent = wrapper
	ThemesModule:AddPanel(paraFrame, 0.02)
	
	local paraStroke = Instance.new("UIStroke", paraFrame)
	paraStroke.Thickness = 1.2
	paraStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	ThemesModule:RegisterBorder(paraStroke)
	
	local inner = Instance.new("Frame", paraFrame)
	inner.Size = UDim2.new(1, -16, 1, -12)
	inner.Position = UDim2.fromOffset(8, 6)
	inner.BackgroundTransparency = 1
	
	local ptitleLabel
	if title ~= " " and title ~= "" then
		ptitleLabel = Instance.new("TextLabel", inner)
		ptitleLabel.Size = UDim2.new(1, -90, 1, 0)
		ptitleLabel.BackgroundTransparency = 1
		ptitleLabel.Text = title
		ptitleLabel.Font = Enum.Font.GothamBold
		ptitleLabel.TextSize = 14
		ptitleLabel.TextWrapped = true
		ptitleLabel.TextXAlignment = Enum.TextXAlignment.Left
		ThemesModule:RegisterText(ptitleLabel, false)
	end
	
	local bindContainer = Instance.new("TextButton", inner)
	bindContainer.Size = UDim2.new(0, 80, 0, 24)
	bindContainer.AnchorPoint = Vector2.new(1, 0.5)
	bindContainer.Position = UDim2.new(1, 0, 0.5, 0)
	bindContainer.BorderSizePixel = 0
	bindContainer.Text = ""
	bindContainer.AutoButtonColor = false
	Instance.new("UICorner", bindContainer).CornerRadius = UDim.new(0, 5)
	ThemesModule:AddPanel(bindContainer, 0.05)

	local bindStroke = Instance.new("UIStroke", bindContainer)
	bindStroke.Thickness = 1
	ThemesModule:RegisterBorder(bindStroke)
	
	local bindLabel = Instance.new("TextLabel", bindContainer)
	bindLabel.Size = UDim2.new(1, 0, 1, 0)
	bindLabel.BackgroundTransparency = 1
	bindLabel.Text = currentKey == Enum.KeyCode.Unknown and "None" or currentKey.Name
	bindLabel.Font = Enum.Font.GothamBold
	bindLabel.TextSize = 11
	ThemesModule:RegisterText(bindLabel, false)

	local isHovering = false
	
	bindContainer.MouseEnter:Connect(function()
		isHovering = true
		if not isBinding then 
			TweenService:Create(bindStroke, TWEEN_FAST, {Color = ThemesModule.GlowColor}):Play()
		end
	end)
	bindContainer.MouseLeave:Connect(function()
		isHovering = false
		if not isBinding then 
			TweenService:Create(bindStroke, TWEEN_FAST, {Color = ThemesModule.CurrentTheme.Border}):Play()
		end
	end)
	
	bindContainer.MouseButton1Click:Connect(function()
		if isBinding then return end
		isBinding = true
		bindLabel.Text = "..."
		TweenService:Create(bindStroke, TWEEN_FAST, {Color = ThemesModule.GlowColor}):Play()
		
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
				TweenService:Create(bindStroke, TWEEN_FAST, {Color = ThemesModule.CurrentTheme.Border}):Play()
				conn:Disconnect()
				task.delay(0.15, function() isBinding = false end)
			end
		end)
	end)
	
	UIS.InputBegan:Connect(function(input, gp)
		if not gp and not isBinding and currentKey ~= Enum.KeyCode.Unknown and input.KeyCode == currentKey then
			if typeof(callback) == "function" then
				task.spawn(callback, currentKey)
			end
		end
	end)

	ThemesModule:OnGlowChanged(bindStroke, function(c)
		if isBinding or isHovering then
			bindStroke.Color = c
		end
	end)

	ConfigModule:RegisterFlag(flag, function() return currentKey.Name end, function(val)
		pcall(function()
			currentKey = Enum.KeyCode[val] or Enum.KeyCode.Unknown
			bindLabel.Text = currentKey == Enum.KeyCode.Unknown and "None" or currentKey.Name
		end)
	end)

	return {
		Wrapper = wrapper,
		SetText = function(self, newTitle)
			if ptitleLabel and newTitle then ptitleLabel.Text = newTitle end
		end,
		SetKey = function(self, newKey)
			currentKey = newKey
			bindLabel.Text = currentKey == Enum.KeyCode.Unknown and "None" or currentKey.Name
		end
	}
end

return Keybind
