-- Lilcat Cheat Utility Panel + Admin Log
-- Place in StarterPlayerScripts

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LogService = game:GetService("LogService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "LilcatCheat"
gui.ResetOnSpawn = false

-- Colors
local BG_COLOR = Color3.fromRGB(30, 30, 30)
local BTN_COLOR = Color3.fromRGB(50, 50, 50)
local ACCENT_COLOR = Color3.fromRGB(85, 170, 255)
local ERROR_COLOR = Color3.fromRGB(255, 80, 80)

-- Helper for draggable frames
local function makeDraggable(frame)
	frame.Active = true
	frame.Draggable = true
end

-- Main frame
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 220, 0, 320)
mainFrame.Position = UDim2.new(0, 20, 0.2, 0)
mainFrame.BackgroundColor3 = BG_COLOR
makeDraggable(mainFrame)
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

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
local logBtn = createButton("Admin Log")

-------------------------------------------------
-- Fly Mode Window
-------------------------------------------------
local flyFrame = Instance.new("Frame", gui)
flyFrame.Size = UDim2.new(0, 220, 0, 160)
flyFrame.Position = UDim2.new(0, 260, 0.2, 0)
flyFrame.BackgroundColor3 = BG_COLOR
flyFrame.Visible = false
makeDraggable(flyFrame)
Instance.new("UICorner", flyFrame).CornerRadius = UDim.new(0, 8)

local exitFly = Instance.new("TextButton", flyFrame)
exitFly.Size = UDim2.new(0, 30, 0, 30)
exitFly.Position = UDim2.new(1, -35, 0, 5)
exitFly.Text = "X"
exitFly.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
exitFly.TextColor3 = ERROR_COLOR
exitFly.Font = Enum.Font.SourceSansBold
exitFly.TextSize = 18
exitFly.MouseButton1Click:Connect(function()
	flyFrame.Visible = false
end)

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
-- Admin Log Frame
-------------------------------------------------
local logFrame = Instance.new("Frame", gui)
logFrame.Size = UDim2.new(0, 300, 0, 300)
logFrame.Position = UDim2.new(0, 700, 0.2, 0)
logFrame.BackgroundColor3 = BG_COLOR
logFrame.Visible = false
makeDraggable(logFrame)
Instance.new("UICorner", logFrame).CornerRadius = UDim.new(0, 8)

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

local scrolling = Instance.new("ScrollingFrame", logFrame)
scrolling.Size = UDim2.new(1, -10, 1, -10)
scrolling.Position = UDim2.new(0, 5, 0, 5)
scrolling.CanvasSize = UDim2.new(0,0,0,0)
scrolling.ScrollBarThickness = 5
scrolling.BackgroundTransparency = 1

local listLayout = Instance.new("UIListLayout", scrolling)
listLayout.Padding = UDim.new(0, 2)

-- Add logs
LogService.MessageOut:Connect(function(msg, msgType)
	local lbl = Instance.new("TextLabel", scrolling)
	lbl.Size = UDim2.new(1, -5, 0, 20)
	lbl.BackgroundTransparency = 1
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Font = Enum.Font.Code
	lbl.TextSize = 14
	lbl.TextColor3 = msgType == Enum.MessageType.MessageError and ERROR_COLOR or Color3.new(1,1,1)
	lbl.Text = msg
	scrolling.CanvasSize = UDim2.new(0,0,0,listLayout.AbsoluteContentSize.Y+10)
end)

logBtn.MouseButton1Click:Connect(function()
	logFrame.Visible = not logFrame.Visible
end)
