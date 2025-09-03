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
-- Tween to Player (with proper ScrollingFrame)
-------------------------------------------------
local tweenFrame = Instance.new("Frame", gui)
tweenFrame.Size = UDim2.new(0, 220, 0, 300)
tweenFrame.Position = UDim2.new(0, 480, 0.2, 0)
tweenFrame.BackgroundColor3 = BG_COLOR
tweenFrame.Visible = false
makeDraggable(tweenFrame)
Instance.new("UICorner", tweenFrame).CornerRadius = UDim.new(0, 8)
createExitButton(tweenFrame, tweenFrame)

-- Scrolling frame inside tweenFrame
local scroll = Instance.new("ScrollingFrame")
scroll.Parent = tweenFrame
scroll.Size = UDim2.new(1, -10, 1, -10)
scroll.Position = UDim2.new(0, 5, 0, 5)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

-- Layout
local list = Instance.new("UIListLayout", scroll)
list.Padding = UDim.new(0, 5)
list.SortOrder = Enum.SortOrder.LayoutOrder

-- Auto adjust scroll size
list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 10)
end)

-- Function to refresh list of players
local function refreshTween()
	for _, c in ipairs(scroll:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player then
			-- make sure button is parented to scroll
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, -5, 0, 40)
			btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.Font = Enum.Font.SourceSansBold
			btn.TextSize = 18
			btn.Text = plr.Name
			btn.Parent = scroll

			Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

			btn.MouseButton1Click:Connect(function()
	if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
		local target = plr.Character.HumanoidRootPart
		local myHRP = hrp
		if myHRP then
			local distance = (myHRP.Position - target.Position).Magnitude
			local travelTime = distance / 60 -- 60 studs per second

			-- Minimum time so short hops aren't instant
			if travelTime < 0.2 then
				travelTime = 0.2
			end

			local tween = TweenService:Create(
				myHRP,
				TweenInfo.new(travelTime, Enum.EasingStyle.Linear),
				{ CFrame = target.CFrame + Vector3.new(0, 3, 0) }
			)
			tween:Play()
		end
	end
end)
		end
	end
end

tweenBtn.MouseButton1Click:Connect(function()
	tweenFrame.Visible = not tweenFrame.Visible
	if tweenFrame.Visible then refreshTween() end
end)

Players.PlayerAdded:Connect(function()
	if tweenFrame.Visible then refreshTween() end
end)

Players.PlayerRemoving:Connect(function()
	if tweenFrame.Visible then refreshTween() end
end)
-------------------------------------------------
-- Admin Log (Scrolling-based)
-------------------------------------------------
local logFrame = Instance.new("ScrollingFrame", gui)
logFrame.Size = UDim2.new(0, 350, 0, 350)
logFrame.Position = UDim2.new(0, 700, 0.2, 0)
logFrame.BackgroundColor3 = BG_COLOR
logFrame.Visible = false
logFrame.CanvasSize = UDim2.new(0,0,0,0)
logFrame.ScrollBarThickness = 6
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

-- Logs list
local listLayout = Instance.new("UIListLayout", logFrame)
listLayout.Padding = UDim.new(0, 2)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Store logs for filtering
local allLogs = {}

local function refreshLogs(filterType)
	-- remove old labels except filterBar + exit button
	for _, child in ipairs(logFrame:GetChildren()) do
		if child:IsA("TextLabel") then
			child:Destroy()
		end
	end

	for _, log in ipairs(allLogs) do
		if not filterType or log.Type == filterType then
			local lbl = Instance.new("TextLabel", logFrame)
			lbl.Size = UDim2.new(1, -10, 0, 0) -- allow autosize
			lbl.AutomaticSize = Enum.AutomaticSize.Y
			lbl.BackgroundTransparency = 1
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.TextYAlignment = Enum.TextYAlignment.Top
			lbl.TextWrapped = true
			lbl.Font = Enum.Font.Code
			lbl.TextSize = 14
			lbl.TextColor3 = (log.Type == Enum.MessageType.MessageError and ERROR_COLOR)
				or (log.Type == Enum.MessageType.MessageWarning and Color3.fromRGB(255,200,0))
				or Color3.new(1,1,1)
			lbl.Text = log.Text
		end
	end

	logFrame.CanvasSize = UDim2.new(0,0,0,listLayout.AbsoluteContentSize.Y+10)
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
-------------------------------------------------
-- EXTRA: Explorer Button + Tree Viewer
-------------------------------------------------

-- Explorer Button (next to Clear)
local explorerBtn = createFilterBtn("Explorer", Color3.fromRGB(150, 255, 150))

-- Explorer Frame
local explorerFrame = Instance.new("Frame", gui)
explorerFrame.Size = UDim2.new(0, 400, 0, 400)
explorerFrame.Position = UDim2.new(0, 1100, 0.2, 0)
explorerFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
explorerFrame.Visible = false
makeDraggable(explorerFrame)
Instance.new("UICorner", explorerFrame).CornerRadius = UDim.new(0, 8)

-- Close button for Explorer
local exitExplorer = Instance.new("TextButton", explorerFrame)
exitExplorer.Size = UDim2.new(0, 30, 0, 30)
exitExplorer.Position = UDim2.new(1, -35, 0, 5)
exitExplorer.Text = "X"
exitExplorer.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
exitExplorer.TextColor3 = ERROR_COLOR
exitExplorer.Font = Enum.Font.SourceSansBold
exitExplorer.TextSize = 18
exitExplorer.MouseButton1Click:Connect(function()
	explorerFrame.Visible = false
end)

-- Search bar
local searchBox = Instance.new("TextBox", explorerFrame)
searchBox.Size = UDim2.new(1, -10, 0, 30)
searchBox.Position = UDim2.new(0, 5, 0, 40)
searchBox.PlaceholderText = "Search..."
searchBox.Text = ""
searchBox.ClearTextOnFocus = false
searchBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
searchBox.TextColor3 = Color3.new(1,1,1)
searchBox.Font = Enum.Font.Code
searchBox.TextSize = 14
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 6)

-- Search mode dropdown
local searchMode = "Name" -- default
local searchModeBtn = Instance.new("TextButton", explorerFrame)
searchModeBtn.Size = UDim2.new(0, 100, 0, 30)
searchModeBtn.Position = UDim2.new(1, -105, 0, 40)
searchModeBtn.Text = "Mode: Name"
searchModeBtn.BackgroundColor3 = Color3.fromRGB(70,70,100)
searchModeBtn.TextColor3 = Color3.new(1,1,1)
searchModeBtn.Font = Enum.Font.SourceSansBold
searchModeBtn.TextSize = 14
Instance.new("UICorner", searchModeBtn).CornerRadius = UDim.new(0, 6)

searchModeBtn.MouseButton1Click:Connect(function()
	if searchMode == "Name" then
		searchMode = "Type"
		searchModeBtn.Text = "Mode: Type"
	else
		searchMode = "Name"
		searchModeBtn.Text = "Mode: Name"
	end
end)

-- Scrolling tree
local explorerScroll = Instance.new("ScrollingFrame", explorerFrame)
explorerScroll.Size = UDim2.new(1, -10, 1, -80)
explorerScroll.Position = UDim2.new(0, 5, 0, 75)
explorerScroll.CanvasSize = UDim2.new(0,0,0,0)
explorerScroll.ScrollBarThickness = 6
explorerScroll.BackgroundTransparency = 1

local explorerLayout = Instance.new("UIListLayout", explorerScroll)
explorerLayout.Padding = UDim.new(0, 2)
explorerLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Helper: recursive tree builder
local function addInstanceNode(parent, instance, depth, filter)
	local text = string.rep("   ", depth) .. instance.Name .. " ["..instance.ClassName.."]"
	if not filter or string.find(
		searchMode == "Name" and instance.Name:lower() or instance.ClassName:lower(),
		filter:lower()
	) then
		local lbl = Instance.new("TextLabel", explorerScroll)
		lbl.Size = UDim2.new(1, -5, 0, 20)
		lbl.BackgroundTransparency = 1
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.Font = Enum.Font.Code
		lbl.TextSize = 14
		lbl.TextColor3 = Color3.new(1,1,1)
		lbl.Text = text
	end
	for _, child in ipairs(instance:GetChildren()) do
		addInstanceNode(instance, child, depth+1, filter)
	end
end

-- Refresh Explorer
local function refreshExplorer(filter)
	for _, child in ipairs(explorerScroll:GetChildren()) do
		if child:IsA("TextLabel") then
			child:Destroy()
		end
	end
	addInstanceNode(nil, game, 0, filter)
	explorerScroll.CanvasSize = UDim2.new(0,0,0,explorerLayout.AbsoluteContentSize.Y+10)
end

-- Open Explorer
explorerBtn.MouseButton1Click:Connect(function()
	explorerFrame.Visible = not explorerFrame.Visible
	if explorerFrame.Visible then
		refreshExplorer()
	end
end)

-- Search update
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
	if explorerFrame.Visible then
		refreshExplorer(searchBox.Text)
	end
end)
