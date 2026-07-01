--!strict
--[[
    TextBox.lua
    Implements alphanumeric keyboard focus captures.
--]]

local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")
local Themes = require(script.Parent.Parent.themes)
local Tween = require(script.Parent.Parent.services.Tween)

local TextBoxComponent = {}

function TextBoxComponent.Create(parentFrame: GuiObject, title: string, placeholder: string, defaultVal: string, callback: (string, boolean) -> (), registerFlag: (any, any) -> ())
    title = tostring(title or "Input Text")
    placeholder = tostring(placeholder or "Type here...")
    
    local measuredWidth = 598 * 0.92
    if parentFrame and parentFrame.AbsoluteSize and parentFrame.AbsoluteSize.X > 0 then 
        measuredWidth = parentFrame.AbsoluteSize.X * 0.95 
    end
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
    Themes:AddPanel(paraFrame, 0.02)
    
    local paraStroke = Instance.new("UIStroke", paraFrame)
    paraStroke.Thickness = 1.2
    paraStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Themes:RegisterBorder(paraStroke)
    
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
        Themes:RegisterText(ptitleLabel, false)
    end
    
    local textBoxContainer = Instance.new("Frame")
    textBoxContainer.Size = UDim2.new(1, 0, 0, 30)
    textBoxContainer.Position = UDim2.new(0, 0, 0, titleHeight + 4)
    textBoxContainer.BorderSizePixel = 0
    textBoxContainer.Parent = inner
    Instance.new("UICorner", textBoxContainer).CornerRadius = UDim.new(0, 6)
    Themes:AddPanel(textBoxContainer, -0.01)
    
    local innerStroke = Instance.new("UIStroke", textBoxContainer)
    innerStroke.Thickness = 1
    Themes:RegisterBorder(innerStroke)
    
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, -16, 1, 0)
    textBox.Position = UDim2.fromOffset(8, 0)
    textBox.BackgroundTransparency = 1
    textBox.PlaceholderText = placeholder
    textBox.Text = defaultVal and tostring(defaultVal) or ""
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 12
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.ClearTextOnFocus = false
    textBox.Parent = textBoxContainer
    Themes:RegisterText(textBox, false)
    Themes:OnThemeChanged(textBox, function(t)
        textBox.PlaceholderColor3 = t.MutedText
    end)

    local isFocused = false

    textBox.Focused:Connect(function()
        isFocused = true
        TweenService:Create(innerStroke, Tween.FAST, {Color = Themes.GlowColor}):Play()
        TweenService:Create(paraFrame, Tween.FAST, { BackgroundColor3 = Themes:GetColor(0.04) }):Play()
        TweenService:Create(paraStroke, Tween.FAST, { Color = Themes.GlowColor }):Play()
    end)

    textBox.FocusLost:Connect(function(enterPressed)
        isFocused = false
        TweenService:Create(innerStroke, Tween.FAST, { Color = Themes.CurrentTheme.Border }):Play()
        TweenService:Create(paraFrame, Tween.FAST, { BackgroundColor3 = Themes:GetColor(0.02) }):Play()
        TweenService:Create(paraStroke, Tween.FAST, { Color = Themes.CurrentTheme.Border }):Play()
        if typeof(callback) == "function" then task.spawn(callback, textBox.Text, enterPressed) end
    end)
    
    Themes:OnGlowChanged(innerStroke, function(c)
        if isFocused then
            innerStroke.Color = c
            paraStroke.Color = c
        end
    end)
    
    registerFlag(function() return textBox.Text end, function(val)
        textBox.Text = val
        if typeof(callback) == "function" then task.spawn(callback, val, false) end
    end)

    return { 
        Wrapper = wrapper, 
        SetText = function(self, value) textBox.Text = tostring(value or "") end,
        SetPlaceholder = function(self, val) textBox.PlaceholderText = val end,
        SetTitle = function(self, newTitle)
            if ptitleLabel and newTitle then ptitleLabel.Text = newTitle end
        end
    }
end

return TextBoxComponent
