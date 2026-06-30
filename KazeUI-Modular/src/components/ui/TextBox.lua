local TextBox = {}

local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")
local ThemesModule = require("src/themes/init")
local ConfigModule = require("src/config/init")

local TWEEN_FAST = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

function TextBox.new(parentFrame, title, placeholder, defaultVal, callback, flag)
	title = tostring(title or "Input Text")
	placeholder = tostring(placeholder or "Type here...")
	
	local measuredWidth = 598 * 0.92
	if parentFrame and parentFrame.AbsoluteSize and parentFrame.AbsoluteSize.X > 0 then measuredWidth = parentFrame.AbsoluteSize.X * 0.95 end
	local textContainerWidth = measuredWidth - 24
	
	local titleHeight = 0
	if title ~= " " and title ~= "" then
		local ts = TextService:GetTextSize(title, 14, Enum.Font.GothamBold, Vector2.new(textContainerWidth, 1000))
		titleHeight = math.max(16, math.ceil(ts.Y))
	end
	
	local totalHeight = 8 + titleHeight + 6 + 32 + 8
	
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
		ptitleLabel.Size = UDim2.new(1, 0, 0, titleHeight)
		ptitleLabel.BackgroundTransparency = 1
		ptitleLabel.Text = title
		ptitleLabel.Font = Enum.Font.GothamBold
		ptitleLabel.TextSize = 14
		ptitleLabel.TextWrapped = true
		ptitleLabel.TextXAlignment = Enum.TextXAlignment.Left
		ThemesModule:RegisterText(ptitleLabel, false)
	end
	
	local textBoxContainer = Instance.new("Frame")
	textBoxContainer.Size = UDim2.new(1, 0, 0, 30)
	textBoxContainer.Position = UDim2.new(0, 0, 0, titleHeight + 4)
	textBoxContainer.BorderSizePixel = 0
	textBoxContainer.Parent = inner
	Instance.new("UICorner", textBoxContainer).CornerRadius = UDim.new(0, 6)
	ThemesModule:AddPanel(textBoxContainer, -0.01)
	
	local innerStroke = Instance.new("UIStroke", textBoxContainer)
	innerStroke.Thickness = 1
	ThemesModule:RegisterBorder(innerStroke)
	
	local rbxTextBox = Instance.new("TextBox")
	rbxTextBox.Size = UDim2.new(1, -16, 1, 0)
	rbxTextBox.Position = UDim2.fromOffset(8, 0)
	rbxTextBox.BackgroundTransparency = 1
	rbxTextBox.PlaceholderText = placeholder
	rbxTextBox.Text = defaultVal and tostring(defaultVal) or ""
	rbxTextBox.Font = Enum.Font.Gotham
	rbxTextBox.TextSize = 12
	rbxTextBox.TextXAlignment = Enum.TextXAlignment.Left
	rbxTextBox.ClearTextOnFocus = false
	rbxTextBox.Parent = textBoxContainer
	ThemesModule:RegisterText(rbxTextBox, false)
	ThemesModule:OnThemeChanged(rbxTextBox, function(t)
		rbxTextBox.PlaceholderColor3 = t.MutedText
	end)

	local isFocused = false

	rbxTextBox.Focused:Connect(function()
		isFocused = true
		TweenService:Create(innerStroke, TWEEN_FAST, {Color = ThemesModule.GlowColor}):Play()
		TweenService:Create(paraFrame, TWEEN_FAST, { BackgroundColor3 = ThemesModule.GetColor(0.04) }):Play()
		TweenService:Create(paraStroke, TWEEN_FAST, { Color = ThemesModule.GlowColor }):Play()
	end)

	rbxTextBox.FocusLost:Connect(function(enterPressed)
		isFocused = false
		TweenService:Create(innerStroke, TWEEN_FAST, { Color = ThemesModule.CurrentTheme.Border }):Play()
		TweenService:Create(paraFrame, TWEEN_FAST, { BackgroundColor3 = ThemesModule.GetColor(0.02) }):Play()
		TweenService:Create(paraStroke, TWEEN_FAST, { Color = ThemesModule.CurrentTheme.Border }):Play()
		if typeof(callback) == "function" then task.spawn(callback, rbxTextBox.Text, enterPressed) end
	end)
	
	ThemesModule:OnGlowChanged(innerStroke, function(c)
		if isFocused then
			innerStroke.Color = c
			paraStroke.Color = c
		end
	end)
	
	ConfigModule:RegisterFlag(flag, function() return rbxTextBox.Text end, function(val)
		rbxTextBox.Text = val
		if typeof(callback) == "function" then task.spawn(callback, val) end
	end)

	return { 
		Wrapper = wrapper, 
		SetText = function(self, value) rbxTextBox.Text = tostring(value or "") end,
		SetPlaceholder = function(self, val) rbxTextBox.PlaceholderText = val end,
		SetTitle = function(self, newTitle)
			if ptitleLabel and newTitle then ptitleLabel.Text = newTitle end
		end
	}
end

return TextBox
