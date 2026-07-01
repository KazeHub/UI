--!strict
--[[
    ColorPicker.lua
    Implements immersive saturation, value, and hue selection matrix selectors.
--]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Themes = require(script.Parent.Parent.themes)
local Tween = require(script.Parent.Parent.services.Tween)

local ColorPickerComponent = {}

local function ToggleScrollingAncestors(element: Instance, state: boolean)
    local current = element.Parent
    while current do
        if current:IsA("ScrollingFrame") then current.ScrollingEnabled = state end
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

function ColorPickerComponent.Create(parentFrame: GuiObject, title: string, defaultColor: Color3, callback: (Color3) -> (), registerFlag: (any, any) -> (), cameraLocker: TextButton)
    SetCameraLocker(cameraLocker)
    
    title = tostring(title or "Color Picker")
    local color = defaultColor or Color3.fromRGB(255, 255, 255)
    local h, s, v = Color3.toHSV(color)
    local isOpen = false

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
    Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 8)
    dropFrame.Parent = wrapper
    Themes:AddPanel(dropFrame, 0.02)

    local padding = Instance.new("UIPadding", dropFrame)
    padding.PaddingTop = UDim.new(0, 4)
    padding.PaddingBottom = UDim.new(0, 4)

    local boxStroke = Instance.new("UIStroke", dropFrame)
    boxStroke.Thickness = 1.2
    boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Themes:RegisterBorder(boxStroke)

    local layout = Instance.new("UIListLayout", dropFrame)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Padding = UDim.new(0, 4)

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, -16, 0, 36)
    header.BackgroundTransparency = 1
    header.LayoutOrder = 1
    header.Parent = dropFrame

    local titleLabel = Instance.new("TextLabel", header)
    titleLabel.Size = UDim2.new(0.5, 0, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    Themes:RegisterText(titleLabel, false)

    local previewColor = Instance.new("Frame", header)
    previewColor.AnchorPoint = Vector2.new(1, 0.5)
    previewColor.Position = UDim2.new(1, -24, 0.5, 0)
    previewColor.Size = UDim2.fromOffset(24, 24)
    previewColor.BackgroundColor3 = color
    Instance.new("UICorner", previewColor).CornerRadius = UDim.new(0, 4)
    
    local prevStroke = Instance.new("UIStroke", previewColor)
    Themes:RegisterBorder(prevStroke)

    local arrowIcon = Instance.new("ImageLabel", header)
    arrowIcon.AnchorPoint = Vector2.new(1, 0.5)
    arrowIcon.Position = UDim2.new(1, 0, 0.5, 0)
    arrowIcon.Size = UDim2.fromOffset(16, 16)
    arrowIcon.BackgroundTransparency = 1
    arrowIcon.Image = "rbxassetid://10723415693"
    arrowIcon.Rotation = 0
    Themes:OnThemeChanged(arrowIcon, function(t)
        arrowIcon.ImageColor3 = t.MutedText
    end)

    local clickBtn = Instance.new("TextButton", header)
    clickBtn.Size = UDim2.fromScale(1, 1)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""

    local pickerArea = Instance.new("Frame", dropFrame)
    pickerArea.Size = UDim2.new(1, -16, 0, 150)
    pickerArea.BackgroundTransparency = 1
    pickerArea.Visible = false
    pickerArea.LayoutOrder = 2

    local svMap = Instance.new("TextButton", pickerArea)
    svMap.Size = UDim2.new(1, 0, 0, 120)
    svMap.AutoButtonColor = false
    svMap.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
    svMap.Text = ""
    Instance.new("UICorner", svMap).CornerRadius = UDim.new(0, 4)

    local whiteOverlay = Instance.new("Frame", svMap)
    whiteOverlay.Size = UDim2.fromScale(1, 1)
    whiteOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    local wg = Instance.new("UIGradient", whiteOverlay)
    wg.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)}
    Instance.new("UICorner", whiteOverlay).CornerRadius = UDim.new(0, 4)

    local blackOverlay = Instance.new("Frame", svMap)
    blackOverlay.Size = UDim2.fromScale(1, 1)
    blackOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    local bg = Instance.new("UIGradient", blackOverlay)
    bg.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)}
    bg.Rotation = 90
    Instance.new("UICorner", blackOverlay).CornerRadius = UDim.new(0, 4)

    local svCursor = Instance.new("Frame", svMap)
    svCursor.Size = UDim2.fromOffset(6, 6)
    svCursor.AnchorPoint = Vector2.new(0.5, 0.5)
    svCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", svCursor).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", svCursor).Color = Color3.fromRGB(0, 0, 0)

    local hueSlider = Instance.new("TextButton", pickerArea)
    hueSlider.Size = UDim2.new(1, 0, 0, 20)
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
    Instance.new("UICorner", hueSlider).CornerRadius = UDim.new(0, 4)

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
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingMap = true
            ToggleScrollingAncestors(svMap, false)
            LockCamera()
            updateSV(input)
        end
    end)

    hueSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingHue = true
            ToggleScrollingAncestors(hueSlider, false)
            LockCamera()
            updateHue(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if draggingMap then
                updateSV(input)
            elseif draggingHue then
                updateHue(input)
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if draggingMap or draggingHue then
                UnlockCamera()
            end
            draggingMap = false
            draggingHue = false
            ToggleScrollingAncestors(svMap, true)
        end
    end)

    clickBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        pickerArea.Visible = isOpen
        TweenService:Create(arrowIcon, Tween.SPRING, {Rotation = isOpen and 180 or 0}):Play()
        TweenService:Create(boxStroke, Tween.FAST, {Color = isOpen and Themes.GlowColor or Themes.CurrentTheme.Border}):Play()
    end)
    
    Themes:OnGlowChanged(boxStroke, function(c)
        if isOpen then
            boxStroke.Color = c
        end
    end)

    registerFlag(function() return color:ToHex() end, function(val)
        local success, parsed = pcall(function() return Color3.fromHex(val) end)
        if success then
            color = parsed
            h, s, v = Color3.toHSV(color)
            SetCursorPositions()
            UpdateColor()
        end
    end)

    return {
        Wrapper = wrapper,
        SetValue = function(self, newColor)
            color = newColor
            h, s, v = Color3.toHSV(color)
            SetCursorPositions()
            UpdateColor()
        end,
        SetText = function(self, newTitle)
            titleLabel.Text = newTitle
        end
    }
end

return ColorPickerComponent
