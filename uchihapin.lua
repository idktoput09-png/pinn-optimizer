
-- PINN BRAINROT CARPET ANIMATION + REMOVE AURA
-- LOCAL OPTIMIZER

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- STOP VERSI LAMA
_G.PINN_V11_STOP = false

local function isCarpetBrainrot(obj)
    local current = obj

    while current and current ~= Workspace do
        local name = current.Name:lower()

        if name:find("carpet")
            or name:find("runway")
            or name:find("conveyor") then
            return true
        end

        current = current.Parent
    end

    return false
end

local function removeAuraEffects(obj)
    if _G.PINN_V11_STOP or not obj then
        return
    end

    pcall(function()
        if obj:IsA("ParticleEmitter")
            or obj:IsA("Trail")
            or obj:IsA("Beam")
            or obj:IsA("PointLight")
            or obj:IsA("SpotLight")
            or obj:IsA("SurfaceLight")
            or obj:IsA("Highlight") then
            obj.Enabled = false
        end
    end)
end

local function stopCarpetBrainrotAnimation(animator)
    if _G.PINN_V11_STOP
        or not animator:IsA("Animator") then
        return
    end

    local humanoid = animator.Parent
    local character = humanoid and humanoid.Parent

    if not character
        or character == LocalPlayer.Character then
        return
    end

    if not isCarpetBrainrot(character) then
        return
    end

    pcall(function()
        for _, track in ipairs(
            animator:GetPlayingAnimationTracks()
        ) do
            track:Stop(0)
        end
    end)
end

local function processObject(obj)
    if _G.PINN_V11_STOP then
        return
    end

    removeAuraEffects(obj)

    if obj:IsA("Animator") then
        stopCarpetBrainrotAnimation(obj)
    end
end

-- SCAN OBJEK YANG SUDAH ADA
for _, obj in ipairs(Workspace:GetDescendants()) do
    processObject(obj)
end

-- PROSES OBJEK BARU SAAT SPAWN
if _G.PINN_AURA_CONNECTION then
    _G.PINN_AURA_CONNECTION:Disconnect()
end

_G.PINN_AURA_CONNECTION =
    Workspace.DescendantAdded:Connect(function(obj)
        task.defer(function()
            processObject(obj)
        end)
    end)

-- PANTAU ANIMASI YANG DIMULAI ULANG
if _G.PINN_CARPET_ANIMATION_CONNECTION then
    _G.PINN_CARPET_ANIMATION_CONNECTION:Disconnect()
end

_G.PINN_CARPET_ANIMATION_CONNECTION =
    game:GetService("RunService").Heartbeat:Connect(function()
        if _G.PINN_V11_STOP then
            return
        end

        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Animator") then
                stopCarpetBrainrotAnimation(obj)
            end
        end
    end)

print("PINN: Carpet animation + aura optimizer aktif")
