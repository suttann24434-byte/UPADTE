--// Loader Stabil SuttannHub VFull

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- HWID unik
local HWID = tostring(game:GetService("RbxAnalyticsService"):GetClientId())

-- File key
local keyFile = "SuttannHubKey.json"

-- Ambil key dari Pastebin
local paste_id = "c7DnMX7z"
local function GetPastebinRaw(id)
    local ok, result = pcall(function()
        return game:HttpGet("https://pastebin.com/raw/"..id)
    end)
    if ok then return result else return "" end
end
local ValidKeyData = GetPastebinRaw(paste_id)

-- Fungsi cek key
local function CheckKey(key)
    for line in string.gmatch(ValidKeyData, "[^\r\n]+") do
        local savedKey, usedHWID = string.match(line,"(%S+)|?(%S*)")
        if savedKey == key then
            if usedHWID == "" or usedHWID == HWID then
                return true
            else
                return false, "Key sudah digunakan di device lain!"
            end
        end
    end
    return false, "Key tidak valid atau sudah direset!"
end

-- Fungsi simpan key
local function SaveKey(key)
    if writefile then
        local data = HttpService:JSONEncode({Key=key, HWID=HWID})
        writefile(keyFile, data)
    end
end

-- GUI utama
local function OpenMainGUI()
    local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 220, 0, 400)
    frame.Position = UDim2.new(0, 20, 0.5, -200)
    frame.BackgroundColor3 = Color3.fromRGB(25,25,25)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1,0,0,40)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.Text = "🔥 SuttannHub"

    -- Toggle system
    local y = 50
    local function AddToggle(name, callback)
        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(1,-20,0,30)
        btn.Position = UDim2.new(0,10,0,y)
        btn.Text = "[OFF] "..name
        btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 16

        local state = false
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.Text = (state and "[ON] " or "[OFF] ")..name
            pcall(callback,state)
        end)
        y = y + 35
    end

    -- ✅ Semua fitur toggle
    AddToggle("FPS Boost", function(state)
        if state then
            for _,v in pairs(workspace:GetDescendants()) do
                if v:IsA("Decal") or v:IsA("Texture") then v:Destroy()
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Fire") or v:IsA("Smoke") then v.Enabled=false
                elseif v:IsA("SpotLight") or v:IsA("SurfaceLight") or v:IsA("PointLight") then v.Enabled=false end
            end
            game.Lighting.GlobalShadows = false
            game.Lighting.FogEnd = 9e9
        else
            game.Lighting.GlobalShadows = true
        end
    end)

    AddToggle("Mod Detection", function(state)
        local modAdminOwnerList = {
            ["GroupHolderCosmic"]=true,
            ["Halax"]=true,
            ["zCxsmic"]=true,
            ["555wick"]=true,
            ["Skythrill9"]=true
        }
        if state then
            for _,plr in pairs(Players:GetPlayers()) do
                if modAdminOwnerList[plr.Name] then
                    warn("Mod/Admin detected: "..plr.Name)
                end
            end
            Players.PlayerAdded:Connect(function(plr)
                if modAdminOwnerList[plr.Name] then
                    warn("Mod/Admin join: "..plr.Name)
                end
            end)
        end
    end)

    -- Toggle eksternal
    AddToggle("Name", function(state)
        if state then pcall(function()
            loadstring(game:HttpGet('https://pastebin.com/raw/SDSsfiVN'))()
        end) end
    end)
    AddToggle("Show Guns", function(state)
        if state then pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/hellmid122/script-0x391/main/guns"))()
        end) end
    end)
    AddToggle("Health", function(state)
        if state then pcall(function()
            loadstring(game:HttpGet('https://pastebin.com/raw/mxLC8P1L'))()
        end) end
    end)
    AddToggle("Distance", function(state)
        if state then pcall(function()
            loadstring(game:HttpGet('https://pastebin.com/raw/nDnBxSyZ'))()
        end) end
    end)
    AddToggle("Skeleton", function(state)
        if state then pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/melvin123gp/shit/refs/heads/main/skeleto"))()
        end) end
    end)
    AddToggle("Cham", function(state)
        if state then pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/melvin123gp/e21/refs/heads/main/111"))()
        end) end
    end)

    -- Jalankan script utama
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Mereeeecuf/Scriptbro/refs/heads/main/SuttannHubV3"))()
    end)
end

-- Auto login / input key
local savedKey = nil
if isfile and readfile and isfile(keyFile) then
    local ok, data = pcall(function() return HttpService:JSONDecode(readfile(keyFile)) end)
    if ok and data and data.Key and data.HWID == HWID then
        savedKey = data.Key
    end
end

if savedKey then
    local valid,msg = CheckKey(savedKey)
    if valid then
        OpenMainGUI()
    else
        warn("Key Error: "..msg)
    end
else
    -- GUI input key
    local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 400, 0, 200)
    frame.Position = UDim2.new(0.5, -200, 0.5, -100)
    frame.BackgroundColor3 = Color3.fromRGB(20,20,20)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1,0,0,50)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.Text = "🔑 SuttannHub Loader"

    local KeyBox = Instance.new("TextBox", frame)
    KeyBox.Size = UDim2.new(1,-20,0,40)
    KeyBox.Position = UDim2.new(0,10,0,70)
    KeyBox.PlaceholderText = "Enter your key"
    KeyBox.TextColor3 = Color3.fromRGB(255,255,255)
    KeyBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
    KeyBox.Font = Enum.Font.Gotham
    KeyBox.TextSize = 18

    local Submit = Instance.new("TextButton", frame)
    Submit.Size = UDim2.new(0.5,-15,0,40)
    Submit.Position = UDim2.new(0,10,1,-50)
    Submit.Text = "Submit"
    Submit.BackgroundColor3 = Color3.fromRGB(0,120,255)
    Submit.TextColor3 = Color3.fromRGB(255,255,255)
    Submit.Font = Enum.Font.GothamBold
    Submit.TextSize = 18

    Submit.MouseButton1Click:Connect(function()
        local key = KeyBox.Text
        local valid,msg = CheckKey(key)
        if valid then
            SaveKey(key)
            screenGui:Destroy()
            OpenMainGUI()
        else
            warn("Key Error: "..msg)
        end
    end)
end
