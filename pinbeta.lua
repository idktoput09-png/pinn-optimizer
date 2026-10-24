-- PINN BRAINROT ANIMATION STOPPER
-- DIRECT / SUNG EXECUTE | DELTA ANDROID

_G.PINN_BRAINROT_STOP = false

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- Hentikan versi sebelumnya
if _G.PINN_BRAINROT_CONNECTION then
    pcall(function()
        _G.PINN_BRAINROT_CONNECTION:Disconnect()
    end)
end

if _G.PINN_BRAINROT_ADDED_CONNECTION then
    pcall(function()
        _G.PINN_BRAINROT_ADDED_CONNECTION:Disconnect()
    end)
end

local function isOwnCharacter(animator)
    local character = LocalPlayer.Character
    return character and animator:IsDescendantOf(character)
end

local function stopAnimation(animator)
    if _G.PINN_BRAINROT_STOP then return end
    if not animator or not animator:IsA("Animator") then return end
    if isOwnCharacter(animator) then return end

    pcall(function()
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            track:Stop(0)
        end
    end)
end

-- Animator yang sudah ada
task.spawn(function()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if _G.PINN_BRAINROT_STOP then return end
        if obj:IsA("Animator") then
            stopAnimation(obj)
        end
        task.wait()
    end
end)

-- Animator baru, termasuk brainrot yang muncul kemudian
_G.PINN_BRAINROT_ADDED_CONNECTION =
    Workspace.DescendantAdded:Connect(function(obj)
        if obj:IsA("Animator") then
            task.defer(function()
                stopAnimation(obj)
            end)
        end
    end)

-- Pantau animasi yang dimainkan kembali
_G.PINN_BRAINROT_CONNECTION =
    game:GetService("RunService").Heartbeat:Connect(function()
        if _G.PINN_BRAINROT_STOP then return end

        for _, obj in ipairs(Workspace:GetDescendants()) do
            if _G.PINN_BRAINROT_STOP then return end
            if obj:IsA("Animator") then
                stopAnimation(obj)
            end
        end
    end)

print("[PINN] Brainrot animation stopper aktif!")
print("[PINN] Untuk menghentikan: _G.PINN_BRAINROT_STOP = true")
