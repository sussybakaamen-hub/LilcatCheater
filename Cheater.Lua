-- Lilcat Cheat Utility Panel (Rebuilt)
-- Place in StarterPlayerScripts

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LogService = game:GetService("LogService")

local player = Players.LocalPlayer

-- GUI
local oldgui = player:WaitForChild("PlayerGui"):FindFirstChild("LilcatCheat")
if oldgui then
oldgui:Destroy()
end
local gui = Instance.new("ScreenGui")
gui.Name = "LilcatCheat"
gui.Parent = player:WaitForChild("PlayerGui")

-- Colors
local BG_COLOR = Color3.fromRGB(30, 30, 30)
local BTN_COLOR = Color3.fromRGB(50, 50, 50)
local ACCENT_COLOR = Color3.fromRGB(85, 170, 255)
local ERROR_COLOR = Color3.fromRGB(255, 80, 80)

-- Helpers
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
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	return btn
end

local function createExitButton(parent, closeFrame)
	local exit = Instance.new("TextButton", parent)
	exit.Size = UDim2.new(0, 30, 0, 30)
	exit.Position = UDim2.new(1, -35, 0, 5)
	exit.Text = "X"
	exit.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
	exit.TextColor3 = ERROR_COLOR
	exit.Font = Enum.Font.SourceSansBold
	exit.TextSize = 18
	exit.MouseButton1Click:Connect(function()
		closeFrame.Visible = false
	end)
end

-------------------------------------------------
-- Main Panel
-------------------------------------------------
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 220, 0, 320)
mainFrame.Position = UDim2.new(0, 20, 0.2, 0)
mainFrame.BackgroundColor3 = BG_COLOR
makeDraggable(mainFrame)
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

local titleBar = Instance.new("TextLabel", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = BTN_COLOR
titleBar.Text = "Lilcat Cheat"
titleBar.TextColor3 = ACCENT_COLOR
titleBar.Font = Enum.Font.SourceSansBold
titleBar.TextSize = 18

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 35, 1, 0)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
closeBtn.TextColor3 = ERROR_COLOR
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 20
closeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

local buttonHolder = Instance.new("Frame", mainFrame)
buttonHolder.Size = UDim2.new(1, -20, 1, -45)
buttonHolder.Position = UDim2.new(0, 10, 0, 40)
buttonHolder.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", buttonHolder)
layout.Padding = UDim.new(0, 5)

-- Buttons
local flyBtn = createButton("Fly Mode", buttonHolder)
local espBtn = createButton("ESP Players", buttonHolder)
local tweenBtn = createButton("Tween to Player", buttonHolder)
local logBtn = createButton("Admin Log", buttonHolder)

-------------------------------------------------
-- Fly Mode Frame
-------------------------------------------------
local flyFrame = Instance.new("Frame", gui)
flyFrame.Size = UDim2.new(0, 220, 0, 160)
flyFrame.Position = UDim2.new(0, 260, 0.2, 0)
flyFrame.BackgroundColor3 = BG_COLOR
flyFrame.Visible = false
makeDraggable(flyFrame)
Instance.new("UICorner", flyFrame).CornerRadius = UDim.new(0, 8)
createExitButton(flyFrame, flyFrame)

local speedBox = Instance.new("TextBox", flyFrame)
speedBox.Size = UDim2.new(1, -20, 0, 40)
speedBox.Position = UDim2.new(0, 10, 0, 10)
speedBox.PlaceholderText = "Fly Speed (Default: 50)"
speedBox.BackgroundColor3 = BTN_COLOR
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.Font = Enum.Font.SourceSansBold
speedBox.TextSize = 16

local flyToggle = Instance.new("TextButton", flyFrame)
flyToggle.Size = UDim2.new(1, -20, 0, 40)
flyToggle.Position = UDim2.new(0, 10, 0, 60)
flyToggle.BackgroundColor3 = BTN_COLOR
flyToggle.TextColor3 = Color3.new(1,1,1)
flyToggle.Font = Enum.Font.SourceSansBold
flyToggle.TextSize = 16
flyToggle.Text = "Toggle Fly"
Instance.new("UICorner", flyToggle).CornerRadius = UDim.new(0, 8)

local flying = false
local flySpeed = 50
local input = {Forward=0,Right=0,Up=0}
local hrp = player.Character:WaitForChild("HumanoidRootPart")

flyToggle.MouseButton1Click:Connect(function()
	flying = not flying
	flyToggle.Text = flying and "Fly: ON" or "Fly: OFF"
	if not flying then
		hrp.AssemblyLinearVelocity = Vector3.zero
	end
end)

speedBox.FocusLost:Connect(function()
	local val = tonumber(speedBox.Text)
	if val then flySpeed = val end
end)

UserInputService.InputBegan:Connect(function(i,gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.W then input.Forward=1 end
	if i.KeyCode == Enum.KeyCode.S then input.Forward=-1 end
	if i.KeyCode == Enum.KeyCode.A then input.Right=-1 end
	if i.KeyCode == Enum.KeyCode.D then input.Right=1 end
	if i.KeyCode == Enum.KeyCode.Space then input.Up=1 end
	if i.KeyCode == Enum.KeyCode.LeftShift then input.Up=-1 end
end)

UserInputService.InputEnded:Connect(function(i,gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.W or i.KeyCode==Enum.KeyCode.S then input.Forward=0 end
	if i.KeyCode == Enum.KeyCode.A or i.KeyCode==Enum.KeyCode.D then input.Right=0 end
	if i.KeyCode == Enum.KeyCode.Space or i.KeyCode==Enum.KeyCode.LeftShift then input.Up=0 end
end)

RunService.RenderStepped:Connect(function()
	if flying and hrp then
		local camCF = workspace.CurrentCamera.CFrame
		local dir = (camCF.LookVector*input.Forward)+(camCF.RightVector*input.Right)+(Vector3.yAxis*input.Up)
		if dir.Magnitude>0 then dir=dir.Unit end
		hrp.AssemblyLinearVelocity = dir*flySpeed
	end
end)

flyBtn.MouseButton1Click:Connect(function()
	flyFrame.Visible = not flyFrame.Visible
end)

-------------------------------------------------
-- ESP (Names + Studs + Health) with Cleanup
-------------------------------------------------
local espConnections = {} -- store RenderStepped connections

local function clearESP()
	-- remove GUI and disconnect loops
	for _, conn in pairs(espConnections) do
		if conn then conn:Disconnect() end
	end
	table.clear(espConnections)

	for _, p in ipairs(Players:GetPlayers()) do
		if p.Character and p.Character:FindFirstChild("Head") then
			local tag = p.Character.Head:FindFirstChild("ESPTag")
			if tag then tag:Destroy() end
		end
	end
end

local function createESP(plr)
	if plr == player then return end
	local char = plr.Character
	if not char then return end
	local head = char:FindFirstChild("Head")
	if not head then return end

	-- destroy old tag if exists
	local old = head:FindFirstChild("ESPTag")
	if old then old:Destroy() end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "ESPTag"
	billboard.Adornee = head
	billboard.Size = UDim2.new(0, 200, 0, 50)
	billboard.AlwaysOnTop = true
	billboard.StudsOffset = Vector3.new(0, 3, 0)
	billboard.Parent = head

	local label = Instance.new("TextLabel", billboard)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = plr.Name
	label.TextColor3 = ACCENT_COLOR
	label.TextStrokeTransparency = 0.2
	label.Font = Enum.Font.SourceSansBold
	label.TextSize = 16

	-- update loop, stored in espConnections
	local conn
	conn = RunService.RenderStepped:Connect(function()
		if not (player.Character and plr.Character and billboard.Parent) then
			if conn then conn:Disconnect() end
			return
		end

		local myHRP = player.Character:FindFirstChild("HumanoidRootPart")
		local theirHRP = plr.Character:FindFirstChild("HumanoidRootPart")
		local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")

		if myHRP and theirHRP and humanoid then
			local dist = (myHRP.Position - theirHRP.Position).Magnitude
			local hp = math.floor(humanoid.Health)
			local maxHp = math.floor(humanoid.MaxHealth)
			label.Text = string.format("%s [%d studs] | HP: %d/%d", plr.Name, dist, hp, maxHp)
		end
	end)

	espConnections[plr.UserId] = conn
end

espBtn.MouseButton1Click:Connect(function()
	clearESP()
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player then
			createESP(p)
		end
	end
end)

Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function()
		task.wait(1)
		createESP(p)
	end)
end)
-------------------------------------------------
-- Tween to Player
-------------------------------------------------
local tweenFrame = Instance.new("Frame", gui)
tweenFrame.Size = UDim2.new(0, 220, 0, 300)
tweenFrame.Position = UDim2.new(0, 480, 0.2, 0)
tweenFrame.BackgroundColor3 = BG_COLOR
tweenFrame.Visible = false
makeDraggable(tweenFrame)
Instance.new("UICorner", tweenFrame).CornerRadius = UDim.new(0, 8)
createExitButton(tweenFrame, tweenFrame)

local scroll = Instance.new("ScrollingFrame", tweenFrame)
scroll.Size = UDim2.new(1, -10, 1, -10)
scroll.Position = UDim2.new(0, 5, 0, 5)
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.BackgroundTransparency=1
scroll.ScrollBarThickness=5

local list = Instance.new("UIListLayout", scroll)
list.Padding = UDim.new(0,5)

local function refreshTween()
	for _,c in ipairs(scroll:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end
	for _,plr in ipairs(Players:GetPlayers()) do
		if plr ~= player then
			local btn = createButton(plr.Name, scroll)
			btn.MouseButton1Click:Connect(function()
				if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
					local target = plr.Character.HumanoidRootPart
					local tween = TweenService:Create(hrp, TweenInfo.new(2,Enum.EasingStyle.Linear),{CFrame=target.CFrame+Vector3.new(0,3,0)})
					tween:Play()
				end
			end)
		end
	end
end

tweenBtn.MouseButton1Click:Connect(function()
	tweenFrame.Visible = not tweenFrame.Visible
	if tweenFrame.Visible then refreshTween() end
end)

Players.PlayerAdded:Connect(function() if tweenFrame.Visible then refreshTween() end end)
Players.PlayerRemoving:Connect(function() if tweenFrame.Visible then refreshTween() end end)

-------------------------------------------------
-- Admin Log Frame (with filters)
-------------------------------------------------
local logFrame = Instance.new("Frame", gui)
logFrame.Size = UDim2.new(0, 350, 0, 350)
logFrame.Position = UDim2.new(0, 700, 0.2, 0)
logFrame.BackgroundColor3 = BG_COLOR
logFrame.Visible = false
makeDraggable(logFrame)
Instance.new("UICorner", logFrame).CornerRadius = UDim.new(0, 8)

-- Close button
local exitLog = Instance.new("TextButton", logFrame)
exitLog.Size = UDim2.new(0, 30, 0, 30)
exitLog.Position = UDim2.new(1, -35, 0, 5)
exitLog.Text = "X"
exitLog.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
exitLog.TextColor3 = ERROR_COLOR
exitLog.Font = Enum.Font.SourceSansBold
exitLog.TextSize = 18
exitLog.MouseButton1Click:Connect(function()
	logFrame.Visible = false
end)

-- Filter buttons bar
local filterBar = Instance.new("Frame", logFrame)
filterBar.Size = UDim2.new(1, -10, 0, 35)
filterBar.Position = UDim2.new(0, 5, 0, 5)
filterBar.BackgroundTransparency = 1

local filterLayout = Instance.new("UIListLayout", filterBar)
filterLayout.FillDirection = Enum.FillDirection.Horizontal
filterLayout.Padding = UDim.new(0, 5)

local function createFilterBtn(name, color)
	local btn = Instance.new("TextButton", filterBar)
	btn.Size = UDim2.new(0, 80, 1, 0)
	btn.BackgroundColor3 = BTN_COLOR
	btn.TextColor3 = color or Color3.new(1,1,1)
	btn.Text = name
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 14
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	return btn
end

local infoBtn = createFilterBtn("Info", Color3.fromRGB(200,200,200))
local warnBtn = createFilterBtn("Warning", Color3.fromRGB(255,200,0))
local errorBtn = createFilterBtn("Error", ERROR_COLOR)
local clearBtn = createFilterBtn("Clear", Color3.fromRGB(255,255,255))

-- Log list
local scrolling = Instance.new("ScrollingFrame", logFrame)
scrolling.Size = UDim2.new(1, -10, 1, -50)
scrolling.Position = UDim2.new(0, 5, 0, 45)
scrolling.CanvasSize = UDim2.new(0,0,0,0)
scrolling.ScrollBarThickness = 5
scrolling.BackgroundTransparency = 1

local listLayout = Instance.new("UIListLayout", scrolling)
listLayout.Padding = UDim.new(0, 2)

-- Store logs for filtering
local allLogs = {}

local function refreshLogs(filterType)
	for _, child in ipairs(scrolling:GetChildren()) do
		if child:IsA("TextLabel") then child:Destroy() end
	end
	for _, log in ipairs(allLogs) do
		if not filterType or log.Type == filterType then
			local lbl = Instance.new("TextLabel", scrolling)
			lbl.Size = UDim2.new(1, -5, 0, 20)
			lbl.BackgroundTransparency = 1
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Font = Enum.Font.Code
			lbl.TextSize = 14
			lbl.TextColor3 = (log.Type == Enum.MessageType.MessageError and ERROR_COLOR)
				or (log.Type == Enum.MessageType.MessageWarning and Color3.fromRGB(255,200,0))
				or Color3.new(1,1,1)
			lbl.Text = log.Text
		end
	end
	scrolling.CanvasSize = UDim2.new(0,0,0,listLayout.AbsoluteContentSize.Y+10)
end

-- Capture logs
LogService.MessageOut:Connect(function(msg, msgType)
	table.insert(allLogs, {Text=msg, Type=msgType})
	refreshLogs() -- show immediately
end)

-- Filters
infoBtn.MouseButton1Click:Connect(function() refreshLogs(Enum.MessageType.MessageOutput) end)
warnBtn.MouseButton1Click:Connect(function() refreshLogs(Enum.MessageType.MessageWarning) end)
errorBtn.MouseButton1Click:Connect(function() refreshLogs(Enum.MessageType.MessageError) end)
clearBtn.MouseButton1Click:Connect(function()
	allLogs = {}
	refreshLogs()
end)

-- Toggle open
logBtn.MouseButton1Click:Connect(function()
	logFrame.Visible = not logFrame.Visible
end)
