local Toggle = {}

local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")
local ThemesModule = require("src/themes/init")
local ConfigModule = require("src/config/init")

local TWEEN_FAST = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TWEEN_SPRING = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

function Toggle.new(parentFrame, title, body, defaultState, callback, flag)
	title = tostring(title or "Toggle Switch")
	body = tostring(body or "")
	local state = defaultState or false
	
	local measuredWidth = 598 * 0.92
	if parentFrame and parentFrame.AbsoluteSize and parentFrame.AbsoluteSize.X > 0 then measuredWidth = parentFrame.AbsoluteSize.X * 0.95 end
	local textContainerWidth = measuredWidth - 24 - 55
	
	local titleHeight = 0
	if title ~= " " then
		local ts = TextService:GetTextSize(title, 14, Enum.Font.GothamBold, Vector2.new(textContainerWidth, 1000))
		titleHeight = math.max(18, math.ceil(ts.Y))
	end
	
	local bodyHeight = 0
	if body ~= "" then
		local bodySize = TextService:GetTextSize(body, 13, Enum.Font.Gotham, Vector2.new(textContainerWidth, 2000))
		bodyHeight = math.ceil(bodySize.Y)
	end
	
	local totalHeight = 8 + titleHeight + (body ~= "" and 3 or 0) + bodyHeight + 8
	
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
	
	local switchContainer = Instance.new("Frame")
	switchContainer.AnchorPoint = Vector2.new(1, 0.5)
	switchContainer.Position = UDim2.new(1, -4, 0.5, 0)
	switchContainer.Size = UDim2.fromOffset(36, 18)
	switchContainer.BorderSizePixel = 0
	Instance.new("UICorner", switchContainer).CornerRadius = UDim.new(1, 0)
	switchContainer.Parent = inner
	
	local switchIndicator = Instance.new("Frame")
	switchIndicator.AnchorPoint = Vector2.new(0, 0.5)
	switchIndicator.Position = state and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
	switchIndicator.Size = UDim2.fromOffset(14, 14)
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
		ptitleLabel.TextSize = 14
		ptitleLabel.TextWrapped = true
		ptitleLabel.TextXAlignment = Enum.TextXAlignment.Left
		if body == "" then ptitleLabel.AnchorPoint = Vector2.new(0, 0.5); ptitleLabel.Position = UDim2.new(0, 0, 0.5, 0) end
		ThemesModule:RegisterText(ptitleLabel, false)
	end
	
	local bodyLabel
	if body ~= "" then
		bodyLabel = Instance.new("TextLabel", inner)
		bodyLabel.Size = UDim2.new(1, -48, 0, bodyHeight)
		bodyLabel.Position = UDim2.fromOffset(0, titleHeight + 3)
		bodyLabel.BackgroundTransparency = 1
		bodyLabel.Text = body
		bodyLabel.Font = Enum.Font.Gotham
		bodyLabel.TextSize = 12
		bodyLabel.TextWrapped = true
		bodyLabel.TextXAlignment = Enum.TextXAlignment.Left
		bodyLabel.TextYAlignment = Enum.TextYAlignment.Top
		ThemesModule:RegisterText(bodyLabel, true)
	end

	local clickDetector = Instance.new("TextButton")
	clickDetector.Size = UDim2.fromScale(1, 1)
	clickDetector.BackgroundTransparency = 1
	clickDetector.Text = ""
	clickDetector.ZIndex = 10
	clickDetector.Parent = paraFrame

	local function setToggleState(newState, instant)
		state = newState
		local targetPos = state and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
		local targetBg = state and ThemesModule.GlowColor or ThemesModule.GetColor(0.08)
		
		if instant then
			switchIndicator.Position = targetPos
			switchContainer.BackgroundColor3 = targetBg
		else
			TweenService:Create(switchIndicator, TWEEN_SPRING, { Position = targetPos }):Play()
			TweenService:Create(switchContainer, TWEEN_FAST, { BackgroundColor3 = targetBg }):Play()
		end
	end
	setToggleState(state, true)

	local isHovering = false

	clickDetector.MouseEnter:Connect(function()
		isHovering = true
		TweenService:Create(paraFrame, TWEEN_FAST, { BackgroundColor3 = ThemesModule.GetColor(0.04) }):Play()
		TweenService:Create(paraStroke, TWEEN_FAST, { Color = ThemesModule.GlowColor }):Play()
	end)
	clickDetector.MouseLeave:Connect(function()
		isHovering = false
		TweenService:Create(paraFrame, TWEEN_FAST, { BackgroundColor3 = ThemesModule.GetColor(0.02) }):Play()
		TweenService:Create(paraStroke, TWEEN_FAST, { Color = ThemesModule.CurrentTheme.Border }):Play()
	end)
	clickDetector.MouseButton1Down:Connect(function()
		TweenService:Create(paraFrame, TWEEN_FAST, { Size = UDim2.new(0.93, 0, 0, totalHeight - 2), Position = UDim2.new(0.5, 0, 0, 4) }):Play()
	end)
	clickDetector.MouseButton1Up:Connect(function()
		TweenService:Create(paraFrame, TWEEN_SPRING, { Size = UDim2.new(0.95, 0, 0, totalHeight), Position = UDim2.new(0.5, 0, 0, 3) }):Play()
		setToggleState(not state, false)
		if typeof(callback) == "function" then task.spawn(callback, state) end
	end)

	ThemesModule:OnGlowChanged(switchContainer, function(c)
		if state then
			switchContainer.BackgroundColor3 = c
		end
	end)

	ThemesModule:OnGlowChanged(paraStroke, function(c)
		if isHovering then
			paraStroke.Color = c
		end
	end)

	ConfigModule:RegisterFlag(flag, function() return state end, function(val)
		setToggleState(val, false)
		if typeof(callback) == "function" then task.spawn(callback, state) end
	end)
	
	return { 
		Wrapper = wrapper, 
		SetState = function(self, newState, instant) setToggleState(newState, instant) end,
		SetText = function(self, newTitle, newBody)
			if ptitleLabel and newTitle then ptitleLabel.Text = newTitle end
			if bodyLabel and newBody then bodyLabel.Text = newBody end
		end
	}
end

return Toggle
