local MaxSpeed = 300
local LocalPlayer = game:GetService("Players").LocalPlayer
local Locations = workspace._WorldOrigin.Locations
local collecting = false 
local FirstRun = true
local UncheckedChests = {}

local function getCharacter()
    if not LocalPlayer.Character then
        LocalPlayer.CharacterAdded:Wait()
    end
    LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    return LocalPlayer.Character
end

local function DistanceFromPlrSort(ObjectList: table)
    local RootPart = getCharacter().LowerTorso
    table.sort(ObjectList, function(ChestA, ChestB)
        local RootPos = RootPart.Position
        local DistanceA = (RootPos - ChestA.Position).Magnitude
        local DistanceB = (RootPos - ChestB.Position).Magnitude
        return DistanceA < DistanceB
    end)
end

local function getChestsSorted()
    if FirstRun then
        FirstRun = false
        local Objects = game:GetDescendants()
        for i, Object in pairs(Objects) do
            if Object.Name:find("Chest") and Object.ClassName == "Part" then
                table.insert(UncheckedChests, Object)
            end
        end
    end
    local Chests = {}
    for i, Chest in pairs(UncheckedChests) do
        if Chest:FindFirstChild("TouchInterest") then
            table.insert(Chests, Chest)
        end
    end
    DistanceFromPlrSort(Chests)
    return Chests
end

local function toggleNoclip(Toggle: boolean)
    for i,v in pairs(getCharacter():GetChildren()) do
        if v.ClassName == "Part" then
            v.CanCollide = not Toggle
        end
    end
end

local function Teleport(Goal: CFrame, Speed)
    if not Speed then
        Speed = MaxSpeed
    end
    toggleNoclip(true)
    local RootPart = getCharacter().HumanoidRootPart
    local Magnitude = (RootPart.Position - Goal.Position).Magnitude

    RootPart.CFrame = RootPart.CFrame
    
    while not (Magnitude < 1) do
        local Direction = (Goal.Position - RootPart.Position).unit
        RootPart.CFrame = RootPart.CFrame + Direction * (Speed * wait())
        Magnitude = (RootPart.Position - Goal.Position).Magnitude
    end
    toggleNoclip(false)
end

local function startCollecting()
    collecting = true
    while collecting do
        local Chests = getChestsSorted()
        if #Chests > 0 then
            Teleport(Chests[1].CFrame)
        else
            -- Vai fazer nada
        end
        wait(1) 
    end
end

local function stopCollecting()
    collecting = false
end

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game:GetService("Players").LocalPlayer.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Parent = screenGui

local collectButton = Instance.new("TextButton")
collectButton.Size = UDim2.new(0, 180, 0, 30)
collectButton.Position = UDim2.new(0, 10, 0, 30)
collectButton.Text = "Start Collecting"
collectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
collectButton.BackgroundColor3 = Color3.fromRGB(255, 69, 0)
collectButton.Parent = frame

local function toggleCollecting()
    if collecting then
        collectButton.BackgroundColor3 = Color3.fromRGB(255, 69, 0)
        collectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        stopCollecting()
    else
        collectButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        collectButton.TextColor3 = Color3.fromRGB(0, 0, 0)
        startCollecting()
    end
end



local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 20)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.Text = "By BenzyScripts"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundTransparency = 1
titleLabel.TextSize = 14
titleLabel.Parent = frame


collectButton.MouseButton1Click:Connect(toggleCollecting)

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 20, 0, 20)
toggleButton.Position = UDim2.new(1, -20, 0, 0)
toggleButton.Text = "-"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 69, 0)
toggleButton.Parent = frame

toggleButton.MouseButton1Click:Connect(function()
    if frame.Size == UDim2.new(0, 200, 0, 100) then
        frame.Size = UDim2.new(0, 200, 0, 30)
        toggleButton.Text = "+"
        collectButton.Visible = false
    else
        frame.Size = UDim2.new(0, 200, 0, 100)
        toggleButton.Text = "-"
        collectButton.Visible = true
    end
end)

local dragging = false
local dragInput, dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
