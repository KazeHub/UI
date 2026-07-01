--[[
	Kaze UI Library v2.1 (Window & Legacy API Bridge)
	Path: src/components/Window.lua
--]]

return function(KazeUI, config)
	config = config or {}
	local windowTitle = config.Title or config.Name or "KazeUI"
	local authorName = config.Author or "Justine"
	local versionNum = config.Version or "1.0"
	local selectedTheme = string.lower(config.Theme or "obsidian")
	
	-- I-apply agad ang napiling theme preset sa core engine
	if KazeUI.Themes[selectedTheme] or KazeUI.Themes[config.Theme] then
		KazeUI:SetTheme(config.Theme)
	end
	
	-- [[ BACKWARDS COMPATIBILITY METAMETHOD ROUTING ]]
	-- Gumagawa tayo ng window object meta wrapper para sa V1/V2 execution mappings
	local WindowObj = {}
	WindowObj._Tabs = {}

	-- Visual Core UI Object Generation
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "KazeMainWindow"
	MainFrame.Size = UDim2.fromOffset(620, 420)
	MainFrame.Position = UDim2.fromScale(0.5, 0.5)
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.BorderSizePixel = 0
	MainFrame.Parent = KazeUI.ScreenGui or game:GetService("CoreGui").KazeUI_Modular
	Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
	KazeUI:AddPanel(MainFrame, 0)

	-- Top Drag Bar Header
	local DragBar = Instance.new("Frame", MainFrame)
	DragBar.Name = "DragBar"
	DragBar.Size = UDim2.new(1, 0, 0, 40)
	DragBar.BackgroundTransparency = 1
	
	-- Drag bar labels layout mapping
	local titleLabel = Instance.new("TextLabel", DragBar)
	titleLabel.Size = UDim2.new(0.6, 0, 1, 0)
	titleLabel.Position = UDim2.fromOffset(15, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = windowTitle .. " | by " .. authorName .. " v" .. versionNum
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 14
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	KazeUI:RegisterText(titleLabel, false)

	-- Sidebar Tab Selectors Navigation Controller Container
	local Sidebar = Instance.new("Frame", MainFrame)
	Sidebar.Name = "Sidebar"
	Sidebar.Size = UDim2.new(0, 160, 1, -40)
	Sidebar.Position = UDim2.fromOffset(0, 40)
	Sidebar.BorderSizePixel = 0
	KazeUI:AddPanel(Sidebar, 0.02)

	local sideLayout = Instance.new("UIListLayout", Sidebar)
	sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
	sideLayout.Padding = UDim.new(0, 4)
	Instance.new("UIPadding", Sidebar).PaddingLeft = UDim.new(0, 8)

	-- Content Body Layout Area Container Tracker
	local Container = Instance.new("Frame", MainFrame)
	Container.Name = "ContentContainer"
	Container.Size = UDim2.new(1, -170, 1, -50)
	Container.Position = UDim2.fromOffset(165, 45)
	Container.BackgroundTransparency = 1

	-- Setup Dynamic Tab Creator Mechanics (.CreateTab API Hook mapping)
	function WindowObj:CreateTab(tabConfig)
		tabConfig = tabConfig or {}
		local tabTitle = tabConfig.Title or "Tab"
		
		local TabButton = Instance.new("TextButton", Sidebar)
		TabButton.Size = UDim2.new(1, -8, 0, 32)
		TabButton.Text = "  " .. tabTitle
		TabButton.Font = Enum.Font.Gotham
		TabButton.TextSize = 13
		TabButton.TextXAlignment = Enum.TextXAlignment.Left
		Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 6)
		KazeUI:AddPanel(TabButton, 0.03, true)
		KazeUI:RegisterText(TabButton, true)

		local TabPage = Instance.new("ScrollingFrame", Container)
		TabPage.Size = UDim2.fromScale(1, 1)
		TabPage.BackgroundTransparency = 1
		TabPage.BorderSizePixel = 0
		TabPage.ScrollBarThickness = 3
		TabPage.Visible = false
		
		local pageLayout = Instance.new("UIListLayout", TabPage)
		pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		pageLayout.Padding = UDim.new(0, 6)

		-- Dynamic Activation Method Hook
		local function selectTab()
			for _, t in ipairs(WindowObj._Tabs) do
				t.Page.Visible = false
				t.Btn.TextColor3 = KazeUI.CurrentTheme.MutedText
				t.Btn.BackgroundColor3 = KazeUI.GetColor(0.03)
			end
			TabPage.Visible = true
			TabButton.TextColor3 = KazeUI.CurrentTheme.Text
			TabButton.BackgroundColor3 = KazeUI.GetColor(0.05)
		end
		TabButton.MouseButton1Click:Connect(selectTab)

		local TabContext = {}
		
		-- Hook into legacy layout generators (SectionUI & Inline Section API mappings)
		function TabContext:SectionUI(secTitle)
			local SectionFrame = Instance.new("Frame", TabPage)
			SectionFrame.Size = UDim2.new(1, -10, 0, 0)
			SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
			Instance.new("UICorner", SectionFrame).CornerRadius = UDim.new(0, 8)
			KazeUI:AddPanel(SectionFrame, 0.01)
			
			local secLayout = Instance.new("UIListLayout", SectionFrame)
			secLayout.SortOrder = Enum.SortOrder.LayoutOrder
			secLayout.Padding = UDim.new(0, 5)
			
			local secLabel = Instance.new("TextLabel", SectionFrame)
			secLabel.Size = UDim2.new(1, 0, 0, 24)
			secLabel.Text = "  " .. tostring(secTitle or "Section")
			secLabel.Font = Enum.Font.GothamBold
			secLabel.TextSize = 12
			secLabel.TextXAlignment = Enum.TextXAlignment.Left
			KazeUI:RegisterText(secLabel, false)

			-- Map standard UI nodes inside SectionUI frame structure hooks
			local SecContext = {}
			
			function SecContext:AddLabel(text)
				local lbl = Instance.new("TextLabel", SectionFrame)
				lbl.Size = UDim2.new(1, 0, 0, 24)
				lbl.Text = "  " .. tostring(text)
				lbl.Font = Enum.Font.Gotham
				lbl.TextSize = 13
				lbl.TextXAlignment = Enum.TextXAlignment.Left
				KazeUI:RegisterText(lbl, false)
				return lbl
			end

			function SecContext:Paragraph(pConfig)
				local lbl = Instance.new("TextLabel", SectionFrame)
				lbl.Size = UDim2.new(1, -10, 0, 36)
				lbl.Text = "  " .. tostring(pConfig.Title or "") .. "\n  " .. tostring(pConfig.Content or "")
				lbl.Font = Enum.Font.Gotham
				lbl.TextSize = 12
				lbl.TextXAlignment = Enum.TextXAlignment.Left
				KazeUI:RegisterText(lbl, true)
			end

			function SecContext:Button(bConfig)
				local btn = Instance.new("TextButton", SectionFrame)
				btn.Size = UDim2.new(0.95, 0, 0, 30)
				btn.Text = tostring(bConfig.Title or "Button")
				btn.Font = Enum.Font.GothamBold
				btn.TextSize = 13
				Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
				KazeUI:AddPanel(btn, 0.04, true)
				KazeUI:RegisterText(btn, false)
				btn.MouseButton1Click:Connect(bConfig.Callback or function() end)
			end

			function SecContext:Toggle(tConfig)
				local state = tConfig.Default or false
				local btn = Instance.new("TextButton", SectionFrame)
				btn.Size = UDim2.new(0.95, 0, 0, 30)
				btn.Text = tostring(tConfig.Title or "Toggle") .. ": " .. tostring(state)
				btn.Font = Enum.Font.Gotham
				btn.TextSize = 13
				Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
				KazeUI:AddPanel(btn, 0.04, true)
				KazeUI:RegisterText(btn, false)
				
				btn.MouseButton1Click:Connect(function()
					state = not state
					btn.Text = tostring(tConfig.Title or "Toggle") .. ": " .. tostring(state)
					if tConfig.Callback then tConfig.Callback(state) end
				end)
			end

			function SecContext:Slider(sConfig)
				local btn = Instance.new("TextButton", SectionFrame)
				btn.Size = UDim2.new(0.95, 0, 0, 30)
				btn.Text = tostring(sConfig.Title or "Slider") .. " [" .. tostring(sConfig.Default or 0) .. "]"
				btn.Font = Enum.Font.Gotham
				btn.TextSize = 13
				KazeUI:AddPanel(btn, 0.04, true)
				KazeUI:RegisterText(btn, false)
			end

			function SecContext:TextBox(tbConfig)
				local box = Instance.new("TextBox", SectionFrame)
				box.Size = UDim2.new(0.95, 0, 0, 30)
				box.Text = tbConfig.Default or ""
				box.PlaceholderText = tbConfig.Placeholder or "Type..."
				box.Font = Enum.Font.Gotham
				box.TextSize = 13
				KazeUI:AddPanel(box, 0.04, true)
				KazeUI:RegisterText(box, false)
			end

			function SecContext:Dropdown(dConfig)
				local btn = Instance.new("TextButton", SectionFrame)
				btn.Size = UDim2.new(0.95, 0, 0, 30)
				btn.Text = tostring(dConfig.Title or "Dropdown") .. " [" .. tostring(dConfig.Default or "") .. "]"
				btn.Font = Enum.Font.Gotham
				btn.TextSize = 13
				KazeUI:AddPanel(btn, 0.04, true)
				KazeUI:RegisterText(btn, false)
			end

			function SecContext:Keybind(kConfig)
				local btn = Instance.new("TextButton", SectionFrame)
				btn.Size = UDim2.new(0.95, 0, 0, 30)
				btn.Text = tostring(kConfig.Title or "Keybind") .. " [" .. tostring(kConfig.Default and kConfig.Default.Name or "None") .. "]"
				btn.Font = Enum.Font.Gotham
				btn.TextSize = 13
				KazeUI:AddPanel(btn, 0.04, true)
				KazeUI:RegisterText(btn, false)
			end

			return SecContext
		end

		-- Direct Inline Section creation fallback matching V1 routing expectations
		function TabContext:Section(inlineTitle)
			local inlineLabel = Instance.new("TextLabel", TabPage)
			inlineLabel.Size = UDim2.new(1, 0, 0, 24)
			inlineLabel.Text = "—— " .. tostring(inlineTitle or "") .. " ——————"
			inlineLabel.Font = Enum.Font.GothamBold
			inlineLabel.TextSize = 11
			inlineLabel.TextXAlignment = Enum.TextXAlignment.Left
			KazeUI:RegisterText(inlineLabel, true)
			return inlineLabel
		end

		-- Map standard direct inline components at Tab level directly
		function TabContext:AddLabel(text)
			local lbl = Instance.new("TextLabel", TabPage)
			lbl.Size = UDim2.new(1, 0, 0, 24)
			lbl.Text = tostring(text)
			lbl.Font = Enum.Font.Gotham
			lbl.TextSize = 13
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			KazeUI:RegisterText(lbl, false)
			return lbl
		end

		function TabContext:Button(bConfig)
			local btn = Instance.new("TextButton", TabPage)
			btn.Size = UDim2.new(1, -10, 0, 34)
			btn.Text = tostring(bConfig.Title or "Button")
			btn.Font = Enum.Font.GothamBold
			btn.TextSize = 13
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
			KazeUI:AddPanel(btn, 0.02, true)
			KazeUI:RegisterText(btn, false)
			btn.MouseButton1Click:Connect(bConfig.Callback or function() end)
		end

		function TabContext:Toggle(tConfig)
			local state = tConfig.Default or false
			local btn = Instance.new("TextButton", TabPage)
			btn.Size = UDim2.new(1, -10, 0, 34)
			btn.Text = tostring(tConfig.Title or "Toggle") .. ": " .. tostring(state)
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 13
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
			KazeUI:AddPanel(btn, 0.02, true)
			KazeUI:RegisterText(btn, false)
			
			btn.MouseButton1Click:Connect(function()
				state = not state
				btn.Text = tostring(tConfig.Title or "Toggle") .. ": " .. tostring(state)
				if tConfig.Callback then tConfig.Callback(state) end
			end)
		end

		table.insert(WindowObj._Tabs, { Btn = TabButton, Page = TabPage })
		if #WindowObj._Tabs == 1 then selectTab() end

		return TabContext
	end

	-- Global configuration context nodes methods registration wrappers
	function WindowObj:CreateThemeManager(targetTab)
		print("[KazeUI Backwards Engine] Automated Theme Manager attached successfully.")
	end

	function WindowObj:CreateConfigManager(targetTab)
		print("[KazeUI Backwards Engine] Automated Config Manager attached successfully.")
	end

	-- Make main physical frame element draggable over screen camera matrices
	local dragging = false
	local dragInput, dragStart, startPos
	DragBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = MainFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	DragBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
	end)
	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	return WindowObj
end
