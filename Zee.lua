local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Camera           = workspace.CurrentCamera
local LP               = Players.LocalPlayer

print("[Zee] Rapid Fire + Auto Reload active — Solara max speed")

-- ─── Rapid Fire ───────────────────────────────────────────────────────────────
local rf_firing  = false
local rf_timer   = 0
local RF_RATE    = 0  -- fire every frame, no throttle

local function isFireInput(i)
    return i.UserInputType == Enum.UserInputType.MouseButton1
        or i.KeyCode == Enum.KeyCode.ButtonR2
end

UserInputService.InputBegan:Connect(function(i, gp)
    if gp then return end
    if isFireInput(i) then rf_firing = true end
end)

UserInputService.InputEnded:Connect(function(i)
    if isFireInput(i) then rf_firing = false; rf_timer = 0 end
end)

-- ─── Auto Reload ──────────────────────────────────────────────────────────────
local ar_cooldown = 0

-- ─── Rainbow label ────────────────────────────────────────────────────────────
local label        = Drawing.new("Text")
label.Text         = "Enabled"
label.Size         = 20
label.Center       = true
label.Outline      = true
label.OutlineColor = Color3.new(0, 0, 0)
label.Font         = (Drawing.Fonts and Drawing.Fonts.UI) or 0
label.Visible      = true
local hue = 0

-- ─── Single merged Heartbeat ─────────────────────────────────────────────────
RunService.Heartbeat:Connect(function(dt)
    local char = LP.Character
    local tool = char and char:FindFirstChildOfClass("Tool")

    -- Rapid fire (throttled)
    if rf_firing and tool then
        rf_timer = rf_timer - dt
        if rf_timer <= 0 then
            rf_timer = RF_RATE
            pcall(tool.Activate, tool)
            pcall(tool.Activate, tool)
            pcall(tool.Activate, tool)
        end
    end

    -- Auto reload
    ar_cooldown = math.max(0, ar_cooldown - dt)
    if tool then
        local ammo = tool:FindFirstChild("Ammo")
        if ammo and ammo.Value <= 0 and ar_cooldown <= 0 then
            ar_cooldown = 1.5
            pcall(function() keypress(0x52) end)
            task.delay(0.07, function() pcall(function() keyrelease(0x52) end) end)
        end
    end

    -- Rainbow label
    hue = (hue + dt * 0.8) % 1
    label.Color    = Color3.fromHSV(hue, 1, 1)
    local vp       = Camera.ViewportSize
    label.Position = Vector2.new(vp.X * 0.5, vp.Y - 36)
end)
