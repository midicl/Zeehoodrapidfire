local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Camera           = workspace.CurrentCamera
local LP               = Players.LocalPlayer

print("[Zee] Rapid Fire active — Solara max speed")

local rf_firing = false

local function getGun()
    local char = LP.Character
    if not char then return nil end
    return char:FindFirstChildOfClass("Tool")
end

UserInputService.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        rf_firing = true
    end
end)

UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        rf_firing = false
    end
end)

-- Fire 5x every Heartbeat while M1 held — much faster than once per frame
RunService.Heartbeat:Connect(function()
    if not rf_firing then return end
    local g = getGun()
    if not g then return end
    pcall(function() g:Activate() end)
    pcall(function() g:Activate() end)
    pcall(function() g:Activate() end)
    pcall(function() g:Activate() end)
    pcall(function() g:Activate() end)
end)

-- Rainbow "Enabled" label at bottom center
local label        = Drawing.new("Text")
label.Text         = "Enabled"
label.Size         = 20
label.Center       = true
label.Outline      = true
label.OutlineColor = Color3.new(0, 0, 0)
label.Font         = (Drawing.Fonts and Drawing.Fonts.UI) or 0
label.Visible      = true

local hue = 0
RunService.Heartbeat:Connect(function(dt)
    hue = (hue + dt * 0.8) % 1
    label.Color    = Color3.fromHSV(hue, 1, 1)
    local vp       = Camera.ViewportSize
    label.Position = Vector2.new(vp.X * 0.5, vp.Y - 36)
end)
