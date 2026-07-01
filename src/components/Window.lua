--!strict
--[[
    Window.lua
    Implements draggable, resizable client software application panels.
--]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

local Themes = require(script.Parent.Parent.themes)
local Lucide = require(script.Parent.Parent.services.Lucide)
local Tween = require(script.Parent.Parent.services.Tween)

local WindowComponent = {}

local lastNormalPosition = UDim2.fromScale(0.5, 0.5)
local lastNormalAnchor = Vector2.new(0.5, 0.5)

-- CAMERA LOCKING HOOKS
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

-- Dragging logic
local function MakeDraggable(dragPart: GuiObject, targetPart: GuiObject, scaleObj: UIScale)
    local dragging = false
    local dragInput, dragStart, startPos
    local dragActive = false
    
    dragPart.Active = true
    
    local function update(input)
        if not dragStart or not startPos then return end
        local delta = input.Position - dragStart
        local scale = scaleObj.Scale
        
        if dragActive or delta.Magnitude > 8 then
            dragActive = true
            targetPart.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + (delta.X / scale),
                startPos.Y.Scale, startPos.Y.Offset + (delta.Y / scale)
            )
            
            lastNormalPosition = targetPart.Position
            lastNormalAnchor = targetPart.AnchorPoint
        end
    end
    
    dragPart.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragActive = false
            dragStart = input.Position
            startPos = targetPart.Position
            
            LockCamera()
            
            local changeCon
            changeCon = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    dragInput = nil
                    UnlockCamera()
                    if changeCon then changeCon:Disconnect() end
                end
            end)
        end
    end)
    
    dragPart.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)
end

function WindowComponent.Create(config: {[any]: any}, screenGui: ScreenGui, scaleObj: UIScale, cameraLocker: TextButton)
    SetCameraLocker(cameraLocker)
    
    local Title = config.Title or "Kaze UI"
    local Author = config.Author or "Unknown"
    local Version = config.Version or "1.0"
    local MainIcon = Lucide.Format(config.Icon or "house")
    local OpenIcon = Lucide.Format((config.OpenButton and config.OpenButton.Icon) or config.Icon or "house")
    
    local minWidth = config.MinWidth or 350
    local minHeight = config.MinHeight or 250
    local maxWidth = config.MaxWidth or 900
    local maxHeight = config.MaxHeight or 700

    -- Apply theme parameter
    local selectedTheme = "Obsidian"
    if config.Theme then
        local lowerTheme = string.lower(tostring(config.Theme))
        if lowerTheme == "arctic" or lowerTheme == "white" or lowerTheme == "light" then
            selectedTheme = "Arctic"
        elseif lowerTheme == "amethyst" or lowerTheme == "purple" then
            selectedTheme = "Amethyst"
        elseif lowerTheme == "emerald" or lowerTheme == "green" then
            selectedTheme = "Emerald"
        elseif lowerTheme == "midnight" or lowerTheme == "blue" then
            selectedTheme = "Midnight"
        end
    end
    Themes:SetTheme(selectedTheme)

    -- Glow/Color parameters
    if config.Glow then
        local lowerGlow = string.lower(tostring(config.Glow))
        local glowMap = {
            red = Color3.fromRGB(255, 60, 60),
            blue = Color3.fromRGB(0, 160, 255),
            green = Color3.fromRGB(34, 197, 94),
            yellow = Color3.fromRGB(234, 179, 8),
            purple = Color3.fromRGB(168, 85, 247),
            pink = Color3.fromRGB(244, 114, 182),
            orange = Color3.fromRGB(249, 115, 22),
            white = Color3.fromRGB(255, 255, 255)
        }
        if glowMap[lowerGlow] then
            Themes:SetGlow(glowMap[lowerGlow])
        elseif typeof(config.Glow) == "Color3" then
            Themes:SetGlow(config.Glow)
        end
    elseif config.GlowColor then
        Themes:SetGlow(config.GlowColor)
    end

    local Window = Instance.new("Frame")
    Window.Size = UDim2.fromOffset(600, 400) 
    Window.Position = UDim2.fromScale(0.5, 0.5)
    Window.AnchorPoint = Vector2.new(0.5, 0.5)
    Window.BorderSizePixel = 0
    Window.Active = true
    Window.Parent = screenGui
    Instance.new("UICorner", Window).CornerRadius = UDim.new(0, 12)
    Themes:AddPanel(Window, 0)

    local outerShadow = Instance.new("Frame", Window)
    outerShadow.Size = UDim2.new(1, 10, 1, 10)
    outerShadow.Position = UDim2.fromOffset(-5, -5)
    outerShadow.BackgroundTransparency = 1
    outerShadow.ZIndex = -1
    local shCorner = Instance.new("UICorner", outerShadow)
    shCorner.CornerRadius = UDim.new(0, 14)
    local shStroke = Instance.new("UIStroke", outerShadow)
    shStroke.Thickness = 5
    shStroke.Color = Color3.fromRGB(0, 0, 0)
    shStroke.Transparency = 0.85

    local WindowStroke = Instance.new("UIStroke")
    WindowStroke.Thickness = 1.5
    WindowStroke.Parent = Window
    Themes:RegisterBorder(WindowStroke)

    local ContentClipper = Instance.new("CanvasGroup")
    ContentClipper.Size = UDim2.fromScale(1, 1)
    ContentClipper.BackgroundTransparency = 1
    ContentClipper.BorderSizePixel = 0
    ContentClipper.Parent = Window
    Instance.new("UICorner", ContentClipper).CornerRadius = UDim.new(0, 12)

    -- Animated transition open scale
    Window.Size = UDim2.fromOffset(560, 360)
    ContentClipper.GroupTransparency = 1
    TweenService:Create(Window, Tween.SMOOTH, {Size = UDim2.fromOffset(600, 400)}):Play()
    TweenService:Create(ContentClipper, Tween.FAST, {GroupTransparency = 0}):Play()

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1,0,0,50)
    TopBar.BorderSizePixel = 0
    TopBar.Active = true
    TopBar.Parent = ContentClipper
    MakeDraggable(TopBar, Window, scaleObj)
    Themes:AddPanel(TopBar, -0.01)

    local Avatar = Instance.new("ImageButton")
    Avatar.Size = UDim2.fromOffset(30,30)
    Avatar.Position = UDim2.fromOffset(12,10)
    Avatar.Image = MainIcon
    Avatar.ScaleType = Enum.ScaleType.Fit
    Avatar.AutoButtonColor = false
    Avatar.Parent = TopBar
    Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1,0)
    
    local avatarStroke = Instance.new("UIStroke", Avatar)
    avatarStroke.Thickness = 1
    Themes:RegisterBorder(avatarStroke)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -200, 0, 20)
    TitleLabel.Position = UDim2.fromOffset(52,6)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Title
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar
    Themes:RegisterText(TitleLabel, false)

    local SubLabel = Instance.new("TextLabel")
    SubLabel.Size = UDim2.new(1, -200, 0, 16)
    SubLabel.Position = UDim2.fromOffset(52,26)
    SubLabel.BackgroundTransparency = 1
    SubLabel.Text = Author .. " • v" .. Version
    SubLabel.Font = Enum.Font.Gotham
    SubLabel.TextSize = 11
    SubLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubLabel.Parent = TopBar
    Themes:RegisterText(SubLabel, true)

    local TopDivider = Instance.new("Frame")
    TopDivider.Size = UDim2.new(1,0,0,1)
    TopDivider.Position = UDim2.new(0,0,1,-1)
    TopDivider.BorderSizePixel = 0
    TopDivider.ZIndex = 5
    TopDivider.Parent = TopBar
    Themes:OnThemeChanged(TopDivider, function(t)
        TopDivider.BackgroundColor3 = t.Border
    end)

    local defaultWindowSize = UDim2.fromOffset(600, 400)
    local lastNormalSize = defaultWindowSize
    local toggledMaximized = false

    local function createCircleButton(name: string, offsetX: number, color: Color3)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.fromOffset(12,12)
        btn.Position = UDim2.new(1, offsetX, 0.5, -6)
        btn.BackgroundColor3 = color
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.Parent = TopBar
        Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)
        
        local innerStroke = Instance.new("UIStroke", btn)
        innerStroke.Thickness = 1
        innerStroke.Color = Color3.fromRGB(20, 20, 22)
        return btn
    end

    local BtnGreen = createCircleButton("BtnGreen", -80, Color3.fromRGB(34, 197, 94))
    local BtnYellow = createCircleButton("BtnYellow", -56, Color3.fromRGB(234, 179, 8))
    local BtnRed = createCircleButton("BtnRed", -32, Color3.fromRGB(239, 68, 68))

    -- Mobile floating launcher button configuration
    local MiniButton = Instance.new("TextButton") 
    MiniButton.Size = UDim2.fromOffset(46, 46)
    MiniButton.Position = UDim2.new(0, 24, 0, 85)
    MiniButton.BackgroundTransparency = 1 
    MiniButton.Text = ""
    MiniButton.Visible = false
    MiniButton.Parent = screenGui
    MiniButton.ZIndex = 999

    local MiniIcon = Instance.new("ImageLabel")
    MiniIcon.Size = UDim2.fromScale(1, 1) 
    MiniIcon.Position = UDim2.fromScale(0.5, 0.5)
    MiniIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    MiniIcon.BackgroundTransparency = 0
    MiniIcon.Image = OpenIcon
    MiniIcon.ScaleType = Enum.ScaleType.Fit
    MiniIcon.Parent = MiniButton
    MiniIcon.ZIndex = 1000
    Instance.new("UICorner", MiniIcon).CornerRadius = UDim.new(0, 10)
    Themes:AddPanel(MiniIcon, 0.02)
    Themes:OnThemeChanged(MiniIcon, function(t)
        MiniIcon.ImageColor3 = t.Text
    end)

    local MiniStroke = Instance.new("UIStroke")
    MiniStroke.Thickness = 1.5
    MiniStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MiniStroke.Parent = MiniIcon 
    Themes:RegisterBorder(MiniStroke)

    local isMinimized = false
    local function minimizeWindow()
        if isMinimized then return end
        isMinimized = true
        
        if not toggledMaximized then
            lastNormalPosition = Window.Position
            lastNormalAnchor = Window.AnchorPoint
        end
        Window.Visible = false
        MiniButton.Visible = true
        MiniButton.Size = UDim2.fromOffset(0,0)
        TweenService:Create(MiniButton, Tween.SPRING, { Size = UDim2.fromOffset(46,46) }):Play()
    end

    local function unminimizeWindow()
        if not isMinimized then return end
        isMinimized = false
        
        MiniButton.Visible = false
        Window.Visible = true
        Window.Size = UDim2.fromOffset(0,0)
        if toggledMaximized then
            Window.AnchorPoint = Vector2.new(0.5,0.5)
            Window.Position = UDim2.fromScale(0.5,0.5)
            TweenService:Create(Window, Tween.SPRING, { Size = UDim2.fromScale(0.95,0.9) }):Play()
        else
            Window.AnchorPoint = lastNormalAnchor
            Window.Position = lastNormalPosition
            TweenService:Create(Window, Tween.SPRING, { Size = lastNormalSize, Position = lastNormalPosition }):Play()
        end
    end

    BtnYellow.MouseButton1Click:Connect(minimizeWindow)

    local miniDragStart
    local miniDragMoved = false
    
    MiniButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            miniDragStart = input.Position
            miniDragMoved = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if miniDragStart and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            if (input.Position - miniDragStart).Magnitude > 8 then
                miniDragMoved = true
                local delta = input.Position - miniDragStart
                MiniButton.Position = UDim2.new(
                    0, MiniButton.Position.X.Offset + delta.X,
                    0, MiniButton.Position.Y.Offset + delta.Y
                )
                miniDragStart = input.Position
            end
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if miniDragStart and not miniDragMoved then
                unminimizeWindow()
            end
            miniDragStart = nil
            miniDragMoved = false
        end
    end)

    BtnGreen.MouseButton1Click:Connect(function()
        if not toggledMaximized then
            lastNormalSize = Window.Size
            lastNormalPosition = Window.Position
            lastNormalAnchor = Window.AnchorPoint
            toggledMaximized = true
            Window.AnchorPoint = Vector2.new(0.5,0.5)
            Window.Position = UDim2.fromScale(0.5,0.5)
            TweenService:Create(Window, Tween.SMOOTH, { Size = UDim2.fromScale(0.95,0.9) }):Play()
        else
            toggledMaximized = false
            TweenService:Create(Window, Tween.SMOOTH, { Size = lastNormalSize, Position = lastNormalPosition }):Play()
            task.delay(0.25, function() Window.AnchorPoint = lastNormalAnchor end)
        end
    end)

    local confirmActive = false
    local function ShowCloseConfirm()
        if confirmActive then return end
        confirmActive = true
        BtnYellow.Active = false; BtnGreen.Active = false; BtnRed.Active = false
        
        local Overlay = Instance.new("Frame", Window)
        Overlay.Size = UDim2.new(1,0,1,0)
        Overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
        Overlay.BackgroundTransparency = 1
        Overlay.ZIndex = 50
        Instance.new("UICorner", Overlay).CornerRadius = UDim.new(0, 12)

        TweenService:Create(Overlay, Tween.FAST, {BackgroundTransparency = 0.65}):Play()

        local ConfirmWindow = Instance.new("Frame", Overlay)
        ConfirmWindow.Size = UDim2.fromOffset(340, 140)
        ConfirmWindow.AnchorPoint = Vector2.new(0.5,0.5)
        ConfirmWindow.Position = UDim2.fromScale(0.5,0.45)
        ConfirmWindow.ZIndex = 52
        Instance.new("UICorner", ConfirmWindow).CornerRadius = UDim.new(0,10)
        Themes:AddPanel(ConfirmWindow, 0.02)

        local confirmStroke = Instance.new("UIStroke", ConfirmWindow)
        confirmStroke.Thickness = 1.2
        Themes:RegisterBorder(confirmStroke)

        TweenService:Create(ConfirmWindow, Tween.SPRING, {Position = UDim2.fromScale(0.5,0.5)}):Play()

        local ConfirmText = Instance.new("TextLabel", ConfirmWindow)
        ConfirmText.Size = UDim2.new(1, -40, 0, 50)
        ConfirmText.Position = UDim2.fromOffset(20, 15)
        ConfirmText.BackgroundTransparency = 1
        ConfirmText.Text = "Do you want to exit KazeUI?"
        ConfirmText.Font = Enum.Font.GothamBold
        ConfirmText.TextSize = 13
        ConfirmText.TextWrapped = true
        ConfirmText.ZIndex = 53
        Themes:RegisterText(ConfirmText, false)

        local ButtonsFrame = Instance.new("Frame", ConfirmWindow)
        ButtonsFrame.Size = UDim2.new(1,0,0,40)
        ButtonsFrame.Position = UDim2.new(0,0,1,-12)
        ButtonsFrame.AnchorPoint = Vector2.new(0,1)
        ButtonsFrame.BackgroundTransparency = 1
        ButtonsFrame.ZIndex = 53
        local layout = Instance.new("UIListLayout", ButtonsFrame)
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.Padding = UDim.new(0,12)

        local ConfirmBtn = Instance.new("TextButton", ButtonsFrame)
        ConfirmBtn.Size = UDim2.new(0,100,0,30)
        ConfirmBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
        ConfirmBtn.Text = "Confirm"
        ConfirmBtn.TextColor3 = Color3.fromRGB(255,255,255)
        ConfirmBtn.Font = Enum.Font.GothamBold
        ConfirmBtn.TextSize = 12
        ConfirmBtn.ZIndex = 54
        Instance.new("UICorner", ConfirmBtn).CornerRadius = UDim.new(0,6)

        local CancelBtn = Instance.new("TextButton", ButtonsFrame)
        CancelBtn.Size = UDim2.new(0,100,0,30)
        CancelBtn.Text = "Cancel"
        CancelBtn.Font = Enum.Font.GothamBold
        CancelBtn.TextSize = 12
        CancelBtn.ZIndex = 54
        Instance.new("UICorner", CancelBtn).CornerRadius = UDim.new(0,6)
        Themes:AddPanel(CancelBtn, 0.04)
        Themes:RegisterText(CancelBtn, true)

        ConfirmBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)
        CancelBtn.MouseButton1Click:Connect(function() 
            TweenService:Create(Overlay, Tween.FAST, {BackgroundTransparency = 1}):Play()
            local tw = TweenService:Create(ConfirmWindow, Tween.FAST, {Position = UDim2.fromScale(0.5,0.45)})
            tw:Play()
            tw.Completed:Wait()
            Overlay:Destroy()
            confirmActive = false
            BtnYellow.Active = true; BtnGreen.Active = true; BtnRed.Active = true 
        end)
    end
    BtnRed.MouseButton1Click:Connect(ShowCloseConfirm)

    local Content = Instance.new("Frame")
    Content.Position = UDim2.fromOffset(0,50)
    Content.Size = UDim2.new(1,0,1,-50)
    Content.BackgroundTransparency = 1
    Content.Parent = ContentClipper

    local SideBarMask = Instance.new("Frame")
    SideBarMask.Size = UDim2.new(0, 190, 1, 0)
    SideBarMask.BackgroundTransparency = 1
    SideBarMask.ClipsDescendants = true
    SideBarMask.Parent = Content

    local SideBar = Instance.new("Frame")
    SideBar.Size = UDim2.new(0, 190, 1, 0) 
    SideBar.BorderSizePixel = 0
    SideBar.Parent = SideBarMask
    Themes:AddPanel(SideBar, 0.01)

    local VertDivider = Instance.new("Frame")
    VertDivider.Size = UDim2.new(0,1,1,0)
    VertDivider.Position = UDim2.new(0,190,0,0)
    VertDivider.BorderSizePixel = 0
    VertDivider.Parent = Content
    Themes:OnThemeChanged(VertDivider, function(t)
        VertDivider.BackgroundColor3 = t.Border
    end)

    local Pages = Instance.new("Frame")
    Pages.Position = UDim2.new(0,191,0,0)
    Pages.Size = UDim2.new(1, -191, 1, 0)
    Pages.BorderSizePixel = 0
    Pages.Parent = Content
    Themes:AddPanel(Pages, -0.01)

    local isSidebarOpen = true
    Avatar.MouseButton1Click:Connect(function()
        isSidebarOpen = not isSidebarOpen
        local tInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        if isSidebarOpen then
            TweenService:Create(SideBarMask, tInfo, {Size = UDim2.new(0, 190, 1, 0)}):Play()
            TweenService:Create(VertDivider, tInfo, {Position = UDim2.new(0, 190, 0, 0), BackgroundTransparency = 0}):Play()
            TweenService:Create(Pages, tInfo, {Position = UDim2.new(0, 191, 0, 0), Size = UDim2.new(1, -191, 1, 0)}):Play()
        else
            TweenService:Create(SideBarMask, tInfo, {Size = UDim2.new(0, 0, 1, 0)}):Play()
            TweenService:Create(VertDivider, tInfo, {Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
            TweenService:Create(Pages, tInfo, {Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(1, 0, 1, 0)}):Play()
        end
    end)

    local TabsScroller = Instance.new("ScrollingFrame")
    TabsScroller.Parent = SideBar
    TabsScroller.Position = UDim2.fromOffset(6,6)
    TabsScroller.Size = UDim2.new(1, -12, 1, -12)
    TabsScroller.BackgroundTransparency = 1
    TabsScroller.ScrollBarThickness = 4
    TabsScroller.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabsScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabsScroller.ScrollBarImageColor3 = Color3.fromRGB(40,40,45)

    local TabsList = Instance.new("Frame")
    TabsList.BackgroundTransparency = 1
    TabsList.Size = UDim2.new(1, 0, 0, 0)
    TabsList.Parent = TabsScroller
    TabsList.AutomaticSize = Enum.AutomaticSize.Y

    local tabsLayout = Instance.new("UIListLayout", TabsList)
    tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabsLayout.Padding = UDim.new(0,4)

    -- Dynamic dragging/resizing configurations
    local ResizeHandle = Instance.new("ImageLabel")
    ResizeHandle.Name = "ResizeHandle"
    ResizeHandle.Size = UDim2.fromOffset(18, 18)
    ResizeHandle.Position = UDim2.new(1, -18, 1, -18)
    ResizeHandle.BackgroundTransparency = 1
    ResizeHandle.Image = "rbxassetid://10747373117"
    ResizeHandle.Active = true
    ResizeHandle.ZIndex = 99
    ResizeHandle.Parent = Window
    Themes:OnThemeChanged(ResizeHandle, function(t)
        ResizeHandle.ImageColor3 = t.MutedText
    end)

    local isResizing = false
    local resizeStartSize = Vector2.new(0, 0)
    local resizeStartInput = Vector3.new(0, 0, 0)
    local resizeTouchInput = nil

    local hoverCursor = "rbxassetid://10747373117"
    ResizeHandle.MouseEnter:Connect(function()
        if not isResizing and not toggledMaximized then
            Mouse.Icon = hoverCursor
            TweenService:Create(ResizeHandle, TweenInfo.new(0.12), {ImageColor3 = Themes.GlowColor}):Play()
        end
    end)

    ResizeHandle.MouseLeave:Connect(function()
        if not isResizing then
            Mouse.Icon = ""
            TweenService:Create(ResizeHandle, TweenInfo.new(0.12), {ImageColor3 = Themes.CurrentTheme.MutedText}):Play()
        end
    end)

    local function toggleScrollingAncestors(element, state)
        local current = element.Parent
        while current do
            if current:IsA("ScrollingFrame") then current.ScrollingEnabled = state end
            current = current.Parent
        end
    end

    local function UpdateResize(input)
        if not isResizing then return end
        local delta = input.Position - resizeStartInput
        local scale = scaleObj.Scale

        local newWidth = math.clamp(resizeStartSize.X + (delta.X / scale), minWidth, maxWidth)
        local newHeight = math.clamp(resizeStartSize.Y + (delta.Y / scale), minHeight, maxHeight)

        Window.Size = UDim2.fromOffset(newWidth, newHeight)
        lastNormalSize = Window.Size
    end

    ResizeHandle.InputBegan:Connect(function(input)
        if toggledMaximized then return end

        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if input.UserInputType == Enum.UserInputType.Touch and resizeTouchInput == nil then
                resizeTouchInput = input
            end

            isResizing = true
            resizeStartSize = Vector2.new(Window.AbsoluteSize.X / scaleObj.Scale, Window.AbsoluteSize.Y / scaleObj.Scale)
            resizeStartInput = input.Position

            LockCamera()
            toggleScrollingAncestors(ResizeHandle, false)
            Mouse.Icon = hoverCursor
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isResizing then
            if input.UserInputType == Enum.UserInputType.Touch and input ~= resizeTouchInput then
                return
            end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                UpdateResize(input)
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if isResizing then
            if input.UserInputType == Enum.UserInputType.Touch and input ~= resizeTouchInput then
                return
            end
            isResizing = false
            resizeTouchInput = nil
            
            UnlockCamera()
            toggleScrollingAncestors(ResizeHandle, true)
            Mouse.Icon = ""
            TweenService:Create(ResizeHandle, TweenInfo.new(0.12), {ImageColor3 = Themes.CurrentTheme.MutedText}):Play()
        end
    end)

    return {
        Window = Window,
        Pages = Pages,
        TabsList = TabsList,
        MiniButton = MiniButton,
        isMinimized = function() return isMinimized end,
        Minimize = minimizeWindow,
        Show = unminimizeWindow,
        Toggle = function(self)
            if isMinimized or not Window.Visible then
                self:Show()
            else
                self:Minimize()
            end
        end,
        LastNormalSize = lastNormalSize
    }
end

return WindowComponent
