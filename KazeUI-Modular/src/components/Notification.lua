local Notification = {}

local NotifContainer
local TweenService = game:GetService("TweenService")
local ThemesModule = require("src/themes/init")

function Notification:Init(parentGui)
	-- Notification Container Setup
	NotifContainer = Instance.new("Frame")
	local notifLayout = Instance.new("UIListLayout", NotifContainer)
	notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
	notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	notifLayout.Padding = UDim.new(0, 12)

	local notifPadding = Instance.new("UIPadding", NotifContainer)
	notifPadding.PaddingBottom = UDim.new(0, 24)
	notifPadding.PaddingRight = UDim.new(0, 24)

	NotifContainer.Name = "NotifContainer"
	NotifContainer.Size = UDim2.new(0, 320, 1, 0)
	NotifContainer.Position = UDim2.new(1, -340, 0, 0)
	NotifContainer.BackgroundTransparency = 1
	NotifContainer.Parent = parentGui
end

function Notification:Notify(config)
	config = config or {}
	local title = tostring(config.Title or "Notification")
	local content = tostring(config.Content or "")
	local duration = tonumber(config.Duration) or 3

	local notifHolder = Instance.new("Frame")
	notifHolder.Name = "NotifHolder"
	notifHolder.Size = UDim2.new(1, 0, 0, 0)
	notifHolder.BackgroundTransparency = 1
	notifHolder.BorderSizePixel = 0
	notifHolder.ClipsDescendants = true
	notifHolder.Parent = NotifContainer

	local notifFrame = Instance.new("Frame")
	notifFrame.Name = "NotifFrame"
	notifFrame.Size = UDim2.new(1, -6, 0, 64)
	notifFrame.Position = UDim2.new(1.2, 0, 0, 0)
	notifFrame.BorderSizePixel = 0
	notifFrame.Parent = notifHolder
	Instance.new("UICorner", notifFrame).CornerRadius = UDim.new(0, 10)
	ThemesModule:AddPanel(notifFrame, 0.03)

	local shadow = Instance.new("Frame", notifFrame)
	shadow.Size = UDim2.new(1, 4, 1, 4)
	shadow.Position = UDim2.fromOffset(-2, -2)
	shadow.BackgroundTransparency = 1
	shadow.ZIndex = -1
	local shCorner = Instance.new("UICorner", shadow)
	shCorner.CornerRadius = UDim.new(0, 12)
	local shStroke = Instance.new("UIStroke", shadow)
	shStroke.Thickness = 2.5
	shStroke.Color = Color3.fromRGB(0, 0, 0)
	shStroke.Transparency = 0.85

	local stroke = Instance.new("UIStroke", notifFrame)
	stroke.Thickness = 1
	ThemesModule:RegisterBorder(stroke)

	local titleLab = Instance.new("TextLabel", notifFrame)
	titleLab.Size = UDim2.new(1, -40, 0, 20)
	titleLab.Position = UDim2.fromOffset(14, 10)
	titleLab.BackgroundTransparency = 1
	titleLab.Text = title
	titleLab.Font = Enum.Font.GothamBold
	titleLab.TextSize = 14
	titleLab.TextXAlignment = Enum.TextXAlignment.Left
	ThemesModule:RegisterText(titleLab, false)

	local contentLab = Instance.new("TextLabel", notifFrame)
	contentLab.Size = UDim2.new(1, -40, 0, 18)
	contentLab.Position = UDim2.fromOffset(14, 30)
	contentLab.BackgroundTransparency = 1
	contentLab.Text = content
	contentLab.Font = Enum.Font.Gotham
	contentLab.TextSize = 12
	contentLab.TextXAlignment = Enum.TextXAlignment.Left
	ThemesModule:RegisterText(contentLab, true)

	local progressTrack = Instance.new("Frame", notifFrame)
	progressTrack.Size = UDim2.new(1, -20, 0, 2)
	progressTrack.Position = UDim2.new(0, 10, 1, -4)
	progressTrack.BorderSizePixel = 0
	Instance.new("UICorner", progressTrack).CornerRadius = UDim.new(1, 0)
	ThemesModule:OnThemeChanged(progressTrack, function(t)
		progressTrack.BackgroundColor3 = t.Border
	end)

	local progressBar = Instance.new("Frame", progressTrack)
	progressBar.Size = UDim2.new(1, 0, 1, 0)
	progressBar.BackgroundColor3 = ThemesModule.GlowColor
	progressBar.BorderSizePixel = 0
	Instance.new("UICorner", progressBar).CornerRadius = UDim.new(1, 0)
	ThemesModule:StartNeonLoop(progressBar)
	
	ThemesModule:OnGlowChanged(progressBar, function(c)
		progressBar.BackgroundColor3 = c
	end)

	-- Animations
	TweenService:Create(notifHolder, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 74)}):Play()
	TweenService:Create(notifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 3, 0, 0)}):Play()

	task.spawn(function()
		TweenService:Create(progressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)}):Play()
		task.wait(duration)
		
		local outTween = TweenService:Create(notifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(1.3, 0, 0, 0)})
		outTween:Play()
		outTween.Completed:Wait()
		
		local shrinkTween = TweenService:Create(notifHolder, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 0)})
		shrinkTween:Play()
		shrinkTween.Completed:Wait()

		ThemesModule:StopNeonLoop(progressBar)
		notifHolder:Destroy()
	end)
end

return Notification
