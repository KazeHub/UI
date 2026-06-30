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
