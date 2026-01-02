-- [[ REDZ HUB V21 - PHẦN 1: GIAO DIỆN ]]
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- 1. CẤU HÌNH GLOBAL (Để Phần 2 đọc được)
getgenv().Settings = {
    AttackAura = false,
    HitboxExpander = false,
    HitboxSize = 25,
    HitboxTrans = 5, -- Độ mờ
    TargetName = "",
    AutoStomp = false,
    AimLock = false,
    FixSpeed = true,
    WalkSpeed = 16,
    AntiRagdoll = true,
    SmartNoclip = true,
    InfiniteJump = false,
    EspBox = false,
    AntiVoid = true -- Mặc định bật chống rớt hố
}

-- 2. XÓA UI CŨ
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("RedzV21") then CoreGui.RedzV21:Destroy() end

-- 3. TẠO GUI MỚI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RedzV21"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- NÚT BẬT TẮT
local ToggleBtn = Instance.new("ImageButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
local ToggleText = Instance.new("TextLabel", ToggleBtn)
ToggleText.Size = UDim2.new(1,0,1,0); ToggleText.BackgroundTransparency = 1; ToggleText.Text = "R"; ToggleText.TextColor3 = Color3.fromRGB(255,0,0); ToggleText.Font = Enum.Font.FredokaOne; ToggleText.TextSize = 28

-- MENU CHÍNH
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 450, 0, 320)
Main.Position = UDim2.new(0.5, -225, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Visible = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- TAB CONTAINER
local TabCon = Instance.new("Frame", Main)
TabCon.Size = UDim2.new(0, 110, 1, 0)
TabCon.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", TabCon).CornerRadius = UDim.new(0, 10)
local TabList = Instance.new("UIListLayout", TabCon); TabList.Padding = UDim.new(0, 5); TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
local TabPad = Instance.new("UIPadding", TabCon); TabPad.PaddingTop = UDim.new(0, 10)

local ContentCon = Instance.new("Frame", Main)
ContentCon.Size = UDim2.new(1, -120, 1, -20)
ContentCon.Position = UDim2.new(0, 120, 0, 10)
ContentCon.BackgroundTransparency = 1

-- HÀM TẠO NÚT
function AddTab(Text)
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

function AddToggle(Page, Text, Flag)
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

-- FIX LỖI SLIDER KÉO BỊ DÍNH (QUAN TRỌNG)
function AddSlider(Page, Text, Flag, Min, Max)
    local Frame = Instance.new("Frame", Page)
    Frame.Size = UDim2.new(1, 0, 0, 45)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Instance.new("UICorner", Frame)
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.BackgroundTransparency = 1
    Label.Text = "  " .. Text .. ": " .. getgenv().Settings[Flag]
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
    Fill.Size = UDim2.new((getgenv().Settings[Flag] - Min) / (Max - Min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    Instance.new("UICorner", Fill)
    
    -- LOGIC KÉO ĐỘC LẬP
    SliderBG.MouseButton1Down:Connect(function()
        local Mouse = Players.LocalPlayer:GetMouse()
        local MoveConnection
        local ReleaseConnection
        
        -- Cập nhật giá trị
        local function UpdateSlider()
            local Percent = math.clamp((Mouse.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
            local Value = math.floor(Min + (Max - Min) * Percent)
            getgenv().Settings[Flag] = Value
            Label.Text = "  " .. Text .. ": " .. Value
            Fill.Size = UDim2.new(Percent, 0, 1, 0)
        end
        
        UpdateSlider() -- Cập nhật ngay khi bấm xuống
        
        -- Chỉ lắng nghe khi giữ chuột trên slider NÀY
        MoveConnection = Mouse.Move:Connect(UpdateSlider)
        
        ReleaseConnection = UserInputService.InputEnded:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                if MoveConnection then MoveConnection:Disconnect() end
                if ReleaseConnection then ReleaseConnection:Disconnect() end
            end
        end)
    end)
end

function AddTextBox(Page, Text, Flag)
    local Frame = Instance.new("Frame", Page); Frame.Size = UDim2.new(1,0,0,40); Frame.BackgroundColor3 = Color3.fromRGB(25,25,25); Instance.new("UICorner", Frame)
    local Input = Instance.new("TextBox", Frame); Input.Size = UDim2.new(0.9,0,0.8,0); Input.Position = UDim2.new(0.05,0,0.1,0); Input.BackgroundColor3 = Color3.fromRGB(10,10,10); Input.TextColor3 = Color3.fromRGB(255,255,255); Input.Text = ""; Input.PlaceholderText = Text; Instance.new("UICorner", Input)
    Input.FocusLost:Connect(function() getgenv().Settings[Flag] = Input.Text end)
end

-- TẠO CÁC TAB
local Tab1 = AddTab("Chiến Đấu")
local Tab2 = AddTab("Di Chuyển")
local Tab3 = AddTab("Cài Đặt")

-- Kéo thả Menu
local dragging, dragStart, startPos
ToggleBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = i.Position; startPos = ToggleBtn.Position end end)
UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then local d = i.Position - dragStart; ToggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y) end end)
ToggleBtn.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- NẠP CHỨC NĂNG VÀO MENU
AddTextBox(Tab1, "Tên Mục Tiêu...", "TargetName")
AddToggle(Tab1, "Aim Lock (Khóa Đầu)", "AimLock")
AddToggle(Tab1, "Auto Stomp (Dậm)", "AutoStomp")
AddToggle(Tab1, "Hitbox Expander", "HitboxExpander")
AddSlider(Tab1, "Kích Thước Hitbox", "HitboxSize", 2, 45)
AddSlider(Tab1, "Độ Mờ Hitbox", "HitboxTrans", 0, 10)
AddToggle(Tab1, "Attack Aura", "AttackAura")

AddToggle(Tab2, "Anti-Void (Chống Rớt)", "AntiVoid")
AddToggle(Tab2, "Fix Speed", "FixSpeed")
AddSlider(Tab2, "Tốc Độ Chạy", "WalkSpeed", 16, 150)
AddToggle(Tab2, "Chống Ngã (NoRagdoll)", "AntiRagdoll")
AddToggle(Tab2, "Đi Xuyên Tường", "SmartNoclip")
AddToggle(Tab2, "Nhảy Vô Hạn", "InfiniteJump")
AddToggle(Tab2, "ESP Box", "EspBox")

-- (Kết thúc Phần 1 - Đừng xóa dòng này, hãy dán Phần 2 ngay bên dưới)
-- [[ REDZ HUB V21 - PHẦN 2: LOGIC ]]

-- 1. LOGIC ANTI-VOID (TP LẠI MẶT ĐẤT)
spawn(function()
    while task.wait(0.1) do
        if getgenv().Settings.AntiVoid then
            pcall(function()
                local Char = LocalPlayer.Character
                if Char and Char:FindFirstChild("HumanoidRootPart") then
                    -- Nếu rớt xuống độ cao -50
                    if Char.HumanoidRootPart.Position.Y < -50 then
                        -- TP lên độ cao an toàn (20) giữ nguyên vị trí X, Z
                        local OldPos = Char.HumanoidRootPart.Position
                        Char.HumanoidRootPart.CFrame = CFrame.new(OldPos.X, 20, OldPos.Z)
                        
                        -- Xóa vận tốc rơi để không bị mất máu
                        Char.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                        Char.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    end
                end
            end)
        end
    end
end)

-- 2. LOGIC HITBOX & VISUAL
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
                        game:GetService("VirtualUser"):CaptureController()
                        game:GetService("VirtualUser"):ClickButton1(Vector2.new(999,999))
                    end
                end
            end
        end
    end
end)

-- 3. LOGIC DI CHUYỂN
RunService.Heartbeat:Connect(function()
    if getgenv().Settings.FixSpeed and LocalPlayer.Character then 
        LocalPlayer.Character.Humanoid.WalkSpeed = getgenv().Settings.WalkSpeed 
    end
    
    if getgenv().Settings.AntiRagdoll and LocalPlayer.Character then 
        LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    end
    
    if getgenv().Settings.SmartNoclip and LocalPlayer.Character then 
        for _,v in pairs(LocalPlayer.Character:GetDescendants()) do 
            if v:IsA("BasePart") then v.CanCollide = false end 
        end 
    end
    
    if getgenv().Settings.AimLock then
        local target = nil; local dist = 100
        for _,v in pairs(Players:GetPlayers()) do 
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then 
                local d = (v.Character.Head.Position - Camera.CFrame.Position).Magnitude
                if d < dist then dist = d; target = v.Character.Head end 
            end 
        end
        if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position) end
    end
end)

UserInputService.JumpRequest:Connect(function() 
    if getgenv().Settings.InfiniteJump then 
        LocalPlayer.Character.Humanoid:ChangeState("Jumping") 
    end 
end)

-- 4. ESP BOX
spawn(function()
    local Folder = Instance.new("Folder", game.CoreGui); Folder.Name = "ESPFolder"
    while task.wait(0.5) do
        Folder:ClearAllChildren()
        if getgenv().Settings.EspBox then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local Pos, OnScreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                    if OnScreen then
                        local Box = Instance.new("Frame", Folder)
                        Box.Size = UDim2.new(0, 2000/Pos.Z, 0, 3000/Pos.Z)
                        Box.Position = UDim2.new(0, Pos.X - Box.Size.X.Offset/2, 0, Pos.Y - Box.Size.Y.Offset/2)
                        Box.BackgroundTransparency = 1; Box.BorderSizePixel = 0
                        local S = Instance.new("UIStroke", Box); S.Color = Color3.fromRGB(255, 0, 0); S.Thickness = 1.5
                    end
                end
            end
        end
    end
end)

game.StarterGui:SetCore("SendNotification", {
    Title = "REDZ HUB V21",
    Text = "Đã tải xong! Anti-Void đã bật.",
    Duration = 5
})
