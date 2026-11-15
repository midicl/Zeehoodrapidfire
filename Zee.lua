local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LP               = Players.LocalPlayer

print("[Zee] Rapid Fire active — max speed")

local rf_firing = false

local function getGun()
    local char = LP.Character
    if not char then return nil end
    return char:FindFirstChildOfClass("Tool")
end

UserInputService.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    if rf_firing then return end
    rf_firing = true
    task.spawn(function()
        while rf_firing do
            local g = getGun()
            if g then pcall(function() g:Activate() end) end
            task.wait()
        end
    end)
end)

UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        rf_firing = false
    end
end)
