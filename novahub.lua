local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
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
    Background = Color3.fromRGB(15, 16, 20),
    CardBg = Color3.fromRGB(21, 23, 28),
    ItemBg = Color3.fromRGB(28, 30, 38),
    AccentPurple = Color3.fromRGB(138, 43, 226),
    BrightPurple = Color3.fromRGB(168, 85, 247),
    TextWhite = Color3.fromRGB(255, 255, 255),
    TextMuted = Color3.fromRGB(150, 145, 165),
    CloseRed = Color3.fromRGB(239, 68, 68),
    LayoutLine = Color3.fromRGB(38, 38, 50),
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
Main.Size = UDim2.new(0, 520, 0, 350)
Main.Position = UDim2.new(0.5, -260, 0.5, -175)
Main.BackgroundColor3 = Colors.Background
Main.BorderSizePixel = 0
Main.Active = true
Main.Visible = false 

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = Main

-- =============================================================================
-- UNRESTRICTED DYNAMIC RESIZING SYSTEM
-- =============================================================================
local ResizeHandle = Instance.new("TextButton")
ResizeHandle.Name = "ResizeHandle"
ResizeHandle.Size = UDim2.new(0, 16, 0, 16)
ResizeHandle.Position = UDim2.new(1, -16, 1, -16)
ResizeHandle.BackgroundTransparency = 1
ResizeHandle.Text = "◢"
ResizeHandle.Font = Enum.Font.GothamBold
ResizeHandle.TextSize = 10
ResizeHandle.TextColor3 = Colors.TextMuted
ResizeHandle.ZIndex = 30
ResizeHandle.Parent = Main

local isResizing = false
local resizeStartSize
local resizeStartMousePos

ResizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isResizing = true
        resizeStartSize = Main.AbsoluteSize
        resizeStartMousePos = input.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then isResizing = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isResizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - resizeStartMousePos
        local newWidth = math.max(10, resizeStartSize.X + delta.X)
        local newHeight = math.max(10, resizeStartSize.Y + delta.Y)
        Main.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
end)

-- =============================================================================
-- INTRO SPLASH SYSTEM
-- =============================================================================
local SplashFrame = Instance.new("Frame")
SplashFrame.Name = "SplashFrame"
SplashFrame.Size = UDim2.new(1, 0, 1, 0)
SplashFrame.BackgroundColor3 = Colors.Background
SplashFrame.BorderSizePixel = 0
SplashFrame.ZIndex = 20
SplashFrame.Parent = ScreenGui

local SplashBlur = Instance.new("BlurEffect")
SplashBlur.Size = 0
SplashBlur.Parent = Lighting
TweenService:Create(SplashBlur, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 12}):Play()

local SplashCenter = Instance.new("Frame")
SplashCenter.Size = UDim2.new(0, 260, 0, 100)
SplashCenter.Position = UDim2.new(0.5, -130, 0.5, -50)
SplashCenter.BackgroundTransparency = 1
SplashCenter.Parent = SplashFrame

local SplashTitle = Instance.new("TextLabel")
SplashTitle.Size = UDim2.new(1, 0, 0, 30)
SplashTitle.Position = UDim2.new(0, 0, 0, 15)
SplashTitle.BackgroundTransparency = 1
SplashTitle.Text = "Nova Hub"
SplashTitle.Font = Enum.Font.GothamBold
SplashTitle.TextSize = 26
SplashTitle.TextColor3 = Colors.TextWhite
SplashTitle.TextTransparency = 1
SplashTitle.Parent = SplashCenter

local SplashSubtitle = Instance.new("TextLabel")
SplashSubtitle.Size = UDim2.new(1, 0, 0, 20)
SplashSubtitle.Position = UDim2.new(0, 0, 0, 45)
SplashSubtitle.BackgroundTransparency = 1
SplashSubtitle.Text = "Premium Keyless Automation"
SplashSubtitle.Font = Enum.Font.GothamMedium
SplashSubtitle.TextSize = 10
SplashSubtitle.TextColor3 = Colors.BrightPurple
SplashSubtitle.TextTransparency = 1
SplashSubtitle.Parent = SplashCenter

local ProgressBarTrack = Instance.new("Frame")
ProgressBarTrack.Size = UDim2.new(0.7, 0, 0, 3)
ProgressBarTrack.Position = UDim2.new(0.15, 0, 0, 80)
ProgressBarTrack.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ProgressBarTrack.BorderSizePixel = 0
ProgressBarTrack.BackgroundTransparency = 1
ProgressBarTrack.Parent = SplashCenter
Instance.new("UICorner", ProgressBarTrack).CornerRadius = UDim.new(1, 0)

local ProgressBarFill = Instance.new("Frame")
ProgressBarFill.Size = UDim2.new(0, 0, 1, 0)
ProgressBarFill.BackgroundColor3 = Colors.BrightPurple
ProgressBarFill.BorderSizePixel = 0
ProgressBarFill.Parent = ProgressBarTrack
Instance.new("UICorner", ProgressBarFill).CornerRadius = UDim.new(1, 0)

task.spawn(function()
    task.wait(0.1)
    TweenService:Create(SplashTitle, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {TextTransparency = 0, Position = UDim2.new(0, 0, 0, 10)}):Play()
    TweenService:Create(SplashSubtitle, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {TextTransparency = 0, Position = UDim2.new(0, 0, 0, 40)}):Play()
    TweenService:Create(ProgressBarTrack, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0}):Play()
    
    task.wait(0.3)
    local loadingTween = TweenService:Create(ProgressBarFill, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)})
    loadingTween:Play()
    loadingTween.Completed:Wait()
    
    TweenService:Create(SplashTitle, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
    TweenService:Create(SplashSubtitle, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
    TweenService:Create(ProgressBarTrack, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
    TweenService:Create(ProgressBarFill, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
    TweenService:Create(SplashBlur, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = 0}):Play()
    
    local frameFade = TweenService:Create(SplashFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
    frameFade:Play()
    
    Main.Size = UDim2.new(0, 500, 0, 330)
    Main.Visible = true
    TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 520, 0, 350)}):Play()
    
    frameFade.Completed:Wait()
    SplashFrame:Destroy()
    SplashBlur:Destroy()
end)

local HeaderDragArea = Instance.new("Frame")
HeaderDragArea.Name = "HeaderDragArea"
HeaderDragArea.Size = UDim2.new(1, 0, 0, 45)
HeaderDragArea.BackgroundTransparency = 1
HeaderDragArea.ZIndex = 5
HeaderDragArea.Parent = Main

local function InitializeWindowControls(frame, dragHandle)
    local dragToggle, dragStart, startPos
    local handle = dragHandle or frame
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if isResizing then return end 
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
InitializeWindowControls(Main, HeaderDragArea)

local LayoutLine = Instance.new("Frame")
LayoutLine.Name = "LayoutLine"
LayoutLine.Parent = Main
LayoutLine.Size = UDim2.new(0, 1, 1, -30)
LayoutLine.Position = UDim2.new(0.28, 0, 0, 15)
LayoutLine.BackgroundColor3 = Colors.LayoutLine
LayoutLine.BorderSizePixel = 0

local TopControls = Instance.new("Frame")
TopControls.Name = "TopControls"
TopControls.Parent = Main
TopControls.Size = UDim2.new(0.2, 0, 0, 35)
TopControls.Position = UDim2.new(1, -12, 0, 12)
TopControls.AnchorPoint = Vector2.new(1, 0)
TopControls.BackgroundTransparency = 1
TopControls.ZIndex = 6

local TopLayout = Instance.new("UIListLayout")
TopLayout.Parent = TopControls
TopLayout.FillDirection = Enum.FillDirection.Horizontal
TopLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
TopLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TopLayout.Padding = UDim.new(0, 6)

local function CreateTopButton(text, color, parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 24, 0, 24)
    btn.BackgroundColor3 = Colors.CardBg
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.TextColor3 = color
    btn.ZIndex = 7
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
MiniLogo.Size = UDim2.new(0, 45, 0, 45)
MiniLogo.Position = UDim2.new(0.05, 0, 0.05, 0)
MiniLogo.BackgroundColor3 = Colors.PureBlack
MiniLogo.BorderSizePixel = 0
MiniLogo.Text = "N"
MiniLogo.Font = Enum.Font.GothamBold
MiniLogo.TextSize = 18
MiniLogo.TextColor3 = Colors.BrightPurple
MiniLogo.Visible = false
MiniLogo.Active = true
MiniLogo.Parent = ScreenGui

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(0, 10)
MiniCorner.Parent = MiniLogo

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
Sidebar.Size = UDim2.new(0.28, -1, 1, 0)
Sidebar.BackgroundTransparency = 1

local BrandContainer = Instance.new("Frame")
BrandContainer.Size = UDim2.new(1, 0, 0, 65)
BrandContainer.BackgroundTransparency = 1
BrandContainer.Parent = Sidebar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -15, 0, 20)
Title.Position = UDim2.new(0, 15, 0, 18)
Title.BackgroundTransparency = 1
Title.Text = "Nova Hub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Colors.TextWhite
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = BrandContainer

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -15, 0, 12)
Subtitle.Position = UDim2.new(0, 15, 0, 38)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Premium Automation"
Subtitle.Font = Enum.Font.GothamBold
Subtitle.TextSize = 8
Subtitle.TextColor3 = Colors.BrightPurple
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = BrandContainer

local function CreateNavButton(text, positionY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -16, 0, 32)
    btn.Position = UDim2.new(0, 8, 0, positionY)
    btn.BackgroundColor3 = Colors.Background
    btn.BorderSizePixel = 0
    btn.Text = "     " .. text
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    btn.TextColor3 = Colors.TextMuted
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = Sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local BuyTabBtn = CreateNavButton("Dashboard", 70)
local AutoTabBtn = CreateNavButton("Auto", 106)
local MailTabBtn = CreateNavButton("Mail / Gifting", 142)
local SettingsTabBtn = CreateNavButton("Settings", 178)

local VerTag = Instance.new("TextLabel")
VerTag.Size = UDim2.new(1, -16, 0, 26)
VerTag.Position = UDim2.new(0, 8, 1, -35)
VerTag.BackgroundColor3 = Colors.CardBg
VerTag.Text = "Build v1.1.0"
VerTag.Font = Enum.Font.GothamMedium
VerTag.TextSize = 9
VerTag.TextColor3 = Colors.TextMuted
VerTag.Parent = Sidebar
Instance.new("UICorner", VerTag).CornerRadius = UDim.new(0, 6)

-- =============================================================================
-- VIEWPORTS SYSTEMS MGR
-- =============================================================================
local DashboardView = Instance.new("Frame")
DashboardView.Name = "DashboardView"
DashboardView.Parent = Main
DashboardView.Size = UDim2.new(0.72, -16, 1, -70)
DashboardView.Position = UDim2.new(0.28, 8, 0, 55)
DashboardView.BackgroundTransparency = 1
DashboardView.Visible = true

local AutoView = Instance.new("ScrollingFrame")
AutoView.Name = "AutoView"
AutoView.Parent = Main
AutoView.Size = UDim2.new(0.72, -16, 1, -70)
AutoView.Position = UDim2.new(0.28, 8, 0, 55)
AutoView.BackgroundTransparency = 1
AutoView.Visible = false
AutoView.BorderSizePixel = 0
AutoView.ScrollBarThickness = 3

local MailView = Instance.new("ScrollingFrame")
MailView.Name = "MailView"
MailView.Parent = Main
MailView.Size = UDim2.new(0.72, -16, 1, -70)
MailView.Position = UDim2.new(0.28, 8, 0, 55)
MailView.BackgroundTransparency = 1
MailView.Visible = false
MailView.BorderSizePixel = 0
MailView.ScrollBarThickness = 3

local SettingsView = Instance.new("ScrollingFrame")
SettingsView.Name = "SettingsView"
SettingsView.Parent = Main
SettingsView.Size = UDim2.new(0.72, -16, 1, -70)
SettingsView.Position = UDim2.new(0.28, 8, 0, 55)
SettingsView.BackgroundTransparency = 1
SettingsView.Visible = false
SettingsView.BorderSizePixel = 0
SettingsView.ScrollBarThickness = 3

local function SwitchTab(activeView)
    DashboardView.Visible = (DashboardView == activeView)
    AutoView.Visible = (AutoView == activeView)
    MailView.Visible = (MailView == activeView)
    SettingsView.Visible = (SettingsView == activeView)
    
    BuyTabBtn.BackgroundColor3 = (DashboardView == activeView) and Colors.CardBg or Colors.Background
    BuyTabBtn.TextColor3 = (DashboardView == activeView) and Colors.TextWhite or Colors.TextMuted
    
    AutoTabBtn.BackgroundColor3 = (AutoView == activeView) and Colors.CardBg or Colors.Background
    AutoTabBtn.TextColor3 = (AutoView == activeView) and Colors.TextWhite or Colors.TextMuted
    
    MailTabBtn.BackgroundColor3 = (MailView == activeView) and Colors.CardBg or Colors.Background
    MailTabBtn.TextColor3 = (MailView == activeView) and Colors.TextWhite or Colors.TextMuted
    
    SettingsTabBtn.BackgroundColor3 = (SettingsView == activeView) and Colors.CardBg or Colors.Background
    SettingsTabBtn.TextColor3 = (SettingsView == activeView) and Colors.TextWhite or Colors.TextMuted
end

BuyTabBtn.MouseButton1Click:Connect(function() SwitchTab(DashboardView) end)
AutoTabBtn.MouseButton1Click:Connect(function() SwitchTab(AutoView) end)
MailTabBtn.MouseButton1Click:Connect(function() SwitchTab(MailView) end)
SettingsTabBtn.MouseButton1Click:Connect(function() SwitchTab(SettingsView) end)

SwitchTab(DashboardView)

-- =============================================================================
-- AUTO VIEW TAB - ADDED AUTO SELL
-- =============================================================================
-- Layout Setup
local AutoLayout = Instance.new("UIListLayout", AutoView)
AutoLayout.Padding = UDim.new(0, 10)
AutoLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Helper for uniform UI creation
local function createToggleModule(parent, labelText, callback)
    local Container = Instance.new("Frame", parent)
    Container.Size = UDim2.new(1, -10, 0, 60)
    Container.BackgroundColor3 = Colors.CardBg
    Container.BorderSizePixel = 0
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 8)

    local Label = Instance.new("TextLabel", Container)
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = labelText
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 12
    Label.TextColor3 = Colors.TextWhite
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local ToggleBtn = Instance.new("TextButton", Container)
    ToggleBtn.Size = UDim2.new(0, 32, 0, 18)
    ToggleBtn.Position = UDim2.new(1, -44, 0.5, -9)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    ToggleBtn.Text = ""
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

    local Ball = Instance.new("Frame", ToggleBtn)
    Ball.Size = UDim2.new(0, 12, 0, 12)
    Ball.Position = UDim2.new(0, 2, 0.5, -6)
    Ball.BackgroundColor3 = Colors.TextMuted
    Ball.BorderSizePixel = 0
    Instance.new("UICorner", Ball).CornerRadius = UDim.new(1, 0)

    local isActive = false
    ToggleBtn.MouseButton1Click:Connect(function()
        isActive = not isActive
        local targetPos = isActive and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
        local targetBg = isActive and Colors.BrightPurple or Color3.fromRGB(45, 45, 55)
        local targetBall = isActive and Colors.TextWhite or Colors.TextMuted
        
        TweenService:Create(Ball, TweenInfo.new(0.15), {Position = targetPos, BackgroundColor3 = targetBall}):Play()
        TweenService:Create(ToggleBtn, TweenInfo.new(0.15), {BackgroundColor3 = targetBg}):Play()
        callback(isActive)
    end)
end

-- =============================================================================
-- MODULE REGISTRATION
-- =============================================================================

-- Auto Sell Module
local autoSellID = 28 -- Modify this variable to change the dynamic byte
createToggleModule(AutoView, "Auto Sell", function(isActive)
    if isActive then
        task.spawn(function()
            while true do -- Loop check handled by your trigger logic
                -- Uses string.char to make the last byte dynamic
                firePacket(buffer.fromstring(string.char(179) .. string.char(0) .. string.char(autoSellID)))
                task.wait(1)
            end
        end)
    end
end)

-- Auto Daily Deal Module
-- Add this variable at the top of your script so you can change it globally
local dailyDealID = 20 

-- Define the Daily Deal Module
local function createDailyDealModule(parent)
    -- ... (Container/UI setup remains the same) ...
    
    local isDailyDealActive = false
    local dailyDealThread = nil
    
    DailyDealToggle.MouseButton1Click:Connect(function()
        isDailyDealActive = not isDailyDealActive
        
        -- ... (Tween animations remain the same) ...
        
        if isDailyDealActive then
            dailyDealThread = task.spawn(function()
                while isDailyDealActive do
                    -- DYNAMIC BUFFER: 183, 0, [dailyDealID]
                    local payload = string.char(183) .. string.char(0) .. string.char(dailyDealID)
                    firePacket(buffer.fromstring(payload))
                    
                    task.wait(5)
                end
            end)
        else
            if dailyDealThread then task.cancel(dailyDealThread) end
        end
    end)
end

-- Finalize Canvas
AutoView.CanvasSize = UDim2.new(0, 0, 0, AutoLayout.AbsoluteContentSize.Y + 20)

-- =============================================================================
-- REMOTES EXECUTOR HOOK
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
-- INTERFACE BUILD PANEL SECTIONS
-- =============================================================================
local ColumnLayout = Instance.new("UIListLayout")
ColumnLayout.Parent = DashboardView
ColumnLayout.FillDirection = Enum.FillDirection.Horizontal
ColumnLayout.Padding = UDim.new(0, 10)

local function CreateModuleLayoutCard(title, defaultDelay, onSliderUpdate)
    local masterColumn = Instance.new("Frame")
    masterColumn.Size = UDim2.new(0.5, -5, 1, 0)
    masterColumn.BackgroundTransparency = 1
    masterColumn.Parent = DashboardView

    local upperCard = Instance.new("Frame")
    upperCard.Size = UDim2.new(1, 0, 0.74, 0)
    upperCard.BackgroundColor3 = Colors.CardBg
    upperCard.BorderSizePixel = 0
    upperCard.ZIndex = 2
    upperCard.Parent = masterColumn
    Instance.new("UICorner", upperCard).CornerRadius = UDim.new(0, 10)

    local headerFrame = Instance.new("Frame")
    headerFrame.Size = UDim2.new(1, 0, 0, 38)
    headerFrame.BackgroundTransparency = 1
    headerFrame.ZIndex = 3
    headerFrame.Parent = upperCard

    local expandTrigger = Instance.new("TextButton")
    expandTrigger.Size = UDim2.new(0.65, 0, 1, 0)
    expandTrigger.BackgroundTransparency = 1
    expandTrigger.Text = ""
    expandTrigger.ZIndex = 4
    expandTrigger.Parent = headerFrame

    local headerText = Instance.new("TextLabel")
    headerText.Size = UDim2.new(1, -20, 1, 0)
    headerText.Position = UDim2.new(0, 12, 0, 0)
    headerText.BackgroundTransparency = 1
    headerText.Text = title
    headerText.Font = Enum.Font.GothamBold
    headerText.TextSize = 12
    headerText.TextColor3 = Colors.TextWhite
    headerText.TextXAlignment = Enum.TextXAlignment.Left
    headerText.ZIndex = 4
    headerText.Parent = expandTrigger

    local arrowIndicator = Instance.new("TextLabel")
    arrowIndicator.Size = UDim2.new(0, 12, 1, 0)
    arrowIndicator.Position = UDim2.new(1, -12, 0, 0)
    arrowIndicator.BackgroundTransparency = 1
    arrowIndicator.Text = "▼"
    arrowIndicator.Font = Enum.Font.GothamBold
    arrowIndicator.TextSize = 8
    arrowIndicator.TextColor3 = Colors.TextMuted
    arrowIndicator.ZIndex = 4
    arrowIndicator.Parent = expandTrigger

    local toggleFrame = Instance.new("TextButton")
    toggleFrame.Size = UDim2.new(0, 32, 0, 18)
    toggleFrame.Position = UDim2.new(1, -44, 0.5, -9)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    toggleFrame.Text = ""
    toggleFrame.ZIndex = 4
    toggleFrame.Parent = headerFrame
    Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(1, 0)

    local toggleBall = Instance.new("Frame")
    toggleBall.Size = UDim2.new(0, 12, 0, 12)
    toggleBall.Position = UDim2.new(0, 2, 0.5, -6)
    toggleBall.BackgroundColor3 = Colors.TextMuted
    toggleBall.BorderSizePixel = 0
    toggleBall.ZIndex = 5
    toggleBall.Parent = toggleFrame
    Instance.new("UICorner", toggleBall).CornerRadius = UDim.new(1, 0)

    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, -12, 1, -44)
    container.Position = UDim2.new(0, 6, 0, 38)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.ScrollBarThickness = 3
    container.ScrollBarImageColor3 = Colors.TextMuted
    container.CanvasSize = UDim2.new(0, 0, 0, 0)
    container.ZIndex = 10 
    container.Parent = upperCard

    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = container
    listLayout.Padding = UDim.new(0, 4)

    local isOpen = true
    expandTrigger.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        arrowIndicator.Text = isOpen and "▼" or "▶"
        container.Visible = isOpen
    end)

    local lowerCard = Instance.new("Frame")
    lowerCard.Size = UDim2.new(1, 0, 0, 42)
    lowerCard.Position = UDim2.new(0, 0, 0.77, 0)
    lowerCard.BackgroundColor3 = Colors.CardBg
    lowerCard.BorderSizePixel = 0
    lowerCard.ZIndex = 2
    lowerCard.Parent = masterColumn
    Instance.new("UICorner", lowerCard).CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -24, 0.4, 0)
    label.Position = UDim2.new(0, 12, 0.1, 0)
    label.BackgroundTransparency = 1
    label.Text = title .. ": " .. string.format("%ds", defaultDelay)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 10
    label.TextColor3 = Colors.TextWhite
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 3
    label.Parent = lowerCard

    local track = Instance.new("TextButton")
    track.Size = UDim2.new(1, -24, 0, 4)
    track.Position = UDim2.new(0, 12, 0.65, 0)
    track.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    track.Text = ""
    track.AutoButtonColor = false
    track.ZIndex = 3
    track.Parent = lowerCard
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defaultDelay - minDelay) / (maxDelay - minDelay), 0, 1, 0)
    fill.BackgroundColor3 = Colors.BrightPurple
    fill.BorderSizePixel = 0
    fill.ZIndex = 3
    fill.Parent = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("TextButton")
    knob.Size = UDim2.new(0, 10, 0, 10)
    knob.Position = UDim2.new((defaultDelay - minDelay) / (maxDelay - minDelay), -5, 0.5, -5)
    knob.BackgroundColor3 = Colors.TextWhite
    knob.Text = ""
    knob.ZIndex = 4
    knob.Parent = track
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local externalSetVal = function(targetVal)
        label.Text = title .. ": " .. string.format("%ds", targetVal)
        local visualPercentage = (targetVal - minDelay) / (maxDelay - minDelay)
        fill.Size = UDim2.new(visualPercentage, 0, 1, 0)
        knob.Position = UDim2.new(visualPercentage, -5, 0.5, -5)
    end

    local isSliding = false
    local function UpdateTrack(input)
        local trackWidth = track.AbsoluteSize.X
        if trackWidth <= 0 then return end
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

    return container, toggleFrame, toggleBall, externalSetVal, listLayout
end

-- =============================================================================
-- DATA ROWS GENERATION BINDINGS
-- =============================================================================
local SeedContainer, SeedToggle, SeedBall, seedSliderSetter, seedListLayout = CreateModuleLayoutCard("Seeds", seedDelay, function(newVal)
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

local GearContainer, GearToggle, GearBall, gearSliderSetter, gearListLayout = CreateModuleLayoutCard("Gears", gearDelay, function(newVal)
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
-- MAIL LOGISTICS COMPONENT
-- =============================================================================
local MailLayout = Instance.new("UIListLayout")
MailLayout.Parent = MailView
MailLayout.Padding = UDim.new(0, 10)

local MailCard = Instance.new("Frame")
MailCard.Size = UDim2.new(1, -10, 0, 310)
MailCard.BackgroundColor3 = Colors.CardBg
MailCard.BorderSizePixel = 0
MailCard.Parent = MailView
Instance.new("UICorner", MailCard).CornerRadius = UDim.new(0, 8)

local MailHeader = Instance.new("TextLabel")
MailHeader.Size = UDim2.new(1, -24, 0, 35)
MailHeader.Position = UDim2.new(0, 12, 0, 4)
MailHeader.BackgroundTransparency = 1
MailHeader.Text = "Gifting & Mail Services"
MailHeader.Font = Enum.Font.GothamBold
MailHeader.TextSize = 12
MailHeader.TextColor3 = Colors.TextWhite
MailHeader.TextXAlignment = Enum.TextXAlignment.Left
MailHeader.Parent = MailCard

local UsernameInput = Instance.new("TextBox")
UsernameInput.Size = UDim2.new(1, -24, 0, 32)
UsernameInput.Position = UDim2.new(0, 12, 0, 40)
UsernameInput.BackgroundColor3 = Colors.ItemBg
UsernameInput.BorderSizePixel = 0
UsernameInput.Text = ""
UsernameInput.PlaceholderText = "Target Recipient Username..."
UsernameInput.PlaceholderColor3 = Colors.TextMuted
UsernameInput.Font = Enum.Font.GothamMedium
UsernameInput.TextSize = 11
UsernameInput.TextColor3 = Colors.TextWhite
UsernameInput.ClearTextOnFocus = false
UsernameInput.Parent = MailCard
Instance.new("UICorner", UsernameInput).CornerRadius = UDim.new(0, 6)

local SeedsDropdownTitle = Instance.new("TextLabel")
SeedsDropdownTitle.Size = UDim2.new(0.5, -10, 0, 18)
SeedsDropdownTitle.Position = UDim2.new(0, 12, 0, 80)
SeedsDropdownTitle.BackgroundTransparency = 1
SeedsDropdownTitle.Text = "Select Seeds"
SeedsDropdownTitle.Font = Enum.Font.GothamMedium
SeedsDropdownTitle.TextSize = 10
SeedsDropdownTitle.TextColor3 = Colors.TextMuted
SeedsDropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
SeedsDropdownTitle.Parent = MailCard

local GearsDropdownTitle = Instance.new("TextLabel")
GearsDropdownTitle.Size = UDim2.new(0.5, -10, 0, 18)
GearsDropdownTitle.Position = UDim2.new(0.5, 8, 0, 80)
GearsDropdownTitle.BackgroundTransparency = 1
GearsDropdownTitle.Text = "Select Gears"
GearsDropdownTitle.Font = Enum.Font.GothamMedium
GearsDropdownTitle.TextSize = 10
GearsDropdownTitle.TextColor3 = Colors.TextMuted
GearsDropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
GearsDropdownTitle.Parent = MailCard

local SeedsListFrame = Instance.new("ScrollingFrame")
SeedsListFrame.Size = UDim2.new(0.5, -14, 0, 90)
SeedsListFrame.Position = UDim2.new(0, 12, 0, 100)
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
GearsListFrame.Size = UDim2.new(0.5, -14, 0, 90)
GearsListFrame.Position = UDim2.new(0.5, 6, 0, 100)
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
        rowBtn.Size = UDim2.new(1, 0, 0, 26)
        rowBtn.BackgroundTransparency = 1
        rowBtn.Text = "   " .. item.Name
        rowBtn.Font = Enum.Font.GothamMedium
        rowBtn.TextSize = 10
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
CountInput.Size = UDim2.new(0.3, -8, 0, 32)
CountInput.Position = UDim2.new(0, 12, 0, 200)
CountInput.BackgroundColor3 = Colors.ItemBg
CountInput.BorderSizePixel = 0
CountInput.Text = "1"
CountInput.PlaceholderText = "Count..."
CountInput.PlaceholderColor3 = Colors.TextMuted
CountInput.Font = Enum.Font.GothamMedium
CountInput.TextSize = 11
CountInput.TextColor3 = Colors.TextWhite
CountInput.ClearTextOnFocus = false
CountInput.Parent = MailCard
Instance.new("UICorner", CountInput).CornerRadius = UDim.new(0, 6)

local ManualSendBtn = Instance.new("TextButton")
ManualSendBtn.Size = UDim2.new(0.7, -12, 0, 32)
ManualSendBtn.Position = UDim2.new(0.3, 8, 0, 200)
ManualSendBtn.BackgroundColor3 = Colors.AccentPurple
ManualSendBtn.Text = "Dispatch Mail Package"
ManualSendBtn.Font = Enum.Font.GothamBold
ManualSendBtn.TextSize = 11
ManualSendBtn.TextColor3 = Colors.TextWhite
ManualSendBtn.Parent = MailCard
Instance.new("UICorner", ManualSendBtn).CornerRadius = UDim.new(0, 6)

local AutoRepeatLabel = Instance.new("TextLabel")
AutoRepeatLabel.Size = UDim2.new(0.6, 0, 0, 22)
AutoRepeatLabel.Position = UDim2.new(0, 12, 0, 245)
AutoRepeatLabel.BackgroundTransparency = 1
AutoRepeatLabel.Text = "Continuous Output Pipeline"
AutoRepeatLabel.Font = Enum.Font.GothamMedium
AutoRepeatLabel.TextSize = 11
AutoRepeatLabel.TextColor3 = Colors.TextWhite
AutoRepeatLabel.TextXAlignment = Enum.TextXAlignment.Left
AutoRepeatLabel.Parent = MailCard

local MailToggleFrame = Instance.new("TextButton")
MailToggleFrame.Size = UDim2.new(0, 32, 0, 18)
MailToggleFrame.Position = UDim2.new(1, -44, 0, 247)
MailToggleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
MailToggleFrame.Text = ""
MailToggleFrame.Parent = MailCard
Instance.new("UICorner", MailToggleFrame).CornerRadius = UDim.new(1, 0)

local MailToggleBall = Instance.new("Frame")
MailToggleBall.Size = UDim2.new(0, 12, 0, 12)
MailToggleBall.Position = UDim2.new(0, 2, 0.5, -6)
MailToggleBall.BackgroundColor3 = Colors.TextMuted
MailToggleBall.BorderSizePixel = 0
MailToggleBall.Parent = MailToggleFrame
Instance.new("UICorner", MailToggleBall).CornerRadius = UDim.new(1, 0)

-- =============================================================================
-- CROPS DELIVERY NETWORK
-- =============================================================================
local FruitGiftCard = Instance.new("Frame")
FruitGiftCard.Name = "FruitGiftCard"
FruitGiftCard.Size = UDim2.new(1, -10, 0, 190)
FruitGiftCard.BackgroundColor3 = Colors.CardBg
FruitGiftCard.BorderSizePixel = 0
FruitGiftCard.Parent = MailView
Instance.new("UICorner", FruitGiftCard).CornerRadius = UDim.new(0, 8)

local FruitHeader = Instance.new("TextLabel")
FruitHeader.Size = UDim2.new(1, -24, 0, 35)
FruitHeader.Position = UDim2.new(0, 12, 0, 4)
FruitHeader.BackgroundTransparency = 1
FruitHeader.Text = "Fruit & Crop Delivery Network"
FruitHeader.Font = Enum.Font.GothamBold
FruitHeader.TextSize = 12
FruitHeader.TextColor3 = Colors.TextWhite
FruitHeader.TextXAlignment = Enum.TextXAlignment.Left
FruitHeader.Parent = FruitGiftCard

local FruitUsernameInput = Instance.new("TextBox")
FruitUsernameInput.Size = UDim2.new(1, -24, 0, 32)
FruitUsernameInput.Position = UDim2.new(0, 12, 0, 40)
FruitUsernameInput.BackgroundColor3 = Colors.ItemBg
FruitUsernameInput.BorderSizePixel = 0
FruitUsernameInput.Text = ""
FruitUsernameInput.PlaceholderText = "Target Recipient Username..."
FruitUsernameInput.PlaceholderColor3 = Colors.TextMuted
FruitUsernameInput.Font = Enum.Font.GothamMedium
FruitUsernameInput.TextSize = 11
FruitUsernameInput.TextColor3 = Colors.TextWhite
FruitUsernameInput.ClearTextOnFocus = false
FruitUsernameInput.Parent = FruitGiftCard
Instance.new("UICorner", FruitUsernameInput).CornerRadius = UDim.new(0, 6)

local FruitDropdownToggle = Instance.new("TextButton")
FruitDropdownToggle.Size = UDim2.new(1, -24, 0, 32)
FruitDropdownToggle.Position = UDim2.new(0, 12, 0, 80)
FruitDropdownToggle.BackgroundColor3 = Colors.ItemBg
FruitDropdownToggle.BorderSizePixel = 0
FruitDropdownToggle.Text = "Select Inventory Weight Cargo (kg) v"
FruitDropdownToggle.Font = Enum.Font.GothamMedium
FruitDropdownToggle.TextSize = 11
FruitDropdownToggle.TextColor3 = Colors.TextMuted
FruitDropdownToggle.Parent = FruitGiftCard
Instance.new("UICorner", FruitDropdownToggle).CornerRadius = UDim.new(0, 6)

local FruitDropdownMenu = Instance.new("ScrollingFrame")
FruitDropdownMenu.Size = UDim2.new(1, -24, 0, 100)
FruitDropdownMenu.Position = UDim2.new(0, 12, 0, 115)
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
SendFruitBtn.Size = UDim2.new(1, -24, 0, 35)
SendFruitBtn.Position = UDim2.new(0, 12, 0, 130)
SendFruitBtn.BackgroundColor3 = Colors.BrightPurple
SendFruitBtn.Text = "Transmit Cargo Logistics"
SendFruitBtn.Font = Enum.Font.GothamBold
SendFruitBtn.TextSize = 11
SendFruitBtn.TextColor3 = Colors.TextWhite
SendFruitBtn.Parent = FruitGiftCard
Instance.new("UICorner", SendFruitBtn).CornerRadius = UDim.new(0, 6)

local selectedFruitName = nil

local function PopulateFruitDropdown()
    for _, child in ipairs(FruitDropdownMenu:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, item in ipairs(HarvestedFruits) do
        local row = Instance.new("TextButton")
        row.Size = UDim2.new(1, 0, 0, 26)
        row.BackgroundTransparency = 1
        row.Text = "   " .. item.Name
        row.Font = Enum.Font.GothamMedium
        row.TextSize = 10
        row.TextColor3 = Colors.TextWhite
        row.TextXAlignment = Enum.TextXAlignment.Left
        row.ZIndex = 16
        row.Parent = FruitDropdownMenu
        
        row.MouseButton1Click:Connect(function()
            selectedFruitName = item.Name
            FruitDropdownToggle.Text = "Cargo Set: " .. item.Name .. " v"
            FruitDropdownMenu.Visible = false
        end)
    end
    FruitDropdownMenu.CanvasSize = UDim2.new(0, 0, 0, FruitDropdownLayout.AbsoluteContentSize.Y)
end

FruitDropdownToggle.MouseButton1Click:Connect(function()
    FruitDropdownMenu.Visible = not FruitDropdownMenu.Visible
    if FruitDropdownMenu.Visible then PopulateFruitDropdown() end
end)

SendFruitBtn.MouseButton1Click:Connect(function()
    local targetUser = FruitUsernameInput.Text:gsub("%s+", "")
    if targetUser == "" or not selectedFruitName then return end
    local headerBytes = "\029\001\022\020"
    local fullPayload = headerBytes .. targetUser
    firePacket(buffer.fromstring(fullPayload))
end)

-- =============================================================================
-- LOGISTICS MATRIX HANDLERS
-- =============================================================================
local function buildMailBuffer(targetUser, itemName, itemCount, categoryName)
    local header = "\028\001\024\000\000@<dE\235A\028\005\001\028"
    local userPart = "\v\bReceiver\v" .. string.char(#targetUser) .. targetUser
    local itemPart = "\v\aItemKey\v" .. string.char(#itemName) .. itemName
    local countPart = "\v\005Count\005" .. string.char(math.clamp(itemCount, 1, 255))
    local categoryPart = "\v\bCategory\v" .. string.char(#categoryName) .. categoryName
    local footer = "\000\000\000"
    return buffer.fromstring(header .. userPart .. itemPart .. countPart .. categoryPart .. footer)
end

local function dispatchCustomMail()
    local targetUser = UsernameInput.Text:gsub("%s+", "")
    local amount = tonumber(CountInput.Text) or 1
    if targetUser ~= "" then
        for _, giftData in pairs(selectedGiftItems) do
            firePacket(buildMailBuffer(targetUser, giftData.Item.Name, amount, giftData.Category))
        end
    end
end

local isMailLooping = false
local mailLoopThread = nil

ManualSendBtn.MouseButton1Click:Connect(function() dispatchCustomMail() end)

MailToggleFrame.MouseButton1Click:Connect(function()
    isMailLooping = not isMailLooping
    local targetPos = isMailLooping and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    local targetBg = isMailLooping and Colors.BrightPurple or Color3.fromRGB(45, 45, 55)
    local targetBallColor = isMailLooping and Colors.TextWhite or Colors.TextMuted
    
    TweenService:Create(MailToggleBall, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {Position = targetPos, BackgroundColor3 = targetBallColor}):Play()
    TweenService:Create(MailToggleFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {BackgroundColor3 = targetBg}):Play()
    
    if mailLoopThread then task.cancel(mailLoopThread) mailLoopThread = nil end
    if isMailLooping then
        mailLoopThread = task.spawn(function()
            while true do dispatchCustomMail() task.wait(seedDelay) end
        end)
    end
end)

-- =============================================================================
-- SYSTEM CONFIGURATION SETTINGS
-- =============================================================================
local SettingsLayout = Instance.new("UIListLayout")
SettingsLayout.Parent = SettingsView
SettingsLayout.Padding = UDim.new(0, 8)

local function CreateSettingsOption(titleText, subText)
    local optionFrame = Instance.new("Frame")
    optionFrame.Size = UDim2.new(1, -10, 0, 55)
    optionFrame.BackgroundColor3 = Colors.CardBg
    optionFrame.BorderSizePixel = 0
    optionFrame.Parent = SettingsView
    Instance.new("UICorner", optionFrame).CornerRadius = UDim.new(0, 8)

    local labelText = Instance.new("TextLabel")
    labelText.Size = UDim2.new(0.7, 0, 0, 18)
    labelText.Position = UDim2.new(0, 12, 0, 10)
    labelText.BackgroundTransparency = 1
    labelText.Text = titleText
    labelText.Font = Enum.Font.GothamBold
    labelText.TextSize = 11
    labelText.TextColor3 = Colors.TextWhite
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Parent = optionFrame

    local descText = Instance.new("TextLabel")
    descText.Size = UDim2.new(0.7, 0, 0, 14)
    descText.Position = UDim2.new(0, 12, 0, 28)
    descText.BackgroundTransparency = 1
    descText.Text = subText
    descText.Font = Enum.Font.GothamMedium
    descText.TextSize = 9
    descText.TextColor3 = Colors.TextMuted
    descText.TextXAlignment = Enum.TextXAlignment.Left
    descText.Parent = optionFrame
    return optionFrame
end

CreateSettingsOption("Anti-AFK Verification Bypass", "Intercepts and resets game-engine internal idle timers.")
CreateSettingsOption("High-Velocity Payload Buffering", "Pre-allocates buffer arrays for faster operational dispatch.")

local ConfigCard = Instance.new("Frame")
ConfigCard.Size = UDim2.new(1, -10, 0, 190)
ConfigCard.BackgroundColor3 = Colors.CardBg
ConfigCard.BorderSizePixel = 0
ConfigCard.Parent = SettingsView
Instance.new("UICorner", ConfigCard).CornerRadius = UDim.new(0, 8)

local ConfigHeader = Instance.new("TextLabel")
ConfigHeader.Size = UDim2.new(1, -24, 0, 35)
ConfigHeader.Position = UDim2.new(0, 12, 0, 4)
ConfigHeader.BackgroundTransparency = 1
ConfigHeader.Text = "Profile Allocation Memory"
ConfigHeader.Font = Enum.Font.GothamBold
ConfigHeader.TextSize = 12
ConfigHeader.TextColor3 = Colors.TextWhite
ConfigHeader.TextXAlignment = Enum.TextXAlignment.Left
ConfigHeader.Parent = ConfigCard

local ConfigInput = Instance.new("TextBox")
ConfigInput.Size = UDim2.new(0.6, -12, 0, 30)
ConfigInput.Position = UDim2.new(0, 12, 0, 40)
ConfigInput.BackgroundColor3 = Colors.ItemBg
ConfigInput.BorderSizePixel = 0
ConfigInput.Text = ""
ConfigInput.PlaceholderText = "Profile allocation name..."
ConfigInput.PlaceholderColor3 = Colors.TextMuted
ConfigInput.Font = Enum.Font.GothamMedium
ConfigInput.TextSize = 11
ConfigInput.TextColor3 = Colors.TextWhite
ConfigInput.ClearTextOnFocus = false
ConfigInput.Parent = ConfigCard
Instance.new("UICorner", ConfigInput).CornerRadius = UDim.new(0, 6)

local CreateBtn = Instance.new("TextButton")
CreateBtn.Size = UDim2.new(0.4, -12, 0, 30)
CreateBtn.Position = UDim2.new(0.6, 12, 0, 40)
CreateBtn.BackgroundColor3 = Colors.AccentPurple
CreateBtn.Text = "Initialize Profile"
CreateBtn.Font = Enum.Font.GothamBold
CreateBtn.TextSize = 11
CreateBtn.TextColor3 = Colors.TextWhite
CreateBtn.Parent = ConfigCard
Instance.new("UICorner", CreateBtn).CornerRadius = UDim.new(0, 6)

local ScrollConfigList = Instance.new("ScrollingFrame")
ScrollConfigList.Size = UDim2.new(1, -24, 0, 95)
ScrollConfigList.Position = UDim2.new(0, 12, 0, 80)
ScrollConfigList.BackgroundTransparency = 1
ScrollConfigList.BorderSizePixel = 0
ScrollConfigList.ScrollBarThickness = 2
ScrollConfigList.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollConfigList.Parent = ConfigCard

local ConfigListLayout = Instance.new("UIListLayout")
ConfigListLayout.Parent = ScrollConfigList
ConfigListLayout.Padding = UDim.new(0, 4)

-- =============================================================================
-- PROFILES IO SYSTEM BINDINGS
-- =============================================================================
local FolderName = "MeliodasConfigEngine"
if not isfolder(FolderName) then makefolder(FolderName) end

local function GetAutoLoadFile()
    if isfile(FolderName .. "/autoload.txt") then return readfile(FolderName .. "/autoload.txt") end
    return nil
end

local function SyncVisualState()
    for name, updateVisual in pairs(seedCheckboxElements) do updateVisual(selectedSeeds[name] ~= nil) end
    for name, updateVisual in pairs(gearCheckboxElements) do updateVisual(selectedGears[name] ~= nil) end
    if seedSliderUpdateFunc then seedSliderUpdateFunc(seedDelay) end
    if gearSliderUpdateFunc then gearSliderUpdateFunc(gearDelay) end
    if updateSeedToggleVisual then updateSeedToggleVisual(isSeedLooping) end
    if updateGearToggleVisual then updateGearToggleVisual(isGearLooping) end
end

local RefreshConfigList

local function SaveConfig(name)
    if name == "" then return end
    local structuralState = {
        SelectedSeeds = {}, SelectedGears = {},
        SeedDelay = seedDelay, GearDelay = gearDelay,
        IsSeedLooping = isSeedLooping, IsGearLooping = isGearLooping
    }
    for k, v in pairs(selectedSeeds) do structuralState.SelectedSeeds[k] = true end
    for k, v in pairs(selectedGears) do structuralState.SelectedGears[k] = true end
    writefile(FolderName .. "/" .. name .. ".json", HttpService:JSONEncode(structuralState))
    RefreshConfigList()
end

local function LoadConfig(name)
    local path = FolderName .. "/" .. name .. ".json"
    if not isfile(path) then return end
    
    local success, structuralState = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
    if not success or not structuralState then return end
    
    for _, t in pairs(activeSeedLoops) do task.cancel(t) end
    for _, t in pairs(activeGearLoops) do task.cancel(t) end
    table.clear(activeSeedLoops) table.clear(activeGearLoops)
    table.clear(selectedSeeds) table.clear(selectedGears)
    
    seedDelay = structuralState.SeedDelay or 15
    gearDelay = structuralState.GearDelay or 15
    isSeedLooping = structuralState.IsSeedLooping or false
    isGearLooping = structuralState.IsGearLooping or false
    
    if structuralState.SelectedSeeds then
        for _, seedItem in ipairs(Seeds) do
            if structuralState.SelectedSeeds[seedItem.Name] then selectedSeeds[seedItem.Name] = seedItem.Data end
        end
    end
    if structuralState.SelectedGears then
        for _, gearItem in ipairs(Gears) do
            if structuralState.SelectedGears[gearItem.Name] then selectedGears[gearItem.Name] = gearItem.Data end
        end
    end
    
    if isSeedLooping then
        for n, d in pairs(selectedSeeds) do
            activeSeedLoops[n] = task.spawn(function() while true do firePacket(buffer.fromstring(d)) task.wait(seedDelay) end end)
        end
    end
    if isGearLooping then
        for n, d in pairs(selectedGears) do
            activeGearLoops[n] = task.spawn(function() while true do firePacket(buffer.fromstring(d)) task.wait(gearDelay) end end)
        end
    end
    SyncVisualState()
    RefreshConfigList()
end

RefreshConfigList = function()
    for _, child in ipairs(ScrollConfigList:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
    local autoFile = GetAutoLoadFile()
    
    for _, path in ipairs(listfiles(FolderName)) do
        if path:sub(-5) == ".json" then
            local rawName = path:match("([^/]+)%.json$") or path
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 28)
            row.BackgroundColor3 = Colors.ItemBg
            row.Parent = ScrollConfigList
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(0.4, 0, 1, 0)
            nameLabel.Position = UDim2.new(0, 8, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = rawName .. (autoFile == rawName and " [AUTO]" or "")
            nameLabel.Font = Enum.Font.GothamMedium
            nameLabel.TextSize = 10
            nameLabel.TextColor3 = autoFile == rawName and Colors.BrightPurple or Colors.TextWhite
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.Parent = row
            
            local function CreateActionBtn(txt, color, xPos, widthScale)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(widthScale, -4, 0, 20)
                btn.Position = UDim2.new(xPos, 0, 0.5, -10)
                btn.BackgroundColor3 = color
                btn.Text = txt
                btn.Font = Enum.Font.GothamBold
                btn.TextSize = 9
                btn.TextColor3 = Colors.TextWhite
                btn.Parent = row
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
                return btn
            end
            
            CreateActionBtn("Load", Color3.fromRGB(34, 197, 94), 0.45, 0.16).MouseButton1Click:Connect(function() LoadConfig(rawName) end)
            CreateActionBtn("Auto", Color3.fromRGB(59, 130, 246), 0.62, 0.16).MouseButton1Click:Connect(function()
                if GetAutoLoadFile() == rawName then delfile(FolderName .. "/autoload.txt") else writefile(FolderName .. "/autoload.txt", rawName) end
                RefreshConfigList()
            end)
            CreateActionBtn("Del", Colors.CloseRed, 0.79, 0.16).MouseButton1Click:Connect(function()
                if isfile(FolderName .. "/" .. rawName .. ".json") then delfile(FolderName .. "/" .. rawName .. ".json") end
                if GetAutoLoadFile() == rawName then delfile(FolderName .. "/autoload.txt") end
                RefreshConfigList()
            end)
        end
    end
    ScrollConfigList.CanvasSize = UDim2.new(0, 0, 0, ConfigListLayout.AbsoluteContentSize.Y)
end

CreateBtn.MouseButton1Click:Connect(function()
    local text = ConfigInput.Text:gsub("%s+", "")
    if text ~= "" then SaveConfig(text) ConfigInput.Text = "" end
end)

-- =============================================================================
-- CONTAINER CHECKBOX SELECTION MATRICES
-- =============================================================================
local function PopulateItems(itemsTable, targetContainer, selectedTracker, activeLoopsTracker, loopConditionCheck, getDelay, UIStorageTable, layoutsRef)
    for i, item in ipairs(itemsTable) do
        local itemRow = Instance.new("TextButton")
        itemRow.Size = UDim2.new(1, 0, 0, 26)
        itemRow.BackgroundColor3 = Colors.ItemBg
        itemRow.Text = ""
        itemRow.ZIndex = 12
        itemRow.AutoButtonColor = false
        itemRow.Parent = targetContainer
        Instance.new("UICorner", itemRow).CornerRadius = UDim.new(0, 4)

        local checkBox = Instance.new("Frame")
        checkBox.Size = UDim2.new(0, 10, 0, 10)
        checkBox.Position = UDim2.new(0, 8, 0.5, -5)
        checkBox.BackgroundColor3 = Colors.Background
        checkBox.ZIndex = 13
        checkBox.Parent = itemRow
        Instance.new("UICorner", checkBox).CornerRadius = UDim.new(0, 2)

        local checkStroke = Instance.new("UIStroke")
        checkStroke.Thickness = 1
        checkStroke.Color = Colors.TextMuted
        checkStroke.Parent = checkBox

        local itemLabel = Instance.new("TextLabel")
        itemLabel.Size = UDim2.new(1, -30, 1, 0)
        itemLabel.Position = UDim2.new(0, 26, 0, 0)
        itemLabel.BackgroundTransparency = 1
        itemLabel.Text = item.Name
        itemLabel.Font = Enum.Font.GothamMedium
        itemLabel.TextSize = 10
        itemLabel.TextColor3 = Colors.TextWhite
        itemLabel.TextXAlignment = Enum.TextXAlignment.Left
        itemLabel.ZIndex = 13
        itemLabel.Parent = itemRow

        local updateVisuals = function(shouldCheck)
            if shouldCheck then
                TweenService:Create(checkBox, TweenInfo.new(0.1), {BackgroundColor3 = Colors.BrightPurple}):Play()
                TweenService:Create(checkStroke, TweenInfo.new(0.1), {Color = Colors.BrightPurple}):Play()
            else
                TweenService:Create(checkBox, TweenInfo.new(0.1), {BackgroundColor3 = Colors.Background}):Play()
                TweenService:Create(checkStroke, TweenInfo.new(0.1), {Color = Colors.TextMuted}):Play()
            end
        end

        UIStorageTable[item.Name] = updateVisuals

        itemRow.MouseButton1Click:Connect(function()
            if selectedTracker[item.Name] then
                selectedTracker[item.Name] = nil
                updateVisuals(false)
                if activeLoopsTracker[item.Name] then task.cancel(activeLoopsTracker[item.Name]) activeLoopsTracker[item.Name] = nil end
            else
                selectedTracker[item.Name] = item.Data
                updateVisuals(true)
                if loopConditionCheck() then
                    activeLoopsTracker[item.Name] = task.spawn(function()
                        while true do firePacket(buffer.fromstring(item.Data)) task.wait(getDelay()) end
                    end)
                end
            end
        end)
    end
    targetContainer.CanvasSize = UDim2.new(0, 0, 0, layoutsRef.AbsoluteContentSize.Y + 10)
end

local function handleToggleAnimations(frame, ball, state)
    local targetPos = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    local targetBg = state and Colors.BrightPurple or Color3.fromRGB(45, 45, 55)
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
            activeSeedLoops[name] = task.spawn(function() while true do firePacket(buffer.fromstring(data)) task.wait(seedDelay) end end)
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
            activeGearLoops[name] = task.spawn(function() while true do firePacket(buffer.fromstring(data)) task.wait(gearDelay) end end)
        end
    end
end)

PopulateItems(Seeds, SeedContainer, selectedSeeds, activeSeedLoops, function() return isSeedLooping end, function() return seedDelay end, seedCheckboxElements, seedListLayout)
PopulateItems(Gears, GearContainer, selectedGears, activeGearLoops, function() return isGearLooping end, function() return gearDelay end, gearCheckboxElements, gearListLayout)

SettingsView.CanvasSize = UDim2.new(0, 0, 0, SettingsLayout.AbsoluteContentSize.Y + 20)
MailView.CanvasSize = UDim2.new(0, 0, 0, MailLayout.AbsoluteContentSize.Y + 20)

RefreshConfigList()
local initialAutoFile = GetAutoLoadFile()
if initialAutoFile then pcall(function() LoadConfig(initialAutoFile) end) end
