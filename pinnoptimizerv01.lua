
-- PINN OPTIMIZER: CARPET ANIMATION + REMOVE AURA
-- OPTIMIZED VERSION

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Bersihkan koneksi versi sebelumnya
_G.PINN_V11_STOP = false

for _, key in ipairs({
    "PINN_AURA_CONNECTION",
    "PINN_CARPET_ANIMATION_CONNECTION"
}) do
    local connection = _G[key]
    if connection then
        pcall(function()
            connection:Disconnect()
        end)
        _G[key] = nil
    end
end

local registered = setmetatable({}, {__mode = "k"})

local function isCarpetBrainrot(obj)
    local current = obj

    while current and current ~= Workspace do
        local name = current.Name:lower()

        if name:find("carpet", 1, true)
            or name:find("runway", 1, true)
            or name:find("conveyor", 1, true) then
            return true
        end

        current = current.Parent
    end

    return false
end

local function removeAuraEffects(obj)
    if _G.PINN_V11_STOP then return end

    if obj:IsA("ParticleEmitter")
        or obj:IsA("Trail")
        or obj:IsA("Beam")
        or obj:IsA("PointLight")
        or obj:IsA("SpotLight")
        or obj:IsA("SurfaceLight")
        or obj:IsA("Highlight") then

        pcall(function()
            obj.Enabled = false
        end)
    end
end

local function getBrainrot(animator)
    local parent = animator.Parent
    local model = parent and parent.Parent

    if not model or not model:IsA("Model") then
        return nil
    end

    if model == LocalPlayer.Character then
        return nil
    end

    if isCarpetBrainrot(model) then
        return model
    end

    return nil
end

local function stopAnimations(animator)
    if _G.PINN_V11_STOP then return end
    if not getBrainrot(animator) then return end

    pcall(function()
        for _, track in ipairs(
            animator:GetPlayingAnimationTracks()
        ) do
            track:Stop(0)
        end
    end)
end

local function registerAnimator(obj)
    if not obj:IsA("Animator") or registered[obj] then
        return
    end

    if not getBrainrot(obj) then return end

    registered[obj] = true

    -- Hentikan animasi yang sudah berjalan
    stopAnimations(obj)

    -- Tangani animasi baru tanpa scan setiap frame
    obj.AnimationPlayed:Connect(function(track)
        if _G.PINN_V11_STOP then return end

        pcall(function()
            track:Stop(0)
        end)
    end)
end

local function processObject(obj)
    if _G.PINN_V11_STOP then return end

    removeAuraEffects(obj)

    if obj:IsA("Animator") then
        registerAnimator(obj)
    end
end

-- Scan awal: hanya sekali
for _, obj in ipairs(Workspace:GetDescendants()) do
    processObject(obj)
end

-- Deteksi objek dan efek baru
_G.PINN_AURA_CONNECTION =
    Workspace.DescendantAdded:Connect(function(obj)
        task.defer(function()
            if obj.Parent then
                processObject(obj)
            end
        end)
    end)

-- Periksa jika Animator baru ditambahkan
_G.PINN_CARPET_ANIMATION_CONNECTION =
    Workspace.DescendantAdded:Connect(function(obj)
        if obj:IsA("Animator") then
            task.defer(function()
                if obj.Parent then
                    registerAnimator(obj)
                end
            end)
        end
    end)

print("PINN OPTIMIZER: ACTIVE")
