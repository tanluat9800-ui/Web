--[[ 
    REDZ HUB - BADDIES V15 (GLOBAL EDITION)
    - Multi-Language System (20 Languages)
    - PvP Pro: Auto Stomp, Aim Lock, Attack Aura Fixed
    - ATM Farm Stable V14 Logic
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

-- CẤU HÌNH & DỮ LIỆU NGÔN NGỮ
getgenv().Settings = {
    Language = "English", -- Mặc định
    
    -- ATM
    AutoATM = false, AutoCash = true, FlySpeed = 45, ATMTimeout = 25, MaxDistance = 600,
    
    -- COMBAT
    AttackAura = false, HitboxExpander = false, HitboxSize = 15, TargetName = "", 
    AutoStomp = false, AimLock = false,
    
    -- MOVE
    FixSpeed = true, WalkSpeed = 16, AntiRagdoll = true, SmartNoclip = true, InfiniteJump = false, EspBox = false
}

-- BẢNG DỊCH THUẬT (20 NGÔN NGỮ)
local Translations = {
    English = {
        Tab1="ATM Farm", Tab2="PvP Pro", Tab3="Movement", Tab4="Settings",
        AutoATM="Auto Farm ATM", AutoCash="Auto Loot Cash", FlySpeed="Fly Speed", Timeout="Timeout (s)",
        TargetName="Target Name...", Hitbox="Hitbox Expander", Size="Hitbox Size", Aura="Attack Aura", Stomp="Auto Stomp (Finish)", AimLock="Aim Lock (Head)",
        Noclip="Smart Noclip", NoRagdoll="Anti-Ragdoll", InfJump="Infinite Jump", FixSpeed="Fix Speed", Speed="WalkSpeed", ESP="ESP Box",
        LangSel="Select Language"
    },
    Vietnamese = {
        Tab1="Cày ATM", Tab2="Đánh Nhau", Tab3="Di Chuyển", Tab4="Cài Đặt",
        AutoATM="Tự Động ATM", AutoCash="Tự Nhặt Tiền", FlySpeed="Tốc Độ Bay", Timeout="Thời Gian Chờ",
        TargetName="Tên Mục Tiêu...", Hitbox="Mở Rộng Hitbox", Size="Kích Thước", Aura="Tự Động Đấm", Stomp="Tự Dậm (Kết Liễu)", AimLock="Khóa Mục Tiêu",
        Noclip="Đi Xuyên Tường", NoRagdoll="Chống Ngã", InfJump="Nhảy Vô Hạn", FixSpeed="Ép Tốc Độ", Speed="Tốc Độ Chạy", ESP="Nhìn Xuyên Tường",
        LangSel="Chọn Ngôn Ngữ"
    },
    Japanese = { Tab1="ATMファーム", Tab2="PvPプロ", Tab3="動き", Tab4="設定", AutoATM="自動ATM", AutoCash="自動集金", FlySpeed="飛行速度", Timeout="タイムアウト", TargetName="ターゲット名...", Hitbox="ヒットボックス拡張", Size="サイズ", Aura="攻撃オーラ", Stomp="自動ストンプ", AimLock="エイムロック", LangSel="言語を選択" },
    Chinese = { Tab1="ATM 刷钱", Tab2="PvP 增强", Tab3="移动", Tab4="设置", AutoATM="自动 ATM", AutoCash="自动拾取", FlySpeed="飞行速度", Timeout="超时", TargetName="目标名称...", Hitbox="攻击范围扩大", Size="大小", Aura="自动攻击", Stomp="自动处决", AimLock="自瞄锁定", LangSel="选择语言" },
    Russian = { Tab1="ATM Фарм", Tab2="PvP Про", Tab3="Движение", Tab4="Настройки", AutoATM="Авто ATM", AutoCash="Авто Деньги", FlySpeed="Скорость Полета", Timeout="Тайм-аут", TargetName="Имя Цели...", Hitbox="Хитбокс", Size="Размер", Aura="Аура Атаки", Stomp="Авто Добивание", AimLock="Аим Лок", LangSel="Выберите Язык" },
    Spanish = { Tab1="Granja ATM", Tab2="PvP Pro", Tab3="Movimiento", Tab4="Ajustes", AutoATM="Auto ATM", AutoCash="Auto Dinero", FlySpeed="Velocidad Vuelo", Timeout="Tiempo Espera", TargetName="Nombre Objetivo...", Hitbox="Expandir Hitbox", Size="Tamaño", Aura="Aura Ataque", Stomp="Auto Remate", AimLock="Bloqueo Objetivo", LangSel="Seleccionar Idioma" },
    French = { Tab1="Ferme ATM", Tab2="PvP Pro", Tab3="Mouvement", Tab4="Paramètres", AutoATM="Auto ATM", AutoCash="Auto Cash", FlySpeed="Vitesse Vol", Timeout="Délai", TargetName="Nom Cible...", Hitbox="Hitbox Étendue", Size="Taille", Aura="Aura Attaque", Stomp="Auto Finition", AimLock="Verrouillage Visée", LangSel="Choisir Langue" },
    German = { Tab1="ATM Farm", Tab2="PvP Pro", Tab3="Bewegung", Tab4="Einstellungen", AutoATM="Auto ATM", AutoCash="Auto Geld", FlySpeed="Fluggeschwindigkeit", Timeout="Auszeit", TargetName="Zielname...", Hitbox="Hitbox Erweitern", Size="Größe", Aura="Angriffs Aura", Stomp="Auto Finish", AimLock="Zielverriegelung", LangSel="Sprache wählen" },
    Thai = { Tab1="ฟาร์ม ATM", Tab2="PvP โปร", Tab3="การเคลื่อนไหว", Tab4="การตั้งค่า", AutoATM="ออโต้ ATM", AutoCash="เก็บเงินออโต้", FlySpeed="ความเร็วบิน", Timeout="หมดเวลา", TargetName="ชื่อเป้าหมาย...", Hitbox="ขยาย Hitbox", Size="ขนาด", Aura="ออร่าโจมตี", Stomp="กระทืบซ้ำ", AimLock="ล็อคเป้า", LangSel="เลือกภาษา" },
    Korean = { Tab1="ATM 파밍", Tab2="PvP 프로", Tab3="이동", Tab4="설정", AutoATM="자동 ATM", AutoCash="자동 현금", FlySpeed="비행 속도", Timeout="시간 초과", TargetName="목표 이름...", Hitbox="히트박스 확장", Size="크기", Aura="공격 오라", Stomp="자동 확인사살", AimLock="에임 고정", LangSel="언어 선택" },
    Portuguese = { Tab1="Farm ATM", Tab2="PvP Pro", Tab3="Movimento", Tab4="Config", AutoATM="Auto ATM", AutoCash="Auto Dinheiro", FlySpeed="Vel Voo", Timeout="Tempo", TargetName="Nome Alvo...", Hitbox="Expandir Hitbox", Size="Tamanho", Aura="Aura Ataque", Stomp="Auto Finalizar", AimLock="Mira Auto", LangSel="Selecione Idioma" },
    Indonesian = { Tab1="Farm ATM", Tab2="PvP Pro", Tab3="Gerakan", Tab4="Pengaturan", AutoATM="Auto ATM", AutoCash="Ambil Uang", FlySpeed="Kecepatan Terbang", Timeout="Waktu Habis", TargetName="Nama Target...", Hitbox="Perbesar Hitbox", Size="Ukuran", Aura="Aura Serangan", Stomp="Auto Injak", AimLock="Kunci Aim", LangSel="Pilih Bahasa" },
    Italian = { Tab1="Farm ATM", Tab2="PvP Pro", Tab3="Movimento", Tab4="Impostazioni", AutoATM="Auto ATM", AutoCash="Auto Soldi", FlySpeed="Vel Volo", Timeout="Timeout", TargetName="Nome Bersaglio...", Hitbox="Espandi Hitbox", Size="Dimensione", Aura="Aura Attacco", Stomp="Auto Finitura", AimLock="Blocco Mira", LangSel="Seleziona Lingua" },
    Turkish = { Tab1="ATM Kasma", Tab2="PvP Pro", Tab3="Hareket", Tab4="Ayarlar", AutoATM="Oto ATM", AutoCash="Oto Para", FlySpeed="Uçuş Hızı", Timeout="Zaman Aşımı", TargetName="Hedef Adı...", Hitbox="Hitbox Genişlet", Size="Boyut", Aura="Saldırı Aura", Stomp="Oto Bitir", AimLock="Nişan Kilidi", LangSel="Dil Seç" },
    Arabic = { Tab1="زراعة ATM", Tab2="PvP محترف", Tab3="حركة", Tab4="إعدادات", AutoATM="ATM تلقائي", AutoCash="جمع المال", FlySpeed="سرعة الطيران", Timeout="انتهاء الوقت", TargetName="اسم الهدف...", Hitbox="توسيع الإصابة", Size="بحجم", Aura="هالة الهجوم", Stomp="إنهاء تلقائي", AimLock="قفل الهدف", LangSel="اختار اللغة" },
    Polish = { Tab1="Farma ATM", Tab2="PvP Pro", Tab3="Ruch", Tab4="Ustawienia", AutoATM="Auto ATM", AutoCash="Auto Kasa", FlySpeed="Prędkość Lotu", Timeout="Limit Czasu", TargetName="Nazwa Celu...", Hitbox="Hitbox Expander", Size="Rozmiar", Aura="Aura Ataku", Stomp="Auto Wykończenie", AimLock="Aim Lock", LangSel="Wybierz Język" },
    Filipino = { Tab1="ATM Farm", Tab2="PvP Pro", Tab3="Galaw", Tab4="Settings", AutoATM="Auto ATM", AutoCash="Auto Pera", FlySpeed="Bilis Lipad", Timeout="Timeout", TargetName="Pangalan...", Hitbox="Hitbox Expander", Size="Laki", Aura="Attack Aura", Stomp="Auto Tapos", AimLock="Aim Lock", LangSel="Piliin Wika" },
    Dutch = { Tab1="ATM Farm", Tab2="PvP Pro", Tab3="Beweging", Tab4="Instellingen", AutoATM="Auto ATM", AutoCash="Auto Geld", FlySpeed="Vliegsnelheid", Timeout="Timeout", TargetName="Doel Naam...", Hitbox="Hitbox Expander", Size="Grootte", Aura="Aanval Aura", Stomp="Auto Afmaken", AimLock="Aim Lock", LangSel="Taal Selecteren" },
    Hindi = { Tab1="ATM Farm", Tab2="PvP Pro", Tab3="Movement", Tab4="Settings", AutoATM="Auto ATM", AutoCash="Auto Cash", FlySpeed="Fly Speed", Timeout="Timeout", TargetName="Target Name...", Hitbox="Hitbox Expander", Size="Size", Aura="Attack Aura", Stomp="Auto Stomp", AimLock="Aim Lock", LangSel="Bhasha Chune" }, -- Giữ tiếng Anh cho các từ kĩ thuật
    Romanian = { Tab1="Ferma ATM", Tab2="PvP Pro", Tab3="Mișcare", Tab4="Setări", AutoATM="Auto ATM", AutoCash="Auto Bani", FlySpeed="Viteză Zbor", Timeout="Timp", TargetName="Nume Țintă...", Hitbox="Hitbox Expander", Size="Mărime", Aura="Aură Atac", Stomp="Auto Final", AimLock="Blocare Țintă", LangSel="Selectare Limbă" },
}

local LanguageList = {}
for k,v in pairs(Translations) do table.insert(LanguageList, k) end
table.sort(LanguageList)

-- Hàm lấy Text theo ngôn ngữ
function GetText(Key)
    local Lang = getgenv().Settings.Language
    if Translations[Lang] and Translations[Lang][Key] then
        return Translations[Lang][Key]
    end
    return Translations["English"][Key] or Key -- Fallback về tiếng Anh
end

-- Danh sách các UI cần update text
local TextLabelsToUpdate = {} 

function UpdateUILanguage()
    for _, item in pairs(TextLabelsToUpdate) do
        if item.Object and item.Key then
            if item.Type == "Text" then
                item.Object.Text = "  " .. GetText(item.Key)
            elseif item.Type == "Slider" then
                item.Object.Text = "  " .. GetText(item.Key) .. ": " .. getgenv().Settings[item.Flag]
            elseif item.Type == "Tab" then
                item.Object.Text = GetText(item.Key)
            end
        end
    end
end

--------------------------------------------------------------------------------
-- 1. HỆ THỐNG LOADING SCREEN (GIỮ NGUYÊN)
--------------------------------------------------------------------------------

if CoreGui:FindFirstChild("RedzV15") then CoreGui.RedzV15:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "RedzV15"

-- LOADING
local LoadingFrame = Instance.new("Frame", ScreenGui); LoadingFrame.Size = UDim2.new(1, 0, 1, 0); LoadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0); LoadingFrame.BackgroundTransparency = 0.1; LoadingFrame.ZIndex = 100
local LoadBox = Instance.new("Frame", LoadingFrame); LoadBox.Size = UDim2.new(0, 320, 0, 100); LoadBox.Position = UDim2.new(0.5, -160, 0.5, -50); LoadBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Instance.new("UICorner", LoadBox).CornerRadius = UDim.new(0, 10); Instance.new("UIStroke", LoadBox).Color = Color3.fromRGB(255, 0, 0); Instance.new("UIStroke", LoadBox).Thickness = 2
local LoadTitle = Instance.new("TextLabel", LoadBox); LoadTitle.Text = "REDZ HUB V15 GLOBAL"; LoadTitle.Size = UDim2.new(1, 0, 0, 50); LoadTitle.TextColor3 = Color3.fromRGB(255, 255, 255); LoadTitle.Font = Enum.Font.GothamBlack; LoadTitle.TextSize = 20; LoadTitle.BackgroundTransparency = 1
local LoadBarBG = Instance.new("Frame", LoadBox); LoadBarBG.Size = UDim2.new(0.8, 0, 0, 10); LoadBarBG.Position = UDim2.new(0.1, 0, 0.6, 0); LoadBarBG.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Instance.new("UICorner", LoadBarBG)
local LoadBarFill = Instance.new("Frame", LoadBarBG); LoadBarFill.Size = UDim2.new(0, 0, 1, 0); LoadBarFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0); Instance.new("UICorner", LoadBarFill)

spawn(function()
    for i = 1, 100, 2 do LoadBarFill.Size = UDim2.new(i/100, 0, 1, 0); task.wait(0.01) end
    wait(0.2); LoadingFrame:Destroy()
end)

--------------------------------------------------------------------------------
-- 2. GIAO DIỆN CHÍNH
--------------------------------------------------------------------------------

-- TOGGLE BTN
local ToggleBtn = Instance.new("ImageButton", ScreenGui); ToggleBtn.Size = UDim2.new(0, 50, 0, 50); ToggleBtn.Position = UDim2.new(0.1, 0, 0.3, 0); ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15); ToggleBtn.BorderColor3 = Color3.fromRGB(255, 0, 0); ToggleBtn.BorderSizePixel = 2
local ToggleCorner = Instance.new("UICorner", ToggleBtn); ToggleCorner.CornerRadius = UDim.new(1, 0)
local ToggleText = Instance.new("TextLabel", ToggleBtn); ToggleText.Size = UDim2.new(1,0,1,0); ToggleText.BackgroundTransparency = 1; ToggleText.Text = "R"; ToggleText.TextColor3 = Color3.fromRGB(255, 0, 0); ToggleText.Font = Enum.Font.FredokaOne; ToggleText.TextSize = 28

-- MAIN
local Main = Instance.new("Frame", ScreenGui); Main.Size = UDim2.new(0, 420, 0, 300); Main.Position = UDim2.new(0.5, -210, 0.5, -150); Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12); Main.Visible = false; Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8); Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 0, 0); Instance.new("UIStroke", Main).Thickness = 2

-- TABS
local TabContainer = Instance.new("Frame", Main); TabContainer.Position = UDim2.new(0, 0, 0, 0); TabContainer.Size = UDim2.new(0, 100, 1, 0); TabContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 18); Instance.new("UICorner", TabContainer).CornerRadius = UDim.new(0, 8)
local TabList = Instance.new("UIListLayout", TabContainer); TabList.Padding = UDim.new(0, 2); TabList.SortOrder = Enum.SortOrder.LayoutOrder; TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
local ContentContainer = Instance.new("Frame", Main); ContentContainer.Position = UDim2.new(0, 110, 0, 10); ContentContainer.Size = UDim2.new(1, -120, 1, -20); ContentContainer.BackgroundTransparency = 1

local CurrentTab = nil
function AddTab(Key)
    local TabBtn = Instance.new("TextButton", TabContainer); TabBtn.Size = UDim2.new(0.9, 0, 0, 35); TabBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 18); TabBtn.Text = GetText(Key); TabBtn.TextColor3 = Color3.fromRGB(120, 120, 120); TabBtn.Font = Enum.Font.GothamBold; TabBtn.TextSize = 11; Instance.new("UICorner", TabBtn)
    
    -- Lưu lại để dịch
    table.insert(TextLabelsToUpdate, {Object = TabBtn, Key = Key, Type = "Tab"})

    local Page = Instance.new("ScrollingFrame", ContentContainer); Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 2; local PageList = Instance.new("UIListLayout", Page); PageList.Padding = UDim.new(0, 5); PageList.SortOrder = Enum.SortOrder.LayoutOrder
    TabBtn.MouseButton1Click:Connect(function() for _,v in pairs(ContentContainer:GetChildren()) do v.Visible = false end; for _,v in pairs(TabContainer:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(120, 120, 120) end end; Page.Visible = true; TabBtn.TextColor3 = Color3.fromRGB(255, 0, 0) end)
    if not CurrentTab then CurrentTab = Page; Page.Visible = true; TabBtn.TextColor3 = Color3.fromRGB(255, 0, 0) end
    return Page
end

function AddToggle(Page, Key, Flag, Default)
    getgenv().Settings[Flag] = Default
    local Btn = Instance.new("TextButton", Page); Btn.Size = UDim2.new(1, 0, 0, 35); Btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22); Btn.Text = "  " .. GetText(Key); Btn.TextColor3 = getgenv().Settings[Flag] and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(150, 150, 150); Btn.TextXAlignment = Enum.TextXAlignment.Left; Btn.Font = Enum.Font.GothamBold; Btn.TextSize = 12; Instance.new("UICorner", Btn)
    
    table.insert(TextLabelsToUpdate, {Object = Btn, Key = Key, Type = "Text"})
    
    Btn.MouseButton1Click:Connect(function() getgenv().Settings[Flag] = not getgenv().Settings[Flag]; Btn.TextColor3 = getgenv().Settings[Flag] and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(150, 150, 150) end)
end

function AddSlider(Page, Key, Flag, Min, Max, Default)
    getgenv().Settings[Flag] = Default
    local Frame = Instance.new("Frame", Page); Frame.Size = UDim2.new(1, 0, 0, 45); Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 22); Instance.new("UICorner", Frame)
    local Label = Instance.new("TextLabel", Frame); Label.Text = "  " .. GetText(Key) .. ": " .. Default; Label.Size = UDim2.new(1, 0, 0, 20); Label.BackgroundTransparency = 1; Label.TextColor3 = Color3.fromRGB(200, 200, 200); Label.TextXAlignment = Enum.TextXAlignment.Left; Label.Font = Enum.Font.GothamBold; Label.TextSize = 12
    
    table.insert(TextLabelsToUpdate, {Object = Label, Key = Key, Type = "Slider", Flag = Flag})

    local SliderBG = Instance.new("TextButton", Frame); SliderBG.Size = UDim2.new(0.9, 0, 0, 6); SliderBG.Position = UDim2.new(0.05, 0, 0.6, 0); SliderBG.BackgroundColor3 = Color3.fromRGB(10, 10, 10); SliderBG.Text = ""; SliderBG.AutoButtonColor = false; Instance.new("UICorner", SliderBG)
    local Fill = Instance.new("Frame", SliderBG); Fill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0); Fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0); Instance.new("UICorner", Fill)
    SliderBG.MouseButton1Down:Connect(function()
        local Mouse = Players.LocalPlayer:GetMouse(); local function Update() local P = math.clamp((Mouse.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1); local Val = math.floor(Min + (Max - Min) * P); getgenv().Settings[Flag] = Val; Label.Text = "  " .. GetText(Key) .. ": " .. Val; Fill.Size = UDim2.new(P, 0, 1, 0) end
        local Move = Mouse.Move:Connect(Update); local Rel = UserInputService.InputEnded:Connect(function(I) if I.UserInputType == Enum.UserInputType.MouseButton1 then Move:Disconnect(); Rel:Disconnect() end end); Update()
    end)
end

function AddTextBox(Page, Key, Flag)
    local Frame = Instance.new("Frame", Page); Frame.Size = UDim2.new(1, 0, 0, 40); Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 22); Instance.new("UICorner", Frame)
    local Input = Instance.new("TextBox", Frame); Input.Size = UDim2.new(0.9, 0, 0.8, 0); Input.Position = UDim2.new(0.05, 0, 0.1, 0); Input.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Input.TextColor3 = Color3.fromRGB(255, 0, 0); Input.Text = ""; Input.PlaceholderText = GetText(Key); Instance.new("UICorner", Input)
    Input.FocusLost:Connect(function() getgenv().Settings[Flag] = Input.Text end)
end

-- LANGUAGE DROPDOWN (SETTINGS TAB)
function AddDropdown(Page, Key)
    local Frame = Instance.new("Frame", Page); Frame.Size = UDim2.new(1, 0, 0, 40); Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 22); Instance.new("UICorner", Frame)
    local Btn = Instance.new("TextButton", Frame); Btn.Size = UDim2.new(1, 0, 1, 0); Btn.BackgroundTransparency = 1; Btn.Text = "  " .. GetText(Key) .. ": " .. getgenv().Settings.Language; Btn.TextColor3 = Color3.fromRGB(200, 200, 200); Btn.TextXAlignment = Enum.TextXAlignment.Left; Btn.Font = Enum.Font.GothamBold; Btn.TextSize = 12
    
    local isDropped = false
    Btn.MouseButton1Click:Connect(function()
        isDropped = not isDropped
        if isDropped then
            local DropIdx = 0
            for i, lang in ipairs(LanguageList) do
                 local LangBtn = Instance.new("TextButton", Page)
                 LangBtn.Size = UDim2.new(1, 0, 0, 30); LangBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); LangBtn.Text = lang; LangBtn.TextColor3 = Color3.fromRGB(150, 150, 150); LangBtn.Name = "DropdownItem"
                 LangBtn.MouseButton1Click:Connect(function()
                     getgenv().Settings.Language = lang
                     UpdateUILanguage()
                     Btn.Text = "  " .. GetText(Key) .. ": " .. lang
                     -- Xóa dropdown items
                     for _, v in pairs(Page:GetChildren()) do if v.Name == "DropdownItem" then v:Destroy() end end
                     isDropped = false
                 end)
            end
        else
            for _, v in pairs(Page:GetChildren()) do if v.Name == "DropdownItem" then v:Destroy() end end
        end
    end)
end

-- DRAGGABLE
local dragging, dragInput, dragStart, startPos
local function update(input) local delta = input.Position - dragStart; ToggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end
ToggleBtn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = ToggleBtn.Position; input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)
ToggleBtn.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)
ToggleBtn.MouseButton1Click:Connect(function() isOpen = not isOpen; if isOpen then Main.Visible = true else Main.Visible = false end end)

-- ITEMS
local Tab1 = AddTab("Tab1") -- ATM
local Tab2 = AddTab("Tab2") -- PvP
local Tab3 = AddTab("Tab3") -- Move
local Tab4 = AddTab("Tab4") -- Settings

AddToggle(Tab1, "AutoATM", "AutoATM", false)
AddToggle(Tab1, "AutoCash", "AutoCash", true)
AddSlider(Tab1, "FlySpeed", "FlySpeed", 30, 80, 45)
AddSlider(Tab1, "Timeout", "ATMTimeout", 5, 60, 25)

AddTextBox(Tab2, "TargetName", "TargetName")
AddToggle(Tab2, "AimLock", "AimLock", false) -- New
AddToggle(Tab2, "Stomp", "AutoStomp", false) -- New
AddToggle(Tab2, "Hitbox", "HitboxExpander", false)
AddSlider(Tab2, "Size", "HitboxSize", 2, 25, 15)
AddToggle(Tab2, "Aura", "AttackAura", false)

AddToggle(Tab3, "Noclip", "SmartNoclip", true)
AddToggle(Tab3, "NoRagdoll", "AntiRagdoll", true)
AddToggle(Tab3, "InfJump", "InfiniteJump", false)
AddToggle(Tab3, "FixSpeed", "FixSpeed", true)
AddSlider(Tab3, "Speed", "WalkSpeed", 16, 100, 16)
AddToggle(Tab3, "ESP", "EspBox", false)

AddDropdown(Tab4, "LangSel")

--------------------------------------------------------------------------------
-- 4. CORE LOGIC (V15 IMPROVED)
--------------------------------------------------------------------------------

-- AUTO STOMP (FINISHER)
spawn(function()
    while wait(0.5) do
        if getgenv().Settings.AutoStomp then
            pcall(function()
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") then
                        -- Check Knocked (Máu < 15 hoặc State)
                        if v.Character.Humanoid.Health < 15 and v.Character.Humanoid.Health > 0 then
                            local Dist = (LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                            if Dist < 20 then
                                -- Teleport lại gần để dậm
                                LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
                                VirtualUser:CaptureController()
                                keypress(Enum.KeyCode.E) -- Phím Stomp
                                wait(0.1)
                                keyrelease(Enum.KeyCode.E)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- AIM LOCK
RunService.RenderStepped:Connect(function()
    if getgenv().Settings.AimLock then
        local Nearest = nil
        local MinDist = 100
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                local Dist = (LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                if Dist < MinDist then
                    MinDist = Dist
                    Nearest = v.Character.Head
                end
            end
        end
        if Nearest then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Nearest.Position)
        end
    end
end)

-- ATTACK AURA & HITBOX VISUAL
spawn(function()
    while task.wait(0.1) do
        local TargetStr = getgenv().Settings.TargetName:lower()
        
        -- HITBOX
        if getgenv().Settings.HitboxExpander then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local IsTarget = (TargetStr == "") or v.Name:lower():find(TargetStr)
                    if IsTarget then
                        v.Character.HumanoidRootPart.Size = Vector3.new(getgenv().Settings.HitboxSize, getgenv().Settings.HitboxSize, getgenv().Settings.HitboxSize)
                        v.Character.HumanoidRootPart.Transparency = 0.5
                        v.Character.HumanoidRootPart.CanCollide = false
                        v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really red")
                    end
                end
            end
        end

        -- AURA
        if getgenv().Settings.AttackAura then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local Dist = (LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                    if Dist < getgenv().Settings.HitboxSize + 5 then
                         -- Cầm Tool
                         local Tool = LocalPlayer.Backpack:FindFirstChild("Combat") or LocalPlayer.Backpack:FindFirstChild("Fists")
                         if Tool then LocalPlayer.Character.Humanoid:EquipTool(Tool) end
                         
                         VirtualUser:CaptureController()
                         VirtualUser:ClickButton1(Vector2.new(999,999), Workspace.CurrentCamera.CFrame)
                    end
                end
            end
        end
    end
end)

-- MOVEMENT & ATM LOGIC (KEEP V14 STABLE)
function SmartFlyTo(TargetCFrame)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    if (LocalPlayer.Character.HumanoidRootPart.Position - TargetCFrame.Position).Magnitude > getgenv().Settings.MaxDistance then return false end
    if TargetCFrame.Position.Y < -50 then return false end

    local HRP = LocalPlayer.Character.HumanoidRootPart
    local BodyVel = HRP:FindFirstChild("ATMFly") or Instance.new("BodyVelocity", HRP)
    BodyVel.Name = "ATMFly"; BodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    local Speed = getgenv().Settings.FlySpeed
    local Dist = (HRP.Position - TargetCFrame.Position).Magnitude
    if Dist < 15 then Speed = 20 end
    BodyVel.Velocity = (TargetCFrame.Position - HRP.Position).Unit * Speed
    HRP.CFrame = CFrame.new(HRP.Position, Vector3.new(TargetCFrame.Position.X, HRP.Position.Y, TargetCFrame.Position.Z))
    if Dist < 3 then BodyVel.Velocity = Vector3.new(0,0,0); return true end
    return false
end

local BrokenATMs = {}
spawn(function()
    while task.wait() do
        if getgenv().Settings.AutoATM then
            pcall(function()
                local Char = LocalPlayer.Character
                local CashFound = nil
                if getgenv().Settings.AutoCash then
                    for _, v in pairs(Workspace:GetChildren()) do
                        if (v.Name == "Cash" or v.Name == "Money") and (Char.HumanoidRootPart.Position - v.Position).Magnitude < 25 then
                            CashFound = v; break
                        end
                    end
                end
                if CashFound then
                    firetouchinterest(Char.HumanoidRootPart, CashFound, 0); firetouchinterest(Char.HumanoidRootPart, CashFound, 1)
                else
                    local BestATM = nil; local MinDist = getgenv().Settings.MaxDistance
                    for _, v in pairs(Workspace:GetDescendants()) do
                        if v.Name == "ATM" and v:IsA("Model") and v:FindFirstChild("Screen") then
                            if not BrokenATMs[v] and v.Screen.Position.Y > -20 then
                                local Dist = (Char.HumanoidRootPart.Position - v.Screen.Position).Magnitude
                                if Dist < MinDist then MinDist = Dist; BestATM = v end
                            end
                        end
                    end
                    if BestATM then
                        if SmartFlyTo(BestATM.Screen.CFrame) then
                            local Tool = LocalPlayer.Backpack:FindFirstChild("Combat") or LocalPlayer.Backpack:FindFirstChild("Fists"); if Tool then Char.Humanoid:EquipTool(Tool) end
                            VirtualUser:CaptureController(); VirtualUser:ClickButton1(Vector2.new(999,999), Workspace.CurrentCamera.CFrame)
                            if not BestATM:FindFirstChild("FarmStart") then local T = Instance.new("NumberValue", BestATM); T.Name = "FarmStart"; T.Value = tick()
                            elseif tick() - BestATM.FarmStart.Value > getgenv().Settings.ATMTimeout then BrokenATMs[BestATM] = true; BestATM.FarmStart:Destroy(); if Char.HumanoidRootPart:FindFirstChild("ATMFly") then Char.HumanoidRootPart.ATMFly:Destroy() end; task.wait(0.5) end
                        end
                    else
                         if Char.HumanoidRootPart:FindFirstChild("ATMFly") then Char.HumanoidRootPart.ATMFly:Destroy() end
                    end
                end
            end)
        else
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart:FindFirstChild("ATMFly") then LocalPlayer.Character.HumanoidRootPart.ATMFly:Destroy() end
        end
    end
end)

RunService.Stepped:Connect(function() if getgenv().Settings.AutoATM or getgenv().Settings.SmartNoclip then for _,v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end end)
RunService.Heartbeat:Connect(function() if getgenv().Settings.FixSpeed then LocalPlayer.Character.Humanoid.WalkSpeed = getgenv().Settings.WalkSpeed end; if getgenv().Settings.AntiRagdoll then LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false); LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false) end end)
