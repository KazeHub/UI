local ThemesModule = {}

-- Theme Presets Configuration
ThemesModule.Themes = {
	Obsidian = {
		Name = "Obsidian",
		Background = Color3.fromRGB(10, 10, 12),
		Text = Color3.fromRGB(240, 240, 245),
		MutedText = Color3.fromRGB(150, 150, 155),
		Border = Color3.fromRGB(45, 45, 50),
		LightnessFactor = 1 -- Positive: lighter elevations
	},
	Arctic = {
		Name = "Arctic",
		Background = Color3.fromRGB(245, 247, 250),
		Text = Color3.fromRGB(20, 20, 25),
		MutedText = Color3.fromRGB(110, 115, 125),
		Border = Color3.fromRGB(215, 220, 228),
		LightnessFactor = -1 -- Negative: darker elevations
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
	}
}

-- Registry states
ThemesModule.CurrentTheme = ThemesModule.Themes.Obsidian
ThemesModule.GlowColor = Color3.fromRGB(0, 160, 255)
ThemesModule.BackgroundColor = ThemesModule.CurrentTheme.Background
ThemesModule.BackgroundTransparency = 0

-- Subscription registries
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

function ThemesModule:SetTheme(themeName)
	local targetTheme = ThemesModule.Themes[themeName] or ThemesModule.Themes.Obsidian
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
