-- Lilcat Cheat Utility Panel
-- Place in StarterPlayerScripts

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "LilcatCheat"
gui.ResetOnSpawn = false

-- Colors
local BG_COLOR = Color3.fromRGB(30, 30, 30)
local BTN_COLOR = Color3.fromRGB(50, 50, 50)
local ACCENT_COLOR = Color3.fromRGB(85, 170, 255)
local ERROR_COLOR = Color3.fromRGB(255, 80, 80)

-- Main frame
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 220, 0, 320)
mainFrame.Position = UDim2.new(0, 20, 0.2, 0)
mainFrame.BackgroundColor3 = BG_COLOR
mainFrame.Active = true
mainFrame.Draggable = true

local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 8)

-- Title bar
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

-- Button list
local buttonHolder = Instance.new("Frame", mainFrame)
buttonHolder.Size = UDim2.new(1, -20, 1, -45)
buttonHolder.Position = UDim2.new(0, 10, 0, 40)
buttonHolder.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", buttonHolder)
layout.Padding = UDim.new(0, 5)

local function createButton(name)
	local btn = Instance.new("TextButton", buttonHolder)
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.BackgroundColor3 = BTN_COLOR
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Text = name
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 16
	local c = Instance.new("UICorner", btn)
	c.CornerRadius = UDim.new(0, 8)
	return btn
end

-- === Buttons ===
local flyBtn = createButton("Fly Mode")
local espBtn = createButton("ESP (Names)")
local trackBtn = createButton("Tracking (Studs)")
local tweenBtn = createButton("Tween to Player")

-------------------------------------------------
-- Fly Mode Window
-------------------------------------------------
local flyFrame = Instance.new("Frame", gui)
flyFrame.Size = UDim2.new(0, 220, 0, 140)
flyFrame.Position = UDim2.new(0, 260, 0.2, 0)
flyFrame.BackgroundColor3 = BG_COLOR
flyFrame.Visible = false
Instance.new("UICorner", flyFrame).CornerRadius = UDim.new(0, 8)

local speedBox = Instance.new("TextBox", flyFrame)
speedBox.Size = UDim2.new(1, -20, 0, 40)
speedBox.Position = UDim2.new(0, 10, 0, 10)
speedBox.PlaceholderText = "Fly Speed (Default: 50)"
speedBox.BackgroundColor3 = BTN_COLOR
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.Font = Enum.Font.SourceSansBold
speedBox.TextSize = 16

local flyToggle = createButton("Toggle Fly")
flyToggle.Parent = flyFrame
flyToggle.Position = UDim2.new(0, 10, 0, 60)
flyToggle.Size = UDim2.new(1, -20, 0, 40)

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
	if flying then
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
-- ESP & Tracking
-------------------------------------------------
local function createBillboard(plr, showDist)
	if not plr.Character then return end
	local head = plr.Character:FindFirstChild("Head")
	if not head then return end
	local old = head:FindFirstChild("ESPTag")
	if old then old:Destroy() end

	local bb = Instance.new("BillboardGui", head)
	bb.Name = "ESPTag"
	bb.Size = UDim2.new(0,200,0,50)
	bb.StudsOffset = Vector3.new(0,3,0)
	bb.AlwaysOnTop = true
	bb.Adornee = head

	local lbl = Instance.new("TextLabel", bb)
	lbl.Size = UDim2.new(1,0,1,0)
	lbl.BackgroundTransparency=1
	lbl.Font = Enum.Font.SourceSansBold
	lbl.TextColor3 = Color3.new(1,0,0)
	lbl.TextSize = 16
	lbl.Text = plr.Name

	if showDist then
		RunService.RenderStepped:Connect(function()
			if plr.Character and player.Character then
				local myHRP = player.Character:FindFirstChild("HumanoidRootPart")
				local theirHRP = plr.Character:FindFirstChild("HumanoidRootPart")
				if myHRP and theirHRP then
					local dist = (myHRP.Position - theirHRP.Position).Magnitude
					lbl.Text = plr.Name.." ["..math.floor(dist).." studs]"
				end
			end
		end)
	end
end

local function clearESP()
	for _,p in ipairs(Players:GetPlayers()) do
		if p.Character and p.Character:FindFirstChild("Head") then
			local tag = p.Character.Head:FindFirstChild("ESPTag")
			if tag then tag:Destroy() end
		end
	end
end

espBtn.MouseButton1Click:Connect(function()
	clearESP()
	for _,p in ipairs(Players:GetPlayers()) do
		if p ~= player then
			createBillboard(p,false)
		end
	end
end)

trackBtn.MouseButton1Click:Connect(function()
	clearESP()
	for _,p in ipairs(Players:GetPlayers()) do
		if p ~= player then
			createBillboard(p,true)
		end
	end
end)

-------------------------------------------------
-- Tween to Player
-------------------------------------------------
local tweenFrame = Instance.new("Frame", gui)
tweenFrame.Size = UDim2.new(0,220,0,300)
tweenFrame.Position = UDim2.new(0,480,0.2,0)
tweenFrame.BackgroundColor3 = BG_COLOR
tweenFrame.Visible = false
Instance.new("UICorner",tweenFrame).CornerRadius = UDim.new(0,8)

local scroll = Instance.new("ScrollingFrame", tweenFrame)
scroll.Size = UDim2.new(1,-10,1,-10)
scroll.Position = UDim2.new(0,5,0,5)
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
			local btn = createButton(plr.Name)
			btn.Parent = scroll
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
