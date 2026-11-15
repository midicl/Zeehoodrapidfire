local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Camera           = workspace.CurrentCamera
local LP               = Players.LocalPlayer

print("[Zee] Rapid Fire + Auto Reload active — Solara max speed")

-- ─── Rapid Fire ───────────────────────────────────────────────────────────────
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

-- Fire every Heartbeat while M1 held — no closure allocations, zero GC pressure
RunService.Heartbeat:Connect(function()
    if not rf_firing then return end
    local g = getGun()
    if not g then return end
    pcall(g.Activate, g)
    pcall(g.Activate, g)
    pcall(g.Activate, g)
end)

-- ─── Auto Reload ──────────────────────────────────────────────────────────────
local ar_cooldown = 0

RunService.Heartbeat:Connect(function(dt)
    ar_cooldown = math.max(0, ar_cooldown - dt)
    local char = LP.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if tool then
        local ammo = tool:FindFirstChild("Ammo")
        if ammo and ammo.Value <= 0 and ar_cooldown <= 0 then
            ar_cooldown = 1.5
            pcall(function() keypress(0x52) end)
            task.delay(0.07, function() pcall(function() keyrelease(0x52) end) end)
        end
    end
end)

-- ─── Rainbow "Enabled" label at bottom center ─────────────────────────────────
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
