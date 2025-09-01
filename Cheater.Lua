-- LocalScript inside StarterPlayerScripts
-- HPHats Admin Panel (Client Only)

local Players = game:GetService("Players")
local LogService = game:GetService("LogService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 🧹 Remove old GUI if it exists
local old = playerGui:FindFirstChild("Lilcat Cheat")
if old then old:Destroy() end
-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "Lilcat Cheat"
gui.ResetOnSpawn = false
gui.Parent = playerGui
-----------------------------------------------------
-- MAIN ADMIN PANEL
-----------------------------------------------------
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 200, 0, 150)
panel.Position = UDim2.new(0, 20, 0, 100)
panel.BackgroundColor3 = Color3.fromRGB(30,30,30)
panel.Active = true
panel.Draggable = true
panel.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(50,50,50)
title.Text = "Lilcat Cheat"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Parent = panel

-- Button creator
local function createButton(text, posY)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Text = text
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 16
	btn.Parent = panel
	return btn
end

local logBtn = createButton("1. Toggle Dev Log", 40)
local infoBtn = createButton("2. Check Info", 80)
local highlightBtn = createButton("3. Track Players", 120)

-----------------------------------------------------
-- DEV LOG WINDOW
-----------------------------------------------------
local devLogFrame = Instance.new("Frame")
devLogFrame.Size = UDim2.new(0, 450, 0, 250)
devLogFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
devLogFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
devLogFrame.Visible = false
devLogFrame.Active = true
devLogFrame.Draggable = true
devLogFrame.Parent = gui

local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, -30, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(45,45,45)
titleBar.Text = "Developer Log"
titleBar.TextColor3 = Color3.new(1,1,1)
titleBar.Font = Enum.Font.SourceSansBold
titleBar.TextSize = 18
titleBar.TextXAlignment = Enum.TextXAlignment.Left
titleBar.Parent = devLogFrame

local exitBtn = Instance.new("TextButton")
exitBtn.Size = UDim2.new(0,30,0,30)
exitBtn.Position = UDim2.new(1,-30,0,0)
exitBtn.Text = "X"
exitBtn.BackgroundColor3 = Color3.fromRGB(80,30,30)
exitBtn.TextColor3 = Color3.new(1,0.3,0.3)
exitBtn.Parent = devLogFrame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,-10,1,-40)
scroll.Position = UDim2.new(0,5,0,35)
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 8
scroll.BackgroundTransparency = 1
scroll.Parent = devLogFrame

local layout = Instance.new("UIListLayout")
layout.Parent = scroll
layout.SortOrder = Enum.SortOrder.LayoutOrder

local function addLog(msg, color)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1,-5,0,20)
	label.BackgroundTransparency = 1
	label.Text = msg
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextColor3 = color or Color3.new(1,1,1)
	label.Font = Enum.Font.Code
	label.TextSize = 14
	label.Parent = scroll
	
	scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y)
	scroll.CanvasPosition = Vector2.new(0, math.max(0, scroll.CanvasSize.Y.Offset - scroll.AbsoluteWindowSize.Y))
end

LogService.MessageOut:Connect(function(message, msgType)
	if not devLogFrame.Visible then return end
	if message:find("CorePackages") or message:find("CoreGui") then return end
	
	if msgType == Enum.MessageType.MessageOutput then
		addLog("[PRINT] "..message, Color3.fromRGB(200,200,200))
	elseif msgType == Enum.MessageType.MessageWarning then
		addLog("[WARN] "..message, Color3.fromRGB(255,200,0))
	elseif msgType == Enum.MessageType.MessageError then
		addLog("[ERROR] "..message, Color3.fromRGB(255,80,80))
	end
end)

exitBtn.MouseButton1Click:Connect(function()
	devLogFrame.Visible = false
end)

logBtn.MouseButton1Click:Connect(function()
	devLogFrame.Visible = not devLogFrame.Visible
end)

-----------------------------------------------------
-- INFO WINDOW (Scanner with Remove Button + Search)
-----------------------------------------------------
local infoFrame = Instance.new("Frame")
infoFrame.Size = UDim2.new(0, 500, 0, 360)
infoFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
infoFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
infoFrame.Visible = false
infoFrame.Active = true
infoFrame.Draggable = true
infoFrame.Parent = gui

local infoTitle = Instance.new("TextLabel")
infoTitle.Size = UDim2.new(1,-30,0,30)
infoTitle.BackgroundColor3 = Color3.fromRGB(45,45,45)
infoTitle.Text = "Game Information Scanner"
infoTitle.TextColor3 = Color3.new(1,1,1)
infoTitle.Font = Enum.Font.SourceSansBold
infoTitle.TextSize = 18
infoTitle.TextXAlignment = Enum.TextXAlignment.Left
infoTitle.Parent = infoFrame

local infoExit = Instance.new("TextButton")
infoExit.Size = UDim2.new(0,30,0,30)
infoExit.Position = UDim2.new(1,-30,0,0)
infoExit.Text = "X"
infoExit.BackgroundColor3 = Color3.fromRGB(80,30,30)
infoExit.TextColor3 = Color3.new(1,0.3,0.3)
infoExit.Parent = infoFrame

-- 🔎 Search Bar
local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(0.7,-10,0,30)
searchBox.Position = UDim2.new(0,5,0,35)
searchBox.PlaceholderText = "Search..."
searchBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
searchBox.TextColor3 = Color3.new(1,1,1)
searchBox.Font = Enum.Font.SourceSans
searchBox.TextSize = 16
searchBox.ClearTextOnFocus = false
searchBox.Parent = infoFrame

-- 🔄 Search Mode Toggle
local searchModeBtn = Instance.new("TextButton")
searchModeBtn.Size = UDim2.new(0.3,-10,0,30)
searchModeBtn.Position = UDim2.new(0.7,5,0,35)
searchModeBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
searchModeBtn.TextColor3 = Color3.new(1,1,1)
searchModeBtn.Font = Enum.Font.SourceSansBold
searchModeBtn.TextSize = 14
searchModeBtn.Text = "Mode: Name"
searchModeBtn.Parent = infoFrame

local searchMode = "Name"
searchModeBtn.MouseButton1Click:Connect(function()
	if searchMode == "Name" then
		searchMode = "Type"
		searchModeBtn.Text = "Mode: Type"
	else
		searchMode = "Name"
		searchModeBtn.Text = "Mode: Name"
	end
end)

-- Results Scrolling Frame
local infoScroll = Instance.new("ScrollingFrame")
infoScroll.Size = UDim2.new(1,-10,1,-120)
infoScroll.Position = UDim2.new(0,5,0,70)
infoScroll.CanvasSize = UDim2.new(0,0,0,0)
infoScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
infoScroll.ScrollBarThickness = 8
infoScroll.BackgroundTransparency = 1
infoScroll.Parent = infoFrame

local infoLayout = Instance.new("UIListLayout")
infoLayout.Parent = infoScroll
infoLayout.SortOrder = Enum.SortOrder.LayoutOrder

local selectedObject

local function addLine(obj, text, indent)
	local lbl = Instance.new("TextButton")
	lbl.Size = UDim2.new(1, -10, 0, 20)
	lbl.BackgroundTransparency = 1
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Font = Enum.Font.Code
	lbl.TextSize = 14
	lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
	lbl.Text = string.rep("   ", indent or 0) .. text
	lbl.Parent = infoScroll

	lbl.MouseButton1Click:Connect(function()
		selectedObject = obj
		for _, c in ipairs(infoScroll:GetChildren()) do
			if c:IsA("TextButton") then
				c.TextColor3 = Color3.fromRGB(200, 200, 200)
			end
		end
		lbl.TextColor3 = Color3.fromRGB(100, 255, 100)
	end)
end

local function matchesSearch(obj)
	local keyword = searchBox.Text:lower()
	if keyword == "" then return true end

	if searchMode == "Name" then
		return obj.Name:lower():find(keyword) ~= nil
	elseif searchMode == "Type" then
		return obj.ClassName:lower():find(keyword) ~= nil
	end
	return true
end

local function scanChildren(parent, indent, maxDepth)
	if indent > (maxDepth or 3) then return end
	for _, child in ipairs(parent:GetChildren()) do
		if matchesSearch(child) then
			addLine(child, child.Name .. " (" .. child.ClassName .. ")", indent)
		end
		scanChildren(child, indent + 1, maxDepth)
	end
end

local function scanGame()
	for _, c in ipairs(infoScroll:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end
	selectedObject = nil

	addLine(nil, "🔍 Client Scan Results", 0)
	addLine(nil, "", 0)

	addLine(nil, "Workspace:", 0)
	scanChildren(workspace, 1, 3)

	addLine(nil, "", 0)
	addLine(nil, "Players:", 0)
	for _, p in ipairs(Players:GetPlayers()) do
		if matchesSearch(p) then
			addLine(p, p.Name .. " (Player)", 1)
		end
	end

	addLine(nil, "", 0)
	addLine(nil, "ReplicatedStorage:", 0)
	scanChildren(game.ReplicatedStorage, 1, 3)

	addLine(nil, "", 0)
	addLine(nil, "Your PlayerGui:", 0)
	scanChildren(player.PlayerGui, 1, 2)
end

infoBtn.MouseButton1Click:Connect(function()
	scanGame()
	infoFrame.Visible = true
end)

infoExit.MouseButton1Click:Connect(function()
	infoFrame.Visible = false
end)

-- Remove Button
local removeBtn = Instance.new("TextButton")
removeBtn.Size = UDim2.new(0, 120, 0, 35)
removeBtn.Position = UDim2.new(0.5, -60, 1, -40)
removeBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
removeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
removeBtn.Text = "Remove"
removeBtn.Parent = infoFrame

removeBtn.MouseButton1Click:Connect(function()
	if selectedObject and selectedObject.Parent then
		selectedObject:Destroy()
		selectedObject = nil
		scanGame()
	end
end)

-- Auto refresh search
searchBox:GetPropertyChangedSignal("Text"):Connect(scanGame)

-----------------------------------------------------
-- TRACK PLAYERS (BillboardGui, Client Only)
-----------------------------------------------------
local tracking = false
local connections = {}

local function createBillboard(forPlayer)
	if not forPlayer.Character then return end
	local head = forPlayer.Character:FindFirstChild("Head")
	if not head then return end
	if head:FindFirstChild("HPHatsTag") then return end
	
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "HPHatsTag"
	billboard.Size = UDim2.new(0,200,0,50)
	billboard.StudsOffset = Vector3.new(0,3,0)
	billboard.AlwaysOnTop = true
	billboard.Parent = head
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1,0,1,0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1,1,1)
	label.Font = Enum.Font.SourceSansBold
	label.TextSize = 16
	label.Text = forPlayer.Name
	label.Parent = billboard
	
	local conn
	conn = RunService.RenderStepped:Connect(function()
		if not billboard.Parent then
			if conn then conn:Disconnect() end
			return
		end
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and forPlayer.Character and forPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local dist = (player.Character.HumanoidRootPart.Position - forPlayer.Character.HumanoidRootPart.Position).Magnitude
			label.Text = forPlayer.Name.." ("..math.floor(dist).." studs)"
		end
	end)
	table.insert(connections, conn)
end

local function removeBillboard(forPlayer)
	if forPlayer.Character and forPlayer.Character:FindFirstChild("Head") then
		local tag = forPlayer.Character.Head:FindFirstChild("HPHatsTag")
		if tag then tag:Destroy() end
	end
end

highlightBtn.MouseButton1Click:Connect(function()
	tracking = not tracking
	if tracking then
		for _,p in ipairs(Players:GetPlayers()) do
			if p ~= player then
				createBillboard(p)
				p.CharacterAdded:Connect(function()
					task.wait(1)
					createBillboard(p)
				end)
			end
		end
	else
		for _,p in ipairs(Players:GetPlayers()) do
			removeBillboard(p)
		end
		for _,c in ipairs(connections) do
			if c.Connected then
				c:Disconnect()
			end
		end
		connections = {}
	end
end)
