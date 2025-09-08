-- Lilcat Cheat Utility Panel (Fixed & Working)
-- Place in StarterPlayerScripts

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LogService = game:GetService("LogService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

-- Wait for character to load
local function waitForCharacter()
    if not player.Character then
        player.CharacterAdded:Wait()
    end
    return player.Character:WaitForChild("HumanoidRootPart")
end

-- GUI Setup
local oldgui = CoreGui:FindFirstChild("LilcatCheat")
if oldgui then
    oldgui:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "LilcatCheat"
gui.Parent = CoreGui
gui.ResetOnSpawn = false

-- Colors
local BG_COLOR = Color3.fromRGB(30, 30, 30)
local BTN_COLOR = Color3.fromRGB(50, 50, 50)
local ACCENT_COLOR = Color3.fromRGB(85, 170, 255)
local ERROR_COLOR = Color3.fromRGB(255, 80, 80)

-- Helper Functions
local function makeDraggable(frame)
    frame.Active = true
    frame.Draggable = true
end

local function createButton(name, parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = BTN_COLOR
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = name
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    return btn
end

local function createExitButton(parent, closeFrame)
    local exit = Instance.new("TextButton")
    exit.Size = UDim2.new(0, 30, 0, 30)
    exit.Position = UDim2.new(1, -35, 0, 5)
    exit.Text = "X"
    exit.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
    exit.TextColor3 = ERROR_COLOR
    exit.Font = Enum.Font.SourceSansBold
    exit.TextSize = 18
    exit.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = exit
    
    exit.MouseButton1Click:Connect(function()
        closeFrame.Visible = false
    end)
    
    return exit
end

-------------------------------------------------
-- Main Panel
-------------------------------------------------
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 320)
mainFrame.Position = UDim2.new(0, 20, 0.2, 0)
mainFrame.BackgroundColor3 = BG_COLOR
mainFrame.Parent = gui
makeDraggable(mainFrame)

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = BTN_COLOR
titleBar.Text = "Lilcat Cheat"
titleBar.TextColor3 = ACCENT_COLOR
titleBar.Font = Enum.Font.SourceSansBold
titleBar.TextSize = 18
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 1, 0)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
closeBtn.TextColor3 = ERROR_COLOR
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 20
closeBtn.Parent = titleBar

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

local buttonHolder = Instance.new("Frame")
buttonHolder.Size = UDim2.new(1, -20, 1, -45)
buttonHolder.Position = UDim2.new(0, 10, 0, 40)
buttonHolder.BackgroundTransparency = 1
buttonHolder.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.Parent = buttonHolder

-- Main Buttons
local flyBtn = createButton("Fly Mode", buttonHolder)
local espBtn = createButton("ESP Players", buttonHolder)
local tweenBtn = createButton("Tween to Player", buttonHolder)
local logBtn = createButton("Admin Log", buttonHolder)
local explorerBtn = createButton("Explorer", buttonHolder)
local afkBtn = createButton("AFK Platform", buttonHolder)

-------------------------------------------------
-- Fly Mode Frame
-------------------------------------------------
local flyFrame = Instance.new("Frame")
flyFrame.Size = UDim2.new(0, 220, 0, 160)
flyFrame.Position = UDim2.new(0, 260, 0.2, 0)
flyFrame.BackgroundColor3 = BG_COLOR
flyFrame.Visible = false
flyFrame.Parent = gui
makeDraggable(flyFrame)

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 8)
flyCorner.Parent = flyFrame

createExitButton(flyFrame, flyFrame)

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(1, -20, 0, 40)
speedBox.Position = UDim2.new(0, 10, 0, 10)
speedBox.PlaceholderText = "Fly Speed (Default: 50)"
speedBox.BackgroundColor3 = BTN_COLOR
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.Font = Enum.Font.SourceSansBold
speedBox.TextSize = 16
speedBox.Parent = flyFrame

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 8)
speedCorner.Parent = speedBox

local flyToggle = Instance.new("TextButton")
flyToggle.Size = UDim2.new(1, -20, 0, 40)
flyToggle.Position = UDim2.new(0, 10, 0, 60)
flyToggle.BackgroundColor3 = BTN_COLOR
flyToggle.TextColor3 = Color3.new(1, 1, 1)
flyToggle.Font = Enum.Font.SourceSansBold
flyToggle.TextSize = 16
flyToggle.Text = "Toggle Fly"
flyToggle.Parent = flyFrame

local flyToggleCorner = Instance.new("UICorner")
flyToggleCorner.CornerRadius = UDim.new(0, 8)
flyToggleCorner.Parent = flyToggle

-- Fly Variables
local flying = false
local flySpeed = 50
local input = {Forward=0, Right=0, Up=0}
local flyConnection = nil

flyToggle.MouseButton1Click:Connect(function()
    flying = not flying
    flyToggle.Text = flying and "Fly: ON" or "Fly: OFF"
    
    if flying then
        local hrp = waitForCharacter()
        if flyConnection then
            flyConnection:Disconnect()
        end
        
        flyConnection = RunService.RenderStepped:Connect(function()
            if not flying then
                if flyConnection then
                    flyConnection:Disconnect()
                    flyConnection = nil
                end
                return
            end
            
            if not (player.Character and player.Character:FindFirstChild("HumanoidRootPart")) then
                return
            end
            
            local currentHRP = player.Character.HumanoidRootPart
            local camCF = workspace.CurrentCamera.CFrame
            local dir = (camCF.LookVector * input.Forward) + (camCF.RightVector * input.Right) + (Vector3.new(0, 1, 0) * input.Up)
            
            if dir.Magnitude > 0 then
                dir = dir.Unit
            end
            
            currentHRP.AssemblyLinearVelocity = dir * flySpeed
        end)
    else
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
    end
end)

speedBox.FocusLost:Connect(function()
    local val = tonumber(speedBox.Text)
    if val and val > 0 then
        flySpeed = val
    end
end)

-- Input Handling
UserInputService.InputBegan:Connect(function(inputObject, gameProcessed)
    if gameProcessed then return end
    
    local keyCode = inputObject.KeyCode
    if keyCode == Enum.KeyCode.W then
        input.Forward = 1
    elseif keyCode == Enum.KeyCode.S then
        input.Forward = -1
    elseif keyCode == Enum.KeyCode.A then
        input.Right = -1
    elseif keyCode == Enum.KeyCode.D then
        input.Right = 1
    elseif keyCode == Enum.KeyCode.Space then
        input.Up = 1
    elseif keyCode == Enum.KeyCode.LeftShift then
        input.Up = -1
    end
end)

UserInputService.InputEnded:Connect(function(inputObject, gameProcessed)
    if gameProcessed then return end
    
    local keyCode = inputObject.KeyCode
    if keyCode == Enum.KeyCode.W or keyCode == Enum.KeyCode.S then
        input.Forward = 0
    elseif keyCode == Enum.KeyCode.A or keyCode == Enum.KeyCode.D then
        input.Right = 0
    elseif keyCode == Enum.KeyCode.Space or keyCode == Enum.KeyCode.LeftShift then
        input.Up = 0
    end
end)

flyBtn.MouseButton1Click:Connect(function()
    flyFrame.Visible = not flyFrame.Visible
end)

-------------------------------------------------
-- ESP System
-------------------------------------------------
local espActive = false
local espConnections = {}

local function clearESP()
    espActive = false
    
    -- Disconnect all connections
    for _, conn in pairs(espConnections) do
        if conn then
            conn:Disconnect()
        end
    end
    table.clear(espConnections)

    -- Remove all ESP tags
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("Head") then
            local tag = plr.Character.Head:FindFirstChild("ESPTag")
            if tag then
                tag:Destroy()
            end
        end
    end
end

local function createESP(targetPlayer)
    if targetPlayer == player then return end
    if not targetPlayer.Character then return end
    
    local head = targetPlayer.Character:FindFirstChild("Head")
    if not head then return end

    -- Remove old tag if exists
    local oldTag = head:FindFirstChild("ESPTag")
    if oldTag then
        oldTag:Destroy()
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESPTag"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Parent = head

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = targetPlayer.Name
    label.TextColor3 = ACCENT_COLOR
    label.TextStrokeTransparency = 0.2
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 16
    label.Parent = billboard

    -- Update loop
    local updateConnection = RunService.RenderStepped:Connect(function()
        if not espActive or not billboard.Parent then
            if espConnections[targetPlayer.UserId] then
                espConnections[targetPlayer.UserId]:Disconnect()
                espConnections[targetPlayer.UserId] = nil
            end
            return
        end

        if not (player.Character and targetPlayer.Character) then
            return
        end

        local myHRP = player.Character:FindFirstChild("HumanoidRootPart")
        local theirHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")

        if myHRP and theirHRP and humanoid then
            local dist = math.floor((myHRP.Position - theirHRP.Position).Magnitude)
            local hp = math.floor(humanoid.Health)
            local maxHp = math.floor(humanoid.MaxHealth)
            label.Text = string.format("%s [%d studs] | HP: %d/%d", targetPlayer.Name, dist, hp, maxHp)
        end
    end)

    espConnections[targetPlayer.UserId] = updateConnection
end

espBtn.MouseButton1Click:Connect(function()
    if espActive then
        clearESP()
    else
        espActive = true
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then
                spawn(function()
                    createESP(plr)
                end)
            end
        end
    end
end)

-- Handle new players
Players.PlayerAdded:Connect(function(newPlayer)
    newPlayer.CharacterAdded:Connect(function()
        if espActive then
            task.wait(1) -- Wait for character to fully load
            createESP(newPlayer)
        end
    end)
end)

-------------------------------------------------
-- Tween to Player Frame
-------------------------------------------------
local tweenFrame = Instance.new("Frame")
tweenFrame.Size = UDim2.new(0, 220, 0, 300)
tweenFrame.Position = UDim2.new(0, 480, 0.2, 0)
tweenFrame.BackgroundColor3 = BG_COLOR
tweenFrame.Visible = false
tweenFrame.Parent = gui
makeDraggable(tweenFrame)

local tweenCorner = Instance.new("UICorner")
tweenCorner.CornerRadius = UDim.new(0, 8)
tweenCorner.Parent = tweenFrame

createExitButton(tweenFrame, tweenFrame)

local tweenScroll = Instance.new("ScrollingFrame")
tweenScroll.Size = UDim2.new(1, -10, 1, -10)
tweenScroll.Position = UDim2.new(0, 5, 0, 5)
tweenScroll.BackgroundTransparency = 1
tweenScroll.ScrollBarThickness = 6
tweenScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
tweenScroll.Parent = tweenFrame

local tweenLayout = Instance.new("UIListLayout")
tweenLayout.Padding = UDim.new(0, 5)
tweenLayout.SortOrder = Enum.SortOrder.LayoutOrder
tweenLayout.Parent = tweenScroll

tweenLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    tweenScroll.CanvasSize = UDim2.new(0, 0, 0, tweenLayout.AbsoluteContentSize.Y + 10)
end)

local function refreshTweenList()
    -- Clear existing buttons
    for _, child in ipairs(tweenScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    -- Create buttons for each player
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -5, 0, 40)
            btn.BackgroundColor3 = BTN_COLOR
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.Font = Enum.Font.SourceSansBold
            btn.TextSize = 18
            btn.Text = targetPlayer.Name
            btn.Parent = tweenScroll

            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = btn

            btn.MouseButton1Click:Connect(function()
                if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local myHRP = waitForCharacter()
                    local targetHRP = targetPlayer.Character.HumanoidRootPart
                    
                    local distance = (myHRP.Position - targetHRP.Position).Magnitude
                    local travelTime = math.max(distance / 100, 0.2) -- 60 studs per second, minimum 0.2 seconds

                    local tween = TweenService:Create(
                        myHRP,
                        TweenInfo.new(travelTime, Enum.EasingStyle.Linear),
                        {CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)}
                    )
                    tween:Play()
                end
            end)
        end
    end
end

tweenBtn.MouseButton1Click:Connect(function()
    tweenFrame.Visible = not tweenFrame.Visible
    if tweenFrame.Visible then
        refreshTweenList()
    end
end)

Players.PlayerAdded:Connect(function()
    if tweenFrame.Visible then
        refreshTweenList()
    end
end)

Players.PlayerRemoving:Connect(function()
    if tweenFrame.Visible then
        refreshTweenList()
    end
end)

-------------------------------------------------
-- Admin Log Frame
-------------------------------------------------
local logFrame = Instance.new("Frame")
logFrame.Size = UDim2.new(0, 400, 0, 400)
logFrame.Position = UDim2.new(0, 700, 0.2, 0)
logFrame.BackgroundColor3 = BG_COLOR
logFrame.Visible = false
logFrame.Parent = gui
makeDraggable(logFrame)

local logCorner = Instance.new("UICorner")
logCorner.CornerRadius = UDim.new(0, 8)
logCorner.Parent = logFrame

createExitButton(logFrame, logFrame)

-- Filter Bar
local filterBar = Instance.new("Frame")
filterBar.Size = UDim2.new(1, -10, 0, 35)
filterBar.Position = UDim2.new(0, 5, 0, 5)
filterBar.BackgroundTransparency = 1
filterBar.Parent = logFrame

local filterLayout = Instance.new("UIListLayout")
filterLayout.FillDirection = Enum.FillDirection.Horizontal
filterLayout.Padding = UDim.new(0, 5)
filterLayout.Parent = filterBar

local function createFilterBtn(name, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 80, 1, 0)
    btn.BackgroundColor3 = BTN_COLOR
    btn.TextColor3 = color or Color3.new(1, 1, 1)
    btn.Text = name
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.Parent = filterBar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    return btn
end

local infoBtn = createFilterBtn("Info", Color3.fromRGB(200, 200, 200))
local warnBtn = createFilterBtn("Warning", Color3.fromRGB(255, 200, 0))
local errorBtn = createFilterBtn("Error", ERROR_COLOR)
local clearBtn = createFilterBtn("Clear", Color3.fromRGB(255, 255, 255))

-- Logs ScrollingFrame
local logScroll = Instance.new("ScrollingFrame")
logScroll.Size = UDim2.new(1, -10, 1, -50)
logScroll.Position = UDim2.new(0, 5, 0, 45)
logScroll.BackgroundTransparency = 1
logScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
logScroll.ScrollBarThickness = 6
logScroll.Parent = logFrame

local logListLayout = Instance.new("UIListLayout")
logListLayout.Padding = UDim.new(0, 2)
logListLayout.SortOrder = Enum.SortOrder.LayoutOrder
logListLayout.Parent = logScroll

-- Store logs
local allLogs = {}

local function refreshLogs(filterType)
    -- Clear existing logs
    for _, child in ipairs(logScroll:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    -- Add filtered logs
    for _, log in ipairs(allLogs) do
        if not filterType or log.Type == filterType then
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -10, 0, 0)
            lbl.AutomaticSize = Enum.AutomaticSize.Y
            lbl.BackgroundTransparency = 1
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextYAlignment = Enum.TextYAlignment.Top
            lbl.TextWrapped = true
            lbl.Font = Enum.Font.Code
            lbl.TextSize = 14
            lbl.Parent = logScroll
            
            if log.Type == Enum.MessageType.MessageError then
                lbl.TextColor3 = ERROR_COLOR
            elseif log.Type == Enum.MessageType.MessageWarning then
                lbl.TextColor3 = Color3.fromRGB(255, 200, 0)
            else
                lbl.TextColor3 = Color3.new(1, 1, 1)
            end
            
            lbl.Text = log.Text
        end
    end

    logScroll.CanvasSize = UDim2.new(0, 0, 0, logListLayout.AbsoluteContentSize.Y + 10)
end

-- Capture output
LogService.MessageOut:Connect(function(message, messageType)
    table.insert(allLogs, {Text = message, Type = messageType})
    if #allLogs > 100 then -- Limit log history
        table.remove(allLogs, 1)
    end
    refreshLogs()
end)

-- Filter buttons
infoBtn.MouseButton1Click:Connect(function()
    refreshLogs(Enum.MessageType.MessageOutput)
end)

warnBtn.MouseButton1Click:Connect(function()
    refreshLogs(Enum.MessageType.MessageWarning)
end)

errorBtn.MouseButton1Click:Connect(function()
    refreshLogs(Enum.MessageType.MessageError)
end)

clearBtn.MouseButton1Click:Connect(function()
    allLogs = {}
    refreshLogs()
end)

logBtn.MouseButton1Click:Connect(function()
    logFrame.Visible = not logFrame.Visible
end)

-------------------------------------------------
-- Explorer Frame
-------------------------------------------------
local explorerFrame = Instance.new("Frame")
explorerFrame.Size = UDim2.new(0, 400, 0, 400)
explorerFrame.Position = UDim2.new(0, 1100, 0.2, 0)
explorerFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
explorerFrame.Visible = false
explorerFrame.Parent = gui
makeDraggable(explorerFrame)

local explorerCorner = Instance.new("UICorner")
explorerCorner.CornerRadius = UDim.new(0, 8)
explorerCorner.Parent = explorerFrame

createExitButton(explorerFrame, explorerFrame)

-- Search Box
local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -120, 0, 30)
searchBox.Position = UDim2.new(0, 5, 0, 5)
searchBox.PlaceholderText = "Search..."
searchBox.Text = ""
searchBox.ClearTextOnFocus = false
searchBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
searchBox.TextColor3 = Color3.new(1, 1, 1)
searchBox.Font = Enum.Font.Code
searchBox.TextSize = 14
searchBox.Parent = explorerFrame

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 6)
searchCorner.Parent = searchBox

-- Mode Label (toggle between Name and Type)
local modeLabel = Instance.new("TextButton")
modeLabel.Size = UDim2.new(0, 100, 0, 30)
modeLabel.Position = UDim2.new(1, -105, 0, 5)
modeLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
modeLabel.Text = "Mode: Name"
modeLabel.TextColor3 = Color3.new(1, 1, 1)
modeLabel.Font = Enum.Font.Code
modeLabel.TextSize = 14
modeLabel.Parent = explorerFrame

local modeCorner = Instance.new("UICorner")
modeCorner.CornerRadius = UDim.new(0, 6)
modeCorner.Parent = modeLabel

local searchMode = "Name"
modeLabel.MouseButton1Click:Connect(function()
    if searchMode == "Name" then
        searchMode = "Type"
        modeLabel.Text = "Mode: Type"
    else
        searchMode = "Name"
        modeLabel.Text = "Mode: Name"
    end
end)

-- Scrollable content for tree
local explorerScroll = Instance.new("ScrollingFrame")
explorerScroll.Size = UDim2.new(1, -10, 1, -60)
explorerScroll.Position = UDim2.new(0, 5, 0, 40)
explorerScroll.BackgroundTransparency = 1
explorerScroll.ScrollBarThickness = 6
explorerScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
explorerScroll.Parent = explorerFrame

local explorerLayout = Instance.new("UIListLayout")
explorerLayout.Padding = UDim.new(0, 2)
explorerLayout.SortOrder = Enum.SortOrder.LayoutOrder
explorerLayout.Parent = explorerScroll

-- Remove Button (smaller)
local removeBtn = Instance.new("TextButton")
removeBtn.Size = UDim2.new(0, 80, 0, 25)
removeBtn.Position = UDim2.new(1, -85, 1, -30)
removeBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
removeBtn.Text = "Remove"
removeBtn.TextColor3 = Color3.new(1, 1, 1)
removeBtn.Font = Enum.Font.SourceSansBold
removeBtn.TextSize = 14
removeBtn.Parent = explorerFrame

local removeCorner = Instance.new("UICorner")
removeCorner.CornerRadius = UDim.new(0, 6)
removeCorner.Parent = removeBtn

-------------------------------------------------
-- Create Node Function
-------------------------------------------------
local selectedInstance = nil
local highlightedLabel = nil

local function createNode(parentUI, instance, depth)
    local container = Instance.new("Frame")
    container.Name = "Node_" .. instance.Name
    container.Size = UDim2.new(1, -5, 0, 20)
    container.BackgroundTransparency = 1
    container.Parent = parentUI

    local plusBtn = Instance.new("TextButton")
    plusBtn.Size = UDim2.new(0, 20, 0, 20)
    plusBtn.Position = UDim2.new(0, depth * 20, 0, 0)
    plusBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    plusBtn.Text = "+"
    plusBtn.TextColor3 = Color3.new(1, 1, 1)
    plusBtn.Font = Enum.Font.Code
    plusBtn.TextSize = 14
    plusBtn.Parent = container

    local label = Instance.new("TextButton")
    label.Size = UDim2.new(1, -30 - depth * 20, 0, 20)
    label.Position = UDim2.new(0, 25 + depth * 20, 0, 0)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Code
    label.TextSize = 14
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Text = instance.Name .. " (" .. instance.ClassName .. ")"
    label.Parent = container

    -- Highlight selection
    label.MouseButton1Click:Connect(function()
        if highlightedLabel then
            highlightedLabel.BackgroundTransparency = 1
        end
        selectedInstance = instance
        highlightedLabel = label
        label.BackgroundTransparency = 0.5
        label.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
    end)

    -- Expansion tracking
    local expanded = false
    local childrenFrames = {}

    plusBtn.MouseButton1Click:Connect(function()
        if expanded then
            for _, frame in ipairs(childrenFrames) do
                frame:Destroy()
            end
            childrenFrames = {}
            plusBtn.Text = "+"
            expanded = false
        else
            for _, child in ipairs(instance:GetChildren()) do
                table.insert(childrenFrames, createNode(parentUI, child, depth + 1))
            end
            plusBtn.Text = "-"
            expanded = true
        end
        explorerScroll.CanvasSize = UDim2.new(0, 0, 0, explorerLayout.AbsoluteContentSize.Y + 10)
    end)

    return container
end

-------------------------------------------------
-- Refresh Tree Function
-------------------------------------------------
local function refreshExplorerTree()
    for _, child in ipairs(explorerScroll:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    local roots = {
        workspace,
        game.Players,
        game.ReplicatedStorage,
        game:GetService("CoreGui") -- ✅ Full CoreGui included
    }

    for _, root in ipairs(roots) do
        createNode(explorerScroll, root, 0)
    end

    explorerScroll.CanvasSize = UDim2.new(0, 0, 0, explorerLayout.AbsoluteContentSize.Y + 10)
end

explorerBtn.MouseButton1Click:Connect(function()
    explorerFrame.Visible = not explorerFrame.Visible
    if explorerFrame.Visible then
        refreshExplorerTree()
    end
end)

-- Search functionality
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local searchText = searchBox.Text:lower()
    for _, child in ipairs(explorerScroll:GetChildren()) do
        if child:IsA("Frame") then
            local label = child:FindFirstChildOfClass("TextButton")
            if label then
                local checkText = (searchMode == "Name")
                    and label.Text:lower()
                    or label.Text:match("%((.-)%)"):lower()
                child.Visible = (searchText == "" or checkText:find(searchText, 1, true) ~= nil)
            end
        end
    end
end)

-- Remove functionality (works on CoreGui too since exploit unlocks it)
removeBtn.MouseButton1Click:Connect(function()
    if selectedInstance then
        selectedInstance:Destroy()
        refreshExplorerTree()
        selectedInstance = nil
        highlightedLabel = nil
    end
end)
-------------------------------------------------
-- AFK Sky Float Toggle
-------------------------------------------------
local isAfk = false
local afkCoroutine -- store coroutine to stop it later

afkBtn.MouseButton1Click:Connect(function()
    local hrp = waitForCharacter()
    if not hrp then return end

    local TweenService = game:GetService("TweenService")

    if not isAfk then
        isAfk = true

        -- Starting sky position (5000 studs above current pos)
        local startPos = hrp.Position + Vector3.new(0, 5000, 0)
        hrp.CFrame = CFrame.new(startPos)

        -- Waypoints for the player to float around
        local radius = 100
        local height = 5000
        local speed = 20 -- bigger = slower movement

        local points = {
            Vector3.new(radius, height, 0),
            Vector3.new(0, height, radius),
            Vector3.new(-radius, height, 0),
            Vector3.new(0, height, -radius),
        }

        -- Coroutine to loop tweening between waypoints
        afkCoroutine = coroutine.create(function()
            local i = 1
            while isAfk and hrp.Parent do
                local targetPos = startPos + points[i]
                local targetCFrame = CFrame.new(targetPos)

                local distance = (hrp.Position - targetPos).Magnitude
                local travelTime = distance / speed

                local tween = TweenService:Create(
                    hrp,
                    TweenInfo.new(travelTime, Enum.EasingStyle.Linear),
                    {CFrame = targetCFrame}
                )
                tween:Play()
                tween.Completed:Wait()

                i = i + 1
                if i > #points then
                    i = 1
                end
            end
        end)
        coroutine.resume(afkCoroutine)

    else
        -- Toggle off: stop AFK and let player move normally
        isAfk = false
        -- optionally teleport back to ground
        local groundY = workspace.FallenPartsDestroyHeight + 5
        hrp.CFrame = CFrame.new(hrp.Position.X, groundY, hrp.Position.Z)
    end
end)
print("Lilcat Cheat Utility loaded successfully!")
