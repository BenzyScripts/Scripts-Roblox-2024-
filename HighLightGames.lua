local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ScreenGui = Instance.new("ScreenGui")
local RemoveButton = Instance.new("TextButton")

local function addHighlight(player)
    if not player.Character then return end
    
    local existingHighlight = player.Character:FindFirstChildOfClass("Highlight")
    if not existingHighlight then
        local highlight = Instance.new("Highlight")
        highlight.Adornee = player.Character
        highlight.FillColor = Color3.new(1, 0, 0)
        highlight.FillTransparency = 0.5 
        highlight.Parent = player.Character
    end
end

local function removeAllHighlights()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local highlight = player.Character:FindFirstChildOfClass("Highlight")
            if highlight then
                highlight:Destroy()
            end
        end
    end
end

for _, player in pairs(Players:GetPlayers()) do
    addHighlight(player)
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Wait()
    addHighlight(player)
end)

ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "HighlightGui"

RemoveButton.Size = UDim2.new(0, 150, 0, 50)
RemoveButton.Position = UDim2.new(0, 10, 0.5, -25)
RemoveButton.Text = "Remover Highlights"
RemoveButton.Parent = ScreenGui
RemoveButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
RemoveButton.TextColor3 = Color3.new(1, 1, 1)

local function onButtonHover()
    RemoveButton.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
end

local function onButtonLeave()
    RemoveButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
end

RemoveButton.MouseButton1Click:Connect(function()
    removeAllHighlights()
    ScreenGui:Destroy()
end)

RemoveButton.MouseEnter:Connect(onButtonHover)
RemoveButton.MouseLeave:Connect(onButtonLeave)

RemoveButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        removeAllHighlights()
        ScreenGui:Destroy()
    end
end)
