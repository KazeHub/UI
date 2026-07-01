--!strict
--[[
    Tween.lua
    Centralized TweenInfo presets used throughout Kaze UI for responsive animations.
--]]

local Tween = {
    FAST = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    SPRING = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    SMOOTH = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
}

return Tween
