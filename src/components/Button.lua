--!strict
--[[
    Button.lua
    Implements standard buttons, click detectors, labels, and paragraph structures.
--]]

local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")
local Themes = require(script.Parent.Parent.themes)
local Tween = require(script.Parent.Parent.services.Tween)

local ButtonComponent = {}

-- Basic Paragraph layout wrapper
function ButtonComponent.CreateParagraph(parentFrame: GuiObject, title: string, body: string)
    title = tostring(title or "")
    body = tostring(body or "")
    
    local measuredWidth = 598 * 0.92
    if parentFrame and parentFrame.AbsoluteSize and parentFrame.AbsoluteSize.X > 0 then 
        measuredWidth = parentFrame.AbsoluteSize.X * 0.95 
    end
    
    local titleHeight = 0
    if title ~= " " then
        local ts = TextService:GetTextSize(title, 14, Enum.Font.GothamBold, Vector2.new(measuredWidth - 24, 1000))
        titleHeight = math.max(18, math.ceil(ts.Y))
    end
    
    local bodySize = TextService:GetTextSize(body, 13, Enum.Font.Gotham, Vector2.new(measuredWidth - 24, 2000))
    local bodyHeight = math.ceil(bodySize.Y)
    local totalHeight = 8 + titleHeight + 3 + bodyHeight + 8
    
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
    Themes:AddPanel(paraFrame, 0.01)
    
    local paraStroke = Instance.new("UIStroke", paraFrame)
    paraStroke.Thickness = 1.2
    paraStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Themes:RegisterBorder(paraStroke)
    
    local inner = Instance.new("Frame", paraFrame)
    inner.Size = UDim2.new(1, -20, 1, -12)
    inner.Position = UDim2.fromOffset(10, 6)
    inner.BackgroundTransparency = 1
    
    local ptitleLabel
    if title ~= " " then
        ptitleLabel = Instance.new("TextLabel", inner)
        ptitleLabel.Size = UDim2.new(1,0,0,titleHeight)
        ptitleLabel.BackgroundTransparency = 1
        ptitleLabel.Text = title
        ptitleLabel.Font = Enum.Font.GothamBold
        ptitleLabel.TextSize = 14
        ptitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        ptitleLabel.TextWrapped = true
        Themes:RegisterText(ptitleLabel, false)
    end
    
    local bodyLabel = Instance.new("TextLabel", inner)
    bodyLabel.Size = UDim2.new(1,0,0,bodyHeight)
    bodyLabel.Position = UDim2.fromOffset(0, titleHeight + 3)
    bodyLabel.BackgroundTransparency = 1
    bodyLabel.Text = body
    bodyLabel.Font = Enum.Font.Gotham
    bodyLabel.TextSize = 12
    bodyLabel.TextWrapped = true
    bodyLabel.TextXAlignment = Enum.TextXAlignment.Left
    bodyLabel.TextYAlignment = Enum.TextYAlignment.Top
    Themes:RegisterText(bodyLabel, true)
    
    return { 
        Wrapper = wrapper, 
        Frame = paraFrame,
        SetText = function(self, newTitle, newBody)
            if ptitleLabel and newTitle then ptitleLabel.Text = newTitle end
            if bodyLabel and newBody then bodyLabel.Text = newBody end
        end
    }
end

-- Premium click callback button card layout
function ButtonComponent.CreateClickable(parentFrame: GuiObject, title: string, body: string, callback: () -> ())
    title = tostring(title or "Button")
    body = tostring(body or "")
    
    local measuredWidth = 598 * 0.92
    if parentFrame and parentFrame.AbsoluteSize and parentFrame.AbsoluteSize.X > 0 then 
        measuredWidth = parentFrame.AbsoluteSize.X * 0.95 
    end
    local textContainerWidth = measuredWidth - 24 - 42
    
    local titleHeight = 0
    if title ~= " " and title ~= "" then
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
    Themes:AddPanel(paraFrame, 0.02)
    
    local paraStroke = Instance.new("UIStroke", paraFrame)
    paraStroke.Thickness = 1.2
    paraStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Themes:RegisterBorder(paraStroke)
    
    local inner = Instance.new("Frame", paraFrame)
    inner.Size = UDim2.new(1, -16, 1, -12)
    inner.Position = UDim2.fromOffset(8, 6)
    inner.BackgroundTransparency = 1
    
    local rightIcon = Instance.new("ImageLabel")
    rightIcon.AnchorPoint = Vector2.new(1, 0.5)
    rightIcon.Position = UDim2.new(1, -12, 0.5, 0) 
    rightIcon.Size = UDim2.fromOffset(20, 20)
    rightIcon.BackgroundTransparency = 1
    rightIcon.Image = "rbxassetid://107150227368485" 
    rightIcon.ScaleType = Enum.ScaleType.Fit
    rightIcon.Parent = inner
    
    local isHovering = false
    Themes:OnThemeChanged(rightIcon, function(t)
        if not isHovering then
            rightIcon.ImageColor3 = t.MutedText
        end
    end)
    
    local ptitleLabel
    if title ~= " " and title ~= "" then
        ptitleLabel = Instance.new("TextLabel", inner)
        ptitleLabel.Size = UDim2.new(1, -38, 0, titleHeight)
        ptitleLabel.BackgroundTransparency = 1
        ptitleLabel.Text = title
        ptitleLabel.Font = Enum.Font.GothamBold
        ptitleLabel.TextSize = 14
        ptitleLabel.TextWrapped = true
        ptitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        if body == "" then 
            ptitleLabel.AnchorPoint = Vector2.new(0, 0.5)
            ptitleLabel.Position = UDim2.new(0, 0, 0.5, 0) 
        end
        Themes:RegisterText(ptitleLabel, false)
    end
    
    local bodyLabel
    if body ~= "" then
        bodyLabel = Instance.new("TextLabel", inner)
        bodyLabel.Size = UDim2.new(1, -38, 0, bodyHeight)
        bodyLabel.Position = UDim2.fromOffset(0, titleHeight + 3)
        bodyLabel.BackgroundTransparency = 1
        bodyLabel.Text = body
        bodyLabel.Font = Enum.Font.Gotham
        bodyLabel.TextSize = 12
        bodyLabel.TextWrapped = true
        bodyLabel.TextXAlignment = Enum.TextXAlignment.Left
        bodyLabel.TextYAlignment = Enum.TextYAlignment.Top
        Themes:RegisterText(bodyLabel, true)
    end

    local clickDetector = Instance.new("TextButton")
    clickDetector.Size = UDim2.fromScale(1, 1)
    clickDetector.BackgroundTransparency = 1
    clickDetector.Text = ""
    clickDetector.ZIndex = 10
    clickDetector.Parent = paraFrame

    clickDetector.MouseEnter:Connect(function()
        isHovering = true
        TweenService:Create(paraFrame, Tween.FAST, { BackgroundColor3 = Themes:GetColor(0.04) }):Play()
        TweenService:Create(paraStroke, Tween.FAST, { Color = Themes.GlowColor }):Play()
        TweenService:Create(rightIcon, Tween.FAST, { ImageColor3 = Color3.fromRGB(255, 255, 255), Position = UDim2.new(1, -10, 0.5, 0) }):Play()
    end)
    
    clickDetector.MouseLeave:Connect(function()
        isHovering = false
        TweenService:Create(paraFrame, Tween.FAST, { BackgroundColor3 = Themes:GetColor(0.02) }):Play()
        TweenService:Create(paraStroke, Tween.FAST, { Color = Themes.CurrentTheme.Border }):Play()
        TweenService:Create(rightIcon, Tween.FAST, { ImageColor3 = Themes.CurrentTheme.MutedText, Position = UDim2.new(1, -12, 0.5, 0) }):Play()
    end)
    
    clickDetector.MouseButton1Down:Connect(function()
        TweenService:Create(paraFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { 
            Size = UDim2.new(0.93, 0, 0, totalHeight - 2), 
            Position = UDim2.new(0.5, 0, 0, 4) 
        }):Play()
    end)
    
    clickDetector.MouseButton1Up:Connect(function()
        TweenService:Create(paraFrame, Tween.SPRING, { 
            Size = UDim2.new(0.95, 0, 0, totalHeight), 
            Position = UDim2.new(0.5, 0, 0, 3) 
        }):Play()
        if typeof(callback) == "function" then task.spawn(callback) end
    end)
    
    Themes:OnGlowChanged(paraStroke, function(c)
        if isHovering then
            paraStroke.Color = c
        end
    end)
    
    return { 
        Wrapper = wrapper, 
        Frame = paraFrame,
        SetText = function(self, newTitle, newBody)
            if ptitleLabel and newTitle then ptitleLabel.Text = newTitle end
            if bodyLabel and newBody then bodyLabel.Text = newBody end
        end
    }
end

return ButtonComponent
