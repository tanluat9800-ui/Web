-- [[ REDZ HUB V22 - PHẦN 1: SYSTEM & UI ]]
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- 1. CLEANUP & INIT
if getgenv().RedzLib then getgenv().RedzLib = nil end
local Library = {}

local Parent = CoreGui or LocalPlayer.PlayerGui
if Parent:FindFirstChild("RedzV22") then Parent.RedzV22:Destroy() end

local ScreenGui = Instance.new("ScreenGui", Parent)
ScreenGui.Name = "RedzV22"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.DisplayOrder = 9999

-- 2. LOADING SCREEN (6 GIÂY - NỀN ĐEN MỜ)
local LoadHolder = Instance.new("Frame", ScreenGui)
LoadHolder.Size = UDim2.new(1,0,1,0)
LoadHolder.BackgroundColor3 = Color3.fromRGB(0,0,0)
LoadHolder.BackgroundTransparency = 0.3
LoadHolder.ZIndex = 1000

local LoadBox = Instance.new("Frame", LoadHolder)
LoadBox.Size = UDim2.new(0, 300, 0, 80)
LoadBox.Position = UDim2.new(0.5, -150, 0.5, -40)
LoadBox.BackgroundColor3 = Color3.fromRGB(15,15,15)
Instance.new("UICorner", LoadBox).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", LoadBox).Color = Color3.fromRGB(255,0,0)
Instance.new("UIStroke", LoadBox).Thickness = 2

local LoadTitle = Instance.new("TextLabel", LoadBox)
LoadTitle.Text = "REDZ V22 LOADING..."
LoadTitle.Size = UDim2.new(1,0,0,40)
LoadTitle.TextColor3 = Color3.fromRGB(255,255,255)
LoadTitle.BackgroundTransparency = 1
LoadTitle.Font = Enum.Font.GothamBlack
LoadTitle.TextSize = 18

local LoadBarBG = Instance.new("Frame", LoadBox)
LoadBarBG.Size = UDim2.new(0.8,0,0,6)
LoadBarBG.Position = UDim2.new(0.1,0,0.6,0)
LoadBarBG.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", LoadBarBG)

local LoadBarFill = Instance.new("Frame", LoadBarBG)
LoadBarFill.Size = UDim2.new(0,0,1,0)
LoadBarFill.BackgroundColor3 = Color3.fromRGB(255,0,0)
Instance.new("UICorner", LoadBarFill)

-- 3. MAIN UI SETUP
local ToggleBtn = Instance.new("ImageButton", ScreenGui)
ToggleBtn.Visible = false -- Ẩn trước
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", ToggleBtn).Color = Color3.fromRGB(255,0,0)
local ToggleText = Instance.new("TextLabel", ToggleBtn); ToggleText.Size = UDim2.new(1,0,1,0); ToggleText.BackgroundTransparency = 1; ToggleText.Text = "R"; ToggleText.TextColor3 = Color3.fromRGB(255,255,255); ToggleText.Font = Enum.Font.FredokaOne; ToggleText.TextSize = 28

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 450, 0, 320)
Main.Position = UDim2.new(0.5, -225, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(255,0,0)
Instance.new("UIStroke", Main).Thickness = 2

local TabCon = Instance.new("Frame", Main)
TabCon.Size = UDim2.new(0, 110, 1, 0)
TabCon.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", TabCon).CornerRadius = UDim.new(0, 10)
local TabList = Instance.new("UIListLayout", TabCon); TabList.Padding = UDim.new(0, 5); TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center; Instance.new("UIPadding", TabCon).PaddingTop = UDim.new(0,10)

local ContentCon = Instance.new("Frame", Main)
ContentCon.Size = UDim2.new(1, -120, 1, -20)
ContentCon.Position = UDim2.new(0, 120, 0, 10)
ContentCon.BackgroundTransparency = 1

-- 4. HÀM TẠO UI (ĐƯỢC LƯU VÀO THƯ VIỆN ĐỂ PHẦN 2 GỌI)
function Library:AddTab(Text)
    local Btn = Instance.new("TextButton", TabCon)
    Btn.Size = UDim2.new(0.9, 0, 0, 35)
    Btn.Text = Text
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 12
    Instance.new("UICorner", Btn)
    
    local Page = Instance.new("ScrollingFrame", ContentCon)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 5)
    
    Btn.MouseButton1Click:Connect(function()
        for _, v in pairs(ContentCon:GetChildren()) do v.Visible = false end
        Page.Visible = true
    end)
    return Page
end

function Library:AddToggle(Page, Text, Flag, Default)
    getgenv().Settings[Flag] = Default
    local Btn = Instance.new("TextButton", Page)
    Btn.Size = UDim2.new(1, 0, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Btn.Text = "  " .. Text
    Btn.TextColor3 = getgenv().Settings[Flag] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(150, 150, 150)
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 12
    Instance.new("UICorner", Btn)
    
    Btn.MouseButton1Click:Connect(function()
        getgenv().Settings[Flag] = not getgenv().Settings[Flag]
        Btn.TextColor3 = getgenv().Settings[Flag] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(150, 150, 150)
    end)
end

-- FIX LỖI SLIDER DÍNH CHÙM (SỬ DỤNG BIẾN DRAGGING CỤC BỘ)
function Library:AddSlider(Page, Text, Flag, Min, Max, Default)
    getgenv().Settings[Flag] = Default
    local Frame = Instance.new("Frame", Page)
    Frame.Size = UDim2.new(1, 0, 0, 45)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Instance.new("UICorner", Frame)
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.BackgroundTransparency = 1
    Label.Text = "  " .. Text .. ": " .. Default
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 12
    
    local SliderBG = Instance.new("TextButton", Frame)
    SliderBG.Size = UDim2.new(0.9, 0, 0, 6)
    SliderBG.Position = UDim2.new(0.05, 0, 0.6, 0)
    SliderBG.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    SliderBG.Text = ""
    Instance.new("UICorner", SliderBG)
    
    local Fill = Instance.new("Frame", SliderBG)
    Fill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    Instance.new("UICorner", Fill)
    
    -- LOGIC RIÊNG BIỆT CHO TỪNG SLIDER
    local isDragging = false
    
    SliderBG.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local Percent = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
            local Value = math.floor(Min + (Max - Min) * Percent)
            getgenv().Settings[Flag] = Value
            Label.Text = "  " .. Text .. ": " .. Value
            Fill.Size = UDim2.new(Percent, 0, 1, 0)
        end
    end)
end

function Library:AddTextBox(Page, Text, Flag)
    local Frame = Instance.new("Frame", Page); Frame.Size = UDim2.new(1,0,0,40); Frame.BackgroundColor3 = Color3.fromRGB(25,25,25); Instance.new("UICorner", Frame)
    local Input = Instance.new("TextBox", Frame); Input.Size = UDim2.new(0.9,0,0.8,0); Input.Position = UDim2.new(0.05,0,0.1,0); Input.BackgroundColor3 = Color3.fromRGB(10,10,10); Input.TextColor3 = Color3.fromRGB(255,255,255); Input.Text = ""; Input.PlaceholderText = Text; Instance.new("UICorner", Input)
    Input.FocusLost:Connect(function() getgenv().Settings[Flag] = Input.Text end)
end

-- 5. EXPORT LIBRARY RA GLOBAL
getgenv().RedzLib = Library

-- 6. TOGGLE LOGIC & LOADING EXECUTION
local dragging, dragStart, startPos
ToggleBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = i.Position; startPos = ToggleBtn.Position end end)
UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then local d = i.Position - dragStart; ToggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y) end end)
ToggleBtn.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

spawn(function()
    for i = 1, 100 do LoadBarFill.Size = UDim2.new(i/100, 0, 1, 0); task.wait(0.06) end
    LoadHolder:Destroy()
    ToggleBtn.Visible = true
end)
-- [[ REDZ HUB V22 - PHẦN 2: FEATURES ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = game.Workspace.CurrentCamera

-- 1. ĐỢI PHẦN 1 LOAD XONG
if not getgenv().RedzLib then 
    game.StarterGui:SetCore("SendNotification", {Title = "LỖI", Text = "Vui lòng chạy PHẦN 1 trước!", Duration = 5})
    return 
end

-- 2. DÙNG HÀM TỪ PHẦN 1 ĐỂ TẠO MENU
local Lib = getgenv().RedzLib
getgenv().Settings = { -- Reset Settings để đảm bảo đồng bộ
    AttackAura = false, HitboxExpander = false, HitboxSize = 25, HitboxTrans = 5, TargetName = "", AutoStomp = false, AimLock = false,
    FixSpeed = true, WalkSpeed = 16, AntiRagdoll = true, SmartNoclip = true, InfiniteJump = false, EspBox = false, AntiVoid = true
}

local Tab1 = Lib:AddTab("Chiến Đấu")
local Tab2 = Lib:AddTab("Di Chuyển")
local Tab3 = Lib:AddTab("Khác")

-- Nạp Chức Năng
Lib:AddTextBox(Tab1, "Tên Mục Tiêu...", "TargetName")
Lib:AddToggle(Tab1, "Aim Lock (Khóa Đầu)", "AimLock")
Lib:AddToggle(Tab1, "Auto Stomp (Dậm)", "AutoStomp")
Lib:AddToggle(Tab1, "Hitbox Expander", "HitboxExpander")
Lib:AddSlider(Tab1, "Kích Thước Hitbox", "HitboxSize", 2, 45, 25)
Lib:AddSlider(Tab1, "Độ Mờ Hitbox", "HitboxTrans", 0, 10, 5)
Lib:AddToggle(Tab1, "Attack Aura", "AttackAura")

Lib:AddToggle(Tab2, "Anti-Void (Chống Rớt)", "AntiVoid")
Lib:AddToggle(Tab2, "Fix Speed", "FixSpeed")
Lib:AddSlider(Tab2, "Tốc Độ Chạy", "WalkSpeed", 16, 150, 16)
Lib:AddToggle(Tab2, "Chống Ngã (NoRagdoll)", "AntiRagdoll")
Lib:AddToggle(Tab2, "Đi Xuyên Tường", "SmartNoclip")
Lib:AddToggle(Tab2, "Nhảy Vô Hạn", "InfiniteJump")
Lib:AddToggle(Tab3, "ESP Box", "EspBox")

-- 3. LOGIC ANTI-VOID (TP LẠI MẶT ĐẤT)
spawn(function()
    while task.wait(0.1) do
        if getgenv().Settings.AntiVoid then
            pcall(function()
                local Char = LocalPlayer.Character
                if Char and Char:FindFirstChild("HumanoidRootPart") then
                    if Char.HumanoidRootPart.Position.Y < -50 then
                        -- TP về vị trí an toàn, giữ nguyên X, Z nhưng Y cao lên
                        local OldPos = Char.HumanoidRootPart.Position
                        Char.HumanoidRootPart.CFrame = CFrame.new(OldPos.X, 20, OldPos.Z)
                        Char.HumanoidRootPart.Velocity = Vector3.new(0,0,0) -- Xóa lực rơi
                    end
                end
            end)
        end
    end
end)

-- 4. LOGIC GAMEPLAY
spawn(function()
    while task.wait(0.1) do
        local TargetStr = getgenv().Settings.TargetName:lower()
        if getgenv().Settings.HitboxExpander then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local IsTarget = (TargetStr == "") or v.Name:lower():find(TargetStr)
                    if IsTarget then
                        v.Character.HumanoidRootPart.Size = Vector3.new(getgenv().Settings.HitboxSize, getgenv().Settings.HitboxSize, getgenv().Settings.HitboxSize)
                        v.Character.HumanoidRootPart.Transparency = getgenv().Settings.HitboxTrans / 10
                        v.Character.HumanoidRootPart.CanCollide = false
                        v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really red")
                    end
                end
            end
        end
        if getgenv().Settings.AttackAura then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    if (v.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < getgenv().Settings.HitboxSize + 5 then
                        local Tool = LocalPlayer.Backpack:FindFirstChild("Combat") or LocalPlayer.Backpack:FindFirstChild("Fists")
                        if Tool then LocalPlayer.Character.Humanoid:EquipTool(Tool) end
                        VirtualUser:CaptureController(); VirtualUser:ClickButton1(Vector2.new(999,999))
                    end
                end
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if getgenv().Settings.FixSpeed and LocalPlayer.Character then LocalPlayer.Character.Humanoid.WalkSpeed = getgenv().Settings.WalkSpeed end
    if getgenv().Settings.AntiRagdoll and LocalPlayer.Character then LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false); LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false) end
    if getgenv().Settings.SmartNoclip and LocalPlayer.Character then for _,v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    if getgenv().Settings.AimLock then
        local target = nil; local dist = 100
        for _,v in pairs(Players:GetPlayers()) do if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then local d = (v.Character.Head.Position - Camera.CFrame.Position).Magnitude; if d < dist then dist = d; target = v.Character.Head end end end
        if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position) end
    end
end)
UserInputService.JumpRequest:Connect(function() if getgenv().Settings.InfiniteJump then LocalPlayer.Character.Humanoid:ChangeState("Jumping") end end)
