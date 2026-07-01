--!strict
--[[
    Section.lua
    Implements collapsible folder-like logical sections and horizontal layout dividers.
--]]

local TweenService = game:GetService("TweenService")
local Themes = require(script.Parent.Parent.themes)
local Tween = require(script.Parent.Parent.services.Tween)

local SectionComponent = {}

-- Collapsible Accordion Sections
function SectionComponent.CreateCollapsible(parentFrame: GuiObject, titleArg: any, attachElementsCallback: (any, Frame) -> ())
    local title = type(titleArg) == "table" and titleArg.Title or tostring(titleArg or "Section")
    local isOpen = false

    local sectionBox = Instance.new("Frame")
    sectionBox.Name = "CollapsibleSection_" .. title
    sectionBox.Size = UDim2.new(0.95, 0, 0, 0)
    sectionBox.BorderSizePixel = 0
    sectionBox.Parent = parentFrame
    sectionBox.AutomaticSize = Enum.AutomaticSize.Y
    Instance.new("UICorner", sectionBox).CornerRadius = UDim.new(0, 10)
    Themes:AddPanel(sectionBox, 0.02)

    local boxStroke = Instance.new("UIStroke", sectionBox)
    boxStroke.Thickness = 1.5
    boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Themes:RegisterBorder(boxStroke)

    local boxLayout = Instance.new("UIListLayout", sectionBox)
    boxLayout.SortOrder = Enum.SortOrder.LayoutOrder
    boxLayout.Padding = UDim.new(0, 0)
    boxLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local headerFrame = Instance.new("Frame")
    headerFrame.Name = "Header"
    headerFrame.Size = UDim2.new(1, 0, 0, 42)
    headerFrame.BackgroundTransparency = 1
    headerFrame.LayoutOrder = 1
    headerFrame.Parent = sectionBox
    Instance.new("UICorner", headerFrame).CornerRadius = UDim.new(0, 10)

    local accentLine = Instance.new("Frame", headerFrame)
    accentLine.Size = UDim2.new(0, 4, 0, 18)
    accentLine.Position = UDim2.new(0, 12, 0.5, -9)
    accentLine.BorderSizePixel = 0
    Instance.new("UICorner", accentLine).CornerRadius = UDim.new(1, 0)
    
    Themes:OnThemeChanged(accentLine, function(t)
        if not isOpen then accentLine.BackgroundColor3 = t.MutedText end
    end)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -40, 1, 0)
    titleLabel.Position = UDim2.fromOffset(26, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = headerFrame
    Themes:RegisterText(titleLabel, false)

    local arrowIcon = Instance.new("ImageLabel")
    arrowIcon.AnchorPoint = Vector2.new(1, 0.5)
    arrowIcon.Position = UDim2.new(1, -16, 0.5, 0)
    arrowIcon.Size = UDim2.fromOffset(16, 16)
    arrowIcon.BackgroundTransparency = 1
    arrowIcon.Image = "rbxassetid://6031091004" 
    arrowIcon.Rotation = -90
    arrowIcon.Parent = headerFrame
    Themes:OnThemeChanged(arrowIcon, function(t)
        if not isOpen then arrowIcon.ImageColor3 = t.MutedText end
    end)

    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(0.95, 0, 0, 1)
    divider.BorderSizePixel = 0
    divider.LayoutOrder = 2
    divider.Visible = false
    divider.Parent = sectionBox
    Themes:OnThemeChanged(divider, function(t)
        divider.BackgroundColor3 = t.Border
    end)

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
    contentPadding.PaddingLeft = UDim.new(0, 4)
    contentPadding.PaddingRight = UDim.new(0, 4)

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

        local animDuration = 0.2
        local easeStyle = Enum.EasingStyle.Quad
        local easeDir = Enum.EasingDirection.Out

        if isOpen then
            TweenService:Create(arrowIcon, TweenInfo.new(animDuration, easeStyle, easeDir), {
                Rotation = 0,
                ImageColor3 = Themes.GlowColor
            }):Play()
            TweenService:Create(accentLine, TweenInfo.new(animDuration, easeStyle, easeDir), {
                BackgroundColor3 = Themes.GlowColor
            }):Play()
            Themes:StartNeonLoop(boxStroke)
            Themes:StartNeonLoop(accentLine)
        else
            TweenService:Create(arrowIcon, TweenInfo.new(animDuration, easeStyle, easeDir), {
                Rotation = -90,
                ImageColor3 = Themes.CurrentTheme.MutedText
            }):Play()
            TweenService:Create(accentLine, TweenInfo.new(animDuration, easeStyle, easeDir), {
                BackgroundColor3 = Themes.CurrentTheme.MutedText
            }):Play()
            Themes:StopNeonLoop(boxStroke)
            Themes:StopNeonLoop(accentLine)
            boxStroke.Color = Themes.CurrentTheme.Border
            accentLine.BackgroundColor3 = Themes.CurrentTheme.MutedText
        end
    end

    toggleDetector.MouseEnter:Connect(function()
        TweenService:Create(headerFrame, TweenInfo.new(0.15), { BackgroundColor3 = Themes:GetColor(0.04), BackgroundTransparency = 0.4 }):Play()
        TweenService:Create(titleLabel, TweenInfo.new(0.15), { TextColor3 = Themes.CurrentTheme.Text }):Play()
    end)
    toggleDetector.MouseLeave:Connect(function()
        TweenService:Create(headerFrame, TweenInfo.new(0.15), { BackgroundTransparency = 1 }):Play()
        TweenService:Create(titleLabel, TweenInfo.new(0.15), { TextColor3 = Themes.CurrentTheme.Text }):Play()
    end)

    toggleDetector.MouseButton1Down:Connect(function()
        TweenService:Create(sectionBox, TweenInfo.new(0.1), { Size = UDim2.new(0.93, 0, 0, 0) }):Play()
    end)
    toggleDetector.MouseButton1Up:Connect(function()
        TweenService:Create(sectionBox, TweenInfo.new(0.1), { Size = UDim2.new(0.95, 0, 0, 0) }):Play()
        toggleSection()
    end)

    local sectionPublic = { Frame = sectionBox, ContentFrame = sectionContent, Header = headerFrame }
    attachElementsCallback(sectionPublic, sectionContent)
    
    function sectionPublic:SetText(newText)
        titleLabel.Text = newText
    end
    
    return sectionPublic
end

-- Horizontal Line Separators
function SectionComponent.CreateDivider(parentFrame: GuiObject, titleArg: any)
    local title = tostring(titleArg or "Section")

    local wrapper = Instance.new("Frame")
    wrapper.Size = UDim2.new(0.95, 0, 0, 32)
    wrapper.BackgroundTransparency = 1
    wrapper.Parent = parentFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -12, 1, 0)
    label.Position = UDim2.fromOffset(12, 0)
    label.BackgroundTransparency = 1
    label.Text = title
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = wrapper
    Themes:RegisterText(label, false)
    
    local leftLine = Instance.new("Frame")
    leftLine.Size = UDim2.new(0, 3, 0, 14)
    leftLine.Position = UDim2.new(0, 0, 0.5, -7)
    leftLine.BackgroundColor3 = Themes.GlowColor
    leftLine.BorderSizePixel = 0
    leftLine.Parent = wrapper
    Instance.new("UICorner", leftLine).CornerRadius = UDim.new(1, 0)

    Themes:OnGlowChanged(leftLine, function(c)
        leftLine.BackgroundColor3 = c
    end)

    return {
        Label = label,
        LeftLine = leftLine,
        SetText = function(self, t)
            label.Text = t
        end
    }
end

return SectionComponent
