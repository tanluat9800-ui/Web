--[[ 
    REDZ HUB - BADDIES V17 (NEON FIXED)
    - Fix: Independent Slider Logic (No conflict)
    - Fix: Neon Rainbow Border Restored
    - Fix: Toggle Button appears only after Loading
    - Update: Hitbox Max Size 45
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- CẤU HÌNH GLOBAL
getgenv().Settings = {
    Language = "English",
    -- COMBAT
    AttackAura = false, HitboxExpander = false, HitboxSize = 20, HitboxTrans = 5, TargetName = "", AutoStomp = false, AimLock = false,
    -- MOVE
    FixSpeed = true, WalkSpeed = 16, AntiRagdoll = true, SmartNoclip = true, InfiniteJump = false, EspBox = false
}

-- DỊCH THUẬT
local Translations = {
    English = { Tab2="Combat", Tab3="Movement", Tab4="Settings", TargetName="Target Name...", Hitbox="Hitbox Expander", Size="Hitbox Size", Trans="Transparency", Aura="Attack Aura", Stomp="Auto Stomp", AimLock="Aim Lock", Noclip="Smart Noclip", NoRagdoll="Anti-Ragdoll", InfJump="Infinite Jump", FixSpeed="Fix Speed", Speed="WalkSpeed", ESP="ESP Box", LangSel="Select Language" },
    Vietnamese = { Tab2="Chiến Đấu", Tab3="Di Chuyển", Tab4="Cài Đặt", TargetName="Tên Mục Tiêu...", Hitbox="Mở Rộng Hitbox", Size="Kích Thước (Max 45)", Trans="Độ Mờ", Aura="Tự Động Đấm", Stomp="Tự Dậm (Stomp)", AimLock="Khóa Mục Tiêu", Noclip="Đi Xuyên Tường", NoRagdoll="Chống Ngã", InfJump="Nhảy Vô Hạn", FixSpeed="Ép Tốc Độ", Speed="Tốc Độ Chạy", ESP="Nhìn Xuyên Tường", LangSel="Chọn Ngôn Ngữ" }
}

local TextLabelsToUpdate = {} 
function GetText(Key) local Lang = getgenv().Settings.Language; if Translations[Lang] and Translations[Lang][Key] then return Translations[Lang][Key] end; return Translations["English"][Key] or Key end
function UpdateUILanguage() for _, item in pairs(TextLabelsToUpdate) do if item.Object and item.Key then if item.Type == "Text" then item.Object.Text = "  " .. GetText(item.Key) elseif item.Type == "Slider" then item.Object.Text = "  " .. GetText(item.Key) .. ": " .. getgenv().Settings[item.Flag] elseif item.Type == "Tab" then item.Object.Text = GetText(item.Key) end end end end

--------------------------------------------------------------------------------
-- 1. HỆ THỐNG UI NEON (SETUP)
--------------------------------------------------------------------------------
if CoreGui:FindFirstChild("RedzV17") then CoreGui.RedzV17:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "RedzV17"

-- LOGIC NOTIFY
function SendNotify(FeatureName, Status)
    spawn(function()
        local NotifyFrame = Instance.new("Frame", ScreenGui); NotifyFrame.Size = UDim2.new(0, 250, 0, 40); NotifyFrame.Position = UDim2.new(1, 20, 0.85, 0); NotifyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Instance.new("UICorner", NotifyFrame).CornerRadius = UDim.new(0, 6); Instance.new("UIStroke", NotifyFrame).Color = Color3.fromRGB(255, 0, 0)
        local Title = Instance.new("TextLabel", NotifyFrame); Title.Size = UDim2.new(1, -20, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0); Title.BackgroundTransparency = 1; Title.Text = FeatureName .. " [" .. (Status and "ON" or "OFF") .. "]"; Title.TextColor3 = Status and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100); Title.Font = Enum.Font.GothamBold; Title.TextSize = 14; Title.TextXAlignment = Enum.TextXAlignment.Left
        TweenService:Create(NotifyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(1, -270, 0.85, 0)}):Play(); wait(1.5); TweenService:Create(NotifyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Position = UDim2.new(1, 20, 0.85, 0)}):Play(); wait(0.5); NotifyFrame:Destroy()
    end)
end

--------------------------------------------------------------------------------
-- 2. LOADING SCREEN (6 GIÂY - TRONG SUỐT)
--------------------------------------------------------------------------------
local LoadingHolder = Instance.new("Frame", ScreenGui); LoadingHolder.Size = UDim2.new(1, 0, 1, 0); LoadingHolder.BackgroundTransparency = 1; LoadingHolder.ZIndex = 100
local LoadBox = Instance.new("Frame", LoadingHolder); LoadBox.Size = UDim2.new(0, 300, 0, 80); LoadBox.Position = UDim2.new(0.5, -150, 0.5, -40); LoadBox.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Instance.new("UICorner", LoadBox).CornerRadius = UDim.new(0, 10)
local LoadStroke = Instance.new("UIStroke", LoadBox); LoadStroke.Thickness = 2
local LoadTitle = Instance.new("TextLabel", LoadBox); LoadTitle.Text = "REDZ HUB V17 NEON"; LoadTitle.Size = UDim2.new(1, 0, 0, 40); LoadTitle.TextColor3 = Color3.fromRGB(255, 255, 255); LoadTitle.Font = Enum.Font.GothamBlack; LoadTitle.TextSize = 18; LoadTitle.BackgroundTransparency = 1
local LoadBarBG = Instance.new("Frame", LoadBox); LoadBarBG.Size = UDim2.new(0.8, 0, 0, 6); LoadBarBG.Position = UDim2.new(0.1, 0, 0.6, 0); LoadBarBG.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Instance.new("UICorner", LoadBarBG)
local LoadBarFill = Instance.new("Frame", LoadBarBG); LoadBarFill.Size = UDim2.new(0, 0, 1, 0); LoadBarFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0); Instance.new("UICorner", LoadBarFill)

--------------------------------------------------------------------------------
-- 3. MAIN UI (NEON RAINBOW)
--------------------------------------------------------------------------------
local ToggleBtn = Instance.new("ImageButton", ScreenGui); ToggleBtn.Visible = false; ToggleBtn.Size = UDim2.new(0, 50, 0, 50); ToggleBtn.Position = UDim2.new(0.1, 0, 0.3, 0); ToggleBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 10); ToggleBtn.BorderSizePixel = 0
local ToggleCorner = Instance.new("UICorner", ToggleBtn); ToggleCorner.CornerRadius = UDim.new(1, 0)
local ToggleStroke = Instance.new("UIStroke", ToggleBtn); ToggleStroke.Thickness = 3 -- VIỀN NEON NÚT
local ToggleText = Instance.new("TextLabel", ToggleBtn); ToggleText.Size = UDim2.new(1,0,1,0); ToggleText.BackgroundTransparency = 1; ToggleText.Text = "R"; ToggleText.TextColor3 = Color3.fromRGB(255, 255, 255); ToggleText.Font = Enum.Font.FredokaOne; ToggleText.TextSize = 28

local Main = Instance.new("Frame", ScreenGui); Main.Size = UDim2.new(0, 450, 0, 320); Main.Position = UDim2.new(0.5, -225, 0.5, -160); Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Main.Visible = false; Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", Main); MainStroke.Thickness = 3 -- VIỀN NEON MENU

-- RAINBOW LOOP (NEON EFFECT)
spawn(function()
    while task.wait() do
        local hue = tick() % 5 / 5
        local color = Color3.fromHSV(hue, 1, 1)
        MainStroke.Color = color
        ToggleStroke.Color = color
        LoadStroke.Color = color
        LoadBarFill.BackgroundColor3 = color
        ToggleText.TextColor3 = color
    end
end)

-- TABS
local TabContainer = Instance.new("Frame", Main); TabContainer.Position = UDim2.new(0, 0, 0, 0); TabContainer.Size = UDim2.new(0, 110, 1, 0); TabContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Instance.new("UICorner", TabContainer).CornerRadius = UDim.new(0, 10)
local TabList = Instance.new("UIListLayout", TabContainer); TabList.Padding = UDim.new(0, 5); TabList.SortOrder = Enum.SortOrder.LayoutOrder; TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center; local TabPad = Instance.new("UIPadding", TabContainer); TabPad.PaddingTop = UDim.new(0, 10)
local ContentContainer = Instance.new("Frame", Main); ContentContainer.Position = UDim2.new(0, 120, 0, 10); ContentContainer.Size = UDim2.new(1, -130, 1, -20); ContentContainer.BackgroundTransparency = 1

local CurrentTab = nil
function AddTab(Key)
    local TabBtn = Instance.new("TextButton", TabContainer); TabBtn.Size = UDim2.new(0.9, 0, 0, 35); TabBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15); TabBtn.Text = GetText(Key); TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150); TabBtn.Font = Enum.Font.GothamBold; TabBtn.TextSize = 11; Instance.new("UICorner", TabBtn)
    table.insert(TextLabelsToUpdate, {Object = TabBtn, Key = Key, Type = "Tab"})
    local Page = Instance.new("ScrollingFrame", ContentContainer); Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 2; local PageList = Instance.new("UIListLayout", Page); PageList.Padding = UDim.new(0, 5); PageList.SortOrder = Enum.SortOrder.LayoutOrder
    TabBtn.MouseButton1Click:Connect(function() for _,v in pairs(ContentContainer:GetChildren()) do v.Visible = false end; for _,v in pairs(TabContainer:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(150, 150, 150) end end; Page.Visible = true; TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255) end)
    if not CurrentTab then CurrentTab = Page; Page.Visible = true; TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255) end
    return Page
end

-- UI ELEMENTS (FIXED SLIDER)
function AddToggle(Page, Key, Flag, Default)
    getgenv().Settings[Flag] = Default; local Btn = Instance.new("TextButton", Page); Btn.Size = UDim2.new(1, 0, 0, 35); Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Btn.Text = "  " .. GetText(Key); Btn.TextColor3 = getgenv().Settings[Flag] and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(150, 150, 150); Btn.TextXAlignment = Enum.TextXAlignment.Left; Btn.Font = Enum.Font.GothamBold; Btn.TextSize = 12; Instance.new("UICorner", Btn)
    table.insert(TextLabelsToUpdate, {Object = Btn, Key = Key, Type = "Text"})
    Btn.MouseButton1Click:Connect(function() getgenv().Settings[Flag] = not getgenv().Settings[Flag]; Btn.TextColor3 = getgenv().Settings[Flag] and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(150, 150, 150); SendNotify(GetText(Key), getgenv().Settings[Flag]) end)
end

function AddSlider(Page, Key, Flag, Min, Max, Default)
    getgenv().Settings[Flag] = Default
    local Frame = Instance.new("Frame", Page); Frame.Size = UDim2.new(1, 0, 0, 45); Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Instance.new("UICorner", Frame)
    local Label = Instance.new("TextLabel", Frame); Label.Text = "  " .. GetText(Key) .. ": " .. Default; Label.Size = UDim2.new(1, 0, 0, 20); Label.BackgroundTransparency = 1; Label.TextColor3 = Color3.fromRGB(200, 200, 200); Label.TextXAlignment = Enum.TextXAlignment.Left; Label.Font = Enum.Font.GothamBold; Label.TextSize = 12
    table.insert(TextLabelsToUpdate, {Object = Label, Key = Key, Type = "Slider", Flag = Flag})
    local SliderBG = Instance.new("TextButton", Frame); SliderBG.Size = UDim2.new(0.9, 0, 0, 6); SliderBG.Position = UDim2.new(0.05, 0, 0.6, 0); SliderBG.BackgroundColor3 = Color3.fromRGB(10, 10, 10); SliderBG.Text = ""; SliderBG.AutoButtonColor = false; Instance.new("UICorner", SliderBG)
    local Fill = Instance.new("Frame", SliderBG); Fill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0); Fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0); Instance.new("UICorner", Fill)
    
    -- *** FIX LỖI KÉO BỊ DÍNH: Dùng kết nối cục bộ ***
    SliderBG.MouseButton1Down:Connect(function()
        local Mouse = Players.LocalPlayer:GetMouse()
        local MoveConnection, ReleaseConnection
        
        local function Update()
            local Percent = math.clamp((Mouse.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
            local Value = math.floor(Min + (Max - Min) * Percent)
            getgenv().Settings[Flag] = Value
            Label.Text = "  " .. GetText(Key) .. ": " .. Value
            Fill.Size = UDim2.new(Percent, 0, 1, 0)
        end
        
        Update() -- Cập nhật ngay khi bấm
        
        MoveConnection = Mouse.Move:Connect(Update)
        ReleaseConnection = UserInputService.InputEnded:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                MoveConnection:Disconnect()
                ReleaseConnection:Disconnect()
            end
        end)
    end)
end

function AddTextBox(Page, Key, Flag) local Frame = Instance.new("Frame", Page); Frame.Size = UDim2.new(1, 0, 0, 40); Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Instance.new("UICorner", Frame); local Input = Instance.new("TextBox", Frame); Input.Size = UDim2.new(0.9, 0, 0.8, 0); Input.Position = UDim2.new(0.05, 0, 0.1, 0); Input.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Input.TextColor3 = Color3.fromRGB(255, 255, 255); Input.Text = ""; Input.PlaceholderText = GetText(Key); Instance.new("UICorner", Input); Input.FocusLost:Connect(function() getgenv().Settings[Flag] = Input.Text end) end

function AddDropdown(Page, Key)
    local Frame = Instance.new("Frame", Page); Frame.Size = UDim2.new(1, 0, 0, 40); Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Instance.new("UICorner", Frame)
    local Btn = Instance.new("TextButton", Frame); Btn.Size = UDim2.new(1, 0, 1, 0); Btn.BackgroundTransparency = 1; Btn.Text = "  " .. GetText(Key) .. ": " .. getgenv().Settings.Language; Btn.TextColor3 = Color3.fromRGB(200, 200, 200); Btn.TextXAlignment = Enum.TextXAlignment.Left; Btn.Font = Enum.Font.GothamBold; Btn.TextSize = 12
    local isDropped = false; Btn.MouseButton1Click:Connect(function() isDropped = not isDropped; if isDropped then for i, lang in ipairs({"English", "Vietnamese"}) do local LangBtn = Instance.new("TextButton", Page); LangBtn.Size = UDim2.new(1, 0, 0, 30); LangBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); LangBtn.Text = lang; LangBtn.TextColor3 = Color3.fromRGB(150, 150, 150); LangBtn.Name = "DropdownItem"; LangBtn.MouseButton1Click:Connect(function() getgenv().Settings.Language = lang; UpdateUILanguage(); Btn.Text = "  " .. GetText(Key) .. ": " .. lang; for _, v in pairs(Page:GetChildren()) do if v.Name == "DropdownItem" then v:Destroy() end end; isDropped = false end) end else for _, v in pairs(Page:GetChildren()) do if v.Name == "DropdownItem" then v:Destroy() end end end end)
end

-- DRAGGABLE
local dragging, dragInput, dragStart, startPos
local function update(input) local delta = input.Position - dragStart; ToggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end
ToggleBtn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = ToggleBtn.Position; input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)
ToggleBtn.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)
ToggleBtn.MouseButton1Click:Connect(function() local isOpen = Main.Visible; Main.Visible = not isOpen end)

-- ITEMS
local Tab2 = AddTab("Tab2")
local Tab3 = AddTab("Tab3")
local Tab4 = AddTab("Tab4")

AddTextBox(Tab2, "TargetName", "TargetName")
AddToggle(Tab2, "AimLock", "AimLock", false)
AddToggle(Tab2, "Stomp", "AutoStomp", false)
AddToggle(Tab2, "Hitbox", "HitboxExpander", false)
AddSlider(Tab2, "Size", "HitboxSize", 2, 45, 15) -- MAX SIZE 45
AddSlider(Tab2, "Trans", "HitboxTrans", 0, 10, 5)
AddToggle(Tab2, "Aura", "AttackAura", false)

AddToggle(Tab3, "Noclip", "SmartNoclip", true)
AddToggle(Tab3, "NoRagdoll", "AntiRagdoll", true)
AddToggle(Tab3, "InfJump", "InfiniteJump", false)
AddToggle(Tab3, "FixSpeed", "FixSpeed", true)
AddSlider(Tab3, "Speed", "WalkSpeed", 16, 100, 16)
AddToggle(Tab3, "ESP", "EspBox", false)

AddDropdown(Tab4, "LangSel")

--------------------------------------------------------------------------------
-- 4. CORE LOGIC
--------------------------------------------------------------------------------

-- LOADING 6 SECONDS
spawn(function()
    local Duration = 6; local Steps = 100; local WaitTime = Duration / Steps
    for i = 1, Steps do LoadBarFill.Size = UDim2.new(i/100, 0, 1, 0); task.wait(WaitTime) end
    wait(0.2); LoadingHolder:Destroy(); ToggleBtn.Visible = true -- HIỆN NÚT SAU KHI LOAD XONG
end)

-- PVP LOGIC
spawn(function()
    while task.wait(0.1) do
        local TargetStr = getgenv().Settings.TargetName:lower()
        -- Hitbox
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
        -- Aura
        if getgenv().Settings.AttackAura then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    if (LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude < getgenv().Settings.HitboxSize + 5 then
                         local Tool = LocalPlayer.Backpack:FindFirstChild("Combat") or LocalPlayer.Backpack:FindFirstChild("Fists"); if Tool then LocalPlayer.Character.Humanoid:EquipTool(Tool) end
                         VirtualUser:CaptureController(); VirtualUser:ClickButton1(Vector2.new(999,999), Workspace.CurrentCamera.CFrame)
                    end
                end
            end
        end
    end
end)

-- AUTO STOMP
spawn(function()
    while wait(0.5) do
        if getgenv().Settings.AutoStomp then
            pcall(function()
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") then
                        if v.Character.Humanoid.Health < 15 and v.Character.Humanoid.Health > 0 then
                            local Dist = (LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                            if Dist < 25 then
                                LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
                                VirtualUser:CaptureController(); keypress(Enum.KeyCode.E); wait(0.1); keyrelease(Enum.KeyCode.E)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- SYSTEM LOGIC
RunService.RenderStepped:Connect(function()
    if getgenv().Settings.AimLock then
        local Nearest = nil; local MinDist = 100
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                local Dist = (LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                if Dist < MinDist then MinDist = Dist; Nearest = v.Character.Head end
            end
        end
        if Nearest then Camera.CFrame = CFrame.new(Camera.CFrame.Position, Nearest.Position) end
    end
end)

RunService.Heartbeat:Connect(function()
    if getgenv().Settings.FixSpeed and LocalPlayer.Character then LocalPlayer.Character.Humanoid.WalkSpeed = getgenv
