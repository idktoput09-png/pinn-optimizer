
-- BRAINROT CARPET ANIMATION + REMOVE AURA
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
    if _G.PINN_V11_STOP or not obj then return end

    pcall(function()
        if obj:IsA("ParticleEmitter")
            or obj:IsA("Trail")
            or obj:IsA("Beam")
            or obj:IsA("PointLight")
            or obj:IsA("SpotLight")
            or obj:IsA("SurfaceLight") then

            obj.Enabled = false

        elseif obj:IsA("Highlight") then
            obj.Enabled = false
        end
    end)
end

local function stopCarpetBrainrotAnimation(obj)
    if _G.PINN_V11_STOP or not obj:IsA("Animator") then
        return
    end

    local humanoid = obj.Parent
    local character = humanoid and humanoid.Parent

    if not character or character == LocalPlayer.Character then
        return
    end

    if not isCarpetBrainrot(character) then
        return
    end

    pcall(function()
        for _, track in ipairs(obj:GetPlayingAnimationTracks()) do
            track:Stop(0)
        end
    end)
end

-- Scan efek aura yang sudah ada
for _, obj in ipairs(Workspace:GetDescendants()) do
    removeAuraEffects(obj)
    stopCarpetBrainrotAnimation(obj)
end

-- Matikan efek aura yang muncul kemudian
_G.PINN_AURA_CONNECTION =
    Workspace.DescendantAdded:Connect(function(obj)
        task.defer(function()
            if _G.PINN_V11_STOP or not obj.Parent then
                return
            end

            removeAuraEffects(obj)
            stopCarpetBrainrotAnimation(obj)
        end)
    end)

-- Pantau animasi brainrot di karpet
_G.PINN_CARPET_ANIMATION_CONNECTION =
    Workspace.DescendantAdded:Connect(function(obj)
        if obj:IsA("Animator") then
            task.defer(function()
                stopCarpetBrainrotAnimation(obj)
            end)
        end
    end)
