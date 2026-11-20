local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local Camera      = workspace.CurrentCamera
local LP          = Players.LocalPlayer

print("[Zee] Rapid Fire + Auto Reload active")

-- ─── State ────────────────────────────────────────────────────────────────────
local rf_firing  = false
local ar_cooldown = 0
local hue = 0

-- ─── Input (guarded — UIS may not be ready on inject) ────────────────────────
pcall(function()
    local UIS = game:GetService("UserInputService")
    local function isFireInput(i)
        return i.UserInputType == Enum.UserInputType.MouseButton1
            or i.KeyCode == Enum.KeyCode.ButtonR2
    end
    UIS.InputBegan:Connect(function(i, gp)
        if not gp and isFireInput(i) then rf_firing = true end
    end)
    UIS.InputEnded:Connect(function(i)
        if isFireInput(i) then rf_firing = false end
    end)
end)

-- ─── Rainbow label (guarded — Drawing may not exist) ─────────────────────────
local label = nil
pcall(function()
    label              = Drawing.new("Text")
    label.Text         = "Enabled"
    label.Size         = 20
    label.Center       = true
    label.Outline      = true
    label.OutlineColor = Color3.new(0, 0, 0)
    label.Font         = (Drawing.Fonts and Drawing.Fonts.UI) or 0
    label.Visible      = true
end)

-- ─── Single merged Heartbeat ─────────────────────────────────────────────────
RunService.Heartbeat:Connect(function(dt)
    local char = LP.Character
    local tool = char and char:FindFirstChildOfClass("Tool")

    -- No shoot delay
    if tool then
        pcall(function()
            for _, v in ipairs(tool:GetChildren()) do
                if v:IsA("NumberValue") and (
                    v.Name == "ShootDelay" or v.Name == "FireDelay" or
                    v.Name == "Cooldown"   or v.Name == "RateOfFire" or
                    v.Name == "FireRate"   or v.Name == "Delay"
                ) then v.Value = 0 end
            end
        end)
    end

    -- Rapid fire
    if rf_firing and tool then
        pcall(function() tool:Activate() end)
        pcall(function() tool:Activate() end)
        pcall(function() tool:Activate() end)
    end

    -- Auto reload
    ar_cooldown = math.max(0, ar_cooldown - dt)
    if tool then
        local ammo = tool:FindFirstChild("Ammo")
        if ammo and ammo.Value <= 0 and ar_cooldown <= 0 then
            ar_cooldown = 1.5
            pcall(function() keypress(0x52) end)
            pcall(function()
                wait(0.07)
                keyrelease(0x52)
            end)
        end
    end

    -- Rainbow label
    if label then
        hue = (hue + dt * 0.8) % 1
        pcall(function()
            label.Color    = Color3.fromHSV(hue, 1, 1)
            label.Position = Vector2.new(Camera.ViewportSize.X * 0.5, Camera.ViewportSize.Y - 36)
        end)
    end
end)
