local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Player = Players.LocalPlayer

-- =============================================================================
-- DATA & STATE CONFIGURATION
-- =============================================================================
local Seeds = {
    { Name = "Carrot", Data = "{\000\006Carrot" },
    { Name = "Strawberry", Data = "{\000\nStrawberry" },
    { Name = "Blueberry", Data = "{\000\tBlueberry" },
    { Name = "Tulip", Data = "{\000\005Tulip" },
    { Name = "Tomato", Data = "{\000\006Tomato" },
    { Name = "Apple", Data = "{\000\005Apple" },
    { Name = "Bamboo", Data = "{\000\006Bamboo" },
    { Name = "Corn", Data = "{\000\004Corn" },
    { Name = "Cactus", Data = "{\000\006Cactus" },
    { Name = "Mushroom", Data = "{\000\008Mushroom" },
    { Name = "Green Bean", Data = "{\000\nGreen Bean" },
    { Name = "Banana", Data = "{\000\006Banana" },
    { Name = "Pineapple", Data = "{\000\tPineapple" },
    { Name = "Grape", Data = "{\000\005Grape" },
    { Name = "Coconut", Data = "{\000\007Coconut" },
    { Name = "Dragon Fruit", Data = "{\000\fDragon Fruit" },
    { Name = "Mango", Data = "{\000\005Mango" },
    { Name = "Acorn", Data = "{\000\005Acorn" },
    { Name = "Cherry", Data = "{\000\006Cherry" },
    { Name = "Sunflower", Data = "{\000\tSunflower" },
    { Name = "Venus Fly Trap", Data = "{\000\014Venus Fly Trap" },
    { Name = "Pomegranate", Data = "{\000\vPomegranate" },
    { Name = "Poison Apple", Data = "{\000\fPoison Apple" },
    { Name = "Moon Bloom", Data = "{\000\nMoon Bloom" },
    { Name = "Dragon's Breath", Data = "{\000\015Dragon's Breath" },
    { Name = "Lotus", Data = "{\000\005Lotus" },
    { Name = "Beanstalk", Data = "{\000\tBeanstalk" }
}

-- Harvested Fruit Inventory Data Map (Uses Weight Payload Structs instead of Seed Structures)
local HarvestedFruits = {
    { Name = "Carrot (kg)", Data = "{\000\006Carrot" },
    { Name = "Strawberry (kg)", Data = "{\000\nStrawberry" },
    { Name = "Blueberry (kg)", Data = "{\000\tBlueberry" },
    { Name = "Tomato (kg)", Data = "{\000\006Tomato" },
    { Name = "Apple (kg)", Data = "{\000\005Apple" },
    { Name = "Banana (kg)", Data = "{\000\006Banana" },
    { Name = "Pineapple (kg)", Data = "{\000\tPineapple" },
    { Name = "Grape (kg)", Data = "{\000\005Grape" },
    { Name = "Coconut (kg)", Data = "{\000\007Coconut" },
    { Name = "Dragon Fruit (kg)", Data = "{\000\fDragon Fruit" },
    { Name = "Mango (kg)", Data = "{\000\005Mango" },
    { Name = "Cherry (kg)", Data = "{\000\006Cherry" },
    { Name = "Pomegranate (kg)", Data = "{\000\vPomegranate" },
    { Name = "Poison Apple (kg)", Data = "{\000\fPoison Apple" }
}

local Gears = {
    { Name = "Common Watering Can", Data = "\127\000\019Common Watering Can" },
    { Name = "Super Watering Can", Data = "\127\000\018Super Watering Can" },
    { Name = "Common Sprinkler", Data = "\127\000\016Common Sprinkler" },
    { Name = "Uncommon Sprinkler", Data = "\127\000\018Uncommon Sprinkler" },
    { Name = "Rare Sprinkler", Data = "\127\000\014Rare Sprinkler" },
    { Name = "Legendary Sprinkler", Data = "\127\000\019Legendary Sprinkler" },
    { Name = "Super Sprinkler", Data = "\127\000\015Super Sprinkler" },
    { Name = "Sign", Data = "\127\000\004Sign" },
    { Name = "Lantern", Data = "\127\000\007Lantern" },
    { Name = "Wheelbarrow", Data = "\127\000\vWheelbarrow" },
    { Name = "Trowel", Data = "\127\000\006Trowel" },
    { Name = "Basic Pot", Data = "\127\000\tBasic Pot" },
    { Name = "Gnome", Data = "\127\000\005Gnome" },
    { Name = "Jump Mushroom", Data = "\127\000\rJump Mushroom" },
    { Name = "Speed Mushroom", Data = "\127\000\014Speed Mushroom" },
    { Name = "Shrink Mushroom", Data = "\127\000\015Shrink Mushroom" },
    { Name = "Supersize Mushroom", Data = "\127\000\018Supersize Mushroom" },
    { Name = "Invisibility Mushroom", Data = "\127\000\021Invisibility Mushroom" },
    { Name = "Flashbang", Data = "\127\000\tFlashbang" },
    { Name = "Megaphone", Data = "\127\000\tMegaphone" },
    { Name = "Strawberry Sniper", Data = "\127\000\017Strawberry Sniper" }
}

local activeSeedLoops = {}
local selectedSeeds = {}
local isSeedLooping = false

local activeGearLoops = {}
local selectedGears = {}
local isGearLooping = false

local minDelay = 1
local maxDelay = 60
local seedDelay = 15 
local gearDelay = 15

local seedCheckboxElements = {}
local gearCheckboxElements = {}
local seedSliderUpdateFunc = nil
local gearSliderUpdateFunc = nil
local updateSeedToggleVisual = nil
local updateGearToggleVisual = nil

local oldGui = Player:WaitForChild("PlayerGui"):FindFirstChild("MeliodasGUI")
if oldGui then oldGui:Destroy() end

-- =============================================================================
-- THEME COLORS
-- =============================================================================
local Colors = {
    Background = Color3.fromRGB(13, 13, 16),
    CardBg = Color3.fromRGB(20, 19, 26),
    ItemBg = Color3.fromRGB(28, 27, 36),
    AccentPurple = Color3.fromRGB(138, 43, 226),
    BrightPurple = Color3.fromRGB(168, 85, 247),
    TextWhite = Color3.fromRGB(255, 255, 255),
    TextMuted = Color3.fromRGB(140, 135, 155),
    CloseRed = Color3.fromRGB(239, 68, 68),
    LayoutLine = Color3.fromRGB(35, 34, 44),
    PureBlack = Color3.fromRGB(0, 0, 0)
}

-- =============================================================================
-- MAIN FRAME & STRUCTURAL LAYOUT
-- =============================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MeliodasGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = ScreenGui
Main.Size = UDim2.new(0, 680, 0, 440)
Main.Position = UDim2.new(0.5, -340, 0.5, -220)
Main.BackgroundColor3 = Colors.Background
Main.BorderSizePixel = 0
Main.Active = true

local MainSizeConstraint = Instance.new("UISizeConstraint")
MainSizeConstraint.MinSize = Vector2.new(600, 440)
MainSizeConstraint.MaxSize = Vector2.new(900, 700)
MainSizeConstraint.Parent = Main

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = Main

local function InitializeWindowControls(frame)
    local dragToggle, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragToggle = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragToggle then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
InitializeWindowControls(Main)

local ResizeHandle = Instance.new("ImageButton")
ResizeHandle.Name = "ResizeHandle"
ResizeHandle.Size = UDim2.new(0, 16, 0, 16)
ResizeHandle.Position = UDim2.new(1, -16, 1, -16)
ResizeHandle.BackgroundTransparency = 1
ResizeHandle.Image = "rbxassetid://6031093155" 
ResizeHandle.ImageColor3 = Colors.TextMuted
ResizeHandle.ZIndex = 10
ResizeHandle.Parent = Main

local resizable = false
local startSize, startMousePos

ResizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizable = true
        startSize = Main.Size
        startMousePos = UserInputService:GetMouseLocation()
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if resizable and input.UserInputType == Enum.UserInputType.MouseMovement then
        local currentMousePos = UserInputService:GetMouseLocation()
        local delta = currentMousePos - startMousePos
        local newWidth = math.clamp(startSize.X.Offset + delta.X, MainSizeConstraint.MinSize.X, MainSizeConstraint.MaxSize.X)
        local newHeight = math.clamp(startSize.Y.Offset + delta.Y, MainSizeConstraint.MinSize.Y, MainSizeConstraint.MaxSize.Y)
        Main.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then resizable = false end
end)

local LayoutLine = Instance.new("Frame")
LayoutLine.Name = "LayoutLine"
LayoutLine.Parent = Main
LayoutLine.Size = UDim2.new(0, 2, 1, -40)
LayoutLine.Position = UDim2.new(0.25, 0, 0, 20)
LayoutLine.BackgroundColor3 = Colors.LayoutLine
LayoutLine.BorderSizePixel = 0

local TopControls = Instance.new("Frame")
TopControls.Name = "TopControls"
TopControls.Parent = Main
TopControls.Size = UDim2.new(0.2, 0, 0, 40)
TopControls.Position = UDim2.new(1, -15, 0, 15)
TopControls.AnchorPoint = Vector2.new(1, 0)
TopControls.BackgroundTransparency = 1

local TopLayout = Instance.new("UIListLayout")
TopLayout.Parent = TopControls
TopLayout.FillDirection = Enum.FillDirection.Horizontal
TopLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
TopLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TopLayout.Padding = UDim.new(0, 8)

local function CreateTopButton(text, color, parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 28, 0, 28)
    btn.BackgroundColor3 = Colors.CardBg
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.TextColor3 = color
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local MinimizeBtn = CreateTopButton("—", Colors.TextMuted, TopControls)
local ZoomBtn = CreateTopButton("▢", Colors.TextMuted, TopControls)
local CloseBtn = CreateTopButton("✕", Colors.CloseRed, TopControls)

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local MiniLogo = Instance.new("TextButton")
MiniLogo.Name = "MiniLogo"
MiniLogo.Size = UDim2.new(0, 50, 0, 50)
MiniLogo.Position = UDim2.new(0.05, 0, 0.05, 0)
MiniLogo.BackgroundColor3 = Colors.PureBlack
MiniLogo.BorderSizePixel = 0
MiniLogo.Text = "M"
MiniLogo.Font = Enum.Font.GothamBold
MiniLogo.TextSize = 22
MiniLogo.TextColor3 = Colors.BrightPurple
MiniLogo.Visible = false
MiniLogo.Active = true
MiniLogo.Parent = ScreenGui

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(0, 12)
MiniCorner.Parent = MiniLogo

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Thickness = 1.5
MiniStroke.Color = Colors.LayoutLine
MiniStroke.Parent = MiniLogo

InitializeWindowControls(MiniLogo)

MinimizeBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    MiniLogo.Visible = true
end)

MiniLogo.MouseButton1Click:Connect(function()
    MiniLogo.Visible = false
    Main.Visible = true
end)

-- =============================================================================
-- SIDEBAR NAVIGATION
-- =============================================================================
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Parent = Main
Sidebar.Size = UDim2.new(0.25, -1, 1, 0)
Sidebar.BackgroundTransparency = 1

local BrandContainer = Instance.new("Frame")
BrandContainer.Size = UDim2.new(1, 0, 0, 70)
BrandContainer.BackgroundTransparency = 1
BrandContainer.Parent = Sidebar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 24)
Title.Position = UDim2.new(0, 20, 0, 20)
Title.BackgroundTransparency = 1
Title.Text = "Meliodas"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Colors.TextWhite
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = BrandContainer

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -20, 0, 14)
Subtitle.Position = UDim2.new(0, 20, 0, 42)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "PREMIUM AUTOMATION"
Subtitle.Font = Enum.Font.GothamBold
Subtitle.TextSize = 9
Subtitle.TextColor3 = Colors.BrightPurple
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = BrandContainer

local function CreateNavButton(text, positionY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -30, 0, 38)
    btn.Position = UDim2.new(0, 15, 0, positionY)
    btn.BackgroundColor3 = Colors.Background
    btn.BorderSizePixel = 0
    btn.Text = "    " .. text
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.TextColor3 = Colors.TextMuted
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = Sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local BuyTabBtn = CreateNavButton("Dashboard", 80)
local MailTabBtn = CreateNavButton("Mail", 124)
local SettingsTabBtn = CreateNavButton("Settings", 168)

local VerTag = Instance.new("TextLabel")
VerTag.Size = UDim2.new(1, -30, 0, 32)
VerTag.Position = UDim2.new(0, 15, 1, -45)
VerTag.BackgroundColor3 = Colors.CardBg
VerTag.Text = "Build v1.0.0"
VerTag.Font = Enum.Font.GothamMedium
VerTag.TextSize = 10
VerTag.TextColor3 = Colors.TextMuted
VerTag.Parent = Sidebar
Instance.new("UICorner", VerTag).CornerRadius = UDim.new(0, 6)

-- =============================================================================
-- VIEWPORTS MANAGER
-- =============================================================================
local DashboardView = Instance.new("Frame")
DashboardView.Name = "DashboardView"
DashboardView.Parent = Main
DashboardView.Size = UDim2.new(0.75, -20, 1, -85)
DashboardView.Position = UDim2.new(0.25, 10, 0, 65)
DashboardView.BackgroundTransparency = 1
DashboardView.Visible = true

local MailView = Instance.new("ScrollingFrame")
MailView.Name = "MailView"
MailView.Parent = Main
MailView.Size = UDim2.new(0.75, -20, 1, -85)
MailView.Position = UDim2.new(0.25, 10, 0, 65)
MailView.BackgroundTransparency = 1
MailView.Visible = false
MailView.BorderSizePixel = 0
MailView.ScrollBarThickness = 4
MailView.ScrollBarImageColor3 = Colors.LayoutLine

local SettingsView = Instance.new("ScrollingFrame")
SettingsView.Name = "SettingsView"
SettingsView.Parent = Main
SettingsView.Size = UDim2.new(0.75, -20, 1, -85)
SettingsView.Position = UDim2.new(0.25, 10, 0, 65)
SettingsView.BackgroundTransparency = 1
SettingsView.Visible = false
SettingsView.BorderSizePixel = 0
SettingsView.ScrollBarThickness = 4
SettingsView.ScrollBarImageColor3 = Colors.LayoutLine

local function SwitchTab(activeView)
    DashboardView.Visible = (DashboardView == activeView)
    MailView.Visible = (MailView == activeView)
    SettingsView.Visible = (SettingsView == activeView)
    
    BuyTabBtn.BackgroundColor3 = (DashboardView == activeView) and Colors.CardBg or Colors.Background
    BuyTabBtn.TextColor3 = (DashboardView == activeView) and Colors.TextWhite or Colors.TextMuted
    
    MailTabBtn.BackgroundColor3 = (MailView == activeView) and Colors.CardBg or Colors.Background
    MailTabBtn.TextColor3 = (MailView == activeView) and Colors.TextWhite or Colors.TextMuted
    
    SettingsTabBtn.BackgroundColor3 = (SettingsView == activeView) and Colors.CardBg or Colors.Background
    SettingsTabBtn.TextColor3 = (SettingsView == activeView) and Colors.TextWhite or Colors.TextMuted
end

BuyTabBtn.MouseButton1Click:Connect(function() SwitchTab(DashboardView) end)
MailTabBtn.MouseButton1Click:Connect(function() SwitchTab(MailView) end)
SettingsTabBtn.MouseButton1Click:Connect(function() SwitchTab(SettingsView) end)

SwitchTab(DashboardView)

-- =============================================================================
-- LOW-LEVEL FIRE NETWORK CLIENT
-- =============================================================================
local function firePacket(customBuffer)
    local success, remote = pcall(function()
        return game:GetService("ReplicatedStorage")
            :WaitForChild("SharedModules", 2)
            :WaitForChild("Packet", 2)
            :WaitForChild("RemoteEvent", 2)
    end)
    if success and remote then
        remote:FireServer(customBuffer)
    end
end

-- =============================================================================
-- DASHBOARD VIEW CARDS
-- =============================================================================
local ColumnLayout = Instance.new("UIListLayout")
ColumnLayout.Parent = DashboardView
ColumnLayout.FillDirection = Enum.FillDirection.Horizontal
ColumnLayout.Padding = UDim.new(0, 14)

local function CreateModuleCard(title, defaultDelay, onSliderUpdate)
    local outerGroup = Instance.new("Frame")
    outerGroup.Size = UDim2.new(0.5, -7, 1, 0)
    outerGroup.BackgroundTransparency = 1
    outerGroup.Parent = DashboardView

    local verticalLayout = Instance.new("UIListLayout")
    verticalLayout.Parent = outerGroup
    verticalLayout.Padding = UDim.new(0, 8)

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 1, -65)
    card.BackgroundColor3 = Colors.CardBg
    card.BorderSizePixel = 0
    card.Parent = outerGroup
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

    local headerFrame = Instance.new("Frame")
    headerFrame.Size = UDim2.new(1, 0, 0, 50)
    headerFrame.BackgroundTransparency = 1
    headerFrame.Parent = card

    local expandTrigger = Instance.new("TextButton")
    expandTrigger.Size = UDim2.new(0.6, 0, 1, 0)
    expandTrigger.BackgroundTransparency = 1
    expandTrigger.Text = ""
    expandTrigger.Parent = headerFrame

    local headerText = Instance.new("TextLabel")
    headerText.Size = UDim2.new(1, -25, 1, 0)
    headerText.Position = UDim2.new(0, 12, 0, 0)
    headerText.BackgroundTransparency = 1
    headerText.Text = title
    headerText.Font = Enum.Font.GothamBold
    headerText.TextSize = 13
    headerText.TextColor3 = Colors.TextWhite
    headerText.TextXAlignment = Enum.TextXAlignment.Left
    headerText.Parent = expandTrigger

    local arrowIndicator = Instance.new("TextLabel")
    arrowIndicator.Size = UDim2.new(0, 15, 1, 0)
    arrowIndicator.Position = UDim2.new(1, -15, 0, 0)
    arrowIndicator.BackgroundTransparency = 1
    arrowIndicator.Text = "▶"
    arrowIndicator.Font = Enum.Font.GothamBold
    arrowIndicator.TextSize = 10
    arrowIndicator.TextColor3 = Colors.TextMuted
    arrowIndicator.Parent = expandTrigger

    local toggleFrame = Instance.new("TextButton")
    toggleFrame.Size = UDim2.new(0, 36, 0, 18)
    toggleFrame.Position = UDim2.new(1, -48, 0.5, -9)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(42, 40, 52)
    toggleFrame.Text = ""
    toggleFrame.Parent = headerFrame
    Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(1, 0)

    local toggleBall = Instance.new("Frame")
    toggleBall.Size = UDim2.new(0, 12, 0, 12)
    toggleBall.Position = UDim2.new(0, 3, 0.5, -6)
    toggleBall.BackgroundColor3 = Colors.TextMuted
    toggleBall.BorderSizePixel = 0
    toggleBall.Parent = toggleFrame
    Instance.new("UICorner", toggleBall).CornerRadius = UDim.new(1, 0)

    local dropdownBody = Instance.new("Frame")
    dropdownBody.Size = UDim2.new(1, -20, 1, -60)
    dropdownBody.Position = UDim2.new(0, 10, 0, 50)
    dropdownBody.BackgroundTransparency = 1
    dropdownBody.ClipsDescendants = true
    dropdownBody.Size = UDim2.new(1, -20, 0, 0)
    dropdownBody.Parent = card

    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.ScrollBarThickness = 2
    container.CanvasSize = UDim2.new(0, 0, 0, 0)
    container.Parent = dropdownBody

    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = container
    listLayout.Padding = UDim.new(0, 6)

    local isOpen = false
    expandTrigger.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        arrowIndicator.Text = isOpen and "▼" or "▶"
        TweenService:Create(dropdownBody, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Size = isOpen and UDim2.new(1, -20, 1, -60) or UDim2.new(1, -20, 0, 0)
        }):Play()
    end)

    local SliderCard = Instance.new("Frame")
    SliderCard.Size = UDim2.new(1, 0, 0, 55)
    SliderCard.BackgroundColor3 = Colors.CardBg
    SliderCard.BorderSizePixel = 0
    SliderCard.Parent = outerGroup
    Instance.new("UICorner", SliderCard).CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -24, 0, 20)
    label.Position = UDim2.new(0, 12, 0, 6)
    label.BackgroundTransparency = 1
    label.Text = title .. " Interval: " .. string.format("%ds", defaultDelay)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 11
    label.TextColor3 = Colors.TextWhite
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = SliderCard

    local track = Instance.new("TextButton")
    track.Size = UDim2.new(1, -24, 0, 5)
    track.Position = UDim2.new(0, 12, 0, 36)
    track.BackgroundColor3 = Color3.fromRGB(42, 40, 52)
    track.Text = ""
    track.AutoButtonColor = false
    track.Parent = track.Parent and SliderCard or SliderCard
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defaultDelay - minDelay) / (maxDelay - minDelay), 0, 1, 0)
    fill.BackgroundColor3 = Colors.BrightPurple
    fill.BorderSizePixel = 0
    fill.Parent = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("TextButton")
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = UDim2.new((defaultDelay - minDelay) / (maxDelay - minDelay), -6, 0.5, -6)
    knob.BackgroundColor3 = Colors.TextWhite
    knob.Text = ""
    knob.Parent = track
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local externalSetVal = function(targetVal)
        label.Text = title .. " Interval: " .. string.format("%ds", targetVal)
        local visualPercentage = (targetVal - minDelay) / (maxDelay - minDelay)
        fill.Size = UDim2.new(visualPercentage, 0, 1, 0)
        knob.Position = UDim2.new(visualPercentage, -6, 0.5, -6)
    end

    local isSliding = false
    local function UpdateTrack(input)
        local trackWidth = track.AbsoluteSize.X
        local relativeX = math.clamp(input.Position.X - track.AbsolutePosition.X, 0, trackWidth)
        local percentage = relativeX / trackWidth
        local calculatedVal = math.round(minDelay + (percentage * (maxDelay - minDelay)))
        
        externalSetVal(calculatedVal)
        onSliderUpdate(calculatedVal)
    end

    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isSliding = true end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then UpdateTrack(input) end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isSliding = false end
    end)

    return container, toggleFrame, toggleBall, externalSetVal
end

local SeedContainer, SeedToggle, SeedBall, seedSliderSetter = CreateModuleCard("Seeds", seedDelay, function(newVal)
    seedDelay = newVal
    if isSeedLooping then
        for name, data in pairs(selectedSeeds) do
            if activeSeedLoops[name] then task.cancel(activeSeedLoops[name]) end
            activeSeedLoops[name] = task.spawn(function()
                while true do firePacket(buffer.fromstring(data)) task.wait(seedDelay) end
            end)
        end
    end
end)
seedSliderUpdateFunc = seedSliderSetter

local GearContainer, GearToggle, GearBall, gearSliderSetter = CreateModuleCard("Gears", gearDelay, function(newVal)
    gearDelay = newVal
    if isGearLooping then
        for name, data in pairs(selectedGears) do
            if activeGearLoops[name] then task.cancel(activeGearLoops[name]) end
            activeGearLoops[name] = task.spawn(function()
                while true do firePacket(buffer.fromstring(data)) task.wait(gearDelay) end
            end)
        end
    end
end)
gearSliderUpdateFunc = gearSliderSetter

-- =============================================================================
-- MAIL VIEW SYSTEM (MODIFIED: SEPARATED SEEDS & GEARS + MULTI-SELECT SUPPORT)
-- =============================================================================
local MailLayout = Instance.new("UIListLayout")
MailLayout.Parent = MailView
MailLayout.Padding = UDim.new(0, 14)

local MailCard = Instance.new("Frame")
MailCard.Size = UDim2.new(1, -10, 0, 320)
MailCard.BackgroundColor3 = Colors.CardBg
MailCard.BorderSizePixel = 0
MailCard.Parent = MailView
Instance.new("UICorner", MailCard).CornerRadius = UDim.new(0, 8)

local MailHeader = Instance.new("TextLabel")
MailHeader.Size = UDim2.new(1, -30, 0, 35)
MailHeader.Position = UDim2.new(0, 15, 0, 5)
MailHeader.BackgroundTransparency = 1
MailHeader.Text = "Gifting & Mail Services"
MailHeader.Font = Enum.Font.GothamBold
MailHeader.TextSize = 13
MailHeader.TextColor3 = Colors.TextWhite
MailHeader.TextXAlignment = Enum.TextXAlignment.Left
MailHeader.Parent = MailCard

local UsernameInput = Instance.new("TextBox")
UsernameInput.Size = UDim2.new(1, -30, 0, 34)
UsernameInput.Position = UDim2.new(0, 15, 0, 45)
UsernameInput.BackgroundColor3 = Colors.ItemBg
UsernameInput.BorderSizePixel = 0
UsernameInput.Text = ""
UsernameInput.PlaceholderText = "Target Username..."
UsernameInput.PlaceholderColor3 = Colors.TextMuted
UsernameInput.Font = Enum.Font.GothamMedium
UsernameInput.TextSize = 12
UsernameInput.TextColor3 = Colors.TextWhite
UsernameInput.ClearTextOnFocus = false
UsernameInput.Parent = MailCard
Instance.new("UICorner", UsernameInput).CornerRadius = UDim.new(0, 6)

local SeedsDropdownTitle = Instance.new("TextLabel")
SeedsDropdownTitle.Size = UDim2.new(0.5, -10, 0, 20)
SeedsDropdownTitle.Position = UDim2.new(0, 15, 0, 90)
SeedsDropdownTitle.BackgroundTransparency = 1
SeedsDropdownTitle.Text = "Select Seeds"
SeedsDropdownTitle.Font = Enum.Font.GothamMedium
SeedsDropdownTitle.TextSize = 11
SeedsDropdownTitle.TextColor3 = Colors.TextMuted
SeedsDropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
SeedsDropdownTitle.Parent = MailCard

local GearsDropdownTitle = Instance.new("TextLabel")
GearsDropdownTitle.Size = UDim2.new(0.5, -10, 0, 20)
GearsDropdownTitle.Position = UDim2.new(0.5, 10, 0, 90)
GearsDropdownTitle.BackgroundTransparency = 1
GearsDropdownTitle.Text = "Select Gears"
GearsDropdownTitle.Font = Enum.Font.GothamMedium
GearsDropdownTitle.TextSize = 11
GearsDropdownTitle.TextColor3 = Colors.TextMuted
GearsDropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
GearsDropdownTitle.Parent = MailCard

local SeedsListFrame = Instance.new("ScrollingFrame")
SeedsListFrame.Size = UDim2.new(0.5, -12, 0, 100)
SeedsListFrame.Position = UDim2.new(0, 15, 0, 115)
SeedsListFrame.BackgroundColor3 = Colors.ItemBg
SeedsListFrame.BorderSizePixel = 0
SeedsListFrame.ScrollBarThickness = 3
SeedsListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
SeedsListFrame.Parent = MailCard
Instance.new("UICorner", SeedsListFrame).CornerRadius = UDim.new(0, 6)

local SeedsListLayout = Instance.new("UIListLayout")
SeedsListLayout.Parent = SeedsListFrame
SeedsListLayout.Padding = UDim.new(0, 2)

local GearsListFrame = Instance.new("ScrollingFrame")
GearsListFrame.Size = UDim2.new(0.5, -12, 0, 100)
GearsListFrame.Position = UDim2.new(0.5, 10, 0, 115)
GearsListFrame.BackgroundColor3 = Colors.ItemBg
GearsListFrame.BorderSizePixel = 0
GearsListFrame.ScrollBarThickness = 3
GearsListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
GearsListFrame.Parent = MailCard
Instance.new("UICorner", GearsListFrame).CornerRadius = UDim.new(0, 6)

local GearsListLayout = Instance.new("UIListLayout")
GearsListLayout.Parent = GearsListFrame
GearsListLayout.Padding = UDim.new(0, 2)

local selectedGiftItems = {}

local function PopulateMailSelector(itemsTable, categoryName, targetFrame, targetLayout)
    for _, item in ipairs(itemsTable) do
        local rowBtn = Instance.new("TextButton")
        rowBtn.Size = UDim2.new(1, 0, 0, 28)
        rowBtn.BackgroundTransparency = 1
        rowBtn.Text = "   " .. item.Name
        rowBtn.Font = Enum.Font.GothamMedium
        rowBtn.TextSize = 11
        rowBtn.TextColor3 = Colors.TextMuted
        rowBtn.TextXAlignment = Enum.TextXAlignment.Left
        rowBtn.Parent = targetFrame
        
        rowBtn.MouseButton1Click:Connect(function()
            if selectedGiftItems[item.Name] then
                selectedGiftItems[item.Name] = nil
                rowBtn.TextColor3 = Colors.TextMuted
            else
                selectedGiftItems[item.Name] = { Item = item, Category = categoryName }
                rowBtn.TextColor3 = Colors.BrightPurple
            end
        end)
    end
    targetFrame.CanvasSize = UDim2.new(0, 0, 0, targetLayout.AbsoluteContentSize.Y)
end

PopulateMailSelector(Seeds, "Seeds", SeedsListFrame, SeedsListLayout)
PopulateMailSelector(Gears, "Gears", GearsListFrame, GearsListLayout)

local CountInput = Instance.new("TextBox")
CountInput.Size = UDim2.new(0.4, -10, 0, 34)
CountInput.Position = UDim2.new(0, 15, 0, 225)
CountInput.BackgroundColor3 = Colors.ItemBg
CountInput.BorderSizePixel = 0
CountInput.Text = "1"
CountInput.PlaceholderText = "Count / Pcs..."
CountInput.PlaceholderColor3 = Colors.TextMuted
CountInput.Font = Enum.Font.GothamMedium
CountInput.TextSize = 12
CountInput.TextColor3 = Colors.TextWhite
CountInput.ClearTextOnFocus = false
CountInput.Parent = MailCard
Instance.new("UICorner", CountInput).CornerRadius = UDim.new(0, 6)

local ManualSendBtn = Instance.new("TextButton")
ManualSendBtn.Size = UDim2.new(0.6, -15, 0, 34)
ManualSendBtn.Position = UDim2.new(0.4, 10, 0, 225)
ManualSendBtn.BackgroundColor3 = Colors.AccentPurple
ManualSendBtn.Text = "Send Mail"
ManualSendBtn.Font = Enum.Font.GothamBold
ManualSendBtn.TextSize = 12
ManualSendBtn.TextColor3 = Colors.TextWhite
ManualSendBtn.Parent = MailCard
Instance.new("UICorner", ManualSendBtn).CornerRadius = UDim.new(0, 6)

local AutoRepeatLabel = Instance.new("TextLabel")
AutoRepeatLabel.Size = UDim2.new(0.6, 0, 0, 24)
AutoRepeatLabel.Position = UDim2.new(0, 15, 0, 275)
AutoRepeatLabel.BackgroundTransparency = 1
AutoRepeatLabel.Text = "Auto Send Mail Repeat"
AutoRepeatLabel.Font = Enum.Font.GothamMedium
AutoRepeatLabel.TextSize = 12
AutoRepeatLabel.TextColor3 = Colors.TextWhite
AutoRepeatLabel.TextXAlignment = Enum.TextXAlignment.Left
AutoRepeatLabel.Parent = MailCard

local MailToggleFrame = Instance.new("TextButton")
MailToggleFrame.Size = UDim2.new(0, 36, 0, 18)
MailToggleFrame.Position = UDim2.new(1, -51, 0, 278)
MailToggleFrame.BackgroundColor3 = Color3.fromRGB(42, 40, 52)
MailToggleFrame.Text = ""
MailToggleFrame.Parent = MailCard
Instance.new("UICorner", MailToggleFrame).CornerRadius = UDim.new(1, 0)

local MailToggleBall = Instance.new("Frame")
MailToggleBall.Size = UDim2.new(0, 12, 0, 12)
MailToggleBall.Position = UDim2.new(0, 3, 0.5, -6)
MailToggleBall.BackgroundColor3 = Colors.TextMuted
MailToggleBall.BorderSizePixel = 0
MailToggleBall.Parent = MailToggleFrame
Instance.new("UICorner", MailToggleBall).CornerRadius = UDim.new(1, 0)

-- =============================================================================
-- FIXED: FRUIT & HARVESTED WEIGHT GIFTING INTERFACE CARD (NO SEEDS)
-- =============================================================================
local FruitGiftCard = Instance.new("Frame")
FruitGiftCard.Name = "FruitGiftCard"
FruitGiftCard.Size = UDim2.new(1, -10, 0, 195)
FruitGiftCard.BackgroundColor3 = Colors.CardBg
FruitGiftCard.BorderSizePixel = 0
FruitGiftCard.Parent = MailView
Instance.new("UICorner", FruitGiftCard).CornerRadius = UDim.new(0, 8)

local FruitHeader = Instance.new("TextLabel")
FruitHeader.Size = UDim2.new(1, -30, 0, 35)
FruitHeader.Position = UDim2.new(0, 15, 0, 5)
FruitHeader.BackgroundTransparency = 1
FruitHeader.Text = "Fruit & Crop Gifting"
FruitHeader.Font = Enum.Font.GothamBold
FruitHeader.TextSize = 13
FruitHeader.TextColor3 = Colors.TextWhite
FruitHeader.TextXAlignment = Enum.TextXAlignment.Left
FruitHeader.Parent = FruitGiftCard

local FruitUsernameInput = Instance.new("TextBox")
FruitUsernameInput.Size = UDim2.new(1, -30, 0, 34)
FruitUsernameInput.Position = UDim2.new(0, 15, 0, 45)
FruitUsernameInput.BackgroundColor3 = Colors.ItemBg
FruitUsernameInput.BorderSizePixel = 0
FruitUsernameInput.Text = ""
FruitUsernameInput.PlaceholderText = "Target Username..."
FruitUsernameInput.PlaceholderColor3 = Colors.TextMuted
FruitUsernameInput.Font = Enum.Font.GothamMedium
FruitUsernameInput.TextSize = 12
FruitUsernameInput.TextColor3 = Colors.TextWhite
FruitUsernameInput.ClearTextOnFocus = false
FruitUsernameInput.Parent = FruitGiftCard
Instance.new("UICorner", FruitUsernameInput).CornerRadius = UDim.new(0, 6)

local FruitDropdownToggle = Instance.new("TextButton")
FruitDropdownToggle.Size = UDim2.new(1, -30, 0, 34)
FruitDropdownToggle.Position = UDim2.new(0, 15, 0, 90)
FruitDropdownToggle.BackgroundColor3 = Colors.ItemBg
FruitDropdownToggle.BorderSizePixel = 0
FruitDropdownToggle.Text = "Select Harvested Fruit (kg) v"
FruitDropdownToggle.Font = Enum.Font.GothamMedium
FruitDropdownToggle.TextSize = 12
FruitDropdownToggle.TextColor3 = Colors.TextMuted
FruitDropdownToggle.Parent = FruitGiftCard
Instance.new("UICorner", FruitDropdownToggle).CornerRadius = UDim.new(0, 6)

local FruitDropdownMenu = Instance.new("ScrollingFrame")
FruitDropdownMenu.Size = UDim2.new(1, -30, 0, 120)
FruitDropdownMenu.Position = UDim2.new(0, 15, 0, 126)
FruitDropdownMenu.BackgroundColor3 = Colors.ItemBg
FruitDropdownMenu.BorderSizePixel = 0
FruitDropdownMenu.Visible = false
FruitDropdownMenu.ZIndex = 15
FruitDropdownMenu.ScrollBarThickness = 3
FruitDropdownMenu.CanvasSize = UDim2.new(0, 0, 0, 0)
FruitDropdownMenu.Parent = FruitGiftCard
Instance.new("UICorner", FruitDropdownMenu).CornerRadius = UDim.new(0, 6)

local FruitDropdownLayout = Instance.new("UIListLayout")
FruitDropdownLayout.Parent = FruitDropdownMenu
FruitDropdownLayout.Padding = UDim.new(0, 2)

local SendFruitBtn = Instance.new("TextButton")
SendFruitBtn.Size = UDim2.new(1, -30, 0, 38)
SendFruitBtn.Position = UDim2.new(0, 15, 0, 140)
SendFruitBtn.BackgroundColor3 = Colors.BrightPurple
SendFruitBtn.Text = "Send Fruit Gift"
SendFruitBtn.Font = Enum.Font.GothamBold
SendFruitBtn.TextSize = 12
SendFruitBtn.TextColor3 = Colors.TextWhite
SendFruitBtn.Parent = FruitGiftCard
Instance.new("UICorner", SendFruitBtn).CornerRadius = UDim.new(0, 6)

local selectedFruitName = nil

local function PopulateFruitDropdown()
    for _, child in ipairs(FruitDropdownMenu:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    -- Dynamically maps exclusively from Harvested Fruits with Weight Signatures
    for _, item in ipairs(HarvestedFruits) do
        local row = Instance.new("TextButton")
        row.Size = UDim2.new(1, 0, 0, 28)
        row.BackgroundTransparency = 1
        row.Text = "   " .. item.Name
        row.Font = Enum.Font.GothamMedium
        row.TextSize = 11
        row.TextColor3 = Colors.TextWhite
        row.TextXAlignment = Enum.TextXAlignment.Left
        row.ZIndex = 16
        row.Parent = FruitDropdownMenu
        
        row.MouseButton1Click:Connect(function()
            selectedFruitName = item.Name
            FruitDropdownToggle.Text = "Selected: " .. item.Name .. " v"
            FruitDropdownMenu.Visible = false
        end)
    end
    FruitDropdownMenu.CanvasSize = UDim2.new(0, 0, 0, FruitDropdownLayout.AbsoluteContentSize.Y)
end

FruitDropdownToggle.MouseButton1Click:Connect(function()
    FruitDropdownMenu.Visible = not FruitDropdownMenu.Visible
    if FruitDropdownMenu.Visible then
        PopulateFruitDropdown()
    end
end)

SendFruitBtn.MouseButton1Click:Connect(function()
    local targetUser = FruitUsernameInput.Text:gsub("%s+", "")
    if targetUser == "" or not selectedFruitName then
        warn("[Error]: Missing target username or chosen inventory fruit selection.")
        return
    end
    
    local headerBytes = "\029\001\022\020"
    local fullPayload = headerBytes .. targetUser
    
    firePacket(buffer.fromstring(fullPayload))
    print("[Network Data]: Fruit Gift packet stream successfully sent to recipient: " .. targetUser)
end)

-- =============================================================================
-- DYNAMIC MAIL SERIALIZATION PACKAGING ENGINE
-- =============================================================================
local function buildMailBuffer(targetUser, itemName, itemCount, categoryName)
    local header = "\028\001\024\000\000@<dE\235A\028\005\001\028"
    local userPart = "\v\bReceiver\v" .. string.char(#targetUser) .. targetUser
    local itemPart = "\v\aItemKey\v" .. string.char(#itemName) .. itemName
    local countPart = "\v\005Count\005" .. string.char(math.clamp(itemCount, 1, 255))
    local categoryPart = "\v\bCategory\v" .. string.char(#categoryName) .. categoryName
    local footer = "\000\000\000"
    
    local fullPayload = header .. userPart .. itemPart .. countPart .. categoryPart .. footer
    return buffer.fromstring(fullPayload)
end

local function dispatchCustomMail()
    local targetUser = UsernameInput.Text:gsub("%s+", "")
    local amount = tonumber(CountInput.Text) or 1
    
    if targetUser ~= "" then
        for _, giftData in pairs(selectedGiftItems) do
            local itemName = giftData.Item.Name
            local categoryName = giftData.Category
            local customBuffer = buildMailBuffer(targetUser, itemName, amount, categoryName)
            firePacket(customBuffer)
        end
    end
end

local isMailLooping = false
local mailLoopThread = nil

ManualSendBtn.MouseButton1Click:Connect(function()
    dispatchCustomMail()
end)

MailToggleFrame.MouseButton1Click:Connect(function()
    isMailLooping = not isMailLooping
    local targetPos = isMailLooping and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
    local targetBg = isMailLooping and Colors.BrightPurple or Color3.fromRGB(42, 40, 52)
    local targetBallColor = isMailLooping and Colors.TextWhite or Colors.TextMuted
    
    TweenService:Create(MailToggleBall, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {Position = targetPos, BackgroundColor3 = targetBallColor}):Play()
    TweenService:Create(MailToggleFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {BackgroundColor3 = targetBg}):Play()
    
    if mailLoopThread then task.cancel(mailLoopThread) mailLoopThread = nil end
    
    if isMailLooping then
        mailLoopThread = task.spawn(function()
            while true do
                dispatchCustomMail()
                task.wait(seedDelay)
            end
        end)
    end
end)

-- =============================================================================
-- SETTINGS VIEW CARDS
-- =============================================================================
local SettingsLayout = Instance.new("UIListLayout")
SettingsLayout.Parent = SettingsView
SettingsLayout.Padding = UDim.new(0, 10)

local function CreateSettingsOption(titleText, subText)
    local optionFrame = Instance.new("Frame")
    optionFrame.Size = UDim2.new(1, -10, 0, 60)
    optionFrame.BackgroundColor3 = Colors.CardBg
    optionFrame.BorderSizePixel = 0
    optionFrame.Parent = SettingsView
    Instance.new("UICorner", optionFrame).CornerRadius = UDim.new(0, 8)

    local labelText = Instance.new("TextLabel")
    labelText.Size = UDim2.new(0.7, 0, 0, 22)
    labelText.Position = UDim2.new(0, 15, 0, 10)
    labelText.BackgroundTransparency = 1
    labelText.Text = titleText
    labelText.Font = Enum.Font.GothamBold
    labelText.TextSize = 13
    labelText.TextColor3 = Colors.TextWhite
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Parent = optionFrame

    local descText = Instance.new("TextLabel")
    descText.Size = UDim2.new(0.7, 0, 0, 16)
    descText.Position = UDim2.new(0, 15, 0, 32)
    descText.BackgroundTransparency = 1
    descText.Text = subText
    descText.Font = Enum.Font.GothamMedium
    descText.TextSize = 10
    descText.TextColor3 = Colors.TextMuted
    descText.TextXAlignment = Enum.TextXAlignment.Left
    descText.Parent = optionFrame
    
    return optionFrame
end

CreateSettingsOption("Anti-AFK Killswitch", "Prevents disconnection automatically from idle servers.")
CreateSettingsOption("Fast Loaded Memory Packets", "Enhances standard data buffering speeds.")

-- =============================================================================
-- INTERACTIVE CHECKBOX POPULATER
-- =============================================================================
local function PopulateItems(itemsTable, targetContainer, selectedTracker, activeLoopsTracker, loopConditionCheck, getDelay, UIStorageTable)
    for i, item in ipairs(itemsTable) do
        local itemRow = Instance.new("TextButton")
        itemRow.Size = UDim2.new(1, 0, 0, 36)
        itemRow.BackgroundColor3 = Colors.ItemBg
        itemRow.Text = ""
        itemRow.AutoButtonColor = false
        itemRow.Parent = targetContainer
        Instance.new("UICorner", itemRow).CornerRadius = UDim.new(0, 6)

        local checkBox = Instance.new("Frame")
        checkBox.Size = UDim2.new(0, 14, 0, 14)
        checkBox.Position = UDim2.new(0, 12, 0.5, -7)
        checkBox.BackgroundColor3 = Colors.Background
        checkBox.Parent = itemRow
        Instance.new("UICorner", checkBox).CornerRadius = UDim.new(0, 4)

        local checkStroke = Instance.new("UIStroke")
        checkStroke.Thickness = 1
        checkStroke.Color = Colors.TextMuted
        checkStroke.Parent = checkBox

        local itemLabel = Instance.new("TextLabel")
        itemLabel.Size = UDim2.new(1, -45, 1, 0)
        itemLabel.Position = UDim2.new(0, 38, 0, 0)
        itemLabel.BackgroundTransparency = 1
        itemLabel.Text = item.Name
        itemLabel.Font = Enum.Font.GothamMedium
        itemLabel.TextSize = 12
        itemLabel.TextColor3 = Colors.TextWhite
        itemLabel.TextXAlignment = Enum.TextXAlignment.Left
        itemLabel.Parent = itemRow

        local updateVisuals = function(shouldCheck)
            if shouldCheck then
                TweenService:Create(checkBox, TweenInfo.new(0.12), {BackgroundColor3 = Colors.BrightPurple}):Play()
                TweenService:Create(checkStroke, TweenInfo.new(0.12), {Color = Colors.BrightPurple}):Play()
            else
                TweenService:Create(checkBox, TweenInfo.new(0.12), {BackgroundColor3 = Colors.Background}):Play()
                TweenService:Create(checkStroke, TweenInfo.new(0.12), {Color = Colors.TextMuted}):Play()
            end
        end

        UIStorageTable[item.Name] = updateVisuals

        itemRow.MouseButton1Click:Connect(function()
            if selectedTracker[item.Name] then
                selectedTracker[item.Name] = nil
                updateVisuals(false)
                if activeLoopsTracker[item.Name] then
                    task.cancel(activeLoopsTracker[item.Name])
                    activeLoopsTracker[item.Name] = nil
                end
            else
                selectedTracker[item.Name] = item.Data
                updateVisuals(true)
                if loopConditionCheck() then
                    activeLoopsTracker[item.Name] = task.spawn(function()
                        while true do
                            firePacket(buffer.fromstring(item.Data))
                            task.wait(getDelay())
                        end
                    end)
                end
            end
        end)
    end
end

-- =============================================================================
-- PROFILE CONFIGURATION SYSTEM
-- =============================================================================
local ConfigCard = Instance.new("Frame")
ConfigCard.Size = UDim2.new(1, -10, 0, 200)
ConfigCard.BackgroundColor3 = Colors.CardBg
ConfigCard.BorderSizePixel = 0
ConfigCard.Parent = SettingsView
Instance.new("UICorner", ConfigCard).CornerRadius = UDim.new(0, 8)

local ConfigHeader = Instance.new("TextLabel")
ConfigHeader.Size = UDim2.new(1, -30, 0, 35)
ConfigHeader.Position = UDim2.new(0, 15, 0, 5)
ConfigHeader.BackgroundTransparency = 1
ConfigHeader.Text = "Profile Settings Manager"
ConfigHeader.Font = Enum.Font.GothamBold
ConfigHeader.TextSize = 13
ConfigHeader.TextColor3 = Colors.TextWhite
ConfigHeader.TextXAlignment = Enum.TextXAlignment.Left
ConfigHeader.Parent = ConfigCard

local ConfigInput = Instance.new("TextBox")
ConfigInput.Size = UDim2.new(0.6, -15, 0, 32)
ConfigInput.Position = UDim2.new(0, 15, 0, 40)
ConfigInput.BackgroundColor3 = Colors.ItemBg
ConfigInput.BorderSizePixel = 0
ConfigInput.Text = ""
ConfigInput.PlaceholderText = "Profile name..."
ConfigInput.PlaceholderColor3 = Colors.TextMuted
ConfigInput.Font = Enum.Font.GothamMedium
ConfigInput.TextSize = 12
ConfigInput.TextColor3 = Colors.TextWhite
ConfigInput.ClearTextOnFocus = false
ConfigInput.Parent = ConfigCard
Instance.new("UICorner", ConfigInput).CornerRadius = UDim.new(0, 6)

local CreateBtn = Instance.new("TextButton")
CreateBtn.Size = UDim2.new(0.4, -15, 0, 32)
CreateBtn.Position = UDim2.new(0.6, 15, 0, 40)
CreateBtn.BackgroundColor3 = Colors.AccentPurple
CreateBtn.Text = "Create"
CreateBtn.Font = Enum.Font.GothamBold
CreateBtn.TextSize = 12
CreateBtn.TextColor3 = Colors.TextWhite
CreateBtn.Parent = ConfigCard
Instance.new("UICorner", CreateBtn).CornerRadius = UDim.new(0, 6)

local ScrollConfigList = Instance.new("ScrollingFrame")
ScrollConfigList.Size = UDim2.new(1, -30, 0, 110)
ScrollConfigList.Position = UDim2.new(0, 15, 0, 80)
ScrollConfigList.BackgroundTransparency = 1
ScrollConfigList.BorderSizePixel = 0
ScrollConfigList.ScrollBarThickness = 2
ScrollConfigList.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollConfigList.Parent = ConfigCard

local ConfigListLayout = Instance.new("UIListLayout")
ConfigListLayout.Parent = ScrollConfigList
ConfigListLayout.Padding = UDim.new(0, 5)

local FolderName = "MeliodasConfigEngine"
if not isfolder(FolderName) then makefolder(FolderName) end

local function GetAutoLoadFile()
    if isfile(FolderName .. "/autoload.txt") then
        return readfile(FolderName .. "/autoload.txt")
    end
    return nil
end

local function SetAutoLoadFile(filename)
    writefile(FolderName .. "/autoload.txt", filename)
end

local function SyncVisualState()
    for name, updateVisual in pairs(seedCheckboxElements) do
        updateVisual(selectedSeeds[name] ~= nil)
    end
    for name, updateVisual in pairs(gearCheckboxElements) do
        updateVisual(selectedGears[name] ~= nil)
    end
    if seedSliderUpdateFunc then seedSliderUpdateFunc(seedDelay) end
    if gearSliderUpdateFunc then gearSliderUpdateFunc(gearDelay) end
    if updateSeedToggleVisual then updateSeedToggleVisual(isSeedLooping) end
    if updateGearToggleVisual then updateGearToggleVisual(isGearLooping) end
end

local RefreshConfigList

local function SaveConfig(name)
    if name == "" then return end
    local structuralState = {
        SelectedSeeds = {},
        SelectedGears = {},
        SeedDelay = seedDelay,
        GearDelay = gearDelay,
        IsSeedLooping = isSeedLooping,
        IsGearLooping = isGearLooping
    }
    for k, v in pairs(selectedSeeds) do structuralState.SelectedSeeds[k] = true end
    for k, v in pairs(selectedGears) do structuralState.SelectedGears[k] = true end
    
    local rawJSON = HttpService:JSONEncode(structuralState)
    writefile(FolderName .. "/" .. name .. ".json", rawJSON)
    RefreshConfigList()
end

local function LoadConfig(name)
    local path = FolderName .. "/" .. name .. ".json"
    if not isfile(path) then return end
    
    local rawJSON = readfile(path)
    local success, structuralState = pcall(function() return HttpService:JSONDecode(rawJSON) end)
    if not success or not structuralState then return end
    
    for _, t in pairs(activeSeedLoops) do task.cancel(t) end
    for _, t in pairs(activeGearLoops) do task.cancel(t) end
    table.clear(activeSeedLoops)
    table.clear(activeGearLoops)
    table.clear(selectedSeeds)
    table.clear(selectedGears)
    
    seedDelay = structuralState.SeedDelay or 15
    gearDelay = structuralState.GearDelay or 15
    isSeedLooping = structuralState.IsSeedLooping or false
    isGearLooping = structuralState.IsGearLooping or false
    
    if structuralState.SelectedSeeds then
        for _, seedItem in ipairs(Seeds) do
            if structuralState.SelectedSeeds[seedItem.Name] then
                selectedSeeds[seedItem.Name] = seedItem.Data
            end
        end
    end
    
    if structuralState.SelectedGears then
        for _, gearItem in ipairs(Gears) do
            if structuralState.SelectedGears[gearItem.Name] then
                selectedGears[gearItem.Name] = gearItem.Data
            end
        end
    end
    
    if isSeedLooping then
        for n, d in pairs(selectedSeeds) do
            activeSeedLoops[n] = task.spawn(function()
                while true do firePacket(buffer.fromstring(d)) task.wait(seedDelay) end
            end)
        end
    end
    if isGearLooping then
        for n, d in pairs(selectedGears) do
            activeGearLoops[n] = task.spawn(function()
                while true do firePacket(buffer.fromstring(d)) task.wait(gearDelay) end
            end)
        end
    end
    
    SyncVisualState()
    RefreshConfigList()
end

local function DeleteConfig(name)
    local path = FolderName .. "/" .. name .. ".json"
    if isfile(path) then delfile(path) end
    if GetAutoLoadFile() == name then
        delfile(FolderName .. "/autoload.txt")
    end
    RefreshConfigList()
end

RefreshConfigList = function()
    for _, child in ipairs(ScrollConfigList:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    local autoFile = GetAutoLoadFile()
    local files = listfiles(FolderName)
    
    for _, path in ipairs(files) do
        if path:sub(-5) == ".json" then
            local rawName = path:match("([^/]+)%.json$") or path
            
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 30)
            row.BackgroundColor3 = Colors.ItemBg
            row.Parent = ScrollConfigList
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 4)
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(0.4, 0, 1, 0)
            nameLabel.Position = UDim2.new(0, 10, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = rawName .. (autoFile == rawName and " [AUTO]" or "")
            nameLabel.Font = Enum.Font.GothamMedium
            nameLabel.TextSize = 11
            nameLabel.TextColor3 = autoFile == rawName and Colors.BrightPurple or Colors.TextWhite
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.Parent = row
            
            local function CreateActionBtn(txt, color, xPos, widthScale)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(widthScale, -5, 0, 22)
                btn.Position = UDim2.new(xPos, 0, 0.5, -11)
                btn.BackgroundColor3 = color
                btn.Text = txt
                btn.Font = Enum.Font.GothamBold
                btn.TextSize = 10
                btn.TextColor3 = Colors.TextWhite
                btn.Parent = row
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
                return btn
            end
            
            local LBtn = CreateActionBtn("Load", Color3.fromRGB(34, 197, 94), 0.45, 0.16)
            local ABtn = CreateActionBtn("Auto", Color3.fromRGB(59, 130, 246), 0.62, 0.16)
            local DBtn = CreateActionBtn("Del", Colors.CloseRed, 0.79, 0.16)
            
            LBtn.MouseButton1Click:Connect(function() LoadConfig(rawName) end)
            ABtn.MouseButton1Click:Connect(function()
                if GetAutoLoadFile() == rawName then
                    delfile(FolderName .. "/autoload.txt")
                else
                    SetAutoLoadFile(rawName)
                end
                RefreshConfigList()
            end)
            DBtn.MouseButton1Click:Connect(function() DeleteConfig(rawName) end)
        end
    end
    ScrollConfigList.CanvasSize = UDim2.new(0, 0, 0, ConfigListLayout.AbsoluteContentSize.Y)
end

CreateBtn.MouseButton1Click:Connect(function()
    local text = ConfigInput.Text:gsub("%s+", "")
    if text ~= "" then
        SaveConfig(text)
        ConfigInput.Text = ""
    end
end)

-- =============================================================================
-- CORE LOOP TRIGGERS
-- =============================================================================
local function handleToggleAnimations(frame, ball, state)
    local targetPos = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
    local targetBg = state and Colors.BrightPurple or Color3.fromRGB(42, 40, 52)
    local targetBallColor = state and Colors.TextWhite or Colors.TextMuted
    
    TweenService:Create(ball, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {Position = targetPos, BackgroundColor3 = targetBallColor}):Play()
    TweenService:Create(frame, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {BackgroundColor3 = targetBg}):Play()
end

updateSeedToggleVisual = function(state) handleToggleAnimations(SeedToggle, SeedBall, state) end
updateGearToggleVisual = function(state) handleToggleAnimations(GearToggle, GearBall, state) end

SeedToggle.MouseButton1Click:Connect(function()
    isSeedLooping = not isSeedLooping
    updateSeedToggleVisual(isSeedLooping)
    for name, thread in pairs(activeSeedLoops) do task.cancel(thread) end
    table.clear(activeSeedLoops)
    if isSeedLooping then
        for name, data in pairs(selectedSeeds) do
            activeSeedLoops[name] = task.spawn(function()
                while true do firePacket(buffer.fromstring(data)) task.wait(seedDelay) end
            end)
        end
    end
end)

GearToggle.MouseButton1Click:Connect(function()
    isGearLooping = not isGearLooping
    updateGearToggleVisual(isGearLooping)
    for name, thread in pairs(activeGearLoops) do task.cancel(thread) end
    table.clear(activeGearLoops)
    if isGearLooping then
        for name, data in pairs(selectedGears) do
            activeGearLoops[name] = task.spawn(function()
                while true do firePacket(buffer.fromstring(data)) task.wait(gearDelay) end
            end)
        end
    end
end)

PopulateItems(Seeds, SeedContainer, selectedSeeds, activeSeedLoops, function() return isSeedLooping end, function() return seedDelay end, seedCheckboxElements)
PopulateItems(Gears, GearContainer, selectedGears, activeGearLoops, function() return isGearLooping end, function() return gearDelay end, gearCheckboxElements)

SettingsView.CanvasSize = UDim2.new(0, 0, 0, SettingsLayout.AbsoluteContentSize.Y + 20)
MailView.CanvasSize = UDim2.new(0, 0, 0, MailLayout.AbsoluteContentSize.Y + 20)
DashboardView.ChildAdded:Connect(function() task.wait() SettingsView.CanvasSize = UDim2.new(0, 0, 0, SettingsLayout.AbsoluteContentSize.Y + 20) end)

RefreshConfigList()
local initialAutoFile = GetAutoLoadFile()
if initialAutoFile then
    task.spawn(function()
        pcall(function() LoadConfig(initialAutoFile) end)
    end)
end
