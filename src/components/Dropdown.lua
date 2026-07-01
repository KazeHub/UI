--!strict
--[[
    Dropdown.lua
    Implements dynamic search, multi/single option selection cards.
--]]

local TweenService = game:GetService("TweenService")
local Themes = require(script.Parent.Parent.themes)
local Tween = require(script.Parent.Parent.services.Tween)

local DropdownComponent = {}

local function ToggleScrollingAncestors(element: Instance, state: boolean)
    local current = element.Parent
    while current do
        if current:IsA("ScrollingFrame") then current.ScrollingEnabled = state end
        current = current.Parent
    end
end

function DropdownComponent.Create(parentFrame: GuiObject, title: string, options: {any}, defaultOption: any, callback: (any) -> (), isMulti: boolean, registerFlag: (any, any) -> ())
    title = tostring(title or "Dropdown")
    options = type(options) == "table" and options or {}
    local isOpen = false

    local selectedSingle = ""
    local selectedMulti = {}

    if isMulti then
        if type(defaultOption) == "table" then
            for _, v in ipairs(defaultOption) do selectedMulti[tostring(v)] = true end
        elseif defaultOption then
            selectedMulti[tostring(defaultOption)] = true
        end
    else
        selectedSingle = defaultOption or (options[1] or "")
    end

    local wrapper = Instance.new("Frame")
    wrapper.Name = "DropdownWrapper"
    wrapper.Size = UDim2.new(1, 0, 0, 0)
    wrapper.BackgroundTransparency = 1
    wrapper.Parent = parentFrame
    wrapper.AutomaticSize = Enum.AutomaticSize.Y

    local dropFrame = Instance.new("Frame")
    dropFrame.Name = "DropdownFrame"
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
    header.Name = "Header"
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

    local selectedLabel = Instance.new("TextLabel", header)
    selectedLabel.Size = UDim2.new(0.5, -24, 1, 0)
    selectedLabel.Position = UDim2.new(0.5, 0, 0, 0)
    selectedLabel.BackgroundTransparency = 1
    selectedLabel.Font = Enum.Font.Gotham
    selectedLabel.TextSize = 12
    selectedLabel.TextXAlignment = Enum.TextXAlignment.Right
    selectedLabel.TextTruncate = Enum.TextTruncate.AtEnd
    Themes:RegisterText(selectedLabel, true)

    local clickBtn = Instance.new("TextButton", header)
    clickBtn.Size = UDim2.fromScale(1, 1)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""

    local function UpdateHeaderVisual()
        if isMulti then
            local count = 0
            local firstVal = ""
            for k, v in pairs(selectedMulti) do
                if v then 
                    count = count + 1 
                    if firstVal == "" then firstVal = k end
                end
            end
            if count == 0 then selectedLabel.Text = "None"
            elseif count == 1 then selectedLabel.Text = firstVal
            else selectedLabel.Text = count .. " Selected" end
        else
            selectedLabel.Text = tostring(selectedSingle)
        end
    end
    UpdateHeaderVisual()

    local searchWrapper = Instance.new("Frame")
    searchWrapper.Size = UDim2.new(1, -16, 0, 30)
    searchWrapper.BackgroundTransparency = 1
    searchWrapper.LayoutOrder = 2
    searchWrapper.Visible = false
    searchWrapper.Parent = dropFrame

    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1, 0, 1, 0)
    searchBox.BorderSizePixel = 0
    searchBox.PlaceholderText = "Search options..."
    searchBox.Text = ""
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 12
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.Parent = searchWrapper
    Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 6)
    Themes:AddPanel(searchBox, -0.01)
    Themes:RegisterText(searchBox, false)

    local searchStroke = Instance.new("UIStroke", searchBox)
    searchStroke.Thickness = 1
    Themes:RegisterBorder(searchStroke)

    local searchPadding = Instance.new("UIPadding", searchBox)
    searchPadding.PaddingLeft = UDim.new(0, 8)

    searchBox.Focused:Connect(function() 
        TweenService:Create(searchStroke, Tween.FAST, {Color = Themes.GlowColor}):Play()
    end)
    searchBox.FocusLost:Connect(function() 
        TweenService:Create(searchStroke, Tween.FAST, {Color = Themes.CurrentTheme.Border}):Play()
    end)
    
    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(1, -16, 0, 1)
    divider.BorderSizePixel = 0
    divider.LayoutOrder = 3
    divider.Visible = false
    divider.Parent = dropFrame
    Themes:OnThemeChanged(divider, function(t)
        divider.BackgroundColor3 = t.Border
    end)

    local listContainer = Instance.new("ScrollingFrame")
    listContainer.Size = UDim2.new(1, -16, 0, 0)
    listContainer.BackgroundTransparency = 1
    listContainer.BorderSizePixel = 0
    listContainer.LayoutOrder = 4
    listContainer.Visible = false
    listContainer.ScrollBarThickness = 3
    listContainer.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 65)
    listContainer.Parent = dropFrame

    listContainer.MouseEnter:Connect(function() ToggleScrollingAncestors(dropFrame, false) end)
    listContainer.MouseLeave:Connect(function() ToggleScrollingAncestors(dropFrame, true) end)

    local listLayout = Instance.new("UIListLayout", listContainer)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 3)

    local optionItems = {}

    local function CalcHeight()
        local count = 0
        for _, item in ipairs(optionItems) do if item.Btn.Visible then count = count + 1 end end
        local targetH = math.min(count, 5) * 32
        TweenService:Create(listContainer, Tween.FAST, {Size = UDim2.new(1, -16, 0, targetH)}):Play()
        listContainer.CanvasSize = UDim2.new(0, 0, 0, count * 32)
    end

    local function CloseDropdown()
        isOpen = false
        searchBox.Text = "" 
        searchWrapper.Visible = false
        divider.Visible = false
        listContainer.Visible = false
        TweenService:Create(arrowIcon, Tween.SPRING, {Rotation = 0}):Play()
        TweenService:Create(boxStroke, Tween.FAST, {Color = Themes.CurrentTheme.Border}):Play()
    end

    local function Refresh(newOptions)
        for _, item in ipairs(optionItems) do item.Btn:Destroy() end
        table.clear(optionItems)

        options = type(newOptions) == "table" and newOptions or {}
        for _, opt in ipairs(options) do
            local optStr = tostring(opt)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -4, 0, 30)
            btn.BorderSizePixel = 0
            btn.Text = "  " .. optStr
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 12
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.Parent = listContainer
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
            
            Themes:AddPanel(btn, 0.03, true)

            local indicator
            if isMulti then
                indicator = Instance.new("Frame", btn)
                indicator.AnchorPoint = Vector2.new(1, 0.5)
                indicator.Position = UDim2.new(1, -8, 0.5, 0)
                indicator.Size = UDim2.fromOffset(12, 12)
                local indStroke = Instance.new("UIStroke", indicator)
                Themes:RegisterBorder(indStroke)
                Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 3)
                Themes:AddPanel(indicator, 0.04)
            end
            
            local isHovering = false
            local currentBgTween, currentTxtTween

            local function UpdateVisuals(instant)
                local active = isMulti and selectedMulti[optStr] or (not isMulti and selectedSingle == optStr)
                
                local targetBg = active and Themes:GetColor(0.06) or Themes:GetColor(0.03)
                local targetTxt = active and Themes.CurrentTheme.Text or Themes.CurrentTheme.MutedText
                local indTargetBg = active and Themes.GlowColor or Themes:GetColor(0.03)
                
                if isHovering then
                    targetBg = Themes:GetColor(0.08)
                    targetTxt = Themes.CurrentTheme.Text
                end

                if currentBgTween then currentBgTween:Cancel() currentBgTween = nil end
                if currentTxtTween then currentTxtTween:Cancel() currentTxtTween = nil end

                if instant then
                    btn.BackgroundColor3 = targetBg
                    btn.TextColor3 = targetTxt
                    if isMulti and indicator then
                        indicator.BackgroundColor3 = indTargetBg
                    end
                else
                    currentBgTween = TweenService:Create(btn, Tween.FAST, {BackgroundColor3 = targetBg})
                    currentTxtTween = TweenService:Create(btn, Tween.FAST, {TextColor3 = targetTxt})
                    currentBgTween:Play()
                    currentTxtTween:Play()
                    
                    if isMulti and indicator then
                        TweenService:Create(indicator, Tween.FAST, {BackgroundColor3 = indTargetBg}):Play()
                    end
                end
            end
            UpdateVisuals(true)

            btn.MouseEnter:Connect(function() 
                isHovering = true
                UpdateVisuals(false)
            end)
            btn.MouseLeave:Connect(function()
                isHovering = false
                UpdateVisuals(false)
            end)

            btn.MouseButton1Click:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true), {Size = UDim2.new(1, -8, 0, 28)}):Play()

                if isMulti then
                    selectedMulti[optStr] = not selectedMulti[optStr]
                    UpdateVisuals(false)
                    UpdateHeaderVisual()
                    if type(callback) == "function" then
                        local ret = {}
                        for k,v in pairs(selectedMulti) do if v then table.insert(ret, k) end end
                        task.spawn(callback, ret)
                    end
                else
                    selectedSingle = optStr
                    UpdateHeaderVisual()
                    CloseDropdown()
                    for _, item in ipairs(optionItems) do item.Update(false) end
                    if type(callback) == "function" then task.spawn(callback, selectedSingle) end
                end
            end)

            table.insert(optionItems, { Btn = btn, Text = optStr, Update = function(instant) UpdateVisuals(instant) end })
            
            Themes:OnGlowChanged(btn, function()
                UpdateVisuals(true)
            end)
        end
        CalcHeight()
    end

    Refresh(options)

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local q = string.lower(searchBox.Text)
        for _, item in ipairs(optionItems) do
            item.Btn.Visible = (q == "" or string.find(string.lower(item.Text), q, 1, true)) ~= nil
        end
        CalcHeight()
    end)

    clickBtn.MouseButton1Click.Connect(clickBtn, function()
        isOpen = not isOpen
        if isOpen then
            searchWrapper.Visible = true
            divider.Visible = true
            listContainer.Visible = true
            CalcHeight()
            TweenService:Create(arrowIcon, Tween.SPRING, {Rotation = 180}):Play()
            TweenService:Create(boxStroke, Tween.FAST, {Color = Themes.GlowColor}):Play()
        else
            CloseDropdown()
        end
    end)
    
    Themes:OnGlowChanged(boxStroke, function(c)
        if isOpen then
            boxStroke.Color = c
        end
    end)
    
    Themes:OnGlowChanged(searchStroke, function(c)
        if searchBox:IsFocused() then
            searchStroke.Color = c
        end
    end)

    Themes:OnThemeChanged(dropFrame, function()
        for _, item in ipairs(optionItems) do item.Update(true) end
    end)

    local function getVal()
        if isMulti then
            local ret = {}
            for k,v in pairs(selectedMulti) do if v then table.insert(ret, k) end end
            return ret
        end
        return selectedSingle 
    end

    registerFlag(getVal, function(val)
        if isMulti then 
            selectedMulti = {}
            if type(val) == "table" then
                for _, v in ipairs(val) do selectedMulti[tostring(v)] = true end
            end
        else 
            selectedSingle = tostring(val)
        end
        UpdateHeaderVisual()
        Refresh(options)
        if typeof(callback) == "function" then
            task.spawn(callback, getVal())
        end
    end)

    return {
        Wrapper = wrapper,
        Frame = dropFrame,
        Refresh = function(self, newOpts) Refresh(newOpts) end,
        GetValue = getVal,
        SetText = function(self, newTitle)
            titleLabel.Text = newTitle
        end
    }
end

return DropdownComponent
