-- PHẦN 1: HỆ THỐNG PHỤC HỒI TỰ ĐỘNG BY PHUC NGUYEN
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local function getLatest()
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    return char, hum
end
local character, humanoid = getLatest()

if _G.EmotesGUIRunning then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/7yd7/Menu-7yd7/refs/heads/Script/GUIS/Off-site/Notify.lua"))()
    getgenv().Notify({Title = 'PHUC NGUYEN', Content = '✔️ Hệ thống Anti-Reset đang chạy!', Duration = 5})
    return
end
_G.EmotesGUIRunning = true
-- PHẦN 2
loadstring(game:HttpGet("https://raw.githubusercontent.com/7yd7/Menu-7yd7/refs/heads/Script/GUIS/Off-site/Notify.lua"))()
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/7yd7/Hub/Branch/GUIS/count-emote"))()
end)

getgenv().Notify({Title = '7yd7 | Emote', Content = '⚠️ Script loading...', Duration = 5})

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
-- PHẦN 3
local emoteClickConnections = {}
local isMonitoringClicks = false
local currentTimer = nil
local currentMode = "emote"
local animationsData = {}
local originalAnimationsData = {}
local filteredAnimations = {}
local favoriteAnimations = {}
local favoriteAnimationsFileName = "FavoriteAnimations.json"
local emoteSearchTerm = ""
local animationSearchTerm = ""
-- PHẦN 4
getgenv().lastPlayedAnimation = getgenv().lastPlayedAnimation or nil
getgenv().autoReloadEnabled = getgenv().autoReloadEnabled or true -- Mặc định bật để chống reset

local lastRadialActionTime = 0
local lastWheelVisibleTime = 0

RunService.Heartbeat:Connect(function()
    local success, menu = pcall(function() return CoreGui.RobloxGui.EmotesMenu.Children end)
    if not (success and menu) then return end
-- PHẦN 5
    pcall(function()
        if menu.Main.EmotesWheel.Visible then
            lastWheelVisibleTime = tick()
        end
    end)

    local errorMsg = menu:FindFirstChild("ErrorMessage")
    if errorMsg and errorMsg.Visible then
        local c, h = getLatest()
        if h and h.RigType == Enum.HumanoidRigType.R6 then
            errorMsg.ErrorText.Text = "Only r15 does not work r6"
        elseif tick() - lastRadialActionTime < 2 then
            errorMsg.Visible = false
        end
    end
end)
-- PHẦN 6
function ErrorMessage(text, duration)
    if currentTimer then task.cancel(currentTimer) currentTimer = nil end
    local errorMessage = CoreGui.RobloxGui.EmotesMenu.Children.ErrorMessage
    errorMessage.ErrorText.Text = text
    errorMessage.Visible = true
    currentTimer = task.delay(duration, function() errorMessage.Visible = false currentTimer = nil end)
end

local function stopEmotes()
    local c, h = getLatest()
    for _, track in ipairs(h:GetPlayingAnimationTracks()) do track:Stop() end
end
-- PHẦN 7
local emotesData = {}
local currentPage = 1
local itemsPerPage = 8
local totalPages = 1
local filteredEmotes = {}
local isLoading = false
local originalEmotesData = {}
local totalEmotesLoaded = 0
local scannedEmotes = {}
local favoriteEmotes = {}
local favoriteEnabled = false
-- PHẦN 8
local favoriteFileName = "FavoriteEmotes.json"
local emotesWalkEnabled = false
local currentEmoteTrack = nil
local currentCharacter = nil
local isGUICreated = false
local speedEmoteEnabled = false
local speedEmoteConfigFile = "SpeedEmoteConfig.json"

local Under, UIListLayout, _1left, _9right, _4pages, _3TextLabel, _2Routenumber, Top, EmoteWalkButton, UICorner1
-- PHẦN 9
local UIListLayout_2, UICorner, Search, Favorite, UICorner2, UICorner_2, SpeedEmote, UICorner_4, SpeedBox, UICorner_5, Changepage, Reload, UICorner_6

local defaultButtonImage = "rbxassetid://71408678974152"
local enabledButtonImage = "rbxassetid://106798555684020"
local favoriteIconId = "rbxassetid://97307461910825" 
local notFavoriteIconId = "rbxassetid://124025954365505"
-- PHẦN 10
local function getCharacterAndHumanoid()
    local c = player.Character or player.CharacterAdded:Wait()
    local h = c:FindFirstChild("Humanoid")
    return c, h
end

local function checkEmotesMenuExists()
    local robloxGui = CoreGui:FindFirstChild("RobloxGui")
    if not robloxGui then return false end
    local emotesMenu = robloxGui:FindFirstChild("EmotesMenu")
    if not emotesMenu then return false end
    local children = emotesMenu:FindFirstChild("Children")
    local main = children and children:FindFirstChild("Main")
    local emotesWheel = main and main:FindFirstChild("EmotesWheel")
    return (emotesWheel ~= nil), emotesWheel
end
-- PHẦN 11
local function getBackgroundOverlay()
    local success, result = pcall(function()
        return CoreGui.RobloxGui.EmotesMenu.Children.Main.EmotesWheel.Back.Background.BackgroundCircleOverlay
    end)
    return success and result or nil
end

local function updateGUIColors()
    local backgroundOverlay = getBackgroundOverlay()
    if not backgroundOverlay then return end
    local bgColor = backgroundOverlay.BackgroundColor3
    local bgTransparency = backgroundOverlay.BackgroundTransparency
 -- PHẦN 12
    if _1left then _1left.ImageColor3 = bgColor _1left.ImageTransparency = bgTransparency end
    if _9right then _9right.ImageColor3 = bgColor _9right.ImageTransparency = bgTransparency end
    if _4pages then _4pages.TextColor3 = bgColor _4pages.TextTransparency = bgTransparency end
    if _3TextLabel then _3TextLabel.TextColor3 = bgColor _3TextLabel.TextTransparency = bgTransparency end
    if _2Routenumber then _2Routenumber.TextColor3 = bgColor _2Routenumber.TextTransparency = bgTransparency end
-- PHẦN 13
    if Top then Top.BackgroundColor3 = bgColor Top.BackgroundTransparency = bgTransparency end
    if EmoteWalkButton then EmoteWalkButton.BackgroundColor3 = bgColor EmoteWalkButton.BackgroundTransparency = bgTransparency end
    if SpeedEmote then SpeedEmote.BackgroundColor3 = bgColor SpeedEmote.BackgroundTransparency = bgTransparency end
    if Changepage then Changepage.BackgroundColor3 = bgColor Changepage.BackgroundTransparency = bgTransparency end
    if SpeedBox then SpeedBox.BackgroundColor3 = bgColor SpeedBox.BackgroundTransparency = bgTransparency end
    if Favorite then Favorite.BackgroundColor3 = bgColor Favorite.BackgroundTransparency = bgTransparency end
  -- PHẦN 14
    if Reload then Reload.BackgroundColor3 = bgColor Reload.BackgroundTransparency = bgTransparency Reload.Visible = (currentMode == "animation") end
end

local function urlToId(id)
    id = string.gsub(id, "http://www%.roblox%.com/asset/%?id=", "")
    return string.gsub(id, "rbxassetid://", "")
end

local function saveFavorites() if writefile then writefile(favoriteFileName, HttpService:JSONEncode(favoriteEmotes)) end end
local function saveFavoritesAnimations() if writefile then writefile(favoriteAnimationsFileName, HttpService:JSONEncode(favoriteAnimations)) end end
-- PHẦN 15
local function loadFavorites() if readfile and isfile and isfile(favoriteFileName) then pcall(function() favoriteEmotes = HttpService:JSONDecode(readfile(favoriteFileName)) end) end end
local function loadFavoritesAnimations() if readfile and isfile and isfile(favoriteAnimationsFileName) then pcall(function() favoriteAnimations = HttpService:JSONDecode(readfile(favoriteAnimationsFileName)) end) end end

local function loadSpeedEmoteConfig()
    if readfile and isfile and isfile(speedEmoteConfigFile) then
        pcall(function()
            local res = HttpService:JSONDecode(readfile(speedEmoteConfigFile))
            speedEmoteEnabled = res.Enabled or false
            if SpeedBox then SpeedBox.Text = tostring(res.SpeedValue or 1) SpeedBox.Visible = speedEmoteEnabled end
        end)
    end
end
-- PHẦN 16
local function extractAssetId(url) return string.match(url, "Asset&id=(%d+)") end
local function getEmoteName(id)
    local s, info = pcall(function() return game:GetService("MarketplaceService"):GetProductInfo(tonumber(id)) end)
    return (s and info) and info.Name or "Emote_" .. tostring(id)
end

local function isInFavorites(id)
    local list = (currentMode == "animation") and favoriteAnimations or favoriteEmotes
    for _, fav in pairs(list) do if tostring(fav.id) == tostring(id) then return true end end
    return false
end
-- PHẦN 17
local function updateAnimationImages(currentPageAnimations)
    local s, frontFrame = pcall(function() return CoreGui.RobloxGui.EmotesMenu.Children.Main.EmotesWheel.Front.EmotesButtons end)
    if not (s and frontFrame) then return end
    local buttonIndex = 1
    for _, child in pairs(frontFrame:GetChildren()) do
        if child:IsA("ImageLabel") then
            if buttonIndex <= #currentPageAnimations then
                local data = currentPageAnimations[buttonIndex]
                child.Image = "rbxthumb://type=BundleThumbnail&id=" .. data.id .. "&w=420&h=420"
                local val = child:FindFirstChild("AnimationID") or Instance.new("IntValue", child)
                val.Name = "AnimationID" val.Value = data.id
                child.Active = not favoriteEnabled
                buttonIndex = buttonIndex + 1
            else child.Image = "" if child:FindFirstChild("AnimationID") then child.AnimationID:Destroy() end child.Active = true end
        end
    end
    frontFrame.Active = not favoriteEnabled
end
-- PHẦN 18
local function updateFavoriteIcon(imageLabel, assetId, isFavorite)
    local icon = imageLabel:FindFirstChild("FavoriteIcon") or Instance.new("ImageLabel", imageLabel)
    icon.Name = "FavoriteIcon" icon.Size = UDim2.new(0.3, 0, 0.3, 0) icon.Position = UDim2.new(0.7, 0, 0, 0)
    icon.BackgroundTransparency = 1 icon.ZIndex = imageLabel.ZIndex + 5 icon.ScaleType = Enum.ScaleType.Fit
    icon.Image = isFavorite and favoriteIconId or notFavoriteIconId
end

local function updateAllFavoriteIcons()
    local s, frontFrame = pcall(function() return CoreGui.RobloxGui.EmotesMenu.Children.Main.EmotesWheel.Front.EmotesButtons end)
    if s and frontFrame then
        for _, child in pairs(frontFrame:GetChildren()) do
            if child:IsA("ImageLabel") and child.Image ~= "" then
                local id = (currentMode == "animation") and (child:FindFirstChild("AnimationID") and child.AnimationID.Value) or extractAssetId(child.Image)
                if id then updateFavoriteIcon(child, id, isInFavorites(id)) end
                child.Active = not favoriteEnabled
            end
        end
        frontFrame.Active = not favoriteEnabled
    end
end
-- PHẦN 19
local function updateAnimations()
    local char, hum = getCharacterAndHumanoid()
    if not (char and hum and hum.HumanoidDescription) then return end
    local desc = hum.HumanoidDescription
    local currentPageAnimations = {} local animationTable = {} local equippedAnimations = {}
    local favs = _G.filteredFavoritesAnimationsForDisplay or favoriteAnimations
    local favPages = #favs > 0 and math.ceil(#favs / itemsPerPage) or 0
    if currentPage <= favPages and #favs > 0 then
        for i = (currentPage-1)*itemsPerPage+1, math.min((currentPage-1)*itemsPerPage+itemsPerPage, #favs) do
            table.insert(currentPageAnimations, {id = tonumber(favs[i].id), name = favs[i].name})
        end
    else
        local norm = {} for _, anim in pairs(filteredAnimations) do if not isInFavorites(anim.id) then table.insert(norm, anim) end end
        for i = (currentPage-favPages-1)*itemsPerPage+1, math.min((currentPage-favPages-1)*itemsPerPage+itemsPerPage, #norm) do
            table.insert(currentPageAnimations, norm[i])
        end
  end
 -- PHẦN 20
    for _, anim in pairs(currentPageAnimations) do
        animationTable[anim.name] = {anim.id} table.insert(equippedAnimations, anim.name)
    end
    desc:SetEmotes(animationTable) desc:SetEquippedEmotes(equippedAnimations)
    task.wait(0.1) updateAnimationImages(currentPageAnimations)
    task.delay(0.2, function() if favoriteEnabled then updateAllFavoriteIcons() end end)
end
-- PHẦN 21
local function updateEmotes()
    local char, hum = getCharacterAndHumanoid()
    if not (char and hum and hum.HumanoidDescription) then return end
    if currentMode == "animation" then updateAnimations() return end
    local desc = hum.HumanoidDescription
    local currentPageEmotes = {} local emoteTable = {} local equippedEmotes = {}
    local favs = _G.filteredFavoritesForDisplay or favoriteEmotes
    local favPages = #favs > 0 and math.ceil(#favs / itemsPerPage) or 0
    if currentPage <= favPages and #favs > 0 then
        for i = (currentPage-1)*itemsPerPage+1, math.min((currentPage-1)*itemsPerPage+itemsPerPage, #favs) do
            table.insert(currentPageEmotes, {id = tonumber(favs[i].id), name = favs[i].name})
        end
    else
        local norm = {} for _, e in pairs(filteredEmotes) do if not isInFavorites(e.id) then table.insert(norm, e) end end
        for i = (currentPage-favPages-1)*itemsPerPage+1, math.min((currentPage-favPages-1)*itemsPerPage+itemsPerPage, #norm) do
            table.insert(currentPageEmotes, norm[i])
        end
    end
    for _, e in pairs(currentPageEmotes) do emoteTable[e.name] = {e.id} table.insert(equippedEmotes, e.name) end
    desc:SetEmotes(emoteTable) desc:SetEquippedEmotes(equippedEmotes)
    task.delay(0.2, function() if favoriteEnabled then updateAllFavoriteIcons() end end)
end
-- PHẦN 22
local function calculateTotalPages()
    local favs = (currentMode == "animation") and (_G.filteredFavoritesAnimationsForDisplay or favoriteAnimations) or (_G.filteredFavoritesForDisplay or favoriteEmotes)
    local list = (currentMode == "animation") and filteredAnimations or filteredEmotes
    local normCount = 0 for _, item in pairs(list) do if not isInFavorites(item.id) then normCount = normCount + 1 end end
    local p = (#favs > 0 and math.ceil(#favs / itemsPerPage) or 0) + (normCount > 0 and math.ceil(normCount / itemsPerPage) or 0)
    return math.max(p, 1)
end

local function isDancing(char, track)
    local id = urlToId(track.Animation.AnimationId)
    for _, holder in char.Animate:GetChildren() do
        if holder:IsA("StringValue") then
            for _, anim in holder:GetChildren() do if anim:IsA("Animation") and urlToId(anim.AnimationId) == id then return false end end
        end
    end
    return true
end
-- PHẦN 23
local function createGUIElements()
    local exists, emotesWheel = checkEmotesMenuExists()
    if not exists then return false end
    for _, n in pairs({"Under", "Top", "EmoteWalkButton", "Favorite", "SpeedEmote", "Changepage", "SpeedBox", "Reload"}) do
        if emotesWheel:FindFirstChild(n) then emotesWheel[n]:Destroy() end
    end
    Under = Instance.new("Frame", emotesWheel) Under.Name = "Under" Under.BackgroundTransparency = 1 Under.Position = UDim2.new(0.13, 0, 1, 0) Under.Size = UDim2.new(0.737, 0, 0.132, 0)
    UIListLayout = Instance.new("UIListLayout", Under) UIListLayout.FillDirection = "Horizontal" UIListLayout.VerticalAlignment = "Center"
    _1left = Instance.new("ImageButton", Under) _1left.Name = "1left" _1left.BackgroundTransparency = 1 _1left.Size = UDim2.new(0.169, 0, 0.943, 0) _1left.Image = "rbxassetid://93111945058621" _1left.ImageTransparency = 0.4
    _9right = Instance.new("ImageButton", Under) _9right.Name = "9right" _9right.BackgroundTransparency = 1 _9right.Size = UDim2.new(0.169, 0, 0.943, 0) _9right.Image = "rbxassetid://107938916240738" _9right.ImageTransparency = 0.4
-- PHẦN 24
    _4pages = Instance.new("TextLabel", Under) _4pages.Name = "4pages" _4pages.BackgroundTransparency = 1 _4pages.Size = UDim2.new(0.159, 0, 0.811, 0) _4pages.Font = "SourceSansBold" _4pages.TextColor3 = Color3.new(0,0,0) _4pages.TextScaled = true _4pages.TextTransparency = 0.4
    _3TextLabel = Instance.new("TextLabel", Under) _3TextLabel.Name = "3TextLabel" _3TextLabel.BackgroundTransparency = 1 _3TextLabel.Size = UDim2.new(0.338, 0, 0.943, 0) _3TextLabel.Font = "SourceSansBold" _3TextLabel.Text = " ------ " _3TextLabel.TextColor3 = Color3.new(0,0,0) _3TextLabel.TextScaled = true _3TextLabel.TextTransparency = 0.4
    _2Routenumber = Instance.new("TextBox", Under) _2Routenumber.Name = "2Route-number" _2Routenumber.BackgroundTransparency = 1 _2Routenumber.Size = UDim2.new(0.159, 0, 0.811, 0) _2Routenumber.Font = "SourceSansBold" _2Routenumber.Text = "1" _2Routenumber.TextColor3 = Color3.new(0,0,0) _2Routenumber.TextScaled = true _2Routenumber.TextTransparency = 0.4
    Top = Instance.new("Frame", emotesWheel) Top.Name = "Top" Top.BackgroundColor3 = Color3.new(0,0,0) Top.BackgroundTransparency = 0.4 Top.Position = UDim2.new(0.127, 0, -0.11, 0) Top.Size = UDim2.new(0.737, 0, 0.095, 0)
    Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 20)
    Search = Instance.new("TextBox", Top) Search.Name = "Search" Search.BackgroundTransparency = 1 Search.Size = UDim2.new(0.864, 0, 0.815, 0) Search.Font = "SourceSansBold" Search.PlaceholderText = "Search/ID" Search.TextColor3 = Color3.new(1,1,1) Search.TextScaled = true
 -- PHẦN 25
    local function createBtn(n, pos, img)
        local b = Instance.new("ImageButton", emotesWheel) b.Name = n b.BackgroundColor3 = Color3.new(0,0,0) b.BackgroundTransparency = 0.4 b.Position = pos b.Size = UDim2.new(0.087, 0, 0.087, 0) b.Image = img
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10) return b
    end
    EmoteWalkButton = createBtn("EmoteWalkButton", UDim2.new(0.89, 0, -0.107, 0), defaultButtonImage)
    Favorite = createBtn("Favorite", UDim2.new(0.019, 0, -0.108, 0), "rbxassetid://124025954365505")
    SpeedEmote = createBtn("SpeedEmote", UDim2.new(0.889, 0, 0, 0), "rbxassetid://116056570415896")
    Changepage = createBtn("Changepage", UDim2.new(0.019, 0, 1.021, 0), "rbxassetid://13285615740")
  -- PHẦN 26
    SpeedBox = Instance.new("TextBox", emotesWheel) SpeedBox.Name = "SpeedBox" SpeedBox.BackgroundColor3 = Color3.new(0,0,0) SpeedBox.BackgroundTransparency = 0.4 SpeedBox.Position = UDim2.new(0.019, 0, 0, 0) SpeedBox.Size = UDim2.new(0.087, 0, 0.087, 0) SpeedBox.Visible = false SpeedBox.Font = "SourceSansBold" SpeedBox.Text = "1" SpeedBox.TextColor3 = Color3.new(1,1,1) SpeedBox.TextScaled = true
    Instance.new("UICorner", SpeedBox).CornerRadius = UDim.new(0, 10)
    loadSpeedEmoteConfig() connectEvents() isGUICreated = true updateGUIColors() return true
end
Reload = createBtn("Reload", UDim2.new(0.889, 0, 1.021, 0), "rbxassetid://127493377027615")
-- PHẦN 27
local function applyAnimation(data)
    local c, h = getCharacterAndHumanoid()
    local animate = c:FindFirstChild("Animate")
    if not (animate and h) then return end
    getgenv().lastPlayedAnimation = data
    for _, t in pairs(h:GetPlayingAnimationTracks()) do t:Stop() end
    for key, ids in pairs(data.bundledItems) do
        for _, id in pairs(ids) do
            spawn(function()
                local s, objs = pcall(function() return game:GetObjects("rbxassetid://" .. id) end)
                if s and objs then
                    local function search(p, path)
                        for _, child in pairs(p:GetChildren()) do
                            if child:IsA("Animation") then
                                local parts = (path .. "." .. child.Name):split(".")
                                if #parts >= 2 then
                                    local cat, name = parts[#parts-1], parts[#parts]
                                    if animate:FindFirstChild(cat) and animate[cat]:FindFirstChild(name) then
                                        animate[cat][name].AnimationId = child.AnimationId
                                        local a = Instance.new("Animation") a.AnimationId = child.AnimationId
                                        local t = h.Animator:LoadAnimation(a) t.Priority = "Action" t:Play() task.wait(0.1) t:Stop()
                                    end
                                end
                            else search(child, path .. "." .. child.Name) end
                        end
                    end
                    for _, o in pairs(objs) do search(o, o.Name) o.Parent = workspace task.delay(1, function() if o then o:Destroy() end end) end
                end
            end)
        end
    end
end
-- PHẦN 28: HỆ THỐNG KHÔI PHỤC TỰ ĐỘNG
player.CharacterAdded:Connect(function(newChar)
    local h = newChar:WaitForChild("Humanoid")
    task.wait(0.5)
    if getgenv().autoReloadEnabled and getgenv().lastPlayedAnimation then
        applyAnimation(getgenv().lastPlayedAnimation)
        getgenv().Notify({Title = 'Anti-Reset', Content = '🔄 Animation đã được khôi phục!', Duration = 3})
    end
end)
-- PHẦN 29
local function fetchAllEmotes()
    if isLoading then return end isLoading = true emotesData = {}
    pcall(function()
        local data = HttpService:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/7yd7/sniper-Emote/refs/heads/test/EmoteSniper.json")).data
        for _, item in pairs(data) do table.insert(emotesData, {id = tonumber(item.id), name = item.name or "Emote_"..item.id}) end
    end)
    originalEmotesData = emotesData filteredEmotes = emotesData totalPages = calculateTotalPages() currentPage = 1 updatePageDisplay() updateEmotes() isLoading = false
end

local function fetchAllAnimations()
    if isLoading then return end isLoading = true animationsData = {}
    pcall(function()
        local data = HttpService:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/7yd7/sniper-Emote/refs/heads/test/AnimationSniper.json")).data
        for _, item in pairs(data) do table.insert(animationsData, {id = tonumber(item.id), name = item.name or "Anim_"..item.id, bundledItems = item.bundledItems}) end
    end)
    originalAnimationsData = animationsData filteredAnimations = animationsData isLoading = false
end
-- PHẦN 30: KẾT THÚC
task.spawn(function()
    while true do
        local exists, wheel = checkEmotesMenuExists()
        if exists then
            if not wheel:FindFirstChild("Under") then 
                createGUIElements() 
                updatePageDisplay() 
                updateEmotes() 
            end
            -- ÉP KHÔNG RESET UI
            pcall(function() wheel.Parent.Parent.Parent.ResetOnSpawn = false end)
        end
        task.wait(1)
    end
end)

fetchAllEmotes() fetchAllAnimations() loadFavorites() loadFavoritesAnimations()
print("ANTI-RESET SYSTEM BY PHUC NGUYEN READY")
