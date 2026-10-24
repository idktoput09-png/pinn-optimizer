-- PINN ULTRA OPTIMIZER V11
-- DIRECT EXECUTE | Delta Android
-- Mage Animation + Optimizer + Hide Empty Base V2

-- STOP VERSI LAMA
_G.PINN_V5_STOP = true
_G.PINN_V6_STOP = true
_G.PINN_V7_STOP = true
_G.PINN_V8_STOP = true
_G.PINN_V9_STOP = true
_G.PINN_V10_STOP = true
_G.PINN_V11_STOP = true

local function disconnect(key)
    local c = _G[key]
    if c then pcall(function() c:Disconnect() end) end
    _G[key] = nil
end

for _, key in ipairs({
    "PINN_V5_CONNECTION", "PINN_V6_CONNECTION",
    "PINN_V7_CONNECTION", "PINN_V8_CONNECTION",
    "PINN_V9_CONNECTION", "PINN_V10_CONNECTION",
    "PINN_V10_PLOT_CONNECTION", "PINN_V10_PLOT_DESC_CONNECTION",
    "PINN_V11_CONNECTION", "PINN_V11_PLOT_CONNECTION",
    "PINN_V11_PLOT_DESC_CONNECTION", "PINN_V11_CHARACTER_CONNECTION"
}) do
    disconnect(key)
end

task.wait(0.2)
_G.PINN_V11_STOP = false

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Terrain = Workspace:FindFirstChildOfClass("Terrain")

-- MAGE ANIMATION: AVATAR SENDIRI
local function applyMageAnimation(character)
    if _G.PINN_V11_STOP or not character then return end

    local animate = character:WaitForChild("Animate", 10)
    local humanoid = character:WaitForChild("Humanoid", 10)
    if not animate or not humanoid then return end

    local function replace(folderName, animName, id)
        local folder = animate:FindFirstChild(folderName)
        local anim = folder and folder:FindFirstChild(animName)
        if anim and anim:IsA("Animation") then
            anim.AnimationId = "rbxassetid://" .. id
        end
    end

    animate.Disabled = false
    replace("walk", "WalkAnim", "707897309")
    replace("run", "RunAnim", "707861613")

    task.wait(0.5)
    if _G.PINN_V11_STOP or not character.Parent then return end

    animate.Disabled = true
    task.wait(0.2)
    if not _G.PINN_V11_STOP and animate.Parent then
        animate.Disabled = false
    end

    print("[PINN V11] Mage animation dipasang.")
end

if LocalPlayer.Character then
    task.spawn(applyMageAnimation, LocalPlayer.Character)
end

_G.PINN_V11_CHARACTER_CONNECTION =
    LocalPlayer.CharacterAdded:Connect(function(character)
        task.wait(1)
        applyMageAnimation(character)
    end)

-- LABEL
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
pcall(function()
    local old = playerGui:FindFirstChild("PINNOptimizerLabel")
    if old then old:Destroy() end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "PINNOptimizerLabel"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local label = Instance.new("TextLabel")
label.Name = "Title"
label.BackgroundTransparency = 1
label.BorderSizePixel = 0
label.AnchorPoint = Vector2.new(1, 0)
label.Position = UDim2.new(1, -12, 0, 8)
label.Size = UDim2.new(0, 130, 0, 20)
label.Font = Enum.Font.GothamMedium
label.Text = "PINNOPTIMIZER"
label.TextSize = 11
label.TextColor3 = Color3.fromRGB(235, 235, 235)
label.TextXAlignment = Enum.TextXAlignment.Right
label.Parent = gui

local line = Instance.new("Frame")
line.Name = "Underline"
line.BorderSizePixel = 0
line.AnchorPoint = Vector2.new(1, 0)
line.Position = UDim2.new(1, -12, 0, 29)
line.Size = UDim2.new(0, 82, 0, 1)
line.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
line.Parent = gui

-- CEK KARAKTER PEMAIN
local function isPlayerPart(obj)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and obj:IsDescendantOf(player.Character) then
            return true
        end
    end
    return false
end

-- VISUAL EVENT
local function isEventVisual(obj)
    local current = obj
    while current and current ~= Workspace do
        local n = current.Name:lower()
        if n:find("eclipse") or n:find("sky event")
            or n:find("cloudevent") or n:find("cloud event")
            or n:find("eventcloud") or n:find("event cloud")
            or n:find("celestial event") then
            return true
        end
        current = current.Parent
    end
    return false
end

local function hidePart(obj)
    if obj:IsA("BasePart") and not isPlayerPart(obj) then
        obj.LocalTransparencyModifier = 1
        obj.CastShadow = false
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        obj.Transparency = 1
    elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail")
        or obj:IsA("Beam") or obj:IsA("PointLight")
        or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
        obj.Enabled = false
    end
end

-- OPTIMIZER VISUAL
local function optimize(obj)
    if _G.PINN_V11_STOP or isPlayerPart(obj) then return end

    local n = obj.Name:lower()

    if isEventVisual(obj) then
        hidePart(obj)
    end

    if n:find("carpet") or n:find("runway")
        or n:find("conveyor") then
        if obj:IsA("BasePart") then
            hidePart(obj)
        elseif obj:IsA("Model") or obj:IsA("Folder") then
            for _, part in ipairs(obj:GetDescendants()) do
                hidePart(part)
            end
        end
    end

    if obj:IsA("BasePart") then
        pcall(function()
            obj.Material = Enum.Material.SmoothPlastic
            obj.CastShadow = false
            obj.TopSurface = Enum.SurfaceType.Smooth
            obj.BottomSurface = Enum.SurfaceType.Smooth
            obj.Reflectance = 0
        end)
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        pcall(function() obj.Transparency = 1 end)
    elseif obj:IsA("SurfaceAppearance") then
        pcall(function() obj:Destroy() end)
    elseif obj:IsA("PostEffect") then
        pcall(function() obj.Enabled = false end)
    elseif obj:IsA("Atmosphere") then
        pcall(function() obj.Parent = nil end)
    elseif obj:IsA("Clouds") then
        pcall(function() obj.Enabled = false end)
    end
end

-- HIDE EMPTY BASE V2
local plots = Workspace:WaitForChild("Plots", 15)
local hiddenBaseParts = setmetatable({}, {__mode = "k"})

local function hasBrainrotAttachment(plot)
    for _, obj in ipairs(plot:GetDescendants()) do
        if obj.Name:lower():find("brainrotrootpartattachment") then
            return true
        end
    end
    return false
end

local function restorePlot(plot)
    for obj, value in pairs(hiddenBaseParts) do
        if obj and obj.Parent and obj:IsDescendantOf(plot) then
            pcall(function()
                if obj:IsA("BasePart") then
                    obj.LocalTransparencyModifier = value
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    obj.Transparency = value
                end
            end)
            hiddenBaseParts[obj] = nil
        end
    end
end

local function hideEmptyPlot(plot)
    if _G.PINN_V11_STOP or not plot:IsA("Model") then return end
    if plot:GetAttribute("Loaded") ~= true then return end

    if hasBrainrotAttachment(plot) then
        restorePlot(plot)
        return
    end

    for _, obj in ipairs(plot:GetDescendants()) do
        if obj:IsA("BasePart") then
            if hiddenBaseParts[obj] == nil then
                hiddenBaseParts[obj] = obj.LocalTransparencyModifier
            end
            obj.LocalTransparencyModifier = 1
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            if hiddenBaseParts[obj] == nil then
                hiddenBaseParts[obj] = obj.Transparency
            end
            obj.Transparency = 1
        end
    end
end

local function scanPlots()
    if not plots then return end
    for _, plot in ipairs(plots:GetChildren()) do
        if _G.PINN_V11_STOP then return end
        pcall(hideEmptyPlot, plot)
        task.wait()
    end
end

if plots then
    task.spawn(scanPlots)

    _G.PINN_V11_PLOT_CONNECTION = plots.ChildAdded:Connect(function(plot)
        task.spawn(function()
            for _ = 1, 30 do
                if _G.PINN_V11_STOP then return end
                if plot:GetAttribute("Loaded") == true then break end
                task.wait(0.5)
            end
            if not _G.PINN_V11_STOP then
                pcall(hideEmptyPlot, plot)
            end
        end)
    end)

    _G.PINN_V11_PLOT_DESC_CONNECTION =
        plots.DescendantAdded:Connect(function(obj)
            local plot = obj:FindFirstAncestorOfClass("Model")
            if not plot or plot.Parent ~= plots then return end

            task.delay(1, function()
                if not _G.PINN_V11_STOP and plot.Parent == plots then
                    pcall(hideEmptyPlot, plot)
                end
            end)
        end)

    task.spawn(function()
        while not _G.PINN_V11_STOP do
            task.wait(8)
            if not _G.PINN_V11_STOP then scanPlots() end
        end
    end)
end

-- SCAN MAP AWAL
task.spawn(function()
    for i, obj in ipairs(Workspace:GetDescendants()) do
        if _G.PINN_V11_STOP then return end
        pcall(optimize, obj)
        if i % 200 == 0 then task.wait() end
    end
end)

-- PANTAU OBJEK BARU
_G.PINN_V11_CONNECTION = Workspace.DescendantAdded:Connect(function(obj)
    task.defer(function()
        if _G.PINN_V11_STOP or not obj.Parent then return end
        pcall(optimize, obj)
    end)
end)

-- HENTIKAN ANIMASI KARAKTER LAIN, KECUALI AVATAR SENDIRI
local function stopOtherAnimations(animator)
    if _G.PINN_V11_STOP or not animator:IsA("Animator") then return end

    local humanoid = animator.Parent
    local character = humanoid and humanoid.Parent
    if not character or character == LocalPlayer.Character then return end

    pcall(function()
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            track:Stop(0)
        end
    end)
end

task.spawn(function()
    while not _G.PINN_V11_STOP do
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if _G.PINN_V11_STOP then return end
            if obj:IsA("Animator") then
                stopOtherAnimations(obj)
            end
        end
        task.wait(1.5)
    end
end)

-- PENCAHAYAAN
pcall(function()
    Lighting.GlobalShadows = false
    Lighting.Brightness = 1
    Lighting.FogEnd = 1000000
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0
    Lighting.Ambient = Color3.fromRGB(180, 180, 180)
    Lighting.OutdoorAmbient = Color3.fromRGB(180, 180, 180)

    for _, obj in ipairs(Lighting:GetDescendants()) do
        if obj:IsA("PostEffect") then
            obj.Enabled = false
        elseif obj:IsA("Atmosphere") then
            obj.Parent = nil
        end
    end

    if Terrain then Terrain.Decoration = false end
end)

print("[PINN V11] Optimizer aktif!")
print("[PINN V11] Mage animation avatar sendiri aktif!")
print("[PINN V11] Hide Empty Base V2 aktif!")
print("[PINN V11] Stop: _G.PINN_V11_STOP = true")