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
