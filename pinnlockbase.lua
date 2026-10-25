-- PINN LOCK BASE V3
-- AUTO FLY GEAR + AUTO BAT DELAY 0.2s
-- DIRECT EXECUTE | Delta Android

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- CLEANUP GUI
for _, parent in ipairs({CoreGui, playerGui}) do
    local old = parent:FindFirstChild("PinnTP")
    if old then old:Destroy() end
end

local selectedMode = "LEFT"
local running = false
local TP_DELAY = 0.08
local BAT_DELAY = 0.2

local coordinates = {
    LEFT = {
        Vector3.new(-392.469299, -7.293217, 53.844055),
        Vector3.new(-356.079071, -7.293217, 6.699300),
        Vector3.new(-300.029022, -5.328496, 6.594552)
    },
    RIGHT = {
        Vector3.new(-392.920135, -7.293216, 48.917263),
        Vector3.new(-348.128754, -6.894292, 113.982872),
        Vector3.new(-301.404175, -5.394292, 114.163086)
    }
}

local flyGearNames = {
    "waverider",
    "witchbroom",
    "cupid wings",
    "santa sleigh",
    "flyng bee"
}

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "PinnTP"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local ok = pcall(function()
    gui.Parent = CoreGui
end)

if not ok or not gui.Parent then
    gui.Parent = playerGui
end

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 155, 0, 102)
main.Position = UDim2.new(0.5, -77, 0.5, -51)
main.BackgroundTransparency = 1
main.BorderSizePixel = 0
main.Active = true
main.Selectable = true
main.Parent = gui

-- TITLE / DRAG HANDLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 20)
title.BackgroundTransparency = 1
title.Text = "PINN LOCK BASE"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 12
title.Font = Enum.Font.GothamBold
title.Active = true
title.Selectable = true
title.Parent = main

-- DRAG GUI
local dragging = false
local dragStart, startPos

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement
    ) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- BUTTON HELPER
local function makeButton(text, size, position, parent)
    local button = Instance.new("TextButton")
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    button.BackgroundTransparency = 0.2
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 10
    button.Font = Enum.Font.GothamBold
    button.BorderSizePixel = 0
    button.Active = true
    button.Selectable = true
    button.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = button

    return button
end

-- MODE BUTTONS
local modeFrame = Instance.new("Frame")
modeFrame.Size = UDim2.new(1, 0, 0, 20)
modeFrame.Position = UDim2.new(0, 0, 0, 23)
modeFrame.BackgroundTransparency = 1
modeFrame.Active = true
modeFrame.Parent = main

local leftButton = makeButton(
    "LEFT", UDim2.new(0.5, -4, 1, 0),
    UDim2.new(0, 0, 0, 0), modeFrame
)

local rightButton = makeButton(
    "RIGHT", UDim2.new(0.5, -4, 1, 0),
    UDim2.new(0.5, 4, 0, 0), modeFrame
)

local function updateMode()
    leftButton.BackgroundColor3 = selectedMode == "LEFT"
        and Color3.fromRGB(30, 170, 80)
        or Color3.fromRGB(45, 45, 45)

    rightButton.BackgroundColor3 = selectedMode == "RIGHT"
        and Color3.fromRGB(30, 170, 80)
        or Color3.fromRGB(45, 45, 45)
end

leftButton.Activated:Connect(function()
    if not running then
        selectedMode = "LEFT"
        updateMode()
    end
end)

rightButton.Activated:Connect(function()
    if not running then
        selectedMode = "RIGHT"
        updateMode()
    end
end)

-- TP BUTTON
local tpButton = makeButton(
    "TP", UDim2.new(1, -36, 0, 21),
    UDim2.new(0, 18, 0, 47), main
)
tpButton.BackgroundColor3 = Color3.fromRGB(35, 125, 220)
tpButton.TextSize = 11

-- PROGRESS BAR
local barBG = Instance.new("Frame")
barBG.Size = UDim2.new(1, -20, 0, 5)
barBG.Position = UDim2.new(0, 10, 0, 73)
barBG.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
barBG.BorderSizePixel = 0
barBG.Active = true
barBG.Parent = main
Instance.new("UICorner", barBG).CornerRadius = UDim.new(1, 0)

local bar = Instance.new("Frame")
bar.Size = UDim2.new(0, 0, 1, 0)
bar.BackgroundColor3 = Color3.fromRGB(30, 220, 100)
bar.BorderSizePixel = 0
bar.Parent = barBG
Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 16)
status.Position = UDim2.new(0, 0, 0, 82)
status.BackgroundTransparency = 1
status.Text = "READY | LEFT"
status.TextColor3 = Color3.new(1, 1, 1)
status.TextSize = 10
status.Font = Enum.Font.Gotham
status.Active = true
status.Parent = main

-- FIND AND EQUIP TOOL
local function findTool(names)
    local character = player.Character
    local backpack = player:FindFirstChildOfClass("Backpack")

    for _, name in ipairs(names) do
        local wanted = string.lower(name)

        for _, container in ipairs({character, backpack}) do
            if container then
                for _, item in ipairs(container:GetChildren()) do
                    if item:IsA("Tool")
                        and string.lower(item.Name) == wanted then
                        return item
                    end
                end
            end
        end
    end

    return nil
end

local function equipTool(names)
    local character = player.Character
    local humanoid = character
        and character:FindFirstChildOfClass("Humanoid")

    if not humanoid then return false end

    local tool = findTool(names)
    if not tool then return false end

    local success = pcall(function()
        humanoid:EquipTool(tool)
    end)

    return success and tool.Parent == character
end

-- TELEPORT
tpButton.Activated:Connect(function()
    if running then return end
    running = true

    local mode = selectedMode
    local points = coordinates[mode]

    task.spawn(function()
        local success, err = pcall(function()
            local character = player.Character
                or player.CharacterAdded:Wait()
            local humanoid = character:WaitForChild("Humanoid", 5)
            local root = character:WaitForChild("HumanoidRootPart", 5)

            if not humanoid or not root then
                error("Character belum siap")
            end

            -- EQUIP FLY GEAR SEBELUM TP
            status.Text = "EQUIPPING FLY GEAR..."
            local flyEquipped = equipTool(flyGearNames)

            status.Text = flyEquipped
                and "FLY GEAR EQUIPPED"
                or "FLY GEAR NOT FOUND"

            task.wait(0.15)

            -- TELEPORT KE SEMUA TITIK
            for i, pos in ipairs(points) do
                character = player.Character
                root = character
                    and character:FindFirstChild("HumanoidRootPart")

                if not root then
                    error("Character tidak ditemukan")
                end

                root.CFrame = CFrame.new(pos)
                status.Text = mode .. " | " .. i .. "/" .. #points

                bar:TweenSize(
                    UDim2.new(i / #points, 0, 1, 0),
                    Enum.EasingDirection.Out,
                    Enum.EasingStyle.Linear,
                    TP_DELAY
                )

                task.wait(TP_DELAY)
            end

            -- DELAY 0.2s SETELAH TP DONE
            status.Text = "TP DONE | WAITING..."
            task.wait(BAT_DELAY)

            -- AUTO EQUIP BAT
            status.Text = "EQUIPPING BAT..."
            local batEquipped = false

            for attempt = 1, 10 do
                if equipTool({"Bat"}) then
                    batEquipped = true
                    break
                end
                task.wait(0.2)
            end

            status.Text = batEquipped
                and "DONE | BAT EQUIPPED"
                or "DONE | BAT NOT FOUND"

            task.wait(1)
        end)

        if not success then
            warn("[PINN LOCK BASE] " .. tostring(err))
            status.Text = "TP ERROR"
        end

        bar.Size = UDim2.new(0, 0, 1, 0)
        running = false
        updateMode()
    end)
end)

updateMode()
print("PINN LOCK BASE V3 READY")