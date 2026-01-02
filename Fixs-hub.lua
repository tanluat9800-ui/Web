-- [[ REDZ HUB V18 - PHẦN 1: UI & LOADING ]]
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- CẤU HÌNH & DỮ LIỆU TOÀN CỤC
getgenv().Settings = {
    Language = "Vietnamese",
    AttackAura = false, HitboxExpander = false, HitboxSize = 20, HitboxTrans = 5, TargetName = "", AutoStomp = false, AimLock = false,
    FixSpeed = true, WalkSpeed = 16, AntiRagdoll = true, SmartNoclip = true, InfiniteJump = false, EspBox = false
}

local Translations = {
    English = { Tab1="Combat", Tab2="Movement", Tab3="Settings", TargetName="Target Name...", Hitbox="Hitbox Expander", Size="Hitbox Size", Trans="Transparency", Aura="Attack Aura", Stomp="Auto Stomp", AimLock="Aim Lock", Noclip="Smart Noclip", NoRagdoll="Anti-Ragdoll", InfJump="Infinite Jump", FixSpeed="Fix Speed", Speed="WalkSpeed", ESP="ESP Box", LangSel="Language" },
    Vietnamese = { Tab1="Chiến Đấu", Tab2="Di Chuyển", Tab3="Cài Đặt", TargetName="Tên Mục Tiêu...", Hitbox="Mở Rộng Hitbox", Size="Kích Thước (Max 45)", Trans="Độ Mờ", Aura="Tự Động Đấm", Stomp="Tự Dậm (Stomp)", AimLock="Khóa Mục Tiêu", Noclip="Đi Xuyên Tường", NoRagdoll="Chống Ngã", InfJump="Nhảy Vô Hạn", FixSpeed="Ép Tốc Độ", Speed="Tốc Độ Chạy", ESP="Nhìn Xuyên Tường", LangSel="Ngôn Ngữ" }
}

function GetText(Key) return Translations[getgenv().Settings.Language][Key] or Key end

-- TÌM NƠI CHỨA GUI AN TOÀN
local ParentTarget = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
if ParentTarget:FindFirstChild("RedzV18") then ParentTarget.RedzV18:Destroy() end

local ScreenGui = Instance.new("ScreenGui", ParentTarget); ScreenGui.Name = "RedzV18"; ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global; ScreenGui.DisplayOrder = 999

-- THÔNG BÁO BADGE
function SendNotify(FeatureName, Status)
    spawn(function()
        local NotifyFrame = Instance.new("Frame", ScreenGui); NotifyFrame.Size = UDim2.new(0, 220, 0, 40); NotifyFrame.Position = UDim2.new(1, 20, 0.8, 0); NotifyFrame.BackgroundColor3 = Color3.fromRGB(15,15,15); Instance.new("UICorner", NotifyFrame); local S = Instance.new("UIStroke", NotifyFrame); S.Thickness = 2
        local T = Instance.new("TextLabel", NotifyFrame); T.Size = UDim2.new(1,0,1,0); T.BackgroundTransparency = 1; T.TextColor3 = Status and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0); T.Text = FeatureName.." ["..(Status and "BẬT" or "TẮT").."]"; T.Font = "GothamBold"; T.TextSize = 12
        spawn(function() while NotifyFrame do local c = Color3.fromHSV(tick()%5/5,1,1); S.Color = c; task.wait() end end)
        TweenService:Create(NotifyFrame, TweenInfo.new(0.5), {Position = UDim2.new(1, -240, 0.8, 0)}):Play(); wait(1.5); TweenService:Create(NotifyFrame, TweenInfo.new(0.5), {Position = UDim2.new(1, 20, 0.8, 0)}):Play(); wait(0.5); NotifyFrame:Destroy()
    end)
end

-- LOADING SCREEN (6 GIÂY)
local LoadHolder = Instance.new("Frame", ScreenGui); LoadHolder.Size = UDim2.new(1,0,1,0); LoadHolder.BackgroundTransparency = 1; LoadHolder.ZIndex = 1000
local LoadBox = Instance.new("Frame", LoadHolder); LoadBox.Size = UDim2.new(0, 300, 0, 80); LoadBox.Position = UDim2.new(0.5, -150, 0.5, -40); LoadBox.BackgroundColor3 = Color3.fromRGB(10,10,10); Instance.new("UICorner", LoadBox)
local LoadStr = Instance.new("UIStroke", LoadBox); LoadStr.Thickness = 3
local LoadBarBG = Instance.new("Frame", LoadBox); LoadBarBG.Size = UDim2.new(0.8,0,0,6); LoadBarBG.Position = UDim2.new(0.1,0,0.7,0); LoadBarBG.BackgroundColor3 = Color3.fromRGB(30,30,30); Instance.new("UICorner", LoadBarBG)
local LoadBarFill = Instance.new("Frame", LoadBarBG); LoadBarFill.Size = UDim2.new(0,0,1,0); Instance.new("UICorner", LoadBarFill)
local LoadTitle = Instance.new("TextLabel", LoadBox); LoadTitle.Text = "REDZ HUB V18 LOADING..."; LoadTitle.Size = UDim2.new(1,0,0,50); LoadTitle.TextColor3 = Color3.fromRGB(255,255,255); LoadTitle.BackgroundTransparency = 1; LoadTitle.Font = "GothamBlack"; LoadTitle.TextSize = 18

-- MAIN UI
local ToggleBtn = Instance.new("ImageButton", ScreenGui); ToggleBtn.Visible = false; ToggleBtn.Size = UDim2.new(0,50,0,50); ToggleBtn.Position = UDim2.new(0.1,0,0.2,0); ToggleBtn.BackgroundColor3 = Color3.fromRGB(10,10,10); local TglStr = Instance.new("UIStroke", ToggleBtn); TglStr.Thickness = 3; local TglTxt = Instance.new("TextLabel", ToggleBtn); TglTxt.Size = UDim2.new(1,0,1,0); TglTxt.Text = "R"; TglTxt.Font = "FredokaOne"; TglTxt.TextSize = 28; TglTxt.BackgroundTransparency = 1; Instance.new("UICorner", ToggleBtn)

local Main = Instance.new("Frame", ScreenGui); Main.Size = UDim2.new(0,420,0,300); Main.Position = UDim2.new(0.5,-210,0.5,-150); Main.BackgroundColor3 = Color3.fromRGB(12,12,12); Main.Visible = false; Instance.new("UICorner", Main); local MainStr = Instance.new("UIStroke", Main); MainStr.Thickness = 3

-- NEON RAINBOW LOOP
spawn(function()
    while task.wait() do
        local c = Color3.fromHSV(tick()%5/5, 1, 1)
        MainStr.Color = c; TglStr.Color = c; LoadStr.Color = c; LoadBarFill.BackgroundColor3 = c; TglTxt.TextColor3 = c
    end
end)

-- CHẠY LOADING 6 GIÂY
spawn(function()
    for i=1, 100 do LoadBarFill.Size = UDim2.new(i/100, 0, 1, 0); task.wait(0.06) end
    LoadHolder:Destroy(); ToggleBtn.Visible = true
end)

-- DRAGGABLE
local dragging, dragInput, dragStart, startPos
ToggleBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = i.Position; startPos = ToggleBtn.Position; i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)
UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - dragStart; ToggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y) end end)
ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
-- [[ REDZ HUB V18 - PHẦN 2: LOGIC & FEATURES ]]
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local ScreenGui = (game:GetService("CoreGui"):FindFirstChild("RedzSplit") or game:GetService("CoreGui"):FindFirstChild("RedzV18")) or LocalPlayer.PlayerGui:FindFirstChild("RedzSplit") or LocalPlayer.PlayerGui:FindFirstChild("RedzV18")
local Main = ScreenGui.Frame

-- TAB SYSTEM
local TabCon = Instance.new("Frame", Main); TabCon.Size = UDim2.new(0,100,1,0); TabCon.BackgroundColor3 = Color3.fromRGB(18,18,18); Instance.new("UICorner", TabCon)
local UIList = Instance.new("UIListLayout", TabCon); UIList.HorizontalAlignment = "Center"; UIList.Padding = UDim.new(0,5)
local PageCon = Instance.new("Frame", Main); PageCon.Size = UDim2.new(1,-110,1,0); PageCon.Position = UDim2.new(0,110,0,0); PageCon.BackgroundTransparency = 1

function AddTab(Key)
    local Name = GetText(Key)
    local B = Instance.new("TextButton", TabCon); B.Size = UDim2.new(0.9,0,0,35); B.Text = Name; B.BackgroundColor3 = Color3.fromRGB(25,25,25); B.TextColor3 = Color3.fromRGB(200,200,200); Instance.new("UICorner", B); B.Font = "GothamBold"; B.TextSize = 11
    local P = Instance.new("ScrollingFrame", PageCon); P.Size = UDim2.new(1,0,1,0); P.Visible = false; P.BackgroundTransparency = 1; P.ScrollBarThickness = 2; Instance.new("UIListLayout", P).Padding = UDim.new(0,5)
    B.MouseButton1Click:Connect(function() for _,v in pairs(PageCon:GetChildren()) do v.Visible = false end; P.Visible = true end)
    if #TabCon:GetChildren() == 2 then P.Visible = true end
    return P
end

function AddToggle(P, Key, F)
    local T = GetText(Key)
    local B = Instance.new("TextButton", P); B.Size = UDim2.new(1,0,0,35); B.BackgroundColor3 = Color3.fromRGB(22,22,22); B.Text = " "..T; B.TextColor3 = Color3.fromRGB(150,150,150); B.TextXAlignment = "Left"; Instance.new("UICorner", B); B.Font = "GothamBold"
    B.MouseButton1Click:Connect(function() getgenv().Settings[F] = not getgenv().Settings[F]; B.TextColor3 = getgenv().Settings[F] and Color3.fromRGB(0,255,100) or Color3.fromRGB(150,150,150); SendNotify(T, getgenv().Settings[F]) end)
end

function AddSlider(P, Key, F, Min, Max)
    local T = GetText(Key)
    local Fr = Instance.new("Frame", P); Fr.Size = UDim2.new(1,0,0,45); Fr.BackgroundColor3 = Color3.fromRGB(22,22,22); Instance.new("UICorner", Fr)
    local L = Instance.new("TextLabel", Fr); L.Text = " "..T..": "..getgenv().Settings[F]; L.Size = UDim2.new(1,0,0,20); L.BackgroundTransparency = 1; L.TextColor3 = Color3.fromRGB(200,200,200); L.Font = "GothamBold"; L.TextSize = 11
    local S = Instance.new("TextButton", Fr); S.Size = UDim2.new(0.9,0,0,6); S.Position = UDim2.new(0.05,0,0.6,0); S.BackgroundColor3 = Color3.fromRGB(0,0,0); S.Text = ""; local Fi = Instance.new("Frame", S); Fi.Size = UDim2.new(0,0,1,0); Fi.BackgroundColor3 = Color3.fromRGB(255,0,0)
    S.MouseButton1Down:Connect(function() local m = game.Players.LocalPlayer:GetMouse(); local move; move = m.Move:Connect(function() local p = math.clamp((m.X - S.AbsolutePosition.X)/S.AbsoluteSize.X, 0, 1); local v = math.floor(Min+(Max-Min)*p); getgenv().Settings[F] = v; L.Text = " "..T..": "..v; Fi.Size = UDim2.new(p,0,1,0) end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then if move then move:Disconnect() end end end) end)
end

function AddTextBox(P, Key, F)
    local Fr = Instance.new("Frame", P); Fr.Size = UDim2.new(1, 0, 0, 40); Fr.BackgroundColor3 = Color3.fromRGB(22, 22, 22); Instance.new("UICorner", Fr)
    local I = Instance.new("TextBox", Fr); I.Size = UDim2.new(0.9, 0, 0.8, 0); I.Position = UDim2.new(0.05, 0, 0.1, 0); I.BackgroundColor3 = Color3.fromRGB(10, 10, 10); I.TextColor3 = Color3.fromRGB(255, 0, 0); I.Text = ""; I.PlaceholderText = GetText(Key); Instance.new("UICorner", I)
    I.FocusLost:Connect(function() getgenv().Settings[F] = I.Text end)
end

-- TẠO TAB
local T1 = AddTab("Tab1"); local T2 = AddTab("Tab2")
AddTextBox(T1, "TargetName", "TargetName"); AddToggle(T1, "Aura", "AttackAura"); AddToggle(T1, "Hitbox", "HitboxExpander"); AddSlider(T1, "Size", "HitboxSize", 2, 45); AddSlider(T1, "Trans", "HitboxTrans", 0, 10); AddToggle(T1, "Stomp", "AutoStomp"); AddToggle(T1, "AimLock", "AimLock")
AddToggle(T2, "FixSpeed", "FixSpeed"); AddSlider(T2, "Speed", "WalkSpeed", 16, 100); AddToggle(T2, "NoRagdoll", "AntiRagdoll"); AddToggle(T2, "Noclip", "SmartNoclip"); AddToggle(T2, "InfJump", "InfiniteJump")

-- LOGIC COMBAT & HITBOX
spawn(function()
    while task.wait(0.1) do
        if getgenv().Settings.HitboxExpander then
            local tar = getgenv().Settings.TargetName:lower()
            for _,v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    if tar == "" or v.Name:lower():find(tar) then
                        v.Character.HumanoidRootPart.Size = Vector3.new(getgenv().Settings.HitboxSize, getgenv().Settings.HitboxSize, getgenv().Settings.HitboxSize)
                        v.Character.HumanoidRootPart.Transparency = getgenv().Settings.HitboxTrans/10; v.Character.HumanoidRootPart.CanCollide = false; v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really red")
                    end
                end
            end
        end
        if getgenv().Settings.AttackAura then
            for _,v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and (v.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < getgenv().Settings.HitboxSize+5 then
                    local t = LocalPlayer.Backpack:FindFirstChild("Combat") or LocalPlayer.Backpack:FindFirstChild("Fists")
                    if t then LocalPlayer.Character.Humanoid:EquipTool(t) end
                    VirtualUser:CaptureController(); VirtualUser:ClickButton1(Vector2.new(999,999))
                end
            end
        end
    end
end)

-- LOGIC SYSTEM
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
