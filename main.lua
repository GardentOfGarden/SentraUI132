-- Укради Брейн Рота - Продвинутый байпас античита
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local settings = {
    floatStrength = 35,
    speedMultiplier = 22,
    flySpeed = 42,
    noclipKey = Enum.KeyCode.N,
    speedKey = Enum.KeyCode.V,
    floatKey = Enum.KeyCode.F,
    flyKey = Enum.KeyCode.G,
    menuKey = Enum.KeyCode.Insert
}

local states = {
    floatEnabled = false,
    speedEnabled = false,
    noclipEnabled = false,
    flyEnabled = false,
    menuOpen = false
}

local originalProperties = {}
local connections = {}
local bypassMethods = {}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HaxMenu_" .. math.random(9999, 99999)
screenGui.Parent = CoreGui
screenGui.Enabled = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 350)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "Укради Брейн Рота v2.0"
title.Font = Enum.Font.SourceSansBold
title.Parent = mainFrame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Text = "X"
closeButton.Parent = mainFrame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -40)
scrollFrame.Position = UDim2.new(0, 5, 0, 35)
scrollFrame.BackgroundTransparency = 1
scrollFrame.Parent = mainFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Parent = scrollFrame

local function createFeatureButton(name, keybind, callback)
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(1, 0, 0, 40)
    buttonFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    buttonFrame.BorderSizePixel = 0
    buttonFrame.Parent = scrollFrame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.7, 0, 1, 0)
    button.Position = UDim2.new(0, 0, 0, 0)
    button.BackgroundTransparency = 1
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = name
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.Parent = buttonFrame

    local keybindText = Instance.new("TextLabel")
    keybindText.Size = UDim2.new(0.3, 0, 1, 0)
    keybindText.Position = UDim2.new(0.7, 0, 0, 0)
    keybindText.BackgroundTransparency = 1
    keybindText.TextColor3 = Color3.fromRGB(200, 200, 200)
    keybindText.Text = "[" .. keybind.Name .. "]"
    keybindText.TextXAlignment = Enum.TextXAlignment.Right
    keybindText.Parent = buttonFrame

    button.MouseButton1Click:Connect(callback)
end

createFeatureButton("Float", settings.floatKey, function()
    states.floatEnabled = not states.floatEnabled
    if states.floatEnabled then
        bypassMethods.enableFloat()
    else
        bypassMethods.disableFloat()
    end
end)

createFeatureButton("Speed", settings.speedKey, function()
    states.speedEnabled = not states.speedEnabled
    if states.speedEnabled then
        bypassMethods.enableSpeed()
    else
        bypassMethods.disableSpeed()
    end
end)

createFeatureButton("Noclip", settings.noclipKey, function()
    states.noclipEnabled = not states.noclipEnabled
    if states.noclipEnabled then
        bypassMethods.enableNoclip()
    else
        bypassMethods.disableNoclip()
    end
end)

createFeatureButton("Fly", settings.flyKey, function()
    states.flyEnabled = not states.flyEnabled
    if states.flyEnabled then
        bypassMethods.enableFly()
    else
        bypassMethods.disableFly()
    end
end)

bypassMethods.enableFloat = function()
    if connections.float then
        connections.float:Disconnect()
    end
    
    local floatPart = Instance.new("Part")
    floatPart.Size = Vector3.new(8, 0.3, 8)
    floatPart.Position = HumanoidRootPart.Position - Vector3.new(0, 3.5, 0)
    floatPart.Anchored = true
    floatPart.CanCollide = false
    floatPart.Transparency = 0.7
    floatPart.BrickColor = BrickColor.new("Cyan")
    floatPart.Material = Enum.Material.Neon
    floatPart.Name = "FloatPart_" .. math.random(1000,9999)
    floatPart.Parent = workspace
    
    connections.float = RunService.Heartbeat:Connect(function()
        if not HumanoidRootPart or not HumanoidRootPart.Parent then return end
        
        floatPart.Position = Vector3.new(
            HumanoidRootPart.Position.X,
            HumanoidRootPart.Position.Y - 3.5,
            HumanoidRootPart.Position.Z
        )
        
        if HumanoidRootPart.Velocity.Y < 0 then
            HumanoidRootPart.Velocity = Vector3.new(
                HumanoidRootPart.Velocity.X,
                settings.floatStrength,
                HumanoidRootPart.Velocity.Z
            )
        end
    end)
end

bypassMethods.disableFloat = function()
    if connections.float then
        connections.float:Disconnect()
        connections.float = nil
    end
    for _, obj in pairs(workspace:GetChildren()) do
        if obj.Name:find("FloatPart_") then
            obj:Destroy()
        end
    end
end

bypassMethods.enableSpeed = function()
    originalProperties.walkSpeed = Humanoid.WalkSpeed
    originalProperties.jumpPower = Humanoid.JumpPower
    
    Humanoid.WalkSpeed = originalProperties.walkSpeed * settings.speedMultiplier
    Humanoid.JumpPower = originalProperties.jumpPower * 1.5
    
    local speedPart = Instance.new("Part")
    speedPart.Size = Vector3.new(6, 0.2, 6)
    speedPart.Position = HumanoidRootPart.Position - Vector3.new(0, 4, 0)
    speedPart.Anchored = true
    speedPart.CanCollide = false
    speedPart.Transparency = 0.7
    speedPart.BrickColor = BrickColor.new("Bright orange")
    speedPart.Material = Enum.Material.Neon
    speedPart.Name = "SpeedPart_" .. math.random(1000,9999)
    speedPart.Parent = workspace
    
    if connections.speed then
        connections.speed:Disconnect()
    end
    
    connections.speed = RunService.Heartbeat:Connect(function()
        if speedPart and speedPart.Parent and HumanoidRootPart and HumanoidRootPart.Parent then
            speedPart.Position = Vector3.new(
                HumanoidRootPart.Position.X,
                HumanoidRootPart.Position.Y - 4,
                HumanoidRootPart.Position.Z
            )
        end
    end)
end

bypassMethods.disableSpeed = function()
    if originalProperties.walkSpeed then
        Humanoid.WalkSpeed = originalProperties.walkSpeed
    end
    if originalProperties.jumpPower then
        Humanoid.JumpPower = originalProperties.jumpPower
    end
    if connections.speed then
        connections.speed:Disconnect()
        connections.speed = nil
    end
    for _, obj in pairs(workspace:GetChildren()) do
        if obj.Name:find("SpeedPart_") then
            obj:Destroy()
        end
    end
end

bypassMethods.enableNoclip = function()
    if connections.noclip then
        connections.noclip:Disconnect()
    end
    
    originalProperties.collision = {}
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            originalProperties.collision[part] = part.CanCollide
            part.CanCollide = false
        end
    end
    
    connections.noclip = RunService.Stepped:Connect(function()
        if states.noclipEnabled and Character then
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

bypassMethods.disableNoclip = function()
    if connections.noclip then
        connections.noclip:Disconnect()
        connections.noclip = nil
    end
    if originalProperties.collision then
        for part, canCollide in pairs(originalProperties.collision) do
            if part and part.Parent then
                part.CanCollide = canCollide
            end
        end
    end
end

bypassMethods.enableFly = function()
    if connections.fly then
        connections.fly:Disconnect()
    end
    
    local flyBV = Instance.new("BodyVelocity")
    flyBV.Velocity = Vector3.new(0, 0, 0)
    flyBV.MaxForce = Vector3.new(10000, 10000, 10000)
    flyBV.Parent = HumanoidRootPart
    
    connections.fly = RunService.Heartbeat:Connect(function()
        if not states.flyEnabled or not flyBV then return end
        
        local camera = workspace.CurrentCamera
        local direction = Vector3.new()
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction = direction + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction = direction - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction = direction - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction = direction + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            direction = direction + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            direction = direction - Vector3.new(0, 1, 0)
        end
        
        if direction.Magnitude > 0 then
            direction = direction.Unit * settings.flySpeed
        end
        
        flyBV.Velocity = direction
    end)
end

bypassMethods.disableFly = function()
    if connections.fly then
        connections.fly:Disconnect()
        connections.fly = nil
    end
    for _, child in pairs(HumanoidRootPart:GetChildren()) do
        if child:IsA("BodyVelocity") then
            child:Destroy()
        end
    end
end

local function stealBrainRot()
    local brainRotModel = workspace:FindFirstChild("BrainRot")
    if not brainRotModel then
        brainRotModel = workspace:FindFirstChild("BrainRoot")
    end
    
    if brainRotModel then
        local humanoid = brainRotModel:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = 0
        end
        
        brainRotModel:SetPrimaryPartCFrame(HumanoidRootPart.CFrame + HumanoidRootPart.CFrame.LookVector * 5)
        
        for _, part in pairs(brainRotModel:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        
        if brainRotModel.PrimaryPart then
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = (HumanoidRootPart.Position - brainRotModel.PrimaryPart.Position).Unit * 25
            bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
            bodyVelocity.Parent = brainRotModel.PrimaryPart
            
            game:GetService("Debris"):AddItem(bodyVelocity, 1)
        end
    end
end

local stealButton = Instance.new("TextButton")
stealButton.Size = UDim2.new(0.9, 0, 0, 40)
stealButton.Position = UDim2.new(0.05, 0, 0, 310)
stealButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
stealButton.TextColor3 = Color3.fromRGB(255, 255, 255)
stealButton.Text = "УКРАСТЬ БРЕЙН РОТ"
stealButton.Font = Enum.Font.SourceSansBold
stealButton.Parent = mainFrame

stealButton.MouseButton1Click:Connect(stealBrainRot)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == settings.menuKey then
        states.menuOpen = not states.menuOpen
        screenGui.Enabled = states.menuOpen
    end
    
    if input.KeyCode == settings.floatKey then
        states.floatEnabled = not states.floatEnabled
        if states.floatEnabled then
            bypassMethods.enableFloat()
        else
            bypassMethods.disableFloat()
        end
    end
    
    if input.KeyCode == settings.speedKey then
        states.speedEnabled = not states.speedEnabled
        if states.speedEnabled then
            bypassMethods.enableSpeed()
        else
            bypassMethods.disableSpeed()
        end
    end
    
    if input.KeyCode == settings.noclipKey then
        states.noclipEnabled = not states.noclipEnabled
        if states.noclipEnabled then
            bypassMethods.enableNoclip()
        else
            bypassMethods.disableNoclip()
        end
    end
    
    if input.KeyCode == settings.flyKey then
        states.flyEnabled = not states.flyEnabled
        if states.flyEnabled then
            bypassMethods.enableFly()
        else
            bypassMethods.disableFly()
        end
    end
end)

closeButton.MouseButton1Click:Connect(function()
    states.menuOpen = false
    screenGui.Enabled = false
end)

Player.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = newCharacter:WaitForChild("Humanoid")
    HumanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
    
    task.wait(1)
    
    if states.floatEnabled then
        bypassMethods.enableFloat()
    end
    if states.speedEnabled then
        bypassMethods.enableSpeed()
    end
    if states.noclipEnabled then
        bypassMethods.enableNoclip()
    end
    if states.flyEnabled then
        bypassMethods.enableFly()
    end
end)

RunService.Heartbeat:Connect(function()
    if not Character or not Character.Parent then
        bypassMethods.disableFloat()
        bypassMethods.disableSpeed()
        bypassMethods.disableNoclip()
        bypassMethods.disableFly()
    end
end)

print("Укради Брейн Рота загружен!")
print("Горячие клавиши:")
print("Insert - Меню")
print("F - Float (пластина + подъем)")
print("V - Speed (ускорение + пластина)")
print("N - Noclip (сквозь стены)")
print("G - Fly (полет)")
