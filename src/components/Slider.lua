--!strict
--[[
    Slider.lua
    Implements analog linear precision adjustments tracking input offsets.
--]]

local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Themes = require(script.Parent.Parent.themes)
local Tween = require(script.Parent.Parent.services.Tween)

local SliderComponent = {}

-- Safely traverses up hierarchy to yield ancestor scrollbars
local function ToggleScrollingAncestors(element: Instance, state: boolean)
    local current = element.Parent
    while current do
        if current:IsA("ScrollingFrame") then 
            current.ScrollingEnabled = state 
        end
        current = current.Parent
    end
end

-- Hook up CameraLocker checks
local CameraLocker: TextButton? = nil
local function SetCameraLocker(locker: TextButton)
    CameraLocker = locker
end

local function LockCamera()
    if CameraLocker then CameraLocker.Modal = true end
end

local function UnlockCamera()
    if CameraLocker then CameraLocker.Modal = false end
end

function SliderComponent.Create(parentFrame: GuiObject, title: string, min: number, max: number, default: number, callback: (number) -> (), registerFlag: (any, any) -> (), cameraLocker: TextButton)
    SetCameraLocker(cameraLocker)
    
    title = tostring(title or "Slider")
    min = tonumber(min) or 0
    max = tonumber(max) or 100
    default = tonumber(default) or min
    local value = math.clamp(default, min, max)
    
    local measuredWidth = 598 * 0.92
    if parentFrame and parentFrame.AbsoluteSize and parentFrame.AbsoluteSize.X > 0 then 
        measuredWidth = parentFrame.AbsoluteSize.X * 0.95 
    end
    local textContainerWidth = measuredWidth - 24
    
    local titleHeight = 0
    if title ~= " " and title ~= "" then
        local ts = TextService:GetTextSize(title, 14, Enum.Font.GothamBold, Vector2.new(textContainerWidth - 80, 1000))
        titleHeight = math.max(16, math.ceil(ts.Y))
    end
    
    local totalHeight = 8 + titleHeight + 6 + 18 + 8
    
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
        ptitleLabel.Size = UDim2.new(1, -80, 0, titleHeight)
        ptitleLabel.BackgroundTransparency = 1
        ptitleLabel.Text = title
        ptitleLabel.Font = Enum.Font.GothamBold
        ptitleLabel.TextSize = 14
        ptitleLabel.TextWrapped = true
        ptitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        Themes:RegisterText(ptitleLabel, false)
    end
    
    local valueLabel = Instance.new("TextLabel", inner)
    valueLabel.Size = UDim2.new(0, 70, 0, titleHeight > 0 and titleHeight or 16)
    valueLabel.Position = UDim2.new(1, -70, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(value)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 12
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    Themes:RegisterText(valueLabel, false)
    
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, 0, 0, 6)
    track.Position = UDim2.new(0, 0, 0, titleHeight + 8)
    track.BorderSizePixel = 0
    track.Parent = inner
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    Themes:AddPanel(track, -0.01)
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Themes.GlowColor
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
    knobStroke.Color = Themes.GlowColor

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
        
        TweenService:Create(fill, Tween.FAST, {Size = UDim2.new(visualPercentage, 0, 1, 0)}):Play()
        TweenService:Create(knob, Tween.FAST, {Position = UDim2.new(visualPercentage, 0, 0.5, 0)}):Play()
        if typeof(callback) == "function" then task.spawn(callback, value) end
    end
    
    local startingPercentage = 0
    if max > min then startingPercentage = (value - min) / (max - min) end
    fill.Size = UDim2.new(startingPercentage, 0, 1, 0)
    knob.Position = UDim2.new(startingPercentage, 0, 0.5, 0)
    
    clickDetector.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            ToggleScrollingAncestors(track, false)
            LockCamera()
            UpdateValueFromInput(input)
            
            TweenService:Create(knob, Tween.FAST, {Size = UDim2.fromOffset(16, 16)}):Play()
            TweenService:Create(paraStroke, Tween.FAST, {Color = Themes.GlowColor}):Play()
            
            local moveCon, endCon
            moveCon = UserInputService.InputChanged:Connect(function(moveInput)
                if isDragging and (moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch) then
                    UpdateValueFromInput(moveInput)
                end
            end)
            endCon = UserInputService.InputEnded:Connect(function(endInput)
                if endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch then
                    isDragging = false
                    ToggleScrollingAncestors(track, true)
                    UnlockCamera()
                    
                    TweenService:Create(knob, Tween.FAST, {Size = UDim2.fromOffset(12, 12)}):Play()
                    TweenService:Create(paraStroke, Tween.FAST, {Color = Themes.CurrentTheme.Border}):Play()
                    if moveCon then moveCon:Disconnect() end
                    if endCon then endCon:Disconnect() end
                end
            end)
        end
    end)

    Themes:OnGlowChanged(fill, function(c)
        fill.BackgroundColor3 = c
        knobStroke.Color = c
    end)

    Themes:OnGlowChanged(paraStroke, function(c)
        if isDragging then
            paraStroke.Color = c
        end
    end)

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
        end
    }
    
    registerFlag(function() return value end, function(val) api:SetValue(val) end)
    return api
end

return SliderComponent
