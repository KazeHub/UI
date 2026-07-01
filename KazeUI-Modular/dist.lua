
--[[
    Kaze UI Library v2.1 (Bundled Production Build)
    Generated automatically by build.py
]]

local modules = {}
local module_cache = {}

local function require(path)
    local clean_path = path:gsub("%.lua$", ""):gsub("^%./", ""):gsub("\\\\", "/")
    if module_cache[clean_path] then
        return module_cache[clean_path]
    end
    local loader = modules[clean_path]
    if not loader then
        error("Module not found in virtual filesystem: " .. tostring(clean_path))
    end
    local result = loader()
    module_cache[clean_path] = result
    return result
end

-- ==========================================
-- MODULE: src/themes/init
-- ==========================================
Modules["src/themes/init"] = function()
    local ThemesModule = {}

    -- 14 Premium Themes (Kasama ang Hacker, Retro, at Luxury styles)
    ThemesModule.Themes = {
        Obsidian = {
            Name = "Obsidian",
            Background = Color3.fromRGB(10, 10, 12),
            Text = Color3.fromRGB(240, 240, 245),
            MutedText = Color3.fromRGB(150, 150, 155),
            Border = Color3.fromRGB(45, 45, 50),
            LightnessFactor = 1
        },
        Arctic = {
            Name = "Arctic",
            Background = Color3.fromRGB(245, 247, 250),
            Text = Color3.fromRGB(20, 20, 25),
            MutedText = Color3.fromRGB(110, 115, 125),
            Border = Color3.fromRGB(215, 220, 228),
            LightnessFactor = -1
        },
        Amethyst = {
            Name = "Amethyst",
            Background = Color3.fromRGB(15, 10, 22),
            Text = Color3.fromRGB(240, 235, 250),
            MutedText = Color3.fromRGB(160, 145, 175),
            Border = Color3.fromRGB(50, 40, 65),
            LightnessFactor = 1
        },
        Emerald = {
            Name = "Emerald",
            Background = Color3.fromRGB(8, 15, 12),
            Text = Color3.fromRGB(235, 245, 240),
            MutedText = Color3.fromRGB(145, 165, 155),
            Border = Color3.fromRGB(38, 55, 45),
            LightnessFactor = 1
        },
        Midnight = {
            Name = "Midnight",
            Background = Color3.fromRGB(5, 7, 15),
            Text = Color3.fromRGB(235, 240, 255),
            MutedText = Color3.fromRGB(135, 145, 165),
            Border = Color3.fromRGB(30, 38, 55),
            LightnessFactor = 1
        },
        CyberHacker = {
            Name = "CyberHacker",
            Background = Color3.fromRGB(5, 10, 6),
            Text = Color3.fromRGB(0, 255, 100),
            MutedText = Color3.fromRGB(0, 140, 55),
            Border = Color3.fromRGB(15, 60, 30),
            LightnessFactor = 1
        },
        TerminalVoid = {
            Name = "TerminalVoid",
            Background = Color3.fromRGB(8, 8, 8),
            Text = Color3.fromRGB(50, 255, 180),
            MutedText = Color3.fromRGB(30, 160, 110),
            Border = Color3.fromRGB(40, 40, 42),
            LightnessFactor = 1
        },
        Synthwave = {
            Name = "Synthwave",
            Background = Color3.fromRGB(20, 8, 30),
            Text = Color3.fromRGB(255, 90, 210),
            MutedText = Color3.fromRGB(150, 70, 170),
            Border = Color3.fromRGB(70, 20, 100),
            LightnessFactor = 1
        },
        DarkGold = {
            Name = "DarkGold",
            Background = Color3.fromRGB(12, 11, 9),
            Text = Color3.fromRGB(255, 215, 115),
            MutedText = Color3.fromRGB(165, 140, 95),
            Border = Color3.fromRGB(50, 40, 30),
            LightnessFactor = 1
        },
        Frostbite = {
            Name = "Frostbite",
            Background = Color3.fromRGB(8, 14, 20),
            Text = Color3.fromRGB(140, 225, 255),
            MutedText = Color3.fromRGB(90, 150, 180),
            Border = Color3.fromRGB(30, 55, 75),
            LightnessFactor = 1
        },
        CrimsonVoid = {
            Name = "CrimsonVoid",
            Background = Color3.fromRGB(10, 5, 6),
            Text = Color3.fromRGB(255, 85, 85),
            MutedText = Color3.fromRGB(155, 60, 60),
            Border = Color3.fromRGB(50, 20, 25),
            LightnessFactor = 1
        },
        SakuraBreeze = {
            Name = "SakuraBreeze",
            Background = Color3.fromRGB(28, 18, 22),
            Text = Color3.fromRGB(255, 185, 200),
            MutedText = Color3.fromRGB(190, 130, 145),
            Border = Color3.fromRGB(75, 45, 55),
            LightnessFactor = 1
        },
        CosmicNebula = {
            Name = "CosmicNebula",
            Background = Color3.fromRGB(12, 10, 18),
            Text = Color3.fromRGB(255, 140, 90),
            MutedText = Color3.fromRGB(140, 100, 150),
            Border = Color3.fromRGB(45, 30, 65),
            LightnessFactor = 1
        },
        GhostRecon = {
            Name = "GhostRecon",
            Background = Color3.fromRGB(14, 16, 13),
            Text = Color3.fromRGB(180, 200, 160),
            MutedText = Color3.fromRGB(120, 130, 110),
            Border = Color3.fromRGB(45, 50, 42),
            LightnessFactor = 1
        }
    }

    ThemesModule.CurrentTheme = ThemesModule.Themes.Obsidian
    ThemesModule.GlowColor = Color3.fromRGB(0, 160, 255)
    ThemesModule.BackgroundColor = ThemesModule.CurrentTheme.Background
    ThemesModule.BackgroundTransparency = 0

    ThemesModule.TextElements = {}
    ThemesModule.MutedTextElements = {}
    ThemesModule.BorderElements = {}
    ThemesModule.ThemeCallbacks = {}
    ThemesModule.PanelElements = {}
    ThemesModule.GlowElements = {}
    ThemesModule.NeonTweens = {}
    ThemesModule.GlowCallbacks = {}

    local TweenService = game:GetService("TweenService")

    function ThemesModule.GetColor(elevation)
        local theme = ThemesModule.CurrentTheme
        local h, s, v = Color3.toHSV(theme.Background)
        local factor = theme.LightnessFactor or 1
        local offset = elevation * factor
        return Color3.fromHSV(h, s, math.clamp(v + offset, 0, 1))
    end

    function ThemesModule:RegisterText(inst, isMuted)
        if not inst then return end
        if isMuted then
            table.insert(ThemesModule.MutedTextElements, inst)
            inst.TextColor3 = ThemesModule.CurrentTheme.MutedText
            if inst:IsA("TextBox") then
                inst.PlaceholderColor3 = ThemesModule.CurrentTheme.MutedText
            end
        else
            table.insert(ThemesModule.TextElements, inst)
            inst.TextColor3 = ThemesModule.CurrentTheme.Text
        end
        inst.Destroying:Connect(function()
            local tbl = isMuted and ThemesModule.MutedTextElements or ThemesModule.TextElements
            for i = #tbl, 1, -1 do
                if tbl[i] == inst then table.remove(tbl, i) end
            end
        end)
    end

    function ThemesModule:RegisterBorder(inst)
        if not inst then return end
        table.insert(ThemesModule.BorderElements, inst)
        inst.Color = ThemesModule.CurrentTheme.Border
        inst.Destroying:Connect(function()
            for i = #ThemesModule.BorderElements, 1, -1 do
                if ThemesModule.BorderElements[i] == inst then table.remove(ThemesModule.BorderElements, i) end
            end
        end)
    end

    function ThemesModule:OnThemeChanged(inst, cb)
        if not inst then return end
        table.insert(ThemesModule.ThemeCallbacks, {Inst = inst, Callback = cb})
        task.spawn(cb, ThemesModule.CurrentTheme)
        inst.Destroying:Connect(function()
            for i = #ThemesModule.ThemeCallbacks, 1, -1 do
                if ThemesModule.ThemeCallbacks[i].Inst == inst then table.remove(ThemesModule.ThemeCallbacks, i) end
            end
        end)
    end

    function ThemesModule:AddPanel(inst, elevation, ignoreColorUpdate)
        table.insert(ThemesModule.PanelElements, {Inst = inst, Elevation = elevation or 0, IgnoreColor = ignoreColorUpdate})
        if inst and inst:IsA("GuiObject") then
            if not ignoreColorUpdate then
                inst.BackgroundColor3 = ThemesModule.GetColor(elevation or 0)
            end
            
            local baseTrans = ThemesModule.BackgroundTransparency or 0
            if elevation and elevation > 0 then
                baseTrans = math.clamp(baseTrans - (elevation * 0.3), 0, 1)
            elseif elevation and elevation < 0 then
                baseTrans = math.clamp(baseTrans + (math.abs(elevation) * 0.3), 0, 1)
            end
            inst.BackgroundTransparency = baseTrans

            inst.Destroying:Connect(function()
                for i = #ThemesModule.PanelElements, 1, -1 do
                    if ThemesModule.PanelElements[i].Inst == inst then table.remove(ThemesModule.PanelElements, i) end
                end
            end)
        end
    end

    function ThemesModule:SetBackgroundColor(color)
        for _, data in ipairs(ThemesModule.PanelElements) do
            if data.Inst and data.Inst.Parent and data.Inst:IsA("GuiObject") and not data.IgnoreColor then
                data.Inst.BackgroundColor3 = ThemesModule.GetColor(data.Elevation)
            end
        end
    end

    function ThemesModule:SetTransparency(alpha)
        ThemesModule.BackgroundTransparency = alpha
        for _, data in ipairs(ThemesModule.PanelElements) do
            local inst = data.Inst
            local elevation = data.Elevation or 0
            if inst and inst.Parent and inst:IsA("GuiObject") then
                local baseTrans = alpha
                if elevation > 0 then
                    baseTrans = math.clamp(alpha - (elevation * 0.3), 0, 1)
                elseif elevation < 0 then
                    baseTrans = math.clamp(alpha + (math.abs(elevation) * 0.3), 0, 1)
                end
                inst.BackgroundTransparency = baseTrans
            end
        end
    end

    -- PINAGANDA: May case-insensitive search at automatic shortcuts
    function ThemesModule:SetTheme(themeName)
        local targetTheme = nil
        local searchName = string.lower(tostring(themeName or "obsidian"))

        -- Madaling aliases para sa mabilisang setup
        if searchName == "black" or searchName == "dark" then
            searchName = "obsidian"
        elseif searchName == "white" or searchName == "light" then
            searchName = "arctic"
        elseif searchName == "purple" then
            searchName = "amethyst"
        elseif searchName == "green" then
            searchName = "emerald"
        elseif searchName == "blue" then
            searchName = "midnight"
        end

        for name, theme in pairs(ThemesModule.Themes) do
            if string.lower(name) == searchName then
                targetTheme = theme
                break
            end
        end

        targetTheme = targetTheme or ThemesModule.Themes.Obsidian
        ThemesModule.CurrentTheme = targetTheme
        ThemesModule.BackgroundColor = targetTheme.Background
        
        ThemesModule:SetBackgroundColor(targetTheme.Background)
        ThemesModule:SetTransparency(ThemesModule.BackgroundTransparency or 0)
        
        for _, inst in ipairs(ThemesModule.TextElements) do
            if inst and inst.Parent then
                inst.TextColor3 = targetTheme.Text
            end
        end
        
        for _, inst in ipairs(ThemesModule.MutedTextElements) do
            if inst and inst.Parent then
                inst.TextColor3 = targetTheme.MutedText
                if inst:IsA("TextBox") then
                    inst.PlaceholderColor3 = targetTheme.MutedText
                end
            end
        end
        
        for _, inst in ipairs(ThemesModule.BorderElements) do
            if inst and inst.Parent then
                inst.Color = targetTheme.Border
            end
        end
        
        for _, data in ipairs(ThemesModule.ThemeCallbacks) do
            if data.Inst and data.Inst.Parent then
                pcall(data.Callback, targetTheme)
            end
        end
    end

    function ThemesModule:OnGlowChanged(inst, callback)
        table.insert(ThemesModule.GlowCallbacks, {Inst = inst, Callback = callback})
        task.spawn(callback, ThemesModule.GlowColor)
    end

    function ThemesModule:StartNeonLoop(target)
        if not target then return end
        local propName = pcall(function() return target.Color end) and "Color" or "BackgroundColor3"

        table.insert(ThemesModule.GlowElements, {Target = target, Prop = propName})

        local function createTween()
            local tweenInfo = TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
            local h, s, v = Color3.toHSV(ThemesModule.GlowColor)
            local targetColor = Color3.fromHSV(h, s * 0.8, math.clamp(v * 1.1, 0, 1))
            local tween = TweenService:Create(target, tweenInfo, { [propName] = targetColor })
            tween:Play()
            ThemesModule.NeonTweens[target] = tween
        end
        target[propName] = ThemesModule.GlowColor
        createTween()
    end

    function ThemesModule:StopNeonLoop(target)
        if not target then return end
        if ThemesModule.NeonTweens[target] then
            ThemesModule.NeonTweens[target]:Cancel()
            ThemesModule.NeonTweens[target] = nil
        end
        for i = #ThemesModule.GlowElements, 1, -1 do
            if ThemesModule.GlowElements[i].Target == target then
                table.remove(ThemesModule.GlowElements, i)
            end
        end
    end

    function ThemesModule:SetGlow(color)
        ThemesModule.GlowColor = color
        
        for _, data in ipairs(ThemesModule.GlowElements) do
            local target = data.Target
            local propName = data.Prop
            if target and target.Parent then
                if ThemesModule.NeonTweens[target] then ThemesModule.NeonTweens[target]:Cancel() end
                target[propName] = color
                local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
                local h, s, v = Color3.toHSV(color)
                local targetColor = Color3.fromHSV(h, s, 1)
                local newTween = TweenService:Create(target, tweenInfo, { [propName] = targetColor })
                newTween:Play()
                ThemesModule.NeonTweens[target] = newTween
            else
                ThemesModule.NeonTweens[target] = nil
            end
        end
        
        for i = #ThemesModule.GlowCallbacks, 1, -1 do
            local data = ThemesModule.GlowCallbacks[i]
            if data.Inst and data.Inst.Parent then
                task.spawn(data.Callback, color)
            else
                table.remove(ThemesModule.GlowCallbacks, i)
            end
        end
    end

    return ThemesModule
end
-- ==========================================
-- MODULE: src/utils/init
-- ==========================================
modules["src/utils/init"] = function()
	local UtilsModule = {}

	local UIS = game:GetService("UserInputService")
	local TweenService = game:GetService("TweenService")
	local HttpService = game:GetService("HttpService")

	local CameraLocker = Instance.new("TextButton")
	CameraLocker.Name = "CameraLocker"
	CameraLocker.Size = UDim2.fromOffset(0, 0)
	CameraLocker.Position = UDim2.fromOffset(0, 0)
	CameraLocker.BackgroundTransparency = 1
	CameraLocker.Text = ""
	CameraLocker.Modal = false
	CameraLocker.Visible = true

	function UtilsModule:InitCameraLocker(screenGui)
		CameraLocker.Parent = screenGui
	end

	function UtilsModule:LockCamera()
		CameraLocker.Modal = true
	end

	function UtilsModule:UnlockCamera()
		CameraLocker.Modal = false
	end

	local UIScale = Instance.new("UIScale")

	function UtilsModule:InitScale(screenGui)
		UIScale.Parent = screenGui
		local function UpdateScale()
			local size = workspace.CurrentCamera.ViewportSize
			local width = size.X
			local height = size.Y
			local minAxis = math.min(width, height)
			
			local targetScale = 1.0

			if UIS.TouchEnabled then
				if minAxis < 500 then
					targetScale = 0.85
				else
					targetScale = 1.0
				end
			else
				if width >= 1920 or height >= 1080 then
					targetScale = 1.15
				elseif width <= 1366 then
					targetScale = 0.95
				else
					targetScale = 1.0
				end
			end

			UIScale.Scale = targetScale
			screenGui.IgnoreGuiInset = true
		end

		UpdateScale()
		workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScale)
	end

	function UtilsModule:GetScale()
		return UIScale.Scale
	end

	local lastNormalPosition = UDim2.fromScale(0.5, 0.5)
	local lastNormalAnchor = Vector2.new(0.5, 0.5)

	function UtilsModule:MakeDraggable(dragPart, targetPart)
		local dragging = false
		local dragInput, dragStart, startPos
		local dragActive = false
		
		dragPart.Active = true
		
		local function update(input)
			if not dragStart or not startPos then return end
			local delta = input.Position - dragStart
			local scale = UIScale.Scale
			
			if dragActive or delta.Magnitude > 8 then
				dragActive = true
				targetPart.Position = UDim2.new(
					startPos.X.Scale, startPos.X.Offset + (delta.X / scale),
					startPos.Y.Scale, startPos.Y.Offset + (delta.Y / scale)
				)
				
				if targetPart.Name == "Frame" or targetPart:IsA("Frame") then
					lastNormalPosition = targetPart.Position
					lastNormalAnchor = targetPart.AnchorPoint
				end
			end
		end
		
		dragPart.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragActive = false
				dragStart = input.Position
				startPos = targetPart.Position
				
				UtilsModule:LockCamera()
				
				local changeCon
				changeCon = input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
						dragInput = nil
						UtilsModule:UnlockCamera()
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
		
		UIS.InputChanged:Connect(function(input)
			if input == dragInput and dragging then update(input) end
		end)
	end

	function UtilsModule:GetLastDragStates()
		return lastNormalPosition, lastNormalAnchor
	end

	function UtilsModule:SetLastDragStates(pos, anchor)
		lastNormalPosition = pos
		lastNormalAnchor = anchor
	end

	local IconsMap = {}

	pcall(function()
		if game and game.HttpGet then
			local rawIcons = game:HttpGet("https://raw.githubusercontent.com/KazeHub/UI/refs/heads/main/Icons.lua.txt")
			if rawIcons then
				local s, res = pcall(function()
					local func = loadstring(rawIcons)
					return func and func()
				end)
				if not s or type(res) ~= "table" then
					s, res = pcall(function() return HttpService:JSONDecode(rawIcons) end)
				end
				if type(res) == "table" then
					for k, v in pairs(res) do IconsMap[string.lower(tostring(k))] = tostring(v) end
				end
			end
		end
	end)

	function UtilsModule:FormatImage(id)
		if not id or id == "" then return "" end
		id = tostring(id)
		local lowerId = string.lower(id)
		if IconsMap[lowerId] then
			local mapped = IconsMap[lowerId]
			if not string.find(mapped, "rbxassetid://") and not string.find(mapped, "http") then
				local clean = string.gsub(mapped, "%D", "")
				if clean ~= "" then return "rbxassetid://" .. clean end
			end
			return mapped
		end
		
		if string.find(id, "rbxassetid://") or string.find(id, "http") then return id end
		local clean = string.gsub(id, "%D", "")
		if clean == "" then return id end
		return "rbxassetid://" .. clean
	end

	function UtilsModule:ToggleScrollingAncestors(element, state)
		local current = element.Parent
		while current do
			if current:IsA("ScrollingFrame") then current.ScrollingEnabled = state end
			current = current.Parent
		end
	end

	return UtilsModule
end

-- ==========================================
-- MODULE: src/config/init
-- ==========================================
modules["src/config/init"] = function()
	local ConfigModule = {}

	local HttpService = game:GetService("HttpService")
	local ThemesModule = require("src/themes/init")

	ConfigModule.Flags = {}

	function ConfigModule:RegisterFlag(flag, getFunc, setFunc)
		if flag then
			ConfigModule.Flags[flag] = { Get = getFunc, Set = setFunc }
		end
	end

	function ConfigModule:SaveConfig(name, notifyCallback)
		if not name or name == "" then
			if notifyCallback then notifyCallback({Title = "Config System", Content = "Config name cannot be empty.", Duration = 3}) end
			return
		end
		
		local data = {}
		for flag, obj in pairs(ConfigModule.Flags) do data[flag] = obj.Get() end
		
		if writefile then
			local success, encoded = pcall(function() return HttpService:JSONEncode(data) end)
			if success then
				writefile("KazeUI_"..name..".json", encoded)
				if notifyCallback then notifyCallback({Title = "Config Saved", Content = "Successfully saved " .. name, Duration = 3}) end
			else
				if notifyCallback then notifyCallback({Title = "Config Error", Content = "Failed to encode settings to JSON.", Duration = 3}) end
			end
		else
			if notifyCallback then notifyCallback({Title = "Config Error", Content = "Your executor does not support saving files.", Duration = 3}) end
		end
	end

	function ConfigModule:LoadConfig(name, notifyCallback)
		if readfile then
			local s, res = pcall(function() return readfile("KazeUI_"..name..".json") end)
			if s then
				local s2, data = pcall(function() return HttpService:JSONDecode(res) end)
				if s2 and type(data) == "table" then
					for flag, val in pairs(data) do
						if ConfigModule.Flags[flag] then ConfigModule.Flags[flag].Set(val) end
					end
					if notifyCallback then notifyCallback({Title = "Config Loaded", Content = "Successfully loaded " .. name, Duration = 3}) end
				else
					if notifyCallback then notifyCallback({Title = "Config Error", Content = "Invalid or corrupted config format.", Duration = 3}) end
				end
			else
				if notifyCallback then notifyCallback({Title = "Config Error", Content = "Config " .. name .. " not found.", Duration = 3}) end
			end
		end
	end

	return ConfigModule
end

-- ==========================================
-- MODULE: src/components/Notification
-- ==========================================
modules["src/components/Notification"] = function()
	local Notification = {}

	local NotifContainer
	local TweenService = game:GetService("TweenService")
	local ThemesModule = require("src/themes/init")

	function Notification:Init(parentGui)
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
end

-- ==========================================
-- MODULE: src/components/ui/Paragraph
-- ==========================================
modules["src/components/ui/Paragraph"] = function()
	local Paragraph = {}

	local TextService = game:GetService("TextService")
	local ThemesModule = require("src/themes/init")

	function Paragraph.new(parentFrame, title, body)
		title = tostring(title or "")
		body = tostring(body or "")
		
		local measuredWidth = 598 * 0.92
		if parentFrame and parentFrame.AbsoluteSize and parentFrame.AbsoluteSize.X > 0 then measuredWidth = parentFrame.AbsoluteSize.X * 0.95 end
		
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
		ThemesModule:AddPanel(paraFrame, 0.01)
		
		local paraStroke = Instance.new("UIStroke", paraFrame)
		paraStroke.Thickness = 1.2
		paraStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		ThemesModule:RegisterBorder(paraStroke)
		
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
			ThemesModule:RegisterText(ptitleLabel, false)
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
		ThemesModule:RegisterText(bodyLabel, true)
		
		return { 
			Wrapper = wrapper, 
			Frame = paraFrame,
			SetText = function(self, newTitle, newBody)
				if ptitleLabel and newTitle then ptitleLabel.Text = newTitle end
				if bodyLabel and newBody then bodyLabel.Text = newBody end
			end
		}
	end

	return Paragraph
end

-- ==========================================
-- MODULE: src/components/ui/Button
-- ==========================================
modules["src/components/ui/Button"] = function()
	local Button = {}

	local TextService = game:GetService("TextService")
	local TweenService = game:GetService("TweenService")
	local ThemesModule = require("src/themes/init")

	local TWEEN_FAST = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local TWEEN_SPRING = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	function Button.new(parentFrame, title, body, callback)
		title = tostring(title or "Button")
		body = tostring(body or "")
		
		local measuredWidth = 598 * 0.92
		if parentFrame and parentFrame.AbsoluteSize and parentFrame.AbsoluteSize.X > 0 then measuredWidth = parentFrame.AbsoluteSize.X * 0.95 end
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
		ThemesModule:AddPanel(paraFrame, 0.02)
		
		local paraStroke = Instance.new("UIStroke", paraFrame)
		paraStroke.Thickness = 1.2
		paraStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		ThemesModule:RegisterBorder(paraStroke)
		
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
		ThemesModule:OnThemeChanged(rightIcon, function(t)
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
			if body == "" then ptitleLabel.AnchorPoint = Vector2.new(0, 0.5); ptitleLabel.Position = UDim2.new(0, 0, 0.5, 0) end
			ThemesModule:RegisterText(ptitleLabel, false)
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
			ThemesModule:RegisterText(bodyLabel, true)
		end

		local clickDetector = Instance.new("TextButton")
		clickDetector.Size = UDim2.fromScale(1, 1)
		clickDetector.BackgroundTransparency = 1
		clickDetector.Text = ""
		clickDetector.ZIndex = 10
		clickDetector.Parent = paraFrame

		clickDetector.MouseEnter:Connect(function()
			isHovering = true
			TweenService:Create(paraFrame, TWEEN_FAST, { BackgroundColor3 = ThemesModule.GetColor(0.04) }):Play()
			TweenService:Create(paraStroke, TWEEN_FAST, { Color = ThemesModule.GlowColor }):Play()
			TweenService:Create(rightIcon, TWEEN_FAST, { ImageColor3 = Color3.fromRGB(255, 255, 255), Position = UDim2.new(1, -10, 0.5, 0) }):Play()
		end)
		clickDetector.MouseLeave:Connect(function()
			isHovering = false
			TweenService:Create(paraFrame, TWEEN_FAST, { BackgroundColor3 = ThemesModule.GetColor(0.02) }):Play()
			TweenService:Create(paraStroke, TWEEN_FAST, { Color = ThemesModule.CurrentTheme.Border }):Play()
			TweenService:Create(rightIcon, TWEEN_FAST, { ImageColor3 = ThemesModule.CurrentTheme.MutedText, Position = UDim2.new(1, -12, 0.5, 0) }):Play()
		end)
		
		clickDetector.MouseButton1Down:Connect(function()
			TweenService:Create(paraFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { 
				Size = UDim2.new(0.93, 0, 0, totalHeight - 2), 
				Position = UDim2.new(0.5, 0, 0, 4) 
			}):Play()
		end)
		clickDetector.MouseButton1Up:Connect(function()
			TweenService:Create(paraFrame, TWEEN_SPRING, { 
				Size = UDim2.new(0.95, 0, 0, totalHeight), 
				Position = UDim2.new(0.5, 0, 0, 3) 
			}):Play()
			if typeof(callback) == "function" then task.spawn(callback) end
		end)
		
		ThemesModule:OnGlowChanged(paraStroke, function(c)
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

	return Button
end

-- ==========================================
-- MODULE: src/components/ui/Toggle
-- ==========================================
modules["src/components/ui/Toggle"] = function()
	local Toggle = {}

	local TextService = game:GetService("TextService")
	local TweenService = game:GetService("TweenService")
	local ThemesModule = require("src/themes/init")
	local ConfigModule = require("src/config/init")

	local TWEEN_FAST = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local TWEEN_SPRING = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	function Toggle.new(parentFrame, title, body, defaultState, callback, flag)
		title = tostring(title or "Toggle Switch")
		body = tostring(body or "")
		local state = defaultState or false
		
		local measuredWidth = 598 * 0.92
		if parentFrame and parentFrame.AbsoluteSize and parentFrame.AbsoluteSize.X > 0 then measuredWidth = parentFrame.AbsoluteSize.X * 0.95 end
		local textContainerWidth = measuredWidth - 24 - 55
		
		local titleHeight = 0
		if title ~= " " then
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
		ThemesModule:AddPanel(paraFrame, 0.02)
		
		local paraStroke = Instance.new("UIStroke", paraFrame)
		paraStroke.Thickness = 1.2
		paraStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		ThemesModule:RegisterBorder(paraStroke)
		
		local inner = Instance.new("Frame", paraFrame)
		inner.Size = UDim2.new(1, -16, 1, -12)
		inner.Position = UDim2.fromOffset(8, 6)
		inner.BackgroundTransparency = 1
		
		local switchContainer = Instance.new("Frame")
		switchContainer.AnchorPoint = Vector2.new(1, 0.5)
		switchContainer.Position = UDim2.new(1, -4, 0.5, 0)
		switchContainer.Size = UDim2.fromOffset(36, 18)
		switchContainer.BorderSizePixel = 0
		Instance.new("UICorner", switchContainer).CornerRadius = UDim.new(1, 0)
		switchContainer.Parent = inner
		
		local switchIndicator = Instance.new("Frame")
		switchIndicator.AnchorPoint = Vector2.new(0, 0.5)
		switchIndicator.Position = state and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
		switchIndicator.Size = UDim2.fromOffset(14, 14)
		switchIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		switchIndicator.BorderSizePixel = 0
		Instance.new("UICorner", switchIndicator).CornerRadius = UDim.new(1, 0)
		switchIndicator.Parent = switchContainer
		
		local ptitleLabel
		if title ~= " " then
			ptitleLabel = Instance.new("TextLabel", inner)
			ptitleLabel.Size = UDim2.new(1, -48, 0, titleHeight)
			ptitleLabel.BackgroundTransparency = 1
			ptitleLabel.Text = title
			ptitleLabel.Font = Enum.Font.GothamBold
			ptitleLabel.TextSize = 14
			ptitleLabel.TextWrapped = true
			ptitleLabel.TextXAlignment = Enum.TextXAlignment.Left
			if body == "" then ptitleLabel.AnchorPoint = Vector2.new(0, 0.5); ptitleLabel.Position = UDim2.new(0, 0, 0.5, 0) end
			ThemesModule:RegisterText(ptitleLabel, false)
		end
		
		local bodyLabel
		if body ~= "" then
			bodyLabel = Instance.new("TextLabel", inner)
			bodyLabel.Size = UDim2.new(1, -48, 0, bodyHeight)
			bodyLabel.Position = UDim2.fromOffset(0, titleHeight + 3)
			bodyLabel.BackgroundTransparency = 1
			bodyLabel.Text = body
			bodyLabel.Font = Enum.Font.Gotham
			bodyLabel.TextSize = 12
			bodyLabel.TextWrapped = true
			bodyLabel.TextXAlignment = Enum.TextXAlignment.Left
			bodyLabel.TextYAlignment = Enum.TextYAlignment.Top
			ThemesModule:RegisterText(bodyLabel, true)
		end

		local clickDetector = Instance.new("TextButton")
		clickDetector.Size = UDim2.fromScale(1, 1)
		clickDetector.BackgroundTransparency = 1
		clickDetector.Text = ""
		clickDetector.ZIndex = 10
		clickDetector.Parent = paraFrame

		local function setToggleState(newState, instant)
			state = newState
			local targetPos = state and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
			local targetBg = state and ThemesModule.GlowColor or ThemesModule.GetColor(0.08)
			
			if instant then
				switchIndicator.Position = targetPos
				switchContainer.BackgroundColor3 = targetBg
			else
				TweenService:Create(switchIndicator, TWEEN_SPRING, { Position = targetPos }):Play()
				TweenService:Create(switchContainer, TWEEN_FAST, { BackgroundColor3 = targetBg }):Play()
			end
		end
		setToggleState(state, true)

		local isHovering = false

		clickDetector.MouseEnter:Connect(function()
			isHovering = true
			TweenService:Create(paraFrame, TWEEN_FAST, { BackgroundColor3 = ThemesModule.GetColor(0.04) }):Play()
			TweenService:Create(paraStroke, TWEEN_FAST, { Color = ThemesModule.GlowColor }):Play()
		end)
		clickDetector.MouseLeave:Connect(function()
			isHovering = false
			TweenService:Create(paraFrame, TWEEN_FAST, { BackgroundColor3 = ThemesModule.GetColor(0.02) }):Play()
			TweenService:Create(paraStroke, TWEEN_FAST, { Color = ThemesModule.CurrentTheme.Border }):Play()
		end)
		clickDetector.MouseButton1Down:Connect(function()
			TweenService:Create(paraFrame, TWEEN_FAST, { Size = UDim2.new(0.93, 0, 0, totalHeight - 2), Position = UDim2.new(0.5, 0, 0, 4) }):Play()
		end)
		clickDetector.MouseButton1Up:Connect(function()
			TweenService:Create(paraFrame, TWEEN_SPRING, { Size = UDim2.new(0.95, 0, 0, totalHeight), Position = UDim2.new(0.5, 0, 0, 3) }):Play()
			setToggleState(not state, false)
			if typeof(callback) == "function" then task.spawn(callback, state) end
		end)

		ThemesModule:OnGlowChanged(switchContainer, function(c)
			if state then
				switchContainer.BackgroundColor3 = c
			end
		end)

		ThemesModule:OnGlowChanged(paraStroke, function(c)
			if isHovering then
				paraStroke.Color = c
			end
		end)

		ConfigModule:RegisterFlag(flag, function() return state end, function(val)
			setToggleState(val, false)
			if typeof(callback) == "function" then task.spawn(callback, state) end
		end)
		
		return { 
			Wrapper = wrapper, 
			SetState = function(self, newState, instant) setToggleState(newState, instant) end,
			SetText = function(self, newTitle, newBody)
				if ptitleLabel and newTitle then ptitleLabel.Text = newTitle end
				if bodyLabel and newBody then bodyLabel.Text = newBody end
			end
		}
	end

	return Toggle
end

-- ==========================================
-- MODULE: src/components/ui/TextBox
-- ==========================================
modules["src/components/ui/TextBox"] = function()
	local TextBox = {}

	local TextService = game:GetService("TextService")
	local TweenService = game:GetService("TweenService")
	local ThemesModule = require("src/themes/init")
	local ConfigModule = require("src/config/init")

	local TWEEN_FAST = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	function TextBox.new(parentFrame, title, placeholder, defaultVal, callback, flag)
		title = tostring(title or "Input Text")
		placeholder = tostring(placeholder or "Type here...")
		
		local measuredWidth = 598 * 0.92
		if parentFrame and parentFrame.AbsoluteSize and parentFrame.AbsoluteSize.X > 0 then measuredWidth = parentFrame.AbsoluteSize.X * 0.95 end
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
		ThemesModule:AddPanel(paraFrame, 0.02)
		
		local paraStroke = Instance.new("UIStroke", paraFrame)
		paraStroke.Thickness = 1.2
		paraStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		ThemesModule:RegisterBorder(paraStroke)
		
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
			ThemesModule:RegisterText(ptitleLabel, false)
		end
		
		local textBoxContainer = Instance.new("Frame")
		textBoxContainer.Size = UDim2.new(1, 0, 0, 30)
		textBoxContainer.Position = UDim2.new(0, 0, 0, titleHeight + 4)
		textBoxContainer.BorderSizePixel = 0
		textBoxContainer.Parent = inner
		Instance.new("UICorner", textBoxContainer).CornerRadius = UDim.new(0, 6)
		ThemesModule:AddPanel(textBoxContainer, -0.01)
		
		local innerStroke = Instance.new("UIStroke", textBoxContainer)
		innerStroke.Thickness = 1
		ThemesModule:RegisterBorder(innerStroke)
		
		local rbxTextBox = Instance.new("TextBox")
		rbxTextBox.Size = UDim2.new(1, -16, 1, 0)
		rbxTextBox.Position = UDim2.fromOffset(8, 0)
		rbxTextBox.BackgroundTransparency = 1
		rbxTextBox.PlaceholderText = placeholder
		rbxTextBox.Text = defaultVal and tostring(defaultVal) or ""
		rbxTextBox.Font = Enum.Font.Gotham
		rbxTextBox.TextSize = 12
		rbxTextBox.TextXAlignment = Enum.TextXAlignment.Left
		rbxTextBox.ClearTextOnFocus = false
		rbxTextBox.Parent = textBoxContainer
		ThemesModule:RegisterText(rbxTextBox, false)
		ThemesModule:OnThemeChanged(rbxTextBox, function(t)
			rbxTextBox.PlaceholderColor3 = t.MutedText
		end)

		local isFocused = false

		rbxTextBox.Focused:Connect(function()
			isFocused = true
			TweenService:Create(innerStroke, TWEEN_FAST, {Color = ThemesModule.GlowColor}):Play()
			TweenService:Create(paraFrame, TWEEN_FAST, { BackgroundColor3 = ThemesModule.GetColor(0.04) }):Play()
			TweenService:Create(paraStroke, TWEEN_FAST, { Color = ThemesModule.GlowColor }):Play()
		end)

		rbxTextBox.FocusLost:Connect(function(enterPressed)
			isFocused = false
			TweenService:Create(innerStroke, TWEEN_FAST, { Color = ThemesModule.CurrentTheme.Border }):Play()
			TweenService:Create(paraFrame, TWEEN_FAST, { BackgroundColor3 = ThemesModule.GetColor(0.02) }):Play()
			TweenService:Create(paraStroke, TWEEN_FAST, { Color = ThemesModule.CurrentTheme.Border }):Play()
			if typeof(callback) == "function" then task.spawn(callback, rbxTextBox.Text, enterPressed) end
		end)
		
		ThemesModule:OnGlowChanged(innerStroke, function(c)
			if isFocused then
				innerStroke.Color = c
				paraStroke.Color = c
			end
		end)
		
		ConfigModule:RegisterFlag(flag, function() return rbxTextBox.Text end, function(val)
			rbxTextBox.Text = val
			if typeof(callback) == "function" then task.spawn(callback, val) end
		end)

		return { 
			Wrapper = wrapper, 
			SetText = function(self, value) rbxTextBox.Text = tostring(value or "") end,
			SetPlaceholder = function(self, val) rbxTextBox.PlaceholderText = val end,
			SetTitle = function(self, newTitle)
				if ptitleLabel and newTitle then ptitleLabel.Text = newTitle end
			end
		}
	end

	return TextBox
end

-- ==========================================
-- MODULE: src/components/ui/Slider
-- ==========================================
modules["src/components/ui/Slider"] = function()
	local Slider = {}

	local TextService = game:GetService("TextService")
	local TweenService = game:GetService("TweenService")
	local UIS = game:GetService("UserInputService")
	local ThemesModule = require("src/themes/init")
	local UtilsModule = require("src/utils/init")
	local ConfigModule = require("src/config/init")

	local TWEEN_FAST = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local TWEEN_SPRING = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	function Slider.new(parentFrame, title, min, max, default, callback, flag)
		title = tostring(title or "Slider")
		min = tonumber(min) or 0
		max = tonumber(max) or 100
		default = tonumber(default) or min
		local value = math.clamp(default, min, max)
		
		local measuredWidth = 598 * 0.92
		if parentFrame and parentFrame.AbsoluteSize and parentFrame.AbsoluteSize.X > 0 then measuredWidth = parentFrame.AbsoluteSize.X * 0.95 end
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
		ThemesModule:AddPanel(paraFrame, 0.02)
		
		local paraStroke = Instance.new("UIStroke", paraFrame)
		paraStroke.Thickness = 1.2
		paraStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		ThemesModule:RegisterBorder(paraStroke)
		
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
			ThemesModule:RegisterText(ptitleLabel, false)
		end
		
		local valueLabel = Instance.new("TextLabel", inner)
		valueLabel.Size = UDim2.new(0, 70, 0, titleHeight > 0 and titleHeight or 16)
		valueLabel.Position = UDim2.new(1, -70, 0, 0)
		valueLabel.BackgroundTransparency = 1
		valueLabel.Text = tostring(value)
		valueLabel.Font = Enum.Font.GothamBold
		valueLabel.TextSize = 12
		valueLabel.TextXAlignment = Enum.TextXAlignment.Right
		ThemesModule:RegisterText(valueLabel, false)
		
		local track = Instance.new("Frame")
		track.Size = UDim2.new(1, 0, 0, 6)
		track.Position = UDim2.new(0, 0, 0, titleHeight + 8)
		track.BorderSizePixel = 0
		track.Parent = inner
		Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
		ThemesModule:AddPanel(track, -0.01)
		
		local fill = Instance.new("Frame")
		fill.Size = UDim2.new(0, 0, 1, 0)
		fill.BackgroundColor3 = ThemesModule.GlowColor
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
		knobStroke.Color = ThemesModule.GlowColor

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
			
			TweenService:Create(fill, TWEEN_FAST, {Size = UDim2.new(visualPercentage, 0, 1, 0)}):Play()
			TweenService:Create(knob, TWEEN_FAST, {Position = UDim2.new(visualPercentage, 0, 0.5, 0)}):Play()
			if typeof(callback) == "function" then task.spawn(callback, value) end
		end
		
		local startingPercentage = 0
		if max > min then startingPercentage = (value - min) / (max - min) end
		fill.Size = UDim2.new(startingPercentage, 0, 1, 0)
		knob.Position = UDim2.new(startingPercentage, 0, 0.5, 0)
		
		clickDetector.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				isDragging = true
				UtilsModule:ToggleScrollingAncestors(track, false)
				UtilsModule:LockCamera()
				UpdateValueFromInput(input)
				
				TweenService:Create(knob, TWEEN_FAST, {Size = UDim2.fromOffset(16, 16)}):Play()
				TweenService:Create(paraStroke, TWEEN_FAST, {Color = ThemesModule.GlowColor}):Play()
				
				local moveCon, endCon
				moveCon = UIS.InputChanged:Connect(function(moveInput)
					if isDragging and (moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch) then
						UpdateValueFromInput(moveInput)
					end
				end)
				endCon = UIS.InputEnded:Connect(function(endInput)
					if endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch then
						isDragging = false
						UtilsModule:ToggleScrollingAncestors(track, true)
						UtilsModule:UnlockCamera()
						
						TweenService:Create(knob, TWEEN_FAST, {Size = UDim2.fromOffset(12, 12)}):Play()
						TweenService:Create(paraStroke, TWEEN_FAST, {Color = ThemesModule.CurrentTheme.Border}):Play()
						if moveCon then moveCon:Disconnect() end
						if endCon then endCon:Disconnect() end
					end
				end)
			end
		end)

		ThemesModule:OnGlowChanged(fill, function(c)
			fill.BackgroundColor3 = c
			knobStroke.Color = c
		end)

		ThemesModule:OnGlowChanged(paraStroke, function(c)
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
		ConfigModule:RegisterFlag(flag, function() return value end, function(val) api:SetValue(val) end)
		return api
	end

	return Slider
end

-- ==========================================
-- MODULE: src/components/ui/Dropdown
-- ==========================================
modules["src/components/ui/Dropdown"] = function()
	local Dropdown = {}

	local ThemesModule = require("src/themes/init")
	local UtilsModule = require("src/utils/init")
	local ConfigModule = require("src/config/init")

	local TweenService = game:GetService("TweenService")
	local TWEEN_FAST = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local TWEEN_SPRING = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	function Dropdown.new(parentFrame, title, options, defaultOption, callback, isMulti, flag)
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
		ThemesModule:AddPanel(dropFrame, 0.02)

		local padding = Instance.new("UIPadding", dropFrame)
		padding.PaddingTop = UDim.new(0, 4)
		padding.PaddingBottom = UDim.new(0, 4)

		local boxStroke = Instance.new("UIStroke", dropFrame)
		boxStroke.Thickness = 1.2
		boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		ThemesModule:RegisterBorder(boxStroke)

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
		ThemesModule:RegisterText(titleLabel, false)

		local arrowIcon = Instance.new("ImageLabel", header)
		arrowIcon.AnchorPoint = Vector2.new(1, 0.5)
		arrowIcon.Position = UDim2.new(1, 0, 0.5, 0)
		arrowIcon.Size = UDim2.fromOffset(16, 16)
		arrowIcon.BackgroundTransparency = 1
		arrowIcon.Image = "rbxassetid://10723415693"
		arrowIcon.Rotation = 0
		ThemesModule:OnThemeChanged(arrowIcon, function(t)
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
		ThemesModule:RegisterText(selectedLabel, true)

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
		ThemesModule:AddPanel(searchBox, -0.01)
		ThemesModule:RegisterText(searchBox, false)

		local searchStroke = Instance.new("UIStroke", searchBox)
		searchStroke.Thickness = 1
		ThemesModule:RegisterBorder(searchStroke)

		local searchPadding = Instance.new("UIPadding", searchBox)
		searchPadding.PaddingLeft = UDim.new(0, 8)

		searchBox.Focused:Connect(function() 
			TweenService:Create(searchStroke, TWEEN_FAST, {Color = ThemesModule.GlowColor}):Play()
		end)
		searchBox.FocusLost:Connect(function() 
			TweenService:Create(searchStroke, TWEEN_FAST, {Color = ThemesModule.CurrentTheme.Border}):Play()
		end)
		
		local divider = Instance.new("Frame")
		divider.Size = UDim2.new(1, -16, 0, 1)
		divider.BorderSizePixel = 0
		divider.LayoutOrder = 3
		divider.Visible = false
		divider.Parent = dropFrame
		ThemesModule:OnThemeChanged(divider, function(t)
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

		listContainer.MouseEnter:Connect(function() UtilsModule:ToggleScrollingAncestors(dropFrame, false) end)
		listContainer.MouseLeave:Connect(function() UtilsModule:ToggleScrollingAncestors(dropFrame, true) end)

		local listLayout = Instance.new("UIListLayout", listContainer)
		listLayout.SortOrder = Enum.SortOrder.LayoutOrder
		listLayout.Padding = UDim.new(0, 3)

		local optionItems = {}

		local function CalcHeight()
			local count = 0
			for _, item in ipairs(optionItems) do if item.Btn.Visible then count = count + 1 end end
			local targetH = math.min(count, 5) * 32
			TweenService:Create(listContainer, TWEEN_FAST, {Size = UDim2.new(1, -16, 0, targetH)}):Play()
			listContainer.CanvasSize = UDim2.new(0, 0, 0, count * 32)
		end

		local function CloseDropdown()
			isOpen = false
			searchBox.Text = "" 
			searchWrapper.Visible = false
			divider.Visible = false
			listContainer.Visible = false
			TweenService:Create(arrowIcon, TWEEN_SPRING, {Rotation = 0}):Play()
			TweenService:Create(boxStroke, TWEEN_FAST, {Color = ThemesModule.CurrentTheme.Border}):Play()
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
				
				ThemesModule:AddPanel(btn, 0.03, true)

				local indicator
				if isMulti then
					indicator = Instance.new("Frame", btn)
					indicator.AnchorPoint = Vector2.new(1, 0.5)
					indicator.Position = UDim2.new(1, -8, 0.5, 0)
					indicator.Size = UDim2.fromOffset(12, 12)
					local indStroke = Instance.new("UIStroke", indicator)
					ThemesModule:RegisterBorder(indStroke)
					Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 3)
					ThemesModule:AddPanel(indicator, 0.04)
				end
				
				local isHovering = false
				local currentBgTween, currentTxtTween

				local function UpdateVisuals(instant)
					local active = isMulti and selectedMulti[optStr] or (not isMulti and selectedSingle == optStr)
					
					local targetBg = active and ThemesModule.GetColor(0.06) or ThemesModule.GetColor(0.03)
					local targetTxt = active and ThemesModule.CurrentTheme.Text or ThemesModule.CurrentTheme.MutedText
					local indTargetBg = active and ThemesModule.GlowColor or ThemesModule.GetColor(0.03)
					
					if isHovering then
						targetBg = ThemesModule.GetColor(0.08)
						targetTxt = ThemesModule.CurrentTheme.Text
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
						currentBgTween = TweenService:Create(btn, TWEEN_FAST, {BackgroundColor3 = targetBg})
						currentTxtTween = TweenService:Create(btn, TWEEN_FAST, {TextColor3 = targetTxt})
						currentBgTween:Play()
						currentTxtTween:Play()
						
						if isMulti and indicator then
							TweenService:Create(indicator, TWEEN_FAST, {BackgroundColor3 = indTargetBg}):Play()
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
				
				ThemesModule:OnGlowChanged(btn, function()
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

		clickBtn.MouseButton1Click:Connect(function()
			isOpen = not isOpen
			if isOpen then
				searchWrapper.Visible = true
				divider.Visible = true
				listContainer.Visible = true
				CalcHeight()
				TweenService:Create(arrowIcon, TWEEN_SPRING, {Rotation = 180}):Play()
				TweenService:Create(boxStroke, TWEEN_FAST, {Color = ThemesModule.GlowColor}):Play()
			else
				CloseDropdown()
			end
		end)
		
		ThemesModule:OnGlowChanged(boxStroke, function(c)
			if isOpen then
				boxStroke.Color = c
			end
		end)
		
		ThemesModule:OnGlowChanged(searchStroke, function(c)
			if searchBox:IsFocused() then
				searchStroke.Color = c
			end
		end)

		ThemesModule:OnThemeChanged(dropFrame, function()
			for _, item in ipairs(optionItems) do item.Update(true) end
		end)

		ConfigModule:RegisterFlag(flag, function()
			if isMulti then
				local ret = {}
				for k,v in pairs(selectedMulti) do if v then table.insert(ret, k) end end
				return ret
			end
			return selectedSingle 
		end, function(val)
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
				if isMulti then
					local ret = {}
					for k,v in pairs(selectedMulti) do if v then table.insert(ret, k) end end
					task.spawn(callback, ret)
				else
					task.spawn(callback, selectedSingle)
				end
			end
		end)

		return {
			Wrapper = wrapper,
			Frame = dropFrame,
			Refresh = function(self, newOpts) Refresh(newOpts) end,
			GetValue = function() 
				if isMulti then
					local ret = {}
					for k,v in pairs(selectedMulti) do if v then table.insert(ret, k) end end
					return ret
				end
				return selectedSingle 
			end,
			SetText = function(self, newTitle)
				titleLabel.Text = newTitle
			end
		}
	end

	return Dropdown
end

-- ==========================================
-- MODULE: src/components/ui/ColorPicker
-- ==========================================
modules["src/components/ui/ColorPicker"] = function()
	local ColorPicker = {}

	local ThemesModule = require("src/themes/init")
	local UtilsModule = require("src/utils/init")
	local ConfigModule = require("src/config/init")

	local UIS = game:GetService("UserInputService")
	local TweenService = game:GetService("TweenService")
	local TWEEN_FAST = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local TWEEN_SPRING = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	function ColorPicker.new(parentFrame, title, defaultColor, callback, flag)
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
		ThemesModule:AddPanel(dropFrame, 0.02)

		local padding = Instance.new("UIPadding", dropFrame)
		padding.PaddingTop = UDim.new(0, 4)
		padding.PaddingBottom = UDim.new(0, 4)

		local boxStroke = Instance.new("UIStroke", dropFrame)
		boxStroke.Thickness = 1.2
		boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		ThemesModule:RegisterBorder(boxStroke)

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
		ThemesModule:RegisterText(titleLabel, false)

		local previewColor = Instance.new("Frame", header)
		previewColor.AnchorPoint = Vector2.new(1, 0.5)
		previewColor.Position = UDim2.new(1, -24, 0.5, 0)
		previewColor.Size = UDim2.fromOffset(24, 24)
		previewColor.BackgroundColor3 = color
		Instance.new("UICorner", previewColor).CornerRadius = UDim.new(0, 4)
		
		local prevStroke = Instance.new("UIStroke", previewColor)
		ThemesModule:RegisterBorder(prevStroke)

		local arrowIcon = Instance.new("ImageLabel", header)
		arrowIcon.AnchorPoint = Vector2.new(1, 0.5)
		arrowIcon.Position = UDim2.new(1, 0, 0.5, 0)
		arrowIcon.Size = UDim2.fromOffset(16, 16)
		arrowIcon.BackgroundTransparency = 1
		arrowIcon.Image = "rbxassetid://10723415693"
		arrowIcon.Rotation = 0
		ThemesModule:OnThemeChanged(arrowIcon, function(t)
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
				UtilsModule:ToggleScrollingAncestors(svMap, false)
				UtilsModule:LockCamera()
				updateSV(input)
			end
		end)

		hueSlider.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				draggingHue = true
				UtilsModule:ToggleScrollingAncestors(hueSlider, false)
				UtilsModule:LockCamera()
				updateHue(input)
			end
		end)

		UIS.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				if draggingMap then
					updateSV(input)
				elseif draggingHue then
					updateHue(input)
				end
			end
		end)

		UIS.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				if draggingMap or draggingHue then
					UtilsModule:UnlockCamera()
				end
				draggingMap = false
				draggingHue = false
				UtilsModule:ToggleScrollingAncestors(svMap, true)
			end
		end)

		clickBtn.MouseButton1Click:Connect(function()
			isOpen = not isOpen
			pickerArea.Visible = isOpen
			TweenService:Create(arrowIcon, TWEEN_SPRING, {Rotation = isOpen and 180 or 0}):Play()
			TweenService:Create(boxStroke, TWEEN_FAST, {Color = isOpen and ThemesModule.GlowColor or ThemesModule.CurrentTheme.Border}):Play()
		end)
		
		ThemesModule:OnGlowChanged(boxStroke, function(c)
			if isOpen then
				boxStroke.Color = c
			end
		end)

		ConfigModule:RegisterFlag(flag, function() return color:ToHex() end, function(val)
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

	return ColorPicker
end

-- ==========================================
-- MODULE: src/components/ui/Keybind
-- ==========================================
modules["src/components/ui/Keybind"] = function()
	local Keybind = {}

	local TextService = game:GetService("TextService")
	local TweenService = game:GetService("TweenService")
	local UIS = game:GetService("UserInputService")
	local ThemesModule = require("src/themes/init")
	local ConfigModule = require("src/config/init")

	local TWEEN_FAST = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	function Keybind.new(parentFrame, title, defaultKey, callback, flag)
		title = tostring(title or "Keybind")
		local currentKey = defaultKey or Enum.KeyCode.Unknown
		local isBinding = false
		
		local measuredWidth = 598 * 0.92
		if parentFrame and parentFrame.AbsoluteSize and parentFrame.AbsoluteSize.X > 0 then measuredWidth = parentFrame.AbsoluteSize.X * 0.95 end
		local textContainerWidth = measuredWidth - 24 - 90
		
		local titleHeight = 0
		if title ~= " " and title ~= "" then
			local ts = TextService:GetTextSize(title, 14, Enum.Font.GothamBold, Vector2.new(textContainerWidth, 1000))
			titleHeight = math.max(16, math.ceil(ts.Y))
		end
		
		local totalHeight = 8 + math.max(titleHeight, 24) + 8
		
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
		ThemesModule:AddPanel(paraFrame, 0.02)
		
		local paraStroke = Instance.new("UIStroke", paraFrame)
		paraStroke.Thickness = 1.2
		paraStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		ThemesModule:RegisterBorder(paraStroke)
		
		local inner = Instance.new("Frame", paraFrame)
		inner.Size = UDim2.new(1, -16, 1, -12)
		inner.Position = UDim2.fromOffset(8, 6)
		inner.BackgroundTransparency = 1
		
		local ptitleLabel
		if title ~= " " and title ~= "" then
			ptitleLabel = Instance.new("TextLabel", inner)
			ptitleLabel.Size = UDim2.new(1, -90, 1, 0)
			ptitleLabel.BackgroundTransparency = 1
			ptitleLabel.Text = title
			ptitleLabel.Font = Enum.Font.GothamBold
			ptitleLabel.TextSize = 14
			ptitleLabel.TextWrapped = true
			ptitleLabel.TextXAlignment = Enum.TextXAlignment.Left
			ThemesModule:RegisterText(ptitleLabel, false)
		end
		
		local bindContainer = Instance.new("TextButton", inner)
		bindContainer.Size = UDim2.new(0, 80, 0, 24)
		bindContainer.AnchorPoint = Vector2.new(1, 0.5)
		bindContainer.Position = UDim2.new(1, 0, 0.5, 0)
		bindContainer.BorderSizePixel = 0
		bindContainer.Text = ""
		bindContainer.AutoButtonColor = false
		Instance.new("UICorner", bindContainer).CornerRadius = UDim.new(0, 5)
		ThemesModule:AddPanel(bindContainer, 0.05)

		local bindStroke = Instance.new("UIStroke", bindContainer)
		bindStroke.Thickness = 1
		ThemesModule:RegisterBorder(bindStroke)
		
		local bindLabel = Instance.new("TextLabel", bindContainer)
		bindLabel.Size = UDim2.new(1, 0, 1, 0)
		bindLabel.BackgroundTransparency = 1
		bindLabel.Text = currentKey == Enum.KeyCode.Unknown and "None" or currentKey.Name
		bindLabel.Font = Enum.Font.GothamBold
		bindLabel.TextSize = 11
		ThemesModule:RegisterText(bindLabel, false)

		local isHovering = false
		
		bindContainer.MouseEnter:Connect(function()
			isHovering = true
			if not isBinding then 
				TweenService:Create(bindStroke, TWEEN_FAST, {Color = ThemesModule.GlowColor}):Play()
			end
		end)
		bindContainer.MouseLeave:Connect(function()
			isHovering = false
			if not isBinding then 
				TweenService:Create(bindStroke, TWEEN_FAST, {Color = ThemesModule.CurrentTheme.Border}):Play()
			end
		end)
		
		bindContainer.MouseButton1Click:Connect(function()
			if isBinding then return end
			isBinding = true
			bindLabel.Text = "..."
			TweenService:Create(bindStroke, TWEEN_FAST, {Color = ThemesModule.GlowColor}):Play()
			
			local conn
			conn = UIS.InputBegan:Connect(function(input)
				local isKey = input.UserInputType == Enum.UserInputType.Keyboard
				local isMouse = input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton3
				
				if isKey or isMouse then
					if isKey then
						local key = input.KeyCode
						if key == Enum.KeyCode.Escape then
						elseif key == Enum.KeyCode.Backspace or key == Enum.KeyCode.Delete then
							currentKey = Enum.KeyCode.Unknown
						else
							currentKey = key
						end
					end
					
					bindLabel.Text = currentKey == Enum.KeyCode.Unknown and "None" or currentKey.Name
					TweenService:Create(bindStroke, TWEEN_FAST, {Color = ThemesModule.CurrentTheme.Border}):Play()
					conn:Disconnect()
					task.delay(0.15, function() isBinding = false end)
				end
			end)
		end)
		
		UIS.InputBegan:Connect(function(input, gp)
			if not gp and not isBinding and currentKey ~= Enum.KeyCode.Unknown and input.KeyCode == currentKey then
				if typeof(callback) == "function" then
					task.spawn(callback, currentKey)
				end
			end
		end)

		ThemesModule:OnGlowChanged(bindStroke, function(c)
			if isBinding or isHovering then
				bindStroke.Color = c
			end
		end)

		ConfigModule:RegisterFlag(flag, function() return currentKey.Name end, function(val)
			pcall(function()
				currentKey = Enum.KeyCode[val] or Enum.KeyCode.Unknown
				bindLabel.Text = currentKey == Enum.KeyCode.Unknown and "None" or currentKey.Name
			end)
		end)

		return {
			Wrapper = wrapper,
			SetText = function(self, newTitle)
				if ptitleLabel and newTitle then ptitleLabel.Text = newTitle end
			end,
			SetKey = function(self, newKey)
				currentKey = newKey
				bindLabel.Text = currentKey == Enum.KeyCode.Unknown and "None" or currentKey.Name
			end
		}
	end

	return Keybind
end

-- ==========================================
-- MODULE: src/components/ui/Divider
-- ==========================================
modules["src/components/ui/Divider"] = function()
	local Divider = {}

	local ThemesModule = require("src/themes/init")

	function Divider.new(parentFrame, titleArg)
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
		ThemesModule:RegisterText(label, false)
		
		local leftLine = Instance.new("Frame")
		leftLine.Size = UDim2.new(0, 3, 0, 14)
		leftLine.Position = UDim2.new(0, 0, 0.5, -7)
		leftLine.BackgroundColor3 = ThemesModule.GlowColor
		leftLine.BorderSizePixel = 0
		leftLine.Parent = wrapper
		Instance.new("UICorner", leftLine).CornerRadius = UDim.new(1, 0)

		ThemesModule:OnGlowChanged(leftLine, function(c)
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

	return Divider
end

-- ==========================================
-- MODULE: src/components/ui/Section
-- ==========================================
modules["src/components/ui/Section"] = function()
	local Section = {}

	local ThemesModule = require("src/themes/init")
	local TweenService = game:GetService("TweenService")

	function Section.new(parentFrame, titleArg, attachElementsCallback)
		local title = type(titleArg) == "table" and titleArg.Title or tostring(titleArg or "Section")
		local isOpen = false

		local sectionBox = Instance.new("Frame")
		sectionBox.Name = "CollapsibleSection_" .. title
		sectionBox.Size = UDim2.new(0.95, 0, 0, 0)
		sectionBox.BorderSizePixel = 0
		sectionBox.Parent = parentFrame
		sectionBox.AutomaticSize = Enum.AutomaticSize.Y
		Instance.new("UICorner", sectionBox).CornerRadius = UDim.new(0, 10)
		ThemesModule:AddPanel(sectionBox, 0.02)

		local boxStroke = Instance.new("UIStroke", sectionBox)
		boxStroke.Thickness = 1.5
		boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		ThemesModule:RegisterBorder(boxStroke)

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
		
		ThemesModule:OnThemeChanged(accentLine, function(t)
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
		ThemesModule:RegisterText(titleLabel, false)

		local arrowIcon = Instance.new("ImageLabel")
		arrowIcon.AnchorPoint = Vector2.new(1, 0.5)
		arrowIcon.Position = UDim2.new(1, -16, 0.5, 0)
		arrowIcon.Size = UDim2.fromOffset(16, 16)
		arrowIcon.BackgroundTransparency = 1
		arrowIcon.Image = "rbxassetid://6031091004" 
		arrowIcon.Rotation = -90
		arrowIcon.Parent = headerFrame
		ThemesModule:OnThemeChanged(arrowIcon, function(t)
			if not isOpen then arrowIcon.ImageColor3 = t.MutedText end
		end)

		local divider = Instance.new("Frame")
		divider.Size = UDim2.new(0.95, 0, 0, 1)
		divider.BorderSizePixel = 0
		divider.LayoutOrder = 2
		divider.Visible = false
		divider.Parent = sectionBox
		ThemesModule:OnThemeChanged(divider, function(t)
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
					ImageColor3 = ThemesModule.GlowColor
				}):Play()
				TweenService:Create(accentLine, TweenInfo.new(animDuration, easeStyle, easeDir), {
					BackgroundColor3 = ThemesModule.GlowColor
				}):Play()
				ThemesModule:StartNeonLoop(boxStroke)
				ThemesModule:StartNeonLoop(accentLine)
			else
				TweenService:Create(arrowIcon, TweenInfo.new(animDuration, easeStyle, easeDir), {
					Rotation = -90,
					ImageColor3 = ThemesModule.CurrentTheme.MutedText
				}):Play()
				TweenService:Create(accentLine, TweenInfo.new(animDuration, easeStyle, easeDir), {
					BackgroundColor3 = ThemesModule.CurrentTheme.MutedText
				}):Play()
				ThemesModule:StopNeonLoop(boxStroke)
				ThemesModule:StopNeonLoop(accentLine)
				boxStroke.Color = ThemesModule.CurrentTheme.Border
				accentLine.BackgroundColor3 = ThemesModule.CurrentTheme.MutedText
			end
		end

		toggleDetector.MouseEnter:Connect(function()
			TweenService:Create(headerFrame, TweenInfo.new(0.15), { BackgroundColor3 = ThemesModule.GetColor(0.04), BackgroundTransparency = 0.4 }):Play()
			TweenService:Create(titleLabel, TweenInfo.new(0.15), { TextColor3 = ThemesModule.CurrentTheme.Text }):Play()
		end)
		toggleDetector.MouseLeave:Connect(function()
			TweenService:Create(headerFrame, TweenInfo.new(0.15), { BackgroundTransparency = 1 }):Play()
			TweenService:Create(titleLabel, TweenInfo.new(0.15), { TextColor3 = ThemesModule.CurrentTheme.Text }):Play()
		end)

		toggleDetector.MouseButton1Down:Connect(function()
			TweenService:Create(sectionBox, TweenInfo.new(0.1), { Size = UDim2.new(0.93, 0, 0, 0) }):Play()
		end)
		toggleDetector.MouseButton1Up:Connect(function()
			TweenService:Create(sectionBox, TweenInfo.new(0.1), { Size = UDim2.new(0.95, 0, 0, 0) }):Play()
			toggleSection()
		end)

		local sectionPublic = { Frame = sectionBox, ContentFrame = sectionContent, Header = headerFrame }
		if attachElementsCallback then
			attachElementsCallback(sectionPublic, sectionContent)
		end
		function sectionPublic:SetText(newText)
			titleLabel.Text = newText
		end
		return sectionPublic
	end

	return Section
end

-- ==========================================
-- MODULE: src/components/Window
-- ==========================================
modules["src/components/Window"] = function()
	local WindowModule = {}

	local ThemesModule = require("src/themes/init")
	local UtilsModule = require("src/utils/init")
	local ConfigModule = require("src/config/init")
	local NotificationModule = require("src/components/Notification")

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
			local title = type(arg1) == "table" and arg1.Title or arg1
			return Section.new(parentFrame, title, AttachElementsToAPI)
		end
		
		function apiTable:Section(arg1)
			local title = type(arg1) == "table" and arg1.Title or arg1
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
			elseif lowerTheme == "midnight" or lowerTheme == "blue" then
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
end

-- ==========================================
-- MODULE: src/init (Main Entry Point)
-- ==========================================
local KazeUI = {}
KazeUI.__index = KazeUI

-- Load internal core sub-modules via simulated require
local ThemesModule = require("src/themes/init")
local UtilsModule = require("src/utils/init")
local ConfigModule = require("src/config/init")
local NotificationModule = require("src/components/Notification")
local WindowModule = require("src/components/Window")

-- Expose configurations
KazeUI.Themes = ThemesModule.Themes
KazeUI.CurrentTheme = ThemesModule.CurrentTheme
KazeUI.GlowColor = ThemesModule.GlowColor
KazeUI.BackgroundColor = ThemesModule.CurrentTheme.Background
KazeUI.BackgroundTransparency = ThemesModule.BackgroundTransparency
KazeUI.Flags = ConfigModule.Flags
KazeUI.ActiveWindows = {} 

-- ScreenGui Setup (Supports CoreGui & PlayerGui Fallback)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KazeUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 10 

local success, parent = pcall(function() return game:GetService("CoreGui") end)
if not success or not parent then
	parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui", 15)
end
ScreenGui.Parent = parent

-- Init global utilities
UtilsModule:InitCameraLocker(ScreenGui)
UtilsModule:InitScale(ScreenGui)

-- Separate Notification screen layer
local NotifScreenGui = Instance.new("ScreenGui")
NotifScreenGui.Name = "KazeUINotifications"
NotifScreenGui.ResetOnSpawn = false
NotifScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NotifScreenGui.DisplayOrder = 999999 
NotifScreenGui.Parent = parent

-- Init notifications
NotificationModule:Init(NotifScreenGui)

-- API Merging to match backward compatibility expectations
function KazeUI:Notify(config)
	NotificationModule:Notify(config)
end

function KazeUI:SaveConfig(name)
	ConfigModule:SaveConfig(name, function(conf) NotificationModule:Notify(conf) end)
end

function KazeUI:LoadConfig(name)
	ConfigModule:LoadConfig(name, function(conf) NotificationModule:Notify(conf) end)
end

function KazeUI:SetTheme(themeName)
	ThemesModule:SetTheme(themeName)
	KazeUI.CurrentTheme = ThemesModule.CurrentTheme
	KazeUI.BackgroundColor = ThemesModule.CurrentTheme.Background
end

function KazeUI:SetGlow(color)
	ThemesModule:SetGlow(color)
	KazeUI.GlowColor = ThemesModule.GlowColor
end

function KazeUI:SetTransparency(alpha)
	ThemesModule:SetTransparency(alpha)
	KazeUI.BackgroundTransparency = ThemesModule.BackgroundTransparency
end

function KazeUI:CreateWindow(config)
	local winInstance = WindowModule:CreateWindow(config, ScreenGui)
	table.insert(KazeUI.ActiveWindows, winInstance.Window)
	return winInstance
end

return KazeUI
