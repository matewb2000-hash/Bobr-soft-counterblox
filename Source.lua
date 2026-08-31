local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Subtitle = Instance.new("TextLabel")
local ESPToggle = Instance.new("TextButton")
local AimToggle = Instance.new("TextButton")
local BHopToggle = Instance.new("TextButton")
local CloseBtn = Instance.new("TextButton")

ScreenGui.Name = "BobrSoft"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

MainFrame.Size = UDim2.new(0, 220, 0, 200)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 28)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
local TC = Instance.new("UICorner")
TC.CornerRadius = UDim.new(0, 8)
TC.Parent = TopBar

Title.Text = "🦫 BOBR SOFT"
Title.Size = UDim2.new(1, -30, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(120, 100, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 26, 0, 22)
CloseBtn.Position = UDim2.new(1, -28, 0, 3)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TopBar
local CC = Instance.new("UICorner")
CC.CornerRadius = UDim.new(0, 5)
CC.Parent = CloseBtn

Subtitle.Text = "Counterblox Cheat"
Subtitle.Size = UDim2.new(1, 0, 0, 20)
Subtitle.Position = UDim2.new(0, 0, 0, 32)
Subtitle.BackgroundTransparency = 1
Subtitle.TextColor3 = Color3.fromRGB(150, 150, 180)
Subtitle.TextSize = 11
Subtitle.Font = Enum.Font.Gotham
Subtitle.Parent = MainFrame

local function makeBtn(btn, text, y)
    btn.Text = text
    btn.Size = UDim2.new(0, 180, 0, 32)
    btn.Position = UDim2.new(0.5, -90, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = MainFrame
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn
end

makeBtn(ESPToggle, "ESP : OFF", 58)
makeBtn(AimToggle, "AIMBOT : OFF", 98)
makeBtn(BHopToggle, "BHOP : OFF", 138)

-- ESP
local ESPEnabled = false
local espHighlights = {}

local function isEnemy(player)
    local lt = LocalPlayer.Team
    if not lt then return true end
    return player.Team ~= lt
end

local function isAlive(player)
    local char = player.Character
    if not char then return false end
    local root = char:FindFirstChild("HumanoidRootPart")
    -- CB не юзает Humanoid, проверяем через CameraPart или просто наличие root
    return root ~= nil
end

local function removeESP(player)
    if espHighlights[player] then
        espHighlights[player]:Destroy()
        espHighlights[player] = nil
    end
end

local function applyESP(player)
    if player == LocalPlayer then return end
    if not isEnemy(player) then return end

    local function onChar(char)
        task.wait(0.5)
        removeESP(player)

        -- удаляем дефолтный highlight CB чтобы не конфликтил
        local existing = char:FindFirstChildOfClass("Highlight")
        if existing then existing:Destroy() end

        local hl = Instance.new("Highlight")
        hl.Name = "BobrESP"
        hl.Adornee = char
        hl.FillColor = Color3.fromRGB(255, 50, 50)
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.4
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = game.CoreGui
        espHighlights[player] = hl
    end

    if player.Character then onChar(player.Character) end
    player.CharacterAdded:Connect(onChar)
end

local function enableESP()
    for _,p in pairs(Players:GetPlayers()) do
        applyESP(p)
    end
    Players.PlayerAdded:Connect(applyESP)
end

local function disableESP()
    for p,hl in pairs(espHighlights) do
        hl:Destroy()
        espHighlights[p] = nil
    end
end

-- AIMBOT
local AimEnabled = false
local FOV = 150

local function getTarget()
    local closest = nil
    local minDist = FOV
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    for _,p in pairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        if not isEnemy(p) then continue end
        local char = p.Character
        if not char then continue end
        local head = char:FindFirstChild("Head")
        if not head then continue end

        local sp, onScreen = Camera:WorldToViewportPoint(head.Position)
        if not onScreen then continue end

        local dist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
        if dist < minDist then
            minDist = dist
            closest = head
        end
    end
    return closest
end

RunService.Heartbeat:Connect(function()
    if AimEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local t = getTarget()
        if t then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Position)
        end
    end
end)

-- BHOP
local BHopEnabled = false

UserInputService.JumpRequest:Connect(function()
    if not BHopEnabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- кнопки
local espOn, aimOn, bhopOn = false, false, false

ESPToggle.MouseButton1Click:Connect(function()
    espOn = not espOn
    ESPEnabled = espOn
    if espOn then
        ESPToggle.Text = "ESP : ON"
        ESPToggle.BackgroundColor3 = Color3.fromRGB(80, 50, 180)
        enableESP()
    else
        ESPToggle.Text = "ESP : OFF"
        ESPToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
        disableESP()
    end
end)

AimToggle.MouseButton1Click:Connect(function()
    aimOn = not aimOn
    AimEnabled = aimOn
    if aimOn then
        AimToggle.Text = "AIMBOT : ON"
        AimToggle.BackgroundColor3 = Color3.fromRGB(80, 50, 180)
    else
        AimToggle.Text = "AIMBOT : OFF"
        AimToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
    end
end)

BHopToggle.MouseButton1Click:Connect(function()
    bhopOn = not bhopOn
    BHopEnabled = bhopOn
    if bhopOn then
        BHopToggle.Text = "BHOP : ON"
        BHopToggle.BackgroundColor3 = Color3.fromRGB(80, 50, 180)
    else
        BHopToggle.Text = "BHOP : OFF"
        BHopToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    disableESP()
    AimEnabled = false
    BHopEnabled = false
    ScreenGui:Destroy()
end)
