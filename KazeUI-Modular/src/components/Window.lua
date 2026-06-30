local WindowModule = {}

-- Load core utilities and engines
local ThemesModule = require("src/themes/init")
local UtilsModule = require("src/utils/init")
local ConfigModule = require("src/config/init")
local NotificationModule = require("src/components/Notification")

-- Components mapping
local Paragraph = require("src/components/ui/Paragraph")
local Button = require("src/components/ui/Button")
local Toggle = require("src/components/ui/Toggle")
local TextBox = require("src/components/ui/TextBox")
local Slider = require("src/components/ui/Slider")
local Dropdown = require("src/components/ui/Dropdown")
local ColorPicker = require("src/components/ui/ColorPicker")
local Keybind = require("src/components/ui/Keybind")
local Divider = require("src/components/ui/Divider")
local Section = require("src/components/ui/Section")

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local LP = game:GetService("Players").LocalPlayer
local Mouse = LP:GetMouse()

-- Tween Presets
local TWEEN_FAST = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TWEEN_SPRING = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local TWEEN_SMOOTH = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local function AttachElementsToAPI(apiTable, parentFrame)
	function apiTable:AddLabel(arg1)
		local t = type(arg1) == "table" and (arg1.Text or arg1.Title) or arg1
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, -8, 0, 20)
		label.BackgroundTransparency = 1
		label.Text = tostring(t or " ")
		label.Font = Enum.Font.Gotham
		label.TextSize = 12
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextWrapped = true
		label.Parent = parentFrame
		ThemesModule:RegisterText(label, true)
		return label
	end

	function apiTable:Paragraph(arg1, arg2)
		local title = type(arg1) == "table" and arg1.Title or arg1
		local content = type(arg1) == "table" and (arg1.Content or arg1.Description) or arg2
		return Paragraph.new(parentFrame, title, content)
	end

	function apiTable:Button(arg1, arg2, arg3)
		local title = type(arg1) == "table" and arg1.Title or arg1
		local desc = type(arg1) == "table" and (arg1.Description or arg1.Content or "") or arg2
		local callback = type(arg1) == "table" and arg1.Callback or arg3
		return Button.new(parentFrame, title, desc, callback)
	end

	function apiTable:Toggle(arg1, arg2, arg3, arg4, arg5)
		local title, desc, def, callback, flag
		if type(arg1) == "table" then
			title, desc, def, callback, flag = arg1.Title, (arg1.Description or arg1.Content or ""), arg1.Default, arg1.Callback, arg1.Flag
		else
			title, desc, def, callback, flag = arg1, arg2, arg3, arg4, arg5
		end
		return Toggle.new(parentFrame, title, desc, def, callback, flag)
	end

	function apiTable:TextBox(arg1, arg2, arg3, arg4, arg5)
		local title, place, def, callback, flag
		if type(arg1) == "table" then
			title, place, def, callback, flag = arg1.Title, arg1.Placeholder, arg1.Default, arg1.Callback, arg1.Flag
		else
			title, place, def, callback, flag = arg1, arg2, arg3, arg4, arg5
		end
		return TextBox.new(parentFrame, title, place, def, callback, flag)
	end

	function apiTable:Slider(arg1, arg2, arg3, arg4, arg5, arg6)
		local title, min, max, def, callback, flag
		if type(arg1) == "table" then
			title, min, max, def, callback, flag = arg1.Title, arg1.Min, arg1.Max, arg1.Default, arg1.Callback, arg1.Flag
		else
			title, min, max, def, callback, flag = arg1, arg2, arg3, arg4, arg5, arg6
		end
		return Slider.new(parentFrame, title, min, max, def, callback, flag)
	end

	function apiTable:Dropdown(arg1, arg2, arg3, arg4, arg5, arg6)
		local title, vals, def, callback, multi, flag
		if type(arg1) == "table" then
			title, vals, def, multi, callback, flag = arg1.Title, (arg1.Values or arg1.Options), arg1.Default, (arg1.Multi or false), arg1.Callback, arg1.Flag
		else
			title, vals, def, callback, multi, flag = arg1, arg2, arg3, arg4, (arg5 or false), arg6
		end
		return Dropdown.new(parentFrame, title, vals, def, callback, multi, flag)
	end

	function apiTable:ColorPicker(arg1, arg2, arg3, arg4)
		local title, def, cb, flag
		if type(arg1) == "table" then
			title, def, cb, flag = arg1.Title, arg1.Default, arg1.Callback, arg1.Flag
		else
			title, def, cb, flag = arg1, arg2, arg3, arg4
		end
		return ColorPicker.new(parentFrame, title, def, cb, flag)
	end
	
	function apiTable:Keybind(arg1, arg2, arg3, arg4)
		local title, def, cb, flag
		if type(arg1) == "table" then
			title, def, cb, flag = arg1.Title, arg1.Default, arg1.Callback, arg1.Flag
		else
			title, def, cb, flag = arg1, arg2, arg3, arg4
		end
		return Keybind.new(parentFrame, title, def, cb, flag)
	end

	function apiTable:SectionUI(arg1)
		local title = type(arg1) == "table" and (arg1.Title or arg1.Name) or arg1
		return Section.new(parentFrame, title, AttachElementsToAPI)
	end
	
	function apiTable:Section(arg1)
		local title = type(arg1) == "table" and (arg1.Title or arg1.Name) or arg1
		return Divider.new(parentFrame, title)
	end
end

function WindowModule:CreateWindow(config, screenGui)
	config = config or {}
	local Title = config.Title or "Kaze UI"
	local Author = config.Author or "Unknown"
	local Version = config.Version or "1.0"
	local MainIcon = UtilsModule:FormatImage(config.Icon or "house")
	local OpenIcon = UtilsModule:FormatImage((config.OpenButton and config.OpenButton.Icon) or config.Icon or "house")
	
	local minWidth = config.MinWidth or 350
	local minHeight = config.MinHeight or 250
	local maxWidth = config.MaxWidth or 900
	local maxHeight = config.MaxHeight or 700

	local selectedTheme = "Obsidian"
	if config.Theme then
		local lowerTheme = string.lower(tostring(config.Theme))
		if lowerTheme == "arctic" or lowerTheme == "white" or lowerTheme == "light" then
			selectedTheme = "Arctic"
		elseif lowerTheme == "amethyst" or lowerTheme == "purple" then
			selectedTheme = "Amethyst"
		elseif lowerTheme == "emerald" or lowerTheme == "green" then
			selectedTheme = "Emerald"
		elseif lowerTheme == "midnight" or lowerTheme == "blue" or lowerTheme == "black" then
			selectedTheme = "Midnight"
		end
	end
	ThemesModule:SetTheme(selectedTheme)

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
			ThemesModule:SetGlow(glowMap[lowerGlow])
		elseif typeof(config.Glow) == "Color3" then
			ThemesModule:SetGlow(config.Glow)
		end
	elseif config.GlowColor then
		ThemesModule:SetGlow(config.GlowColor)
	end

	local MiniButtonSize = UDim2.fromOffset(46, 46)

	local Window = Instance.new("Frame")
	Window.Size = UDim2.fromOffset(600, 400) 
	Window.Position = UDim2.fromScale(0.5, 0.5)
	Window.AnchorPoint = Vector2.new(0.5, 0.5)
	Window.BorderSizePixel = 0
	Window.Active = true
	Window.Parent = screenGui
	Instance.new("UICorner", Window).CornerRadius = UDim.new(0, 12)
	ThemesModule:AddPanel(Window, 0)

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
	ThemesModule:RegisterBorder(WindowStroke)

	local ContentClipper = Instance.new("CanvasGroup")
	ContentClipper.Size = UDim2.fromScale(1, 1)
	ContentClipper.BackgroundTransparency = 1
	ContentClipper.BorderSizePixel = 0
	ContentClipper.Parent = Window
	Instance.new("UICorner", ContentClipper).CornerRadius = UDim.new(0, 12)

	Window.Size = UDim2.fromOffset(560, 360)
	ContentClipper.GroupTransparency = 1
	TweenService:Create(Window, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(600, 400)}):Play()
	TweenService:Create(ContentClipper, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 0}):Play()

	local TopBar = Instance.new("Frame")
	TopBar.Size = UDim2.new(1,0,0,50)
	TopBar.BorderSizePixel = 0
	TopBar.Active = true
	TopBar.Parent = ContentClipper
	UtilsModule:MakeDraggable(TopBar, Window)
	ThemesModule:AddPanel(TopBar, -0.01)

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
	ThemesModule:RegisterBorder(avatarStroke)

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Size = UDim2.new(1, -200, 0, 20)
	TitleLabel.Position = UDim2.fromOffset(52,6)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = Title
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextSize = 14
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Parent = TopBar
	ThemesModule:RegisterText(TitleLabel, false)

	local SubLabel = Instance.new("TextLabel")
	SubLabel.Size = UDim2.new(1, -200, 0, 16)
	SubLabel.Position = UDim2.fromOffset(52,26)
	SubLabel.BackgroundTransparency = 1
	SubLabel.Text = Author .. " • v" .. Version
	SubLabel.Font = Enum.Font.Gotham
	SubLabel.TextSize = 11
	SubLabel.TextXAlignment = Enum.TextXAlignment.Left
	SubLabel.Parent = TopBar
	ThemesModule:RegisterText(SubLabel, true)

	local TopDivider = Instance.new("Frame")
	TopDivider.Size = UDim2.new(1,0,0,1)
	TopDivider.Position = UDim2.new(0,0,1,-1)
	TopDivider.BorderSizePixel = 0
	TopDivider.ZIndex = 5
	TopDivider.Parent = TopBar
	ThemesModule:OnThemeChanged(TopDivider, function(t)
		TopDivider.BackgroundColor3 = t.Border
	end)

	local defaultWindowSize = UDim2.fromOffset(600, 400)
	local lastNormalSize = defaultWindowSize
	local toggledMaximized = false

	local function createCircleButton(name, offsetX, color)
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

	local MiniButton = Instance.new("TextButton") 
	MiniButton.Size = MiniButtonSize
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
	ThemesModule:AddPanel(MiniIcon, 0.02)
	ThemesModule:OnThemeChanged(MiniIcon, function(t)
		MiniIcon.ImageColor3 = t.Text
	end)

	local MiniStroke = Instance.new("UIStroke")
	MiniStroke.Thickness = 1.5
	MiniStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	MiniStroke.Parent = MiniIcon 
	ThemesModule:RegisterBorder(MiniStroke)

	local isMinimized = false
	local function minimizeWindow()
		if isMinimized then return end
		isMinimized = true
		
		local lastPos, lastAnchor = UtilsModule:GetLastDragStates()
		if not toggledMaximized then
			UtilsModule:SetLastDragStates(Window.Position, Window.AnchorPoint)
		end
		Window.Visible = false
		MiniButton.Visible = true
		MiniButton.Size = UDim2.fromOffset(0,0)
		TweenService:Create(MiniButton, TWEEN_SPRING, { Size = MiniButtonSize }):Play()
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
			TweenService:Create(Window, TWEEN_SPRING, { Size = UDim2.fromScale(0.95,0.9) }):Play()
		else
			local lastPos, lastAnchor = UtilsModule:GetLastDragStates()
			Window.AnchorPoint = lastAnchor
			Window.Position = lastPos
			TweenService:Create(Window, TWEEN_SPRING, { Size = lastNormalSize, Position = lastPos }):Play()
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
	
	UIS.InputChanged:Connect(function(input)
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
	
	UIS.InputEnded:Connect(function(input)
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
			local lastPos, lastAnchor = UtilsModule:GetLastDragStates()
			UtilsModule:SetLastDragStates(Window.Position, Window.AnchorPoint)
			toggledMaximized = true
			Window.AnchorPoint = Vector2.new(0.5,0.5)
			Window.Position = UDim2.fromScale(0.5,0.5)
			TweenService:Create(Window, TWEEN_SMOOTH, { Size = UDim2.fromScale(0.95,0.9) }):Play()
		else
			toggledMaximized = false
			local lastPos, lastAnchor = UtilsModule:GetLastDragStates()
			TweenService:Create(Window, TWEEN_SMOOTH, { Size = lastNormalSize, Position = lastPos }):Play()
			task.delay(0.25, function() Window.AnchorPoint = lastAnchor end)
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

		TweenService:Create(Overlay, TWEEN_FAST, {BackgroundTransparency = 0.65}):Play()

		local ConfirmWindow = Instance.new("Frame", Overlay)
		ConfirmWindow.Size = UDim2.fromOffset(340, 140)
		ConfirmWindow.AnchorPoint = Vector2.new(0.5,0.5)
		ConfirmWindow.Position = UDim2.fromScale(0.5,0.45)
		ConfirmWindow.ZIndex = 52
		Instance.new("UICorner", ConfirmWindow).CornerRadius = UDim.new(0,10)
		ThemesModule:AddPanel(ConfirmWindow, 0.02)

		local confirmStroke = Instance.new("UIStroke", ConfirmWindow)
		confirmStroke.Thickness = 1.2
		ThemesModule:RegisterBorder(confirmStroke)

		TweenService:Create(ConfirmWindow, TWEEN_SPRING, {Position = UDim2.fromScale(0.5,0.5)}):Play()

		local ConfirmText = Instance.new("TextLabel", ConfirmWindow)
		ConfirmText.Size = UDim2.new(1, -40, 0, 50)
		ConfirmText.Position = UDim2.fromOffset(20, 15)
		ConfirmText.BackgroundTransparency = 1
		ConfirmText.Text = "Do you want to exit KazeUI?"
		ConfirmText.Font = Enum.Font.GothamBold
		ConfirmText.TextSize = 13
		ConfirmText.TextWrapped = true
		ConfirmText.ZIndex = 53
		ThemesModule:RegisterText(ConfirmText, false)

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
		ThemesModule:AddPanel(CancelBtn, 0.04)
		ThemesModule:RegisterText(CancelBtn, true)

		ConfirmBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)
		CancelBtn.MouseButton1Click:Connect(function() 
			TweenService:Create(Overlay, TWEEN_FAST, {BackgroundTransparency = 1}):Play()
			local tw = TweenService:Create(ConfirmWindow, TWEEN_FAST, {Position = UDim2.fromScale(0.5,0.45)})
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
	ThemesModule:AddPanel(SideBar, 0.01)

	local VertDivider = Instance.new("Frame")
	VertDivider.Size = UDim2.new(0,1,1,0)
	VertDivider.Position = UDim2.new(0,190,0,0)
	VertDivider.BorderSizePixel = 0
	VertDivider.Parent = Content
	ThemesModule:OnThemeChanged(VertDivider, function(t)
		VertDivider.BackgroundColor3 = t.Border
	end)

	local Pages = Instance.new("Frame")
	Pages.Position = UDim2.new(0,191,0,0)
	Pages.Size = UDim2.new(1, -191, 1, 0)
	Pages.BorderSizePixel = 0
	Pages.Parent = Content
	ThemesModule:AddPanel(Pages, -0.01)

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
			TweenService:Create(Pages, tInfo, {Position = UDim2.fromScale(0, 0), Size = UDim2.fromScale(1, 1)}):Play()
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

	local ResizeHandle = Instance.new("ImageLabel")
	ResizeHandle.Name = "ResizeHandle"
	ResizeHandle.Size = UDim2.fromOffset(18, 18)
	ResizeHandle.Position = UDim2.new(1, -18, 1, -18)
	ResizeHandle.BackgroundTransparency = 1
	ResizeHandle.Image = "rbxassetid://10747373117"
	ResizeHandle.Active = true
	ResizeHandle.ZIndex = 99
	ResizeHandle.Parent = Window
	ThemesModule:OnThemeChanged(ResizeHandle, function(t)
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
			TweenService:Create(ResizeHandle, TweenInfo.new(0.12), {ImageColor3 = ThemesModule.GlowColor}):Play()
		end
	end)

	ResizeHandle.MouseLeave:Connect(function()
		if not isResizing then
			Mouse.Icon = ""
			TweenService:Create(ResizeHandle, TweenInfo.new(0.12), {ImageColor3 = ThemesModule.CurrentTheme.MutedText}):Play()
		end
	end)

	local function UpdateResize(input)
		if not isResizing then return end
		local delta = input.Position - resizeStartInput
		local scale = UtilsModule:GetScale()

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
			resizeStartSize = Vector2.new(Window.AbsoluteSize.X / UtilsModule:GetScale(), Window.AbsoluteSize.Y / UtilsModule:GetScale())
			resizeStartInput = input.Position

			UtilsModule:LockCamera()
			UtilsModule:ToggleScrollingAncestors(ResizeHandle, false)
			Mouse.Icon = hoverCursor
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if isResizing then
			if input.UserInputType == Enum.UserInputType.Touch and input ~= resizeTouchInput then
				return
			end
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				UpdateResize(input)
			end
		end
	end)

	UIS.InputEnded:Connect(function(input)
		if isResizing then
			if input.UserInputType == Enum.UserInputType.Touch and input ~= resizeTouchInput then
				return
			end
			isResizing = false
			resizeTouchInput = nil
			
			UtilsModule:UnlockCamera()
			UtilsModule:ToggleScrollingAncestors(ResizeHandle, true)
			Mouse.Icon = ""
			TweenService:Create(ResizeHandle, TweenInfo.new(0.12), {ImageColor3 = ThemesModule.CurrentTheme.MutedText}):Play()
		end
	end)

	local Win = {
		Window = Window,
		ScreenGui = screenGui,
		_Pages = Pages,
		_TabsList = TabsList,
		_Tabs = {},
		Minimize = function(self)
			minimizeWindow()
		end,
		Show = function(self)
			unminimizeWindow()
		end,
		Maximize = function(self)
			unminimizeWindow()
		end,
		Toggle = function(self)
			if isMinimized or not Window.Visible then
				self:Show()
			else
				self:Minimize()
			end
		end
	}

	function Win:CreateConfigManager(tab)
		local sec = tab:SectionUI("Config Manager")
		local cfgName = "Default"

		local function getConfigs()
			local list = {}
			if listfiles then
				local s, files = pcall(function() return listfiles("") end)
				if not s then s, files = pcall(function() return listfiles("workspace") end) end
				if s and type(files) == "table" then
					for _, f in ipairs(files) do
						local fileName = string.match(f, "([^/\\]+)$") or f
						local name = string.match(fileName, "^KazeUI_(.+)%.json$")
						if name then table.insert(list, name) end
					end
				end
			end
			if #list == 0 then table.insert(list, "Default") end
			return list
		end

		sec:TextBox({Title = "Config Name", Default = "Default", Callback = function(v) cfgName = v end})
		
		local configDropdown
		sec:Button({Title = "Save Config", Callback = function() 
			ConfigModule:SaveConfig(cfgName, function(conf) NotificationModule:Notify(conf) end) 
			if configDropdown then configDropdown:Refresh(getConfigs()) end
		end})

		configDropdown = sec:Dropdown({
			Title = "Select Saved Config", 
			Options = getConfigs(), 
			Callback = function(v) cfgName = v end
		})

		sec:Button({Title = "Refresh Configs", Callback = function() if configDropdown then configDropdown:Refresh(getConfigs()) end end})
		sec:Button({Title = "Load Config", Callback = function() ConfigModule:LoadConfig(cfgName, function(conf) NotificationModule:Notify(conf) end) end})
		
		sec:Button({Title = "Delete Config", Callback = function()
			if delfile then
				pcall(function() delfile("KazeUI_"..cfgName..".json") end)
				NotificationModule:Notify({Title = "Config System", Content = "Deleted " .. cfgName, Duration = 3})
				if configDropdown then configDropdown:Refresh(getConfigs()) end
			else
				NotificationModule:Notify({Title = "Error", Content = "Your executor lacks 'delfile' support.", Duration = 3})
			end
		end})
	end

	function Win:CreateThemeManager(tab)
		local sec = tab:SectionUI("Theme & Visuals")
		
		local themeNames = {}
		for name, _ in pairs(ThemesModule.Themes) do
			table.insert(themeNames, name)
		end
		table.sort(themeNames)

		sec:Dropdown({
			Title = "Interface Theme Preset",
			Options = themeNames,
			Default = ThemesModule.CurrentTheme.Name,
			Flag = "KazeUI_Theme_Preset",
			Callback = function(val)
				ThemesModule:SetTheme(val)
			end
		})

		sec:ColorPicker({
			Title = "Accent Glow Color",
			Default = ThemesModule.GlowColor,
			Flag = "KazeUI_Theme_GlowColor", 
			Callback = function(color)
				ThemesModule:SetGlow(color)
			end
		})

		sec:Slider({
			Title = "UI Background Transparency",
			Min = 0,
			Max = 10,
			Default = 0,
			Flag = "KazeUI_Theme_BackgroundTransparency", 
			Callback = function(val)
				ThemesModule:SetTransparency(val / 10)
			end
		})
	end

	function Win:CreateTab(arg1, arg2)
		local name = tostring(type(arg1) == "table" and (arg1.Title or arg1.Name) or arg1 or "Tab")
		local iconId = type(arg1) == "table" and arg1.Icon or arg2
		local formattedIcon = UtilsModule:FormatImage(iconId or "")
		
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, -12, 0, 40)
		btn.BorderSizePixel = 0
		btn.Text = ""
		btn.AutoButtonColor = false
		btn.Parent = TabsList
		btn.ClipsDescendants = true
		btn.LayoutOrder = #self._Tabs + 1
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
		
		ThemesModule:AddPanel(btn, 0.02, true)

		local leftIndicator = Instance.new("Frame", btn)
		leftIndicator.Size = UDim2.new(0,3,1,0)
		leftIndicator.BackgroundColor3 = ThemesModule.GlowColor
		leftIndicator.BorderSizePixel = 0
		leftIndicator.Visible = false
		Instance.new("UICorner", leftIndicator).CornerRadius = UDim.new(0,6)

		ThemesModule:OnGlowChanged(leftIndicator, function(c)
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
		page.Parent = self._Pages

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

		table.insert(self._Tabs, { Button = btn, Indicator = leftIndicator, Label = txt, Page = page, Icon = iconLabel })

		local isHovering = false

		local function activate()
			for _, t in ipairs(self._Tabs) do
				TweenService:Create(t.Button, TWEEN_FAST, { BackgroundColor3 = ThemesModule.GetColor(0.02) }):Play()
				t.Indicator.Visible = false
				t.Page.Visible = false
				t.Label.TextColor3 = ThemesModule.CurrentTheme.MutedText
				t.Icon.ImageColor3 = ThemesModule.CurrentTheme.MutedText
				t.Label.Font = Enum.Font.Gotham
			end
			TweenService:Create(btn, TWEEN_FAST, { BackgroundColor3 = ThemesModule.GetColor(0.04) }):Play()
			leftIndicator.Visible = true
			page.Visible = true
			txt.TextColor3 = ThemesModule.CurrentTheme.Text
			txt.Font = Enum.Font.GothamBold
			
			TweenService:Create(iconLabel, TWEEN_FAST, { ImageColor3 = ThemesModule.GlowColor }):Play()
		end

		btn.MouseEnter:Connect(function()
			isHovering = true
			if not leftIndicator.Visible then
				TweenService:Create(btn, TWEEN_FAST, { BackgroundColor3 = ThemesModule.GetColor(0.03) }):Play()
				TweenService:Create(txt, TWEEN_FAST, { TextColor3 = ThemesModule.CurrentTheme.Text }):Play()
				TweenService:Create(iconLabel, TWEEN_FAST, { ImageColor3 = ThemesModule.CurrentTheme.Text }):Play()
			end
		end)
		btn.MouseLeave:Connect(function()
			isHovering = false
			if not leftIndicator.Visible then
				TweenService:Create(btn, TWEEN_FAST, { BackgroundColor3 = ThemesModule.GetColor(0.02) }):Play()
				TweenService:Create(txt, TWEEN_FAST, { TextColor3 = ThemesModule.CurrentTheme.MutedText }):Play()
				TweenService:Create(iconLabel, TWEEN_FAST, { ImageColor3 = ThemesModule.CurrentTheme.MutedText }):Play()
			end
		end)
		btn.MouseButton1Click:Connect(activate)
		if #self._Tabs == 1 then activate() end

		ThemesModule:OnThemeChanged(btn, function(t)
			if leftIndicator.Visible then
				txt.TextColor3 = t.Text
				if not isHovering then iconLabel.ImageColor3 = ThemesModule.GlowColor end
				btn.BackgroundColor3 = ThemesModule.GetColor(0.04)
			else
				txt.TextColor3 = t.MutedText
				if not isHovering then iconLabel.ImageColor3 = t.MutedText end
				btn.BackgroundColor3 = ThemesModule.GetColor(0.02)
			end
		end)

		local public = { Button = btn, Page = page }
		AttachElementsToAPI(public, pageContent)
		function public:SetText(newText)
			txt.Text = newText
		end
		return public
	end

	if typeof(config.Callback) == "function" then pcall(config.Callback) end
	return Win
end

return WindowModule
