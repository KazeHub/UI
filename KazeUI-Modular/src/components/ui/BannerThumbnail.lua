local BannerThumbnail = {}

function BannerThumbnail.new(parentFrame, title, imageId)
    -- Main container spanning the full section width
    local Frame = Instance.new("Frame")
    Frame.Name = "BannerThumbnailComponent"
    Frame.Size = UDim2.new(1, -16, 0, 0) -- Height is managed by the aspect ratio constraint
    Frame.AutomaticSize = Enum.AutomaticSize.Y
    Frame.BackgroundTransparency = 1
    Frame.Parent = parentFrame

    local Layout = Instance.new("UIListLayout")
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 4)
    Layout.Parent = Frame

    -- Title text above the image
    if title and title ~= "" then
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, 0, 0, 18)
        Label.Text = title
        Label.Font = Enum.Font.GothamBold
        Label.TextSize = 12
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.BackgroundTransparency = 1
        Label.LayoutOrder = 1
        Label.Parent = Frame
    end

    -- Big Image Container
    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Size = UDim2.new(1, 0, 0, 0) -- Width is 100%, height auto-calculates
    ImageLabel.Image = imageId or "rbxassetid://0"
    ImageLabel.ScaleType = Enum.ScaleType.Crop -- Crops seamlessly if the aspect ratio changes
    ImageLabel.LayoutOrder = 2
    ImageLabel.Parent = Frame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = ImageLabel

    -- CRITICAL STEP: Keeps the image big and perfectly proportional (16:9 widescreen format)
    local AspectRatio = Instance.new("UIAspectRatioConstraint")
    AspectRatio.AspectRatio = 16/9 
    AspectRatio.AspectType = Enum.AspectType.ScaleWithWidth
    AspectRatio.DominantAxis = Enum.DominantAxis.Width
    AspectRatio.Parent = ImageLabel

    return Frame
end

return BannerThumbnail
