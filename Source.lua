-- Bobr Soft | ESP Highlight
-- Compatible with most Roblox executors

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Subtitle = Instance.new("TextLabel")
local ESPToggle = Instance.new("TextButton")
local CloseBtn = Instance.new("TextButton")
local DragBar = Instance.new("Frame")

ScreenGui.Name = "BobrSoft"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game.CoreGui

MainFrame.Size = UDim2.new(0, 220, 0, 130)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -65)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Скругление
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = MainFrame

-- Полоска сверху
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 28)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

Title.Text = "🦫 BOBR SOFT"
Title.Size = UDim2.new(1, -30, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(120, 100, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

CloseBtn.Text = "✕"
CloseBtn.Size = UDim2.new(0, 26, 0, 22)
CloseBtn.Position = UDim2.new(1, -28, 0, 3)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TopBar
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 5)
CloseCorner.Parent = CloseBtn

Subtitle.Text = "Counterblox ESP"
Subtitle.Size = UDim2.new(1, 0, 0, 20)
Subtitle.Position = UDim2.new(0, 0, 0, 32)
Subtitle.BackgroundTransparency = 1
Subtitle.TextColor3 = Color3.fromRGB(150, 150, 180)
Subtitle.TextSize = 11
Subtitle.Font = Enum.Font.Gotham
Subtitle.Parent = MainFrame

ESPToggle.Text = "ESP : OFF"
ESPToggle.Size = UDim2.new(0, 180, 0, 36)
ESPToggle.Position = UDim2.new(0.5, -90, 0, 75)
ESPToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
ESPToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPToggle.TextSize = 13
ESPToggle.Font = Enum.Font.GothamBold
ESPToggle.BorderSizePixel = 0
ESPToggle.Parent = MainFrame
local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ESPToggle

-- ESP Logic
local ESPEnabled = false
local highlights = {}

local function removeESP(player)
    if highlights[player] then
        highlights[player]:Destroy()
        highlights[player] = nil
    end
end

local function applyESP(player)
    if player == LocalPlayer then return end
    local function onChar(char)
        removeESP(player)
        local hl = Instance.new("SelectionBox")
        hl.Name = "BobrESP"
        hl.Adornee = char
        hl.Color3 = Color3.fromRGB(255, 50, 50)
        hl.LineThickness = 0.05
        hl.SurfaceTransparency = 0.7
        hl.SurfaceColor3 = Color3.fromRGB(255, 0, 0)
        hl.Parent = game.CoreGui
        highlights[player] = hl
    end
    if player.Character then onChar(player.Character) end
    player.CharacterAdded:Connect(onChar)
end

local function enableESP()
    for _, p in pairs(Players:GetPlayers()) do
        applyESP(p)
    end
    Players.PlayerAdded:Connect(applyESP)
end

local function disableESP()
    for player, hl in pairs(highlights) do
        hl:Destroy()
        highlights[player] = nil
    end
end

-- Кнопки
ESPToggle.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    if ESPEnabled then
        ESPToggle.Text = "ESP : ON"
        ESPToggle.BackgroundColor3 = Color3.fromRGB(80, 50, 180)
        enableESP()
    else
        ESPToggle.Text = "ESP : OFF"
        ESPToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
        disableESP()
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    disableESP()
    ScreenGui:Destroy()
end)
