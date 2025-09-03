--!strict
-- This script combines two separate LocalScripts into a single, comprehensive utility panel.
-- It should be placed in StarterPlayerScripts.

local Players = game:GetService("Players")
local LogService = game:GetService("LogService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- 🧹 Remove any existing GUI to prevent duplicates
for _, gui in ipairs(playerGui:GetChildren()) do
	if gui:IsA("ScreenGui") and (gui.Name == "Lilcat Cheat" or gui.Name == "CustomMenu") then
		gui:Destroy()
	end
end

-- Create the main GUI
local mainGui = Instance.new("ScreenGui")
mainGui.Name = "UtilityPanel"
mainGui.ResetOnSpawn = false
mainGui.Parent = playerGui

--
-- UI Design Constants
--
local ACCENT_COLOR = Color3.fromRGB(85, 170, 255) -- A clean blue
local DARK_BACKGROUND = Color3.fromRGB(25, 25, 25)
local MEDIUM_BACKGROUND = Color3.fromRGB(40, 40, 40)
local LIGHT_BACKGROUND = Color3.fromRGB(55, 55, 55)
local ERROR_COLOR = Color3.fromRGB(255, 80, 80)
local SUCCESS_COLOR = Color3.fromRGB(100, 255, 100)

local FONT = Enum.Font.SourceSansBold
local HEADER_FONT_SIZE = 18
local BODY_FONT_SIZE = 16
local BORDER_RADIUS = UDim.new(0, 8)
local PADDING = UDim.new(0, 10)

--
-- Main Panel
--
local function createPanel(name: string, size: UDim2, position: UDim2, isDraggable: boolean): Frame
	local panel = Instance.new("Frame")
	panel.Name = name
	panel.Size = size
	panel.Position = position
	panel.BackgroundColor3 = DARK_BACKGROUND
	panel.Active = isDraggable
	panel.Draggable = isDraggable
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = BORDER_RADIUS
	corner.Parent = panel

	local titleBar = Instance.new("TextLabel")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 30)
	titleBar.BackgroundColor3 = MEDIUM_BACKGROUND
	titleBar.Text = name
	titleBar.Font = FONT
	titleBar.TextSize = HEADER_FONT_SIZE
	titleBar.TextColor3 = ACCENT_COLOR
	titleBar.Parent = panel
	
	-- Close Button
	local closeBtn = Instance.new("TextButton")
	closeBtn.Name = "CloseButton"
	closeBtn.Size = UDim2.new(0, 30, 0, 30)
	closeBtn.Position = UDim2.new(1, -30, 0, 0)
	closeBtn.Text = "X"
	closeBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
	closeBtn.TextColor3 = ERROR_COLOR
	closeBtn.Font = FONT
	closeBtn.TextSize = 20
	closeBtn.AutoButtonColor = true
	closeBtn.Parent = titleBar
	closeBtn.MouseButton1Click:Connect(function()
		panel.Visible = false
	end)
	
	return panel
end

local function createButton(text: string, parent: Frame): TextButton
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 35)
	btn.BackgroundColor3 = MEDIUM_BACKGROUND
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Text = text
	btn.Font = FONT
	btn.TextSize = BODY_FONT_SIZE
	btn.AutoButtonColor = true
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = BORDER_RADIUS
	corner.Parent = btn
	
	btn.Parent = parent
	return btn
end

local mainPanel = createPanel("Utility Panel", UDim2.new(0, 220, 0, 250), UDim2.new(0, 20, 0.2, 0), true)
mainPanel.Parent = mainGui
mainPanel.TitleBar.Text = "Nexus Utility" -- New name for a fresh look

local buttonLayout = Instance.new("UIListLayout")
buttonLayout.Padding = UDim.new(0, 5)
buttonLayout.FillDirection = Enum.FillDirection.Vertical
buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
buttonLayout.VerticalAlignment = Enum.VerticalAlignment.Center
buttonLayout.Parent = mainPanel

local function createUtilityButton(text: string, icon: string?): TextButton
	local btn = createButton(text, mainPanel)
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.LayoutOrder = mainPanel.UIListLayout.AbsoluteContentSize.Y + 1
	return btn
end

local devLogBtn = createUtilityButton("Toggle Dev Log", "log")
local infoScanBtn = createUtilityButton("Info Scanner", "info")
local playerTrackBtn = createUtilityButton("Track Players", "track")
local flyBtn = createUtilityButton("Fly Mode", "fly")
local espBtn = createUtilityButton("ESP Players", "esp")
local tweenBtn = createUtilityButton("Tween to Player", "tween")

--
-- Dev Log Window
--
local devLogFrame = createPanel("Developer Log", UDim2.new(0, 450, 0, 300), UDim2.new(0.3, 0, 0.2, 0), true)
devLogFrame.Parent = mainGui
devLogFrame.Visible = false

local logScroll = Instance.new("ScrollingFrame")
logScroll.Size = UDim2.new(1, -20, 1, -40)
logScroll.Position = UDim2.new(0, 10, 0, 35)
logScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
logScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
logScroll.ScrollBarThickness = 8
logScroll.BackgroundTransparency = 1
logScroll.Parent = devLogFrame

local logLayout = Instance.new("UIListLayout")
logLayout.Parent = logScroll
logLayout.SortOrder = Enum.SortOrder.LayoutOrder
logLayout.Padding = UDim.new(0, 2)

local function addLog(message: string, color: Color3)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -5, 0, 20)
	label.BackgroundTransparency = 1
	label.Text = message
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextColor3 = color
	label.Font = Enum.Font.Code
	label.TextSize = 14
	label.Parent = logScroll
	logScroll.CanvasPosition = Vector2.new(0, logScroll.CanvasSize.Y.Offset)
end

LogService.MessageOut:Connect(function(message, msgType)
	if not devLogFrame.Visible or message:find("CorePackages") or message:find("CoreGui") then
		return
	end
	
	if msgType == Enum.MessageType.MessageOutput then
		addLog("[PRINT] "..message, Color3.fromRGB(200, 200, 200))
	elseif msgType == Enum.MessageType.MessageWarning then
		addLog("[WARN] "..message, Color3.fromRGB(255, 200, 0))
	elseif msgType == Enum.MessageType.MessageError then
		addLog("[ERROR] "..message, ERROR_COLOR)
	end
end)

devLogBtn.MouseButton1Click:Connect(function()
	devLogFrame.Visible = not devLogFrame.Visible
end)

--
-- Info Scanner Window
--
local infoFrame = createPanel("Info Scanner", UDim2.new(0, 500, 0, 400), UDim2.new(0.35, 0, 0.25, 0), true)
infoFrame.Parent = mainGui
infoFrame.Visible = false

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(0.7, -10, 0, 30)
searchBox.Position = UDim2.new(0, 10, 0, 35)
searchBox.PlaceholderText = "Search..."
searchBox.BackgroundColor3 = MEDIUM_BACKGROUND
searchBox.TextColor3 = Color3.new(1, 1, 1)
searchBox.Font = FONT
searchBox.TextSize = BODY_FONT_SIZE
searchBox.ClearTextOnFocus = false
searchBox.Parent = infoFrame

local searchModeBtn = Instance.new("TextButton")
searchModeBtn.Size = UDim2.new(0.3, -10, 0, 30)
searchModeBtn.Position = UDim2.new(0.7, 5, 0, 35)
searchModeBtn.BackgroundColor3 = LIGHT_BACKGROUND
searchModeBtn.TextColor3 = ACCENT_COLOR
searchModeBtn.Font = FONT
searchModeBtn.TextSize = 14
searchModeBtn.Text = "Mode: Name"
searchModeBtn.Parent = infoFrame

local infoScroll = Instance.new("ScrollingFrame")
infoScroll.Size = UDim2.new(1, -20, 1, -120)
infoScroll.Position = UDim2.new(0, 10, 0, 70)
infoScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
infoScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
infoScroll.ScrollBarThickness = 8
infoScroll.BackgroundTransparency = 1
infoScroll.Parent = infoFrame

local infoLayout = Instance.new("UIListLayout")
infoLayout.Parent = infoScroll
infoLayout.SortOrder = Enum.SortOrder.LayoutOrder

local selectedObject: Instance?

local searchMode = "Name"
searchModeBtn.MouseButton1Click:Connect(function()
	searchMode = (searchMode == "Name" and "Type") or "Name"
	searchModeBtn.Text = "Mode: " .. searchMode
	task.spawn(function()
		infoScanBtn.MouseButton1Click:Fire()
	end)
end)

local function addLine(obj: Instance?, text: string, indent: number?)
	local lbl = Instance.new("TextButton")
	lbl.Size = UDim2.new(1, -10, 0, 20)
	lbl.BackgroundTransparency = 1
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Font = Enum.Font.Code
	lbl.TextSize = 14
	lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
	lbl.Text = string.rep("  ", indent or 0) .. text
	lbl.Parent = infoScroll

	lbl.MouseButton1Click:Connect(function()
		selectedObject = obj
		for _, c in ipairs(infoScroll:GetChildren()) do
			if c:IsA("TextButton") then
				c.TextColor3 = Color3.fromRGB(200, 200, 200)
			end
		end
		lbl.TextColor3 = SUCCESS_COLOR
	end)
end

local function matchesSearch(obj: Instance): boolean
	local keyword = searchBox.Text:lower()
	if keyword == "" then
		return true
	end
	if searchMode == "Name" then
		return string.find(obj.Name:lower(), keyword, 1, true) ~= nil
	elseif searchMode == "Type" then
		return string.find(obj.ClassName:lower(), keyword, 1, true) ~= nil
	end
	return true
end

local function scanChildren(parent: Instance, indent: number, maxDepth: number)
	if indent > maxDepth then return end
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
	addLine(nil, "---", 0)

	addLine(nil, "Workspace:", 0)
	scanChildren(workspace, 1, 3)

	addLine(nil, "Players:", 0)
	for _, p in ipairs(Players:GetPlayers()) do
		if matchesSearch(p) then
			addLine(p, p.Name .. " (Player)", 1)
		end
	end

	addLine(nil, "ReplicatedStorage:", 0)
	scanChildren(game.ReplicatedStorage, 1, 3)

	addLine(nil, "Your PlayerGui:", 0)
	scanChildren(player.PlayerGui, 1, 2)
end

infoScanBtn.MouseButton1Click:Connect(function()
	infoFrame.Visible = not infoFrame.Visible
	if infoFrame.Visible then
		scanGame()
	end
end)

local removeBtn = createButton("Remove Selected", infoFrame)
removeBtn.Size = UDim2.new(1, -20, 0, 35)
removeBtn.Position = UDim2.new(0, 10, 1, -40)
removeBtn.BackgroundColor3 = ERROR_COLOR
removeBtn.TextColor3 = Color3.new(1, 1, 1)
removeBtn.MouseButton1Click:Connect(function()
	if selectedObject and selectedObject.Parent and not selectedObject:IsA("Player") then
		selectedObject:Destroy()
		selectedObject = nil
		scanGame()
	end
end)

searchBox:GetPropertyChangedSignal("Text"):Connect(scanGame)

--
-- Fly Mode
--
local flyFrame = createPanel("Fly Controls", UDim2.new(0, 220, 0, 140), UDim2.new(0, 260, 0.2, 0), true)
flyFrame.Parent = mainGui
flyFrame.Visible = false

local speedBox = Instance.new("TextBox", flyFrame)
speedBox.Size = UDim2.new(1, -20, 0, 40)
speedBox.Position = UDim2.new(0, 10, 0, 35)
speedBox.PlaceholderText = "Fly Speed (Default: 50)"
speedBox.BackgroundColor3 = MEDIUM_BACKGROUND
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.Font = FONT
speedBox.TextSize = BODY_FONT_SIZE

local flyToggleBtn = createButton("Toggle Fly", flyFrame)
flyToggleBtn.Size = UDim2.new(1, -20, 0, 40)
flyToggleBtn.Position = UDim2.new(0, 10, 0, 85)

local flying = false
local flySpeed = 50
local flyInput = { Forward = 0, Right = 0, Up = 0 }

flyToggleBtn.MouseButton1Click:Connect(function()
	flying = not flying
	flyToggleBtn.Text = "Fly: " .. (flying and "ON") or "OFF"
	if not flying then
		hrp.AssemblyLinearVelocity = Vector3.zero
	end
end)

speedBox.FocusLost:Connect(function()
	local val = tonumber(speedBox.Text)
	if val then
		flySpeed = val
	end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then return end
	if input.KeyCode == Enum.KeyCode.W then flyInput.Forward = 1 end
	if input.KeyCode == Enum.KeyCode.S then flyInput.Forward = -1 end
	if input.KeyCode == Enum.KeyCode.D then flyInput.Right = 1 end
	if input.KeyCode == Enum.KeyCode.A then flyInput.Right = -1 end
	if input.KeyCode == Enum.KeyCode.Space then flyInput.Up = 1 end
	if input.KeyCode == Enum.KeyCode.LeftShift then flyInput.Up = -1 end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then return end
	if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.S then flyInput.Forward = 0 end
	if input.KeyCode == Enum.KeyCode.D or input.KeyCode == Enum.KeyCode.A then flyInput.Right = 0 end
	if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.LeftShift then flyInput.Up = 0 end
end)

RunService.RenderStepped:Connect(function()
	if flying then
		local camCF = camera.CFrame
		local dir = (camCF.LookVector * flyInput.Forward) + (camCF.RightVector * flyInput.Right) + (Vector3.yAxis * flyInput.Up)
		if dir.Magnitude > 0 then
			dir = dir.Unit
		end
		hrp.AssemblyLinearVelocity = dir * flySpeed
	end
end)

flyBtn.MouseButton1Click:Connect(function()
	flyFrame.Visible = not flyFrame.Visible
end)

--
-- ESP & Player Tracking
--
local function createBillboard(targetPlayer: Player, isTracking: boolean)
	local char = targetPlayer.Character
	if not char then return end
	local head = char:FindFirstChild("Head")
	if not head then return end
	
	local existingTag = head:FindFirstChild("UtilityTag")
	if existingTag then existingTag:Destroy() end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "UtilityTag"
	billboard.Adornee = head
	billboard.Size = UDim2.new(0, 200, 0, 50)
	billboard.AlwaysOnTop = true
	billboard.StudsOffset = Vector3.new(0, 3, 0)
	billboard.Parent = head
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = targetPlayer.Name
	label.TextColor3 = isTracking and ACCENT_COLOR or SUCCESS_COLOR
	label.TextStrokeTransparency = 0.2
	label.Font = FONT
	label.TextSize = 16
	label.TextWrapped = true
	label.Parent = billboard
	
	if isTracking then
		local conn
		conn = RunService.RenderStepped:Connect(function()
			if not billboard.Parent or not player.Character then
				if conn then conn:Disconnect() end
				return
			end
			local dist = (player.Character.HumanoidRootPart.Position - head.Position).Magnitude
			label.Text = targetPlayer.Name .. " (" .. math.floor(dist) .. " studs)"
		end)
	end
end

local function removeBillboards()
	for _, p in ipairs(Players:GetPlayers()) do
		if p.Character and p.Character:FindFirstChild("Head") then
			local tag = p.Character.Head:FindFirstChild("UtilityTag")
			if tag then tag:Destroy() end
		end
	end
end

playerTrackBtn.MouseButton1Click:Connect(function()
	removeBillboards()
	playerTrackBtn.Text = (playerTrackBtn.Text == "Track Players" and "Tracking: ON") or "Track Players"
	if playerTrackBtn.Text == "Tracking: ON" then
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= player then
				createBillboard(p, true)
				p.CharacterAdded:Connect(function()
					task.wait(1)
					createBillboard(p, true)
				end)
			end
		end
	end
end)

espBtn.MouseButton1Click:Connect(function()
	removeBillboards()
	espBtn.Text = (espBtn.Text == "ESP Players" and "ESP: ON") or "ESP Players"
	if espBtn.Text == "ESP: ON" then
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= player then
				createBillboard(p, false)
				p.CharacterAdded:Connect(function()
					task.wait(1)
					createBillboard(p, false)
				end)
			end
		end
	end
end)

--
-- Tween to Player
--
local tweenFrame = createPanel("Tween to Player", UDim2.new(0, 220, 0, 300), UDim2.new(0, 480, 0.2, 0), true)
tweenFrame.Parent = mainGui
tweenFrame.Visible = false

local tweenScroll = Instance.new("ScrollingFrame", tweenFrame)
tweenScroll.Size = UDim2.new(1, -20, 1, -40)
tweenScroll.Position = UDim2.new(0, 10, 0, 35)
tweenScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
tweenScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
tweenScroll.BackgroundTransparency = 1
tweenScroll.BorderSizePixel = 0
tweenScroll.ScrollBarThickness = 5

local tweenLayout = Instance.new("UIListLayout", tweenScroll)
tweenLayout.Padding = UDim.new(0, 5)
tweenLayout.SortOrder = Enum.SortOrder.Name

local function makePlayerButton(plr: Player): TextButton
	local btn = createButton(plr.Name, tweenScroll)
	btn.Size = UDim2.new(1, -5, 0, 35)
	
	btn.MouseButton1Click:Connect(function()
		if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local targetHRP = plr.Character.HumanoidRootPart
			local tween = TweenService:Create(hrp, TweenInfo.new(1.5, Enum.EasingStyle.Cubic), {
				CFrame = targetHRP.CFrame * CFrame.new(0, 3, 0)
			})
			tween:Play()
		end
	end)
	return btn
end

local function refreshTweenMenu()
	for _, child in ipairs(tweenScroll:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end
	
	local playersInGame = Players:GetPlayers()
	for _, plr in ipairs(playersInGame) do
		if plr ~= player then
			makePlayerButton(plr)
		end
	end
	tweenScroll.CanvasSize = UDim2.new(0, 0, 0, (#playersInGame - 1) * 40 + tweenLayout.Padding.Offset * #playersInGame)
end

tweenBtn.MouseButton1Click:Connect(function()
	tweenFrame.Visible = not tweenFrame.Visible
	if tweenFrame.Visible then
		refreshTweenMenu()
	end
end)

Players.PlayerAdded:Connect(function()
	if tweenFrame.Visible then
		refreshTweenMenu()
	end
end)

Players.PlayerRemoving:Connect(function()
	if tweenFrame.Visible then
		refreshTweenMenu()
	end
end)
