--!strict
--[[
    Tab.lua
    Exposes page tabs mapped inside application navigators.
--]]

local TweenService = game:GetService("TweenService")
local Themes = require(script.Parent.Parent.themes)
local Tween = require(script.Parent.Parent.services.Tween)
local Lucide = require(script.Parent.Parent.services.Lucide)

local TabComponent = {}

function TabComponent.Create(parentWindow: any, arg1: any, arg2: any)
    local name = tostring(type(arg1) == "table" and (arg1.Title or arg1.Name) or arg1 or "Tab")
    local iconId = type(arg1) == "table" and arg1.Icon or arg2
    local formattedIcon = Lucide.Format(iconId or "")
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 40)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = parentWindow.TabsList
    btn.ClipsDescendants = true
    btn.LayoutOrder = #parentWindow._Tabs + 1
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    Themes:AddPanel(btn, 0.02, true)

    local leftIndicator = Instance.new("Frame", btn)
    leftIndicator.Size = UDim2.new(0,3,1,0)
    leftIndicator.BackgroundColor3 = Themes.GlowColor
    leftIndicator.BorderSizePixel = 0
    leftIndicator.Visible = false
    Instance.new("UICorner", leftIndicator).CornerRadius = UDim.new(0,6)

    Themes:OnGlowChanged(leftIndicator, function(c)
        leftIndicator.BackgroundColor3 = c
    end)

    local iconLabel = Instance.new("ImageLabel", btn)
    iconLabel.Size = UDim2.fromOffset(20,20)
    iconLabel.Position = UDim2.new(0,12,0.5,-10)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Image = formattedIcon
    iconLabel.ScaleType = Enum.ScaleType.Fit
    iconLabel.Parent = btn
    
    local txt = Instance.new("TextLabel", btn)
    txt.Size = UDim2.new(1, -44, 1, 0)
    txt.Position = UDim2.fromOffset(40,0)
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
    page.Size = UDim2.new(1,0,1,0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = parentWindow.Pages

    local pageContent = Instance.new("ScrollingFrame", page)
    pageContent.Size = UDim2.new(1, 0, 1, 0)
    pageContent.BackgroundTransparency = 1
    pageContent.BorderSizePixel = 0
    pageContent.ScrollBarThickness = 3
    pageContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    pageContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    pageContent.ScrollBarImageColor3 = Color3.fromRGB(40,40,45)

    local pagePadding = Instance.new("UIPadding", pageContent)
    pagePadding.PaddingTop = UDim.new(0, 8)
    pagePadding.PaddingBottom = UDim.new(0, 8)
    pagePadding.PaddingLeft = UDim.new(0, 8)
    pagePadding.PaddingRight = UDim.new(0, 8)

    local contentLayout = Instance.new("UIListLayout", pageContent)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0,4)
    contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local tabData = { Button = btn, Indicator = leftIndicator, Label = txt, Page = page, Icon = iconLabel }
    table.insert(parentWindow._Tabs, tabData)

    local isHovering = false

    local function activate()
        for _, t in ipairs(parentWindow._Tabs) do
            TweenService:Create(t.Button, Tween.FAST, { BackgroundColor3 = Themes:GetColor(0.02) }):Play()
            t.Indicator.Visible = false
            t.Page.Visible = false
            t.Label.TextColor3 = Themes.CurrentTheme.MutedText
            t.Icon.ImageColor3 = Themes.CurrentTheme.MutedText
            t.Label.Font = Enum.Font.Gotham
        end
        TweenService:Create(btn, Tween.FAST, { BackgroundColor3 = Themes:GetColor(0.04) }):Play()
        leftIndicator.Visible = true
        page.Visible = true
        txt.TextColor3 = Themes.CurrentTheme.Text
        txt.Font = Enum.Font.GothamBold
        
        TweenService:Create(iconLabel, Tween.FAST, { ImageColor3 = Themes.GlowColor }):Play()
    end

    btn.MouseEnter:Connect(function()
        isHovering = true
        if not leftIndicator.Visible then
            TweenService:Create(btn, Tween.FAST, { BackgroundColor3 = Themes:GetColor(0.03) }):Play()
            TweenService:Create(txt, Tween.FAST, { TextColor3 = Themes.CurrentTheme.Text }):Play()
            TweenService:Create(iconLabel, Tween.FAST, { ImageColor3 = Themes.CurrentTheme.Text }):Play()
        end
    end)
    
    btn.MouseLeave:Connect(function()
        isHovering = false
        if not leftIndicator.Visible then
            TweenService:Create(btn, Tween.FAST, { BackgroundColor3 = Themes:GetColor(0.02) }):Play()
            TweenService:Create(txt, Tween.FAST, { TextColor3 = Themes.CurrentTheme.MutedText }):Play()
            TweenService:Create(iconLabel, Tween.FAST, { ImageColor3 = Themes.CurrentTheme.MutedText }):Play()
        end
    end)
    
    btn.MouseButton1Click:Connect(activate)
    if #parentWindow._Tabs == 1 then activate() end

    Themes:OnThemeChanged(btn, function(t)
        if leftIndicator.Visible then
            txt.TextColor3 = t.Text
            if not isHovering then iconLabel.ImageColor3 = Themes.GlowColor end
            btn.BackgroundColor3 = Themes:GetColor(0.04)
        else
            txt.TextColor3 = t.MutedText
            if not isHovering then iconLabel.ImageColor3 = t.MutedText end
            btn.BackgroundColor3 = Themes:GetColor(0.02)
        end
    end)

    return btn, page, pageContent
end

return TabComponent
