-- [[ REDZ HUB V20 - PART 1: UI FOUNDATION ]]
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- 1. CLEANUP CŨ
getgenv().RedzLoaded = false -- Đánh dấu chưa load xong
if CoreGui:FindFirstChild("RedzV20") then CoreGui.RedzV20:Destroy() end

-- 2. TẠO SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RedzV20"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.DisplayOrder = 9999

-- 3. GLOBAL VARIABLES (ĐỂ PHẦN 2 DÙNG LẠI)
getgenv().UI_Storage = {} 
getgenv().Settings = {
    Language = "Vietnamese",
    AttackAura = false, HitboxExpander = false, HitboxSize = 25, HitboxTrans = 5, TargetName = "", AutoStomp = false, AimLock = false,
    FixSpeed = true, WalkSpeed = 16, AntiRagdoll = true, SmartNoclip = true, InfiniteJump = false, EspBox = false
}

-- 4. KHUNG MENU CHÍNH (MAIN FRAME)
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "MainFrame"
Main.Size = UDim2.new(0, 420, 0, 320)
Main.Position = UDim2.new(0.5, -210, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Visible = false -- Ẩn trước, đợi Loading
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", Main); MainStroke.Thickness = 3

-- 5. NÚT MỞ MENU (TOGGLE BUTTON)
local ToggleBtn = Instance.new("ImageButton", ScreenGui)
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Visible = false -- Ẩn trước
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
local TglStroke = Instance.new("UIStroke", ToggleBtn); TglStroke.Thickness = 3
local TglText = Instance.new("TextLabel", ToggleBtn); TglText.Size = UDim2.new(1,0,1,0); TglText.BackgroundTransparency = 1; TglText.Text = "R"; TglText.TextColor3 = Color3.fromRGB(255,255,255); TglText.Font = Enum.Font.FredokaOne; TglText.TextSize = 28

-- 6. TAB CONTAINER (NƠI CHỨA CÁC TAB)
local TabCon = Instance.new("Frame", Main)
TabCon.Name = "Tabs"
TabCon.Position = UDim2.new(0, 0, 0, 0)
TabCon.Size = UDim2.new(0, 110, 1, 0)
TabCon.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Instance.new("UICorner", TabCon).CornerRadius = UDim.new(0, 10)
local TabList = Instance.new("UIListLayout", TabCon); TabList.Padding = UDim.new(0, 5); TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
local TabPad = Instance.new("UIPadding", TabCon); TabPad.PaddingTop = UDim.new(0, 10)

local ContentCon = Instance.new("Frame", Main)
ContentCon.Name = "Contents"
ContentCon.Position = UDim2.new(0, 120, 0, 10)
ContentCon.Size = UDim2.new(1, -130, 1, -20)
ContentCon.BackgroundTransparency = 1

-- LƯU VÀO GLOBAL ĐỂ PHẦN 2 TÌM THẤY
getgenv().UI_Storage.Main = Main
getgenv().UI_Storage.TabCon = TabCon
getgenv().UI_Storage.ContentCon = ContentCon

-- 7. HIỆU ỨNG NEON (CHẠY NGẦM)
spawn(function()
    while task.wait() do
        local color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
        MainStroke.Color = color
        TglStroke.Color = color
        TglText.TextColor3 = color
    end
end)

-- 8. DRAGGABLE LOGIC (KÉO THẢ)
local dragging, dragInput, dragStart, startPos
local function update(input) local delta = input.Position - dragStart; ToggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end
ToggleBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = i.Position; startPos = ToggleBtn.Position; i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)
UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then update(i) end end)
ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- 9. LOADING SCREEN (6 GIÂY)
local LoadBox = Instance.new("Frame", ScreenGui); LoadBox.Size = UDim2.new(0, 300, 0, 80); LoadBox.Position = UDim2.new(0.5, -150, 0.5, -40); LoadBox.BackgroundColor3 = Color3.fromRGB(15,15,15); Instance.new("UICorner", LoadBox); local LoadStr = Instance.new("UIStroke", LoadBox); LoadStr.Thickness = 2; LoadStr.Color = Color3.fromRGB(255,0,0)
local LoadTitle = Instance.new("TextLabel", LoadBox); LoadTitle.Text = "REDZ V20 LOADING..."; LoadTitle.Size = UDim2.new(1,0,0,40); LoadTitle.TextColor3 = Color3.fromRGB(255,255,255); LoadTitle.BackgroundTransparency = 1; LoadTitle.Font = Enum.Font.GothamBlack; LoadTitle.TextSize = 18
local LoadBarBG = Instance.new("Frame", LoadBox); LoadBarBG.Size = UDim2.new(0.8,0,0,6); LoadBarBG.Position = UDim2.new(0.1,0,0.6,0); LoadBarBG.BackgroundColor3 = Color3.fromRGB(30,30,30); Instance.new("UICorner", LoadBarBG)
local LoadBarFill = Instance.new("Frame", LoadBarBG); LoadBarFill.Size = UDim2.new(0,0,1,0); LoadBarFill.BackgroundColor3 = Color3.fromRGB(255,0,0); Instance.new("UICorner", LoadBarFill)

spawn(function()
    for i = 1, 100 do LoadBarFill.Size = UDim2.new(i/100, 0, 1, 0); task.wait(0.06) end -- 6 Giây
    LoadBox:Destroy()
    ToggleBtn.Visible = true
    getgenv().RedzLoaded = true -- BÁO HIỆU ĐÃ LOAD XONG
end)
-- [[ REDZ HUB V20 - PART 2: LOGIC INJECTION ]]
repeat task.wait() until getgenv().RedzLoaded -- ĐỢI PHẦN 1 LOAD XONG MỚI CHẠY

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = game.Workspace.CurrentCamera

-- LẤY UI TỪ PHẦN 1
local TabCon = getgenv().UI_Storage.TabCon
local ContentCon = getgenv().UI_Storage.ContentCon

-- HÀM DỊCH THUẬT
local Translations = {
    Vietnamese = { Tab1="Chiến Đấu", Tab2="Di Chuyển", Tab3="Cài Đặt", TargetName="Tên Mục Tiêu...", Hitbox="Mở Rộng Hitbox", Size="Kích Thước (Max 45)", Trans="Độ Mờ", Aura="Tự Động Đấm", Stomp="Tự Dậm (Stomp)", AimLock="Khóa Mục Tiêu", Noclip="Đi Xuyên Tường", NoRagdoll="Chống Ngã", InfJump="Nhảy Vô Hạn", FixSpeed="Ép Tốc Độ", Speed="Tốc Độ Chạy", ESP="Nhìn Xuyên Tường", LangSel="Ngôn Ngữ" },
    English = { Tab1="Combat", Tab2="Movement", Tab3="Settings", TargetName="Target Name...", Hitbox="Hitbox Expander", Size="Hitbox Size", Trans="Transparency", Aura="Attack Aura", Stomp="Auto Stomp", AimLock="Aim Lock", Noclip="Smart Noclip", NoRagdoll="Anti-Ragdoll", InfJump="Infinite Jump", FixSpeed="Fix Speed", Speed="WalkSpeed", ESP="ESP Box", LangSel="Language" }
}
function GetText(Key) return Translations[getgenv().Settings.Language][Key] or Key end

-- HỆ THỐNG TẠO NÚT
function AddTab(Key)
    local B = Instance.new("TextButton", TabCon); B.Size = UDim2.new(0.9,0,0,35); B.Text = GetText(Key); B.BackgroundColor3 = Color3.fromRGB(25,25,25); B.TextColor3 = Color3.fromRGB(200,200,200); Instance.new("UICorner", B); B.Font = Enum.Font.GothamBold; B.TextSize = 11
    local P = Instance.new("ScrollingFrame", ContentCon); P.Size = UDim2.new(1,0,1,0); P.Visible = false; P.BackgroundTransparency = 1; P.ScrollBarThickness = 2; Instance.new("UIListLayout", P).Padding = UDim.new(0,5)
    B.MouseButton1Click:Connect(function() for _,v in pairs(ContentCon:GetChildren()) do v.Visible = false end; P.Visible = true end)
    if #TabCon:GetChildren() == 2 then P.Visible = true end
    return P
end

function AddToggle(P, Key, F)
    local B = Instance.new("TextButton", P); B.Size = UDim2.new(1,0,0,35); B.BackgroundColor3 = Color3.fromRGB(22,22,22); B.Text = "  "..GetText(Key); B.TextColor3 = Color3.fromRGB(150,150,150); B.TextXAlignment = "Left"; Instance.new("UICorner", B); B.Font = Enum.Font.GothamBold
    B.MouseButton1Click:Connect(function() getgenv().Settings[F] = not getgenv().Settings[F]; B.TextColor3 = getgenv().Settings[F] and Color3.fromRGB(0,255,100) or Color3.fromRGB(150,150,150) end)
end

function AddSlider(P, Key, F, Min, Max)
    local Fr = Instance.new("Frame", P); Fr.Size = UDim2.new(1,0,0,45); Fr.BackgroundColor3 = Color3.fromRGB(22,22,22); Instance.new("UICorner", Fr)
    local L = Instance.new("TextLabel", Fr); L.Text = "  "..GetText(Key)..": "..getgenv().Settings[F]; L.Size = UDim2.new(1,0,0,20); L.BackgroundTransparency = 1; L.TextColor3 = Color3.fromRGB(200,200,200); L.Font = Enum.Font.GothamBold; L.TextSize = 11; L.TextXAlignment = "Left"
    local S = Instance.new("TextButton", Fr); S.Size = UDim2.new(0.9,0,0,6); S.Position = UDim2.new(0.05,0,0.6,0); S.BackgroundColor3 = Color3.fromRGB(0,0,0); S.Text = ""; local Fi = Instance.new("Frame", S); Fi.Size = UDim2.new(0,0,1,0); Fi.BackgroundColor3 = Color3.fromRGB(255,0,0)
    S.MouseButton1Down:Connect(function() local m = LocalPlayer:GetMouse(); local move; move = m.Move:Connect(function() local p = math.clamp((m.X - S.AbsolutePosition.X)/S.AbsoluteSize.X, 0, 1); local v = math.floor(Min+(Max-Min)*p); getgenv().Settings[F] = v; L.Text = "  "..GetText(Key)..": "..v; Fi.Size = UDim2.new(p,0,1,0) end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect() end end) end)
end

function AddTextBox(P, Key, F)
    local Fr = Instance.new("Frame", P); Fr.Size = UDim2.new(1,0,0,40); Fr.BackgroundColor3 = Color3.fromRGB(22,22,22); Instance.new("UICorner", Fr)
    local I = Instance.new("TextBox", Fr); I.Size = UDim2.new(0.9,0,0.8,0); I.Position = UDim2.new(0.05,0,0.1,0); I.BackgroundColor3 = Color3.fromRGB(10,10,10); I.TextColor3 = Color3.fromRGB(255,255,255); I.Text = ""; I.PlaceholderText = GetText(Key); Instance.new("UICorner", I)
    I.FocusLost:Connect(function() getgenv().Settings[F] = I.Text end)
end

-- TẠO MENU CHỨC NĂNG (VIP)
local T1 = AddTab("Tab1"); local T2 = AddTab("Tab2"); local T3 = AddTab("Tab3")
AddTextBox(T1, "TargetName", "TargetName"); AddToggle(T1, "Aura", "AttackAura"); AddToggle(T1, "Hitbox", "HitboxExpander"); AddSlider(T1, "Size", "HitboxSize", 2, 45); AddSlider(T1, "Trans", "HitboxTrans", 0, 10); AddToggle(T1, "Stomp", "AutoStomp"); AddToggle(T1, "AimLock", "AimLock")
AddToggle(T2, "FixSpeed", "FixSpeed"); AddSlider(T2, "Speed", "WalkSpeed", 16, 100); AddToggle(T2, "NoRagdoll", "AntiRagdoll"); AddToggle(T2, "Noclip", "SmartNoclip"); AddToggle(T2, "InfJump", "InfiniteJump"); AddToggle(T2, "ESP", "EspBox")

-- LOGIC GAME (KHÔNG CẮT BỚT)
spawn(function()
    while task.wait(0.1) do
        -- HITBOX
        if getgenv().Settings.HitboxExpander then
            local tar = getgenv().Settings.TargetName:lower()
            for _,v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    if tar == "" or v.Name:lower():find(tar) then
                        v.Character.HumanoidRootPart.Size = Vector3.new(getgenv().Settings.HitboxSize, getgenv().Settings.HitboxSize, getgenv().Settings.HitboxSize)
                        v.Character.HumanoidRootPart.Transparency = getgenv().Settings.HitboxTrans/10
                        v.Character.HumanoidRootPart.CanCollide = false
                        v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really red")
                    end
                end
            end
        end
        -- AURA
        if getgenv().Settings.AttackAura then
            for _,v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    if (v.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < getgenv().Settings.HitboxSize+5 then
                        local t = LocalPlayer.Backpack:FindFirstChild("Combat") or LocalPlayer.Backpack:FindFirstChild("Fists")
                        if t then LocalPlayer.Character.Humanoid:EquipTool(t) end
                        VirtualUser:CaptureController(); VirtualUser:ClickButton1(Vector2.new(999,999))
                    end
                end
            end
        end
    end
end)

-- AUTO STOMP
spawn(function()
    while task.wait(0.5) do
        if getgenv().Settings.AutoStomp then
            for _,v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health < 15 and v.Character.Humanoid.Health > 0 then
                    if (LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude < 25 then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0,3,0)
                        VirtualUser:CaptureController(); keypress(Enum.KeyCode.E); wait(0.1); keyrelease(Enum.KeyCode.E)
                    end
                end
            end
        end
    end
end)

-- SYSTEM LOOP
RunService.Heartbeat:Connect(function()
    if getgenv().Settings.FixSpeed and LocalPlayer.Character then LocalPlayer.Character.Humanoid.WalkSpeed = getgenv().Settings.WalkSpeed end
    if getgenv().Settings.AntiRagdoll and LocalPlayer.Character then LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false) end
    if getgenv().Settings.SmartNoclip and LocalPlayer.Character then for _,v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    if getgenv().Settings.AimLock then
        local target = nil; local dist = 100
        for _,v in pairs(Players:GetPlayers()) do if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then local d = (v.Character.Head.Position - Camera.CFrame.Position).Magnitude; if d < dist then dist = d; target = v.Character.Head end end end
        if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position) end
    end
end)
UserInputService.JumpRequest:Connect(function() if getgenv().Settings.InfiniteJump then LocalPlayer.Character.Humanoid:ChangeState("Jumping") end end)
