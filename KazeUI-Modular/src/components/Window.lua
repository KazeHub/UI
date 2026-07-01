
local ThemesModule = {}

-- Preset ng mga Tema (Configurations)
ThemesModule.Themes = {
	Obsidian = {
		Name = "Obsidian",
		Background = Color3.fromRGB(10, 10, 12),
		Text = Color3.fromRGB(240, 240, 245),
		MutedText = Color3.fromRGB(150, 150, 155),
		Border = Color3.fromRGB(45, 45, 50),
		LightnessFactor = 1 -- Positibo: mas maliwanag na elevations
	},
	Arctic = {
		Name = "Arctic",
		Background = Color3.fromRGB(245, 247, 250),
		Text = Color3.fromRGB(20, 20, 25),
		MutedText = Color3.fromRGB(110, 115, 125),
		Border = Color3.fromRGB(215, 220, 228),
		LightnessFactor = -1 -- Negatibo: mas madidilim na elevations
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
	-- Matrix Classic Neon Green
	CyberHacker = {
		Name = "CyberHacker",
		Background = Color3.fromRGB(5, 10, 6),
		Text = Color3.fromRGB(0, 255, 100),
		MutedText = Color3.fromRGB(0, 140, 55),
		Border = Color3.fromRGB(15, 60, 30),
		LightnessFactor = 1
	},
	-- Terminal Overdrive
	TerminalVoid = {
		Name = "TerminalVoid",
		Background = Color3.fromRGB(8, 8, 8),
		Text = Color3.fromRGB(50, 255, 180),
		MutedText = Color3.fromRGB(30, 160, 110),
		Border = Color3.fromRGB(40, 40, 42),
		LightnessFactor = 1
	},
	-- Synthwave Tokyo Night
	Synthwave = {
		Name = "Synthwave",
		Background = Color3.fromRGB(20, 8, 30),
		Text = Color3.fromRGB(255, 90, 210),
		MutedText = Color3.fromRGB(150, 70, 170),
		Border = Color3.fromRGB(70, 20, 100),
		LightnessFactor = 1
	},
	-- Luxury Dark Gold
	DarkGold = {
		Name = "DarkGold",
		Background = Color3.fromRGB(12, 11, 9),
		Text = Color3.fromRGB(255, 215, 115),
		MutedText = Color3.fromRGB(165, 140, 95),
		Border = Color3.fromRGB(50, 40, 30),
		LightnessFactor = 1
	},
	-- Frostbite Cool Blue
	Frostbite = {
		Name = "Frostbite",
		Background = Color3.fromRGB(8, 14, 20),
		Text = Color3.fromRGB(140, 225, 255),
		MutedText = Color3.fromRGB(90, 150, 180),
		Border = Color3.fromRGB(30, 55, 75),
		LightnessFactor = 1
	},
	-- Vampire/Dark Red
	CrimsonVoid = {
		Name = "CrimsonVoid",
		Background = Color3.fromRGB(10, 5, 6),
		Text = Color3.fromRGB(255, 85, 85),
		MutedText = Color3.fromRGB(155, 60, 60),
		Border = Color3.fromRGB(50, 20, 25),
		LightnessFactor = 1
	},
	-- Sakura Breeze (Pastel Pink)
	SakuraBreeze = {
		Name = "SakuraBreeze",
		Background = Color3.fromRGB(28, 18, 22),
		Text = Color3.fromRGB(255, 185, 200),
		MutedText = Color3.fromRGB(190, 130, 145),
		Border = Color3.fromRGB(75, 45, 55),
		LightnessFactor = 1
	},
	-- Cosmic Nebula (Purple/Orange Highlight)
	CosmicNebula = {
		Name = "CosmicNebula",
		Background = Color3.fromRGB(12, 10, 18),
		Text = Color3.fromRGB(255, 140, 90),
		MutedText = Color3.fromRGB(140, 100, 150),
		Border = Color3.fromRGB(45, 30, 65),
		LightnessFactor = 1
	},
	-- Ghost Recon (Tactical Camo/Olive Green)
	GhostRecon = {
		Name = "GhostRecon",
		Background = Color3.fromRGB(14, 16, 13),
		Text = Color3.fromRGB(180, 200, 160),
		MutedText = Color3.fromRGB(120, 130, 110),
		Border = Color3.fromRGB(45, 50, 42),
		LightnessFactor = 1
	}
}

-- Mga paunang estado ng rehistro
ThemesModule.CurrentTheme = ThemesModule.Themes.Obsidian
ThemesModule.GlowColor = Color3.fromRGB(0, 160, 255)
ThemesModule.BackgroundColor = ThemesModule.CurrentTheme.Background
ThemesModule.BackgroundTransparency = 0

-- Mga listahan ng rehistradong elemento para sa pagbabago
ThemesModule.TextElements = {}
ThemesModule.MutedTextElements = {}
ThemesModule.BorderElements = {}
ThemesModule.ThemeCallbacks = {}
ThemesModule.PanelElements = {}
ThemesModule.GlowElements = {}
ThemesModule.NeonTweens = {}
ThemesModule.GlowCallbacks = {}

local TweenService = game:GetService("TweenService")

-- Kumuha ng kulay batay sa elevation at kasalukuyang tema
function ThemesModule.GetColor(elevation)
	local theme = ThemesModule.CurrentTheme
	local h, s, v = Color3.toHSV(theme.Background)
	local factor = theme.LightnessFactor or 1
	local offset = elevation * factor
	return Color3.fromHSV(h, s, math.clamp(v + offset, 0, 1))
end

-- Rehistro para sa mga Teksto
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

-- Rehistro para sa mga Borders o Gilid
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

-- Callback kapag nagbago ang tema
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

-- Magdagdag ng Panel sa listahan
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

-- Baguhin ang kulay ng Background ng lahat ng panel
function ThemesModule:SetBackgroundColor(color)
	for _, data in ipairs(ThemesModule.PanelElements) do
		if data.Inst and data.Inst.Parent and data.Inst:IsA("GuiObject") and not data.IgnoreColor then
			data.Inst.BackgroundColor3 = ThemesModule.GetColor(data.Elevation)
		end
	end
end

-- Baguhin ang aninag (transparency)
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

-- Set ang kasalukuyang tema (May Case-Insensitive at Shortcut Fallbacks)
function ThemesModule:SetTheme(themeName)
	local targetTheme = nil
	local searchName = string.lower(tostring(themeName or "obsidian"))
	
	-- Mga alias o shortcuts para sa madaling pagtawag
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

-- Listener kapag nagbago ang Glow
function ThemesModule:OnGlowChanged(inst, callback)
	table.insert(ThemesModule.GlowCallbacks, {Inst = inst, Callback = callback})
	task.spawn(callback, ThemesModule.GlowColor)
end

-- Simulan ang Neon Glow Loop animation (Kumukurap na ilaw)
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

-- Itigil ang Neon Glow Loop animation
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

-- Palitan ang kulay ng Glow ng lahat ng neon elements
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
