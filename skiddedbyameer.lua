if not LPH_OBFUSCATED then
    LPH_JIT_MAX = function(...) return(...) end;
    LPH_NO_VIRTUALIZE = function(...) return(...) end;
end

--//Pet Simulator X
repeat task.wait() until game:IsLoaded()
if game.PlaceId == 6284583030 or 10321372166 or 7722306047 then
repeat task.wait() until require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library")).Loaded


local StartTick = tick()

--// Anti Afk
local VirtualUser=game:service'VirtualUser'
game:service'Players'.LocalPlayer.Idled:connect(function()
VirtualUser:CaptureController()
VirtualUser:ClickButton2(Vector2.new())
end)

--// Variables
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local PathfindingService = game:GetService("PathfindingService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Player = Players.LocalPlayer

if not isfolder("MilkUp") then
    makefolder("MilkUp")
end
if not isfolder("MilkUp/PetSimulatorX") then
    makefolder("MilkUp/PetSimulatorX")
end
if not isfile("MilkUp/PetSimulatorX/GlobalSettings.json") then
    writefile("MilkUp/PetSimulatorX/GlobalSettings.json", HttpService:JSONEncode({["LoadConfig"] = false, ["SeparateConfig"] = false}))
end

local Library = require(ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
local Scripts = Player.PlayerScripts.Scripts
local Api = "https://games.roblox.com/v1/games/"
local HTTPRequest =  http_request or request or HttpPost or syn.request
local UserIDToUsername = Library.Functions.UserIdToUsername
local IsHardcoreMode = (game.PlaceId == 10321372166 and true) or false
local Premium = (LRM_IsUserPremium and true) or (not LPH_OBFUSCATED and true) or false
local DiscordID = (not LPH_OBFUSCATED and "Flury") or (LRM_LinkedDiscordID and LRM_LinkedDiscordID)  or "Someone"
local RemotesLoaded = false
local ScriptVersion = 2.4

--// PSX Remotes
local Remotes = {
    ["Get Coins"] = {"Invoke", nil},
    ["Join Coin"] = {"Invoke", nil},
    ["Leave Coin"] = {"Invoke", nil},
    ["Farm Coin"] = {"Fire", nil},
    ["Claim Orbs"] = {"Invoke", nil},
    ["Collect Lootbag"] = {"Fire", nil},
    ["Buy Egg"] = {"Invoke", nil},
    ["Use Golden Machine"] = {"Invoke", nil},
    ["Use Rainbow Machine"] = {"Invoke", nil},
    ["Convert To Dark Matter"] = {"Invoke", nil},
    ["Redeem Dark Matter Pet"] = {"Invoke", nil},
    ["Fuse Pets"] = {"Invoke", nil},
    ["Delete Several Pets"] = {"Invoke", nil},
    ["Request World"] = {"Invoke", nil},
    ["Claim Trading Booth"] = {"Invoke", nil},
    ["Purchase Trading Booth Pet"] = {"Invoke", nil},
    ["Add Trading Booth Pet"] = {"Invoke", nil},
    ["Get Booth By Id"] = {"Invoke", nil},
    ["Get All Booths"] = {"Invoke", nil},
    ["Redeem Rank Rewards"] = {"Invoke", nil},
    ["Redeem VIP Rewards"] = {"Invoke", nil},
    ["Redeem Free Gift"] = {"Invoke", nil},
    ["Activate Boost"] = {"Fire", nil},
    ["Activate Server Boost"] = {"Fire", nil},
    ["Travel To Main World"] = {"Invoke", nil},
    ["Travel To Trading Plaza"] = {"Invoke", nil},
    ["Travel To Hardcore World"] = {"Invoke", nil},
    ["Buy Area"] = {"Invoke", nil},
    ["Request Cannon Launch"] = {"Invoke", nil},
    ["Start Hacker Portal Quests"] = {"Fire", nil},
    ["Finish Hacker Portal Quest"] = {"Invoke", nil}
}

local function UseRemote(RemoteName, ...)
    if RemoteName[2] ~= nil and RemotesLoaded then
        local RemoteNetwork = Library.Network[RemoteName[1]]
        return RemoteNetwork(RemoteName[2], ...)
    end
end

local function AdvancedSignal(Content, ColorToInput)
    return Library.Signal.Fire("Notification", Content, {color = ColorToInput})
end

local function NewFunction(...)
    return ...
end

local function GetAllRemotes()
    task.spawn(function()
        task.wait(10)
        LPH_NO_VIRTUALIZE(function()
            local RemoteTime = tick()
            InvokeHook = hookfunction(getupvalue(Library.Network.Invoke, 1), function(...) return true end)
            FireHook = hookfunction(getupvalue(Library.Network.Fire, 1), function(...) return true end)
            for i,v in pairs(getgc()) do
                if type(v) == "function" and islclosure(v) then
                    --// Join Coin
                    if debug.getinfo(v).name == "SelectCoin" then
                        if #debug.getconstants(v) > 15 then
                            Remotes["Join Coin"][2] = debug.getconstant(v, 36)
                            Remotes["Leave Coin"][2] = debug.getconstant(v, 51)
                        end
                    end 
                    --// Farm Coin
                    if debug.getinfo(v).name == "SelectCoin" then
                        if #debug.getconstants(v) > 15 then
                            Remotes["Farm Coin"][2] = debug.getconstant(debug.getproto(v, 5), 6)
                        end
                    end
                end
            end
            
            --// Get Coins
            Remotes["Get Coins"][2] = debug.getconstant(getsenv(Scripts.Game.Coins).InvokeCoins, 3)

            --// Collect LootBag
            Remotes["Collect Lootbag"][2] = debug.getconstant(getsenv(Scripts.Game.Lootbags).Collect, 32)

            --// Buy Egg
            Remotes["Buy Egg"][2] = debug.getconstant(debug.getproto(getsenv(Scripts.Game.Eggs).SetupEgg, 5), 26)

            --/ Use Golden Machine
            Remotes["Use Golden Machine"][2] = debug.getconstant(getsenv(Scripts.GUIs["Golden Machine"]).Convert, 15)

            --// Use Rainbow Machine
            Remotes["Use Rainbow Machine"][2] = debug.getconstant(getsenv(Scripts.GUIs["Rainbow Machine"]).Convert, 15)

            --// Convert To Dark Matter
            Remotes["Convert To Dark Matter"][2] = debug.getconstant(getsenv(Scripts.GUIs["Dark Matter Machine"]).PetsConvert, 3)

            --// Redeem Dark Matter Pet
            Remotes["Redeem Dark Matter Pet"][2] = debug.getconstant(getsenv(Scripts.GUIs["Dark Matter Machine"]).RedeemQueuePet, 3)

            --// Fuse Pets
            Remotes["Fuse Pets"][2] = debug.getconstant(getsenv(Scripts.GUIs["Fuse Pets"]).Fuse, 7)

            --// Delete Several Pets
            Remotes["Delete Several Pets"][2] = debug.getconstant(debug.getproto(getsenv(Scripts.GUIs.Inventory).DeletePets, 1), 22)

            --// Request World
            Remotes["Request World"][2] = debug.getconstant(Library.WorldCmds.Load, 16)

            --// Claim Trading Booth
            Remotes["Claim Trading Booth"][2] = debug.getconstant(getsenv(Scripts.Game["Trading Booths"]).ClaimBooth, 3)

            --// Purchase Trading Booth Pet
            Remotes["Purchase Trading Booth Pet"][2] = debug.getconstant(getsenv(Scripts.Game["Trading Booths"]).AttemptBuy, 32)

            --// Add Trading Booth Pet
            Remotes["Add Trading Booth Pet"][2] = debug.getconstant(getsenv(Scripts.GUIs["List Pet"]).List, 8)

            --// Get Booth By Id
            Remotes["Get Booth By Id"][2] = debug.getconstant(getsenv(Scripts.GUIs["Booth Inventory"]).Update, 7)

            --// Get All Booths
            Remotes["Get All Booths"][2] = debug.getconstant(getsenv(Scripts.Game["Trading Booths"]).Setup, 3)

            --// Redeem Rank Rewards
            Remotes["Redeem Rank Rewards"][2] = debug.getconstant(getsenv(Scripts.Game["Reedem Rank Rewards"]).Redeem, 3)

            --// Redeem VIP Rewards
            Remotes["Redeem VIP Rewards"][2] = debug.getconstant(getsenv(Scripts.Game["Reedem VIP Rewards"]).Redeem, 3)

            --// Redeem Free Gift
            Remotes["Redeem Free Gift"][2] = debug.getconstant(getsenv(Scripts.GUIs["Free Gifts"]).Redeem, 3)

            --// Activate Boost
            Remotes["Activate Boost"][2] = debug.getconstant(debug.getproto(debug.getproto(getsenv(Scripts.GUIs["Exclusive Shop"]).UpdateBoosts, 2), 2), 3)

            --// Activate Server Boost
            Remotes["Activate Server Boost"][2] = debug.getconstant(debug.getproto(debug.getproto(getsenv(Scripts.GUIs["Server Boosts"]).Update, 3), 1), 3)

            --// World Remotes
            Remotes["Travel To Main World"][2] = debug.getconstant(getsenv(Scripts.Game.Misc["Leave Trading Plaza"]).Request, 5)
            Remotes["Travel To Hardcore World"][2] = debug.getconstant(getsenv(Scripts.Game.Misc["Hardcore Mode Teleports"]).Request, 15)
            Remotes["Travel To Trading Plaza"][2] = debug.getconstant(getsenv(Scripts.Game.Misc["Join Trading Plaza"]).Request, 7)

            --// Buy Gate
            Remotes["Buy Area"][2] = debug.getconstant(getsenv(Scripts.Game.Gates).BuyGate, 20)

            --// Request Cannon Launch
            Remotes["Request Cannon Launch"][2] = debug.getconstant(getsenv(Scripts.Game.Cannons).ClientAttemptFire, 14)

            --// Start Hacker Portal Quest
            Remotes["Start Hacker Portal Quests"][2] = debug.getconstant(getsenv(Scripts.Game["Hacker Portal Quests"]).PromptQuest, 12)

            --// Finish Hacker Portal Quest
            Remotes["Finish Hacker Portal Quest"][2] = debug.getconstant(getsenv(Scripts.Game["Hacker Portal Quests"]).PromptQuest, 19)
            RemotesLoaded = true
            AdvancedSignal("Remotes Loaded Took: "..tick() - RemoteTime, Color3.fromRGB(115, 80, 255))
        end)()
    end)
end

GetAllRemotes()

LPH_NO_VIRTUALIZE(function()
    local Audio = require(game:GetService("ReplicatedStorage").Library.Audio)
    local AudoHook
    local FakeSound = Instance.new("Sound", game.Workspace)
    FakeSound.Name = "Fake"
    AudoHook = hookfunction(Audio.Play, function(...)
        return FakeSound
    end)
end)()

--// Tables
getgenv().Config = {
    ConfigVersion = ScriptVersion,
    SelectedConfig = "None",
    Valentines = {
        StartHeartFarm = false,
        StartWorldTeleport = false,
        StartServerTeleport = false,
        StartInstantWorldTeleport = false,
        Worlds = {
            Spawn = false,
            Fantasy = false,
            Tech = false,
            Axolotl = false,
            Pixel = false,
            Cat = false
        }
    },
    Farming = {
        StartFarm = false,
        Mode = "Normal",
        CoinType = "Normal",
        FarmSpeed = 0.09,
        PetSendSpeed = 0,
        SendAllPets = false,
        CollectOrbs = false,
        CollectLootbags = false,
        TeleportToCoinsArea = false,
        StayOnPrivatePlatform = false,
        StartCompleteGame = false,
        Areas = {},
        Blacklisted = {}
    },
    Pets = {
        StartHatch = false,
        StartOpenInventory = false,
        DisableEggAnimation = false,
        DisableNotifications = false,
        TeleportToEgg = false,
        Mode = "Single",
        ChoosenEgg = "None"
    },
    Machines = {
        Golden = {
            StartGolden = false,
            GoldenAmount = 6,
            GoldenHC = false,
            GoldenHCAmount = 10,
            GoldenShiny = false,
        },
        Rainbow = {
            StartRainbow = false,
            RainbowAmount = 6,
            RainbowHC = false,
            RainbowHCAmount = 10,
            RainbowShiny = false,
        },
        DarkMatter = {
            StartDarkMatter = false,
            ClaimPets = false,
            DarkMatterAmount = 6,
            DarkMatterHC = false,
            DarkMatterHCAmount = 8,
            DarkMatterShiny = false,
        },
        Fusing = {
            StartFuse = false,
            Amount = 3,
            Mode = "Normal",
            WhenToStop = 0
        }
    },
    Booths = {
        Selling = {
            StartSellingPet = false,
            ChoosenPetToSell = "None",
            ChoosenPetPrice = "None",
            SellingList = {},
            Options = {},
            EditMode = false,
            EditNumber = "None"
        },
        Sniping = {
            StartSnipingPet = false,
            SnipePetRarity = false,
            SnipePetUnder = false,
            GemsUnderToSnipe = "None",
            ChoosenPetToSnipe = "None",
            SnipingList = {},
            Options = {},
            Rarities = {},
            EditMode = false,
            EditNumber = "None"
        },
        Extra = {
            TeleportToBooth = false,
            GoInvisible = false,
            WalkToBooth = false,
            BoothServerHop = false,
            BoothServerHopVoice = false,
            BoothServerHopSeconds = 1
        }
    },
    Deleting = {
        StartDelete = false,
        DeleteByRarity = false,
        ChoosenPetToDelete = "None",
        Options = {},
        Rarities = {}
    },
    Misc = {
        Redeeming = {
            RedeemRankRewards = false,
            RedeemVIPRewards = false,
            RedeemFreeGifts = false
        },
        Teleports = {
            LoadNormalExperience = false,
            LoadHardcoreExperience = false,
            LoadTradingExperience = false,
            LoadTradingVoiceExperience = false,
        },
        Hoverboards = {
            CurrentHoverboard = "Cat",
            HoverboardSpeed = 75,
        },
        Boosting = {
            UseBoosts = false,
            UseAllBoosts = false,
            BoostsToActivate = {},
            UseServerBoost = false,
            ServerBoostsToActivate = {}
        },
        Extra = {
            StatsTracker = false,
            ReduceLag = false,
            LockFps = false,
            ChangeFpsTo = 60
        }
    },
    PetCollection = {
        StartCollecting = false,
        Mode = "Single",
        Options = {},
        Rarities = {}
    },
    Mastery = {
        StartCompletingMasterys = false,
        MasterysToFarm = {},
    },
    Guis = {
        GuiMachines = {
            GoldenMachine = "T",
            RainbowMachine = "Y",
            DarkMatterMachine = "G",
            FuseMachine = "J",
            EnchantMachine = "H",
            BankMachine = "B",
            ServerBoostMachine = "V"
        }
    },
    Webhooks = {
        HatchWebhook = {
            StartWebhook = false,
            ChoosenWebhook = "None",
            PingUser = false,
            ChoosenUserID = "None",
            ShowChances = false,
            ShowEggsHatched = false,
            ShowEggsRemaining = false,
            ShowCurrencyRemaining = false,
            ShowStrength = false,
            ShowEnchants = false,
            Rarities = {}
        },
        SnipeWebhook = {
            StartWebhook = false,
            ChoosenWebhook = "None",
            PingUser = false,
            ChoosenUserID = "None",
            ShowGemsSnipedFor = false,
            ShowGemsRemaining = false,
            ShowOwner = false,
            ShowStrength = false,
            ShowEnchants = false
        },
        SellWebhook = {
            StartWebhook = false,
            ChoosenWebhook = "None",
            PingUser = false,
            ChoosenUserID = "None",
            ShowSoldFor = false,
            ShowTotalGems = false,
            ShowPurchasedBy = false,
        }
    }
}

local IsLoadConfig = (HttpService:JSONDecode(readfile("MilkUp/PetSimulatorX/GlobalSettings.json"))["LoadConfig"] == true and true) or false
local IsSeparateConfig = (HttpService:JSONDecode(readfile("MilkUp/PetSimulatorX/GlobalSettings.json"))["SeparateConfig"] == true and true) or false
if not isfile("MilkUp/PetSimulatorX/DefaultConfig.json") then
    writefile("MilkUp/PetSimulatorX/DefaultConfig.json", HttpService:JSONEncode(Config))
end
if IsSeparateConfig and not isfile("MilkUp/PetSimulatorX/"..Player.Name..".json") then
    writefile("MilkUp/PetSimulatorX/"..Player.Name..".json", HttpService:JSONEncode(Config))
end
local ConfigName = (IsSeparateConfig and "MilkUp/PetSimulatorX/"..Player.Name..".json") or "MilkUp/PetSimulatorX/DefaultConfig.json"

--// Config
local function DeleteConfig()
    if isfile(ConfigName) then
        delfile(ConfigName)
        AdvancedSignal("Deleted Config!", Color3.fromRGB(255, 0, 0))
    end
end

local function SaveConfig()
    writefile(ConfigName, HttpService:JSONEncode(Config))
end

local function UpdateConfg()
    for i,v in pairs(HttpService:JSONDecode(readfile(ConfigName))) do
        if type(v) == "table" then
            for i2,v2 in pairs(v) do
                if type(v2) == "boolean" then
                    Config[i][i2] = v2
                end
                if type(v2) == "string" then
                    Config[i][i2] = v2
                end
                if type(v2) == "table" then
                    for i3,v3 in pairs(v2) do
                        if type(v3) ~= "table" then
                            Config[i][i2] = v2
                        end
                        if type(v3) == "boolean" then
                            Config[i][i2][i3] = v3
                        end
                        if type(v2) == "string" then
                            Config[i][i2][i3] = v3
                        end
                        if type(v3) == "table" then
                            Config[i][i2][i3] = v3
                        end
                    end
                end
            end
        end
    end
    writefile(ConfigName, HttpService:JSONEncode(Config))
    AdvancedSignal("Updated Config To Latest Version!", Color3.fromRGB(52, 235, 171))
    -- AdvancedSignal("Config Error! Erased Config, Sorry!", Color3.fromRGB(224, 67, 67))
end

local function LoadConfig()
    if isfile(ConfigName) and IsLoadConfig then
        if HttpService:JSONDecode(readfile(ConfigName))["ConfigVersion"] ~= ScriptVersion then
            UpdateConfg()
        else
            Config = HttpService:JSONDecode(readfile(ConfigName))
        end
        ConfigLoaded = true
        return AdvancedSignal("Loaded Config!", Color3.fromRGB(88, 247, 255))
    end
end

local ConfigSuccess, ConfigError = pcall(function() LoadConfig() end)
if not ConfigSuccess then
    warn("(Error-MilkUp) "..ConfigError)
    AdvancedSignal("Config Error! Please Make A Ticket At .gg/milkup", Color3.fromRGB(224, 67, 67))
end

--// Tables
local RaritiesList = {"Basic", "Rare", "Epic", "Legendary", "Mythical", "", "Event",  "Exclusive"}
local RaritiesWithoutExclusiveList = {"Basic", "Rare", "Epic", "Legendary", "Mythical"}
local TypeList = {"Regular", "Hardcore", "Shiny", "Golden", "Rainbow", "Dark Matter", "Any"}
local TypesForCollectionList = {"Regular", "Golden", "Rainbow", "Dark Matter", "Any"}
local MasteryList = {"Coin Piles", "Crates", "Diamond Piles", "Chests", "Presents", "VaultsAndSafes", "Eggs", "Golden Eggs"}

local LayoutOrdersList = {
    ["Diamonds"] = 999910,
    ["Halloween Candy"] = 999920,
    ["Gingerbread"] = 999930,
    ["Rainbow Coins"] = 999940,
    ["Tech Coins"] = 999950,
    ["Fantasy Coins"] = 999960,
    ["Coins"] = 999970,
}

local AreaList = {}
for i,v in pairs(ReplicatedStorage["__DIRECTORY"].Areas:GetChildren()) do
    if not AreaList[v.Name:split("| ")[2]] then
        AreaList[v.Name:split("| ")[2]] = {}
    end
    for i2,v2 in pairs(require(v)) do
        table.insert(AreaList[v.Name:split("| ")[2]], i2)
    end
end

local HoverboardList = {}
for i,v in pairs(Library.Directory.Hoverboards) do
    table.insert(HoverboardList, i)
end

local CoinTypeList = {}
for i,v in pairs(Library.Directory.Worlds) do
    if v.Disabled ~= true then
        if not CoinTypeList[i] then
            CoinTypeList[i] = {}
        end
        for i2,v2 in pairs(v.spawns) do
            for i3,v3 in pairs(v2.coins) do
                table.insert(CoinTypeList[i], v3[1])
            end
        end
    end
end

local EggList = {}
for i,v in pairs(ReplicatedStorage["__DIRECTORY"].Eggs:GetDescendants()) do
    if v:IsA("ModuleScript") and v.Name ~= "Grab All Eggs" then
        local EggModule = require(v)
        if EggModule.hatchable then
            table.insert(EggList, v.Name)
        end
    end
end
table.sort(EggList, function(a,b)
    return a < b
end)

local PetList = {}
for i,v in pairs(ReplicatedStorage["__DIRECTORY"].Pets:GetChildren()) do
    if not v:IsA("ModuleScript") then
        for i2,v2 in pairs(v:GetChildren()) do
            if v2:IsA("ModuleScript") then
                if not PetList[require(v2).rarity] then
                    PetList[require(v2).rarity] = {}
                end
                table.insert(PetList[require(v2).rarity], v.Name)
            end
        end
    end
end
for i,v in pairs(PetList) do
    table.sort(v, function(a,b)
        return a:split("- ")[2] < b:split("- ")[2]
    end)
end

local CompleteTable = {
	"Town",--// World
	"Forest",
	"Beach",
	"Mine",
	"Winter",
	"Glacier",
	"Desert",
	"Volcano",
    'Cave',
	"Enchanted Forest",--// World
	"Ancient Island",
	"Samurai Island",
	"Candy Island",
	"Haunted Island",
	"Hell Island",
	"Heaven Island",
	"Heavens Gate",
	"Ice Tech",
	"Tech City", --//World
	"Dark Tech",
	"Steampunk",
	"Alien Lab",
	"Alien Forest",
	"Glitch",
	"Hacker Portal",
	"The Void",--// World
	"Axolotl Ocean",--// World
	"Axolotl Deep Ocean",
	"Axolotl Cave",
	"Pixel Forest", --// World
	"Pixel Kyoto",
	"Pixel Alps",
	"Pixel Vault",
	"Cat Paradise",--// World
	"Cat Backyard",
	"Cat Taiga",
	"Cat Kingdom"
}

local BlacklistedDiscords = {"1026701036678807643"}
--// Functions
--// Misc Functions
local function LowServerTeleport(GameHop, GameID)
    local LowPlayerServerId
    if GameHop then
        LowPlayerServerId = GameID
    else
        LowPlayerServerId = game.PlaceId
    end
    local PlaceID = LowPlayerServerId
    local AllIDs = {}
    local foundAnything = ""
    local actualHour = os.date("!*t").hour
    local Deleted = false
    local File = pcall(function()
        AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
    end)
    if not File then
        table.insert(AllIDs, actualHour)
        writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
    end
    function TPReturner()
        local Site;
        if foundAnything == "" then
            Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
        else
            Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
        end
        local ID = ""
        if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
            foundAnything = Site.nextPageCursor
        end
        local num = 0;
        for i,v in pairs(Site.data) do
            local Possible = true
            ID = tostring(v.id)
            if tonumber(v.maxPlayers) > tonumber(v.playing) then
                for _,Existing in pairs(AllIDs) do
                    if num ~= 0 then
                        if ID == tostring(Existing) then
                            Possible = false
                        end
                    else
                        if tonumber(actualHour) ~= tonumber(Existing) then
                            local delFile = pcall(function()
                                delfile("NotSameServers.json")
                                AllIDs = {}
                                table.insert(AllIDs, actualHour)
                            end)
                        end
                    end
                    num = num + 1
                end
                if Possible == true then
                    table.insert(AllIDs, ID)
                    wait()
                    pcall(function()
                        writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                        wait()
                        game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                    end)
                    wait(4)
                end
            end
        end
    end
    
    function Teleport()
        while wait() do
            pcall(function()
                TPReturner()
                if foundAnything ~= "" then
                    TPReturner()
                end
            end)
        end
    end
    Teleport()
end

function ServerTeleport(Place)
    local function FindServer(PlaceID)
        local servers = {}
        local req = HTTPRequest({Url = "https://games.roblox.com/v1/games/".. PlaceID.."/servers/Public?sortOrder=Desc&limit=100"})
        local body = HttpService:JSONDecode(req.Body)
        if body and body.data then
            for i, v in next, body.data do
                if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and (PlaceID == 7722306047 and v.playing > 20) or (PlaceID == 11725212117 and v.playing > 20) or v.playing > 7 and v.id ~= game.JobId then
                    table.insert(servers, {v.playing, v.id})
                end
            end
        end
        game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, servers[math.random(1, #servers)][2], Players.LocalPlayer)
    end
    if Place == "Main World" then
        while task.wait(1) do FindServer(6284583030) end
    elseif Place == "Hardcore World" then
        while task.wait(1) do FindServer(10321372166) end
    elseif Place == "Trading Plaza" then
        while task.wait(1) do FindServer(7722306047) end
    elseif Place == "Trading Plaza Voice Chat" then
        while task.wait(1) do FindServer(11725212117) end
    end
end

local function GetHumanoidRootPart()
    return Player.Character.HumanoidRootPart
end

local function FindPath(Destination)
    local Humanoid = Player.Character.Humanoid
    local CreatedPath = PathfindingService:CreatePath()
    CreatedPath:ComputeAsync(GetHumanoidRootPart().Position, Destination.Position)
    if CreatedPath.Status == Enum.PathStatus.Success then
        for i,v in pairs(CreatedPath:GetWaypoints()) do
            Humanoid:MoveTo(v.Position + Vector3.new(0,0,5))
            local MoveSuccess = Humanoid.MoveToFinished:Wait()
            if v.Action == Enum.PathWaypointAction.Jump then
                Humanoid.WalkSpeed = 0
                task.wait(0.2)
                Humanoid.WalkSpeed = 16
                Humanoid.Jump = true
            end
            if not MoveSuccess then
                Humanoid.Jump = true
                Humanoid:MoveTo(v.Position)
                if not Humanoid.MoveToFinished:Wait() then
                    break
                end
            end
        end
        return
    end
end

local function CalculateItemsInTable(Table, AmountOfLoops)
    local AmountToReturn = 0
    if AmountOfLoops == 1 then
        for i,v in pairs(Table) do
            AmountToReturn = AmountToReturn + 1
        end
    elseif AmountOfLoops == 2 then
        for i,v in pairs(Table) do
            for i2,v2 in pairs(v) do
                AmountToReturn = AmountToReturn + 1
            end
        end
    end
    return AmountToReturn
end

local function DateTime()
    local OSTime = os.time()
    local Time = os.date('!*t', OSTime)
    return string.format('%d-%d-%dT%02d:%02d:%02dZ', Time.year, Time.month, Time.day, Time.hour, Time.min, Time.sec)
end

local function CheckTypeOrRarity(Type, TypeTable, CheckTable)
    local Settings = TypeTable
    local Pet = CheckTable
    if Type == "Type" then
        if (Settings["Regular"] and (not Pet.hc and not Pet.sh and not Pet.g and not Pet.r and not Pet.dm)) then
            return true
        end
        if (Settings["Golden"] and (not Pet.hc and not Pet.sh and Pet.g)) then
            return true
        end
        if (Settings["Rainbow"] and (not Pet.hc and not Pet.sh and Pet.r)) then
            return true
        end
        if (Settings["Dark Matter"] and (not Pet.hc and not Pet.sh and Pet.dm)) then
            return true
        end
        if ((Settings["Hardcore"] and Settings["Regular"]) and (Pet.hc and not Pet.sh and not Pet.g and not Pet.r and not Pet.dm)) then
            return true
        end
        if ((Settings["Hardcore"] and Settings["Golden"]) and (Pet.hc and not Pet.sh and Pet.g)) then
            return true
        end
        if ((Settings["Hardcore"] and Settings["Rainbow"]) and (Pet.hc and not Pet.sh and Pet.r)) then
            return true
        end
        if ((Settings["Hardcore"] and Settings["Dark Matter"]) and (Pet.hc and not Pet.sh and Pet.dm)) then
            return true
        end
        if ((Settings["Shiny"] and Settings["Regular"]) and (not Pet.hc and Pet.sh and not Pet.g and not Pet.r and not Pet.dm)) then
            return true
        end
        if ((Settings["Shiny"] and Settings["Golden"]) and (not Pet.hc and Pet.sh and Pet.g)) then
            return true
        end
        if ((Settings["Shiny"] and Settings["Rainbow"]) and (not Pet.hc and Pet.sh and Pet.r)) then
            return true
        end
        if ((Settings["Shiny"] and Settings["Dark Matter"]) and (not Pet.hc and Pet.sh and Pet.dm)) then
            return true
        end
        if ((Settings["Shiny"] and Settings["Hardcore"] and Settings["Regular"]) and (Pet.hc and Pet.sh and not Pet.g and not Pet.r and not Pet.dm)) then
            return true
        end
        if ((Settings["Shiny"] and Settings["Hardcore"] and Settings["Golden"]) and (Pet.hc and Pet.sh and Pet.g)) then
            return true
        end
        if ((Settings["Shiny"] and Settings["Hardcore"] and Settings["Rainbow"]) and (Pet.hc and Pet.sh and Pet.r)) then
            return true
        end
        if ((Settings["Shiny"] and Settings["Hardcore"] and Settings["Dark Matter"]) and (Pet.hc and Pet.sh and Pet.dm)) then
            return true
        end
        if Settings["Any"] then
            return true
        end
    elseif Type == "Rarity" then
        if (Settings.Rarities["Basic"] and Library.Directory.Pets[Pet.id].rarity == "Basic") or (Settings.Rarities["Rare"] and Library.Directory.Pets[Pet.id].rarity == "Rare") or (Settings.Rarities["Epic"] and Library.Directory.Pets[Pet.id].rarity == "Epic") or (Settings.Rarities["Legendary"] and Library.Directory.Pets[Pet.id].rarity == "Legendary") or (Settings.Rarities["Mythical"] and Library.Directory.Pets[Pet.id].rarity == "Mythical") or (Settings.Rarities[""] and Library.Directory.Pets[Pet.id].rarity == "") or (Settings.Rarities["Event"] and Library.Directory.Pets[Pet.id].rarity == "Event") or(Settings.Rarities["Exclusive"] and Library.Directory.Pets[Pet.id].rarity == "Exclusive") or (Settings.Rarities["Huge"] and Library.Directory.Pets[Pet.id].huge) or (Settings.Rarities["Titanic"] and Library.Directory.Pets[Pet.id].titanic) then
            return true
        end
    end
    return false
end

local function HasPetEquipped(Uid)
    local PetsPath = IsHardcoreMode and Library.Save.Get().HardcorePetsEquipped or Library.Save.Get().PetsEquipped
    if PetsPath[Uid] then
        return true
    end
end

--// Webhooks
local function CheckForPet(UID)
    for i,v in pairs(Library.Save.Get().Pets) do
        if v.uid == UID then
            return true
        end
    end
    return false
end

local function SendHatchWebhook(PetTable, PetEgg)
    LPH_JIT_MAX(function()
        local DescriptionTable = {}
        local PetID = PetTable.id
        local PetName = Library.Directory.Pets[PetID].name
        local PetType = (PetTable.r and "RAINBOW") or (PetTable.g and "GOLDEN") or (PetTable.dm and "DARK MATTER") or "NORMAL"
        local PetImage = Library.Directory.Pets[PetID][(PetTable.r and "thumbnail") or (PetTable.g and "goldenThumbnail") or (PetTable.dm and "darkMatterThumbnail") or "thumbnail"]:split("//")[2]
        local EmbedColor = (Library.Directory.Pets[PetID].rarity == "" and 0x0d3b60) or 0x7b4fdb
        local PingCheck = (Config.Webhooks.HatchWebhook.PingUser and "||<@"..Config.Webhooks.HatchWebhook.ChoosenUserID..">||") or ""
        local ChangedEgg = PetEgg
        local CurrencyPath = (IsHardcoreMode and Library.Save.Get().HardcoreCurrency) or Library.Save.Get()
        if string.find(ChangedEgg, "Golden") then
            ChangedEgg = string.gsub(PetEgg, "Golden ", "")
        end
        if Config.Webhooks.HatchWebhook.ShowChances then
            for i2,v2 in pairs(Library.Directory.Eggs[ChangedEgg].drops) do
                if v2[1] == PetID then
                    table.insert(DescriptionTable, ":four_leaf_clover: Chance: "..Library.Functions.FormatOdds(v2[2]))
                end
            end
        end
        if Config.Webhooks.HatchWebhook.ShowEggsHatched then
            for i2,v2 in pairs(Library.Save.Get().EggsOpened) do
                if i2 == ChangedEgg then
                    table.insert(DescriptionTable, ":egg: Eggs Hatched: "..Library.Functions.Commas(tonumber(v2)))
                end
            end
        end
        if Config.Webhooks.HatchWebhook.ShowEggsRemaining then
            for i2,v2 in pairs(Library.Directory.Eggs) do
                if i2 == ChangedEgg then
                    for i3,v3 in pairs(CurrencyPath) do
                        if i3 == v2.currency then
                            table.insert(DescriptionTable, ":sparkles: Eggs Remaining: "..Library.Functions.Commas(math.floor(v3 / v2.cost) % 1000000000))
                        end
                    end
                end
            end
        end
        if Config.Webhooks.HatchWebhook.ShowStrength then
            table.insert(DescriptionTable, ":boom: Strength: "..Library.Functions.NumberShorten(PetTable.s))
        end
        if Config.Webhooks.HatchWebhook.ShowCurrencyRemaining then
            local CurrencyLeft = Library.Save.Get()[Library.Directory.Eggs[ChangedEgg].currency]
            table.insert(DescriptionTable, ":money_with_wings: Currency Remaining: "..Library.Functions.NumberShorten(CurrencyLeft))
        end
        if Config.Webhooks.HatchWebhook.ShowEnchants then
            local Enchants = {}
            if PetTable.powers then
                if PetTable.powers[1] then
                    table.insert(Enchants, "â†³ "..PetTable.powers[1][1].." "..PetTable.powers[1][2])
                end
                if PetTable.powers[2] then
                    table.insert(Enchants, "â†³ "..PetTable.powers[2][1].." "..PetTable.powers[1][2])
                end
                if PetTable.powers[3] then
                    table.insert(Enchants, "â†³ "..PetTable.powers[3][1].." "..PetTable.powers[1][2])
                end
                table.insert(DescriptionTable, "\n:dizzy: __Enchants__")
                table.insert(DescriptionTable, table.concat(Enchants, "\n"))
            end
        end
        local Title = (IsHardcoreMode and "||"..Player.Name.."|| Hatched A Hardcore"..((Library.Directory.Pets[PetTable.id].rarity == "" and " ") or "")..((PetTable.sh and " Shiny ") or " ")..PetType.." "..PetName) or ("||"..Player.Name.."|| Hatched A"..((Library.Directory.Pets[PetTable.id].rarity == "" and " ") or "")..((PetTable.sh and " Shiny ") or " ")..PetType.." "..PetName)
        local Webhook = Config.Webhooks.HatchWebhook.ChoosenWebhook
        local msg = {
            ["username"] =  "Milk Up",
            ["avatar_url"] = "https://media.istockphoto.com/id/1256233718/vector/cute-cow-vector-icon-illustration.jpg?s=612x612&w=0&k=20&c=i_MCfgGxR-6GvXYV5yZ4jNF_7VwGKxd0TMaEEyo0Mqk=",
            ["content"] = PingCheck,
            ["embeds"] = {
                {
                    ["color"] = EmbedColor,
                    ["title"] = Title,
                    ["thumbnail"] = {["url"] = HttpService:JSONDecode(game:HttpGet(("https://thumbnails.roblox.com/v1/assets?assetIds="..PetImage.."&size=250x250&format=Png&isCircular=false"))).data[1].imageUrl},
                    ["description"] = "**"..table.concat(DescriptionTable, "\n").."**",
                    ['timestamp'] = DateTime(),
                    ["footer"] = {
                        ["text"] = "Milk Up",
                        ["icon_url"] = "https://media.istockphoto.com/id/1256233718/vector/cute-cow-vector-icon-illustration.jpg?s=612x612&w=0&k=20&c=i_MCfgGxR-6GvXYV5yZ4jNF_7VwGKxd0TMaEEyo0Mqk="
                    },
                },
            },
        }

        HTTPRequest({Url = Webhook, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(msg)})
    end)()
end

local function SendMiscHatchWebhook(PetTable, PetEgg)
    if Library.Directory.Pets[PetTable.id].rarity == "Exclusive" or Library.Directory.Pets[PetTable.id].rarity == "Event" then
        if not LPH_OBFUSCATED then
            local DescriptionTable = {}
            local PetID = PetTable.id
            local PetName = Library.Directory.Pets[PetID].name
            local PetType = (PetTable.r and "RAINBOW") or (PetTable.g and "GOLDEN") or (PetTable.dm and "DARK MATTER") or "NORMAL"
            local PetImage = Library.Directory.Pets[PetID][(PetTable.r and "thumbnail") or (PetTable.g and "goldenThumbnail") or (PetTable.dm and "darkMatterThumbnail") or "thumbnail"]:split("//")[2]
            local EmbedColor = (Library.Directory.Pets[PetID].rarity == "" and 0x0d3b60) or 0x7b4fdb
            local ChangedEgg = PetEgg
            local CurrencyPath = (IsHardcoreMode and Library.Save.Get().HardcoreCurrency) or Library.Save.Get()
            if string.find(ChangedEgg, "Golden") then
                ChangedEgg = string.gsub(PetEgg, "Golden ", "")
            end 
            for i2,v2 in pairs(Library.Directory.Eggs[ChangedEgg].drops) do
                if v2[1] == PetID then
                    table.insert(DescriptionTable, ":four_leaf_clover: Chance: "..Library.Functions.FormatOdds(v2[2]))
                end
            end 
            for i2,v2 in pairs(Library.Save.Get().EggsOpened) do
                if i2 == ChangedEgg then
                    table.insert(DescriptionTable, ":egg: Eggs Hatched: "..Library.Functions.Commas(tonumber(v2)))
                end
            end 
            for i2,v2 in pairs(Library.Directory.Eggs) do
                if i2 == ChangedEgg then
                    for i3,v3 in pairs(CurrencyPath) do
                        if i3 == v2.currency then
                            table.insert(DescriptionTable, ":sparkles: Eggs Remaining: "..Library.Functions.Commas(math.floor(v3 / v2.cost) % 1000000000))
                        end
                    end
                end
            end 
            table.insert(DescriptionTable, ":boom: Strength: "..Library.Functions.NumberShorten(PetTable.s))    
            local CurrencyLeft = Library.Save.Get()[Library.Directory.Eggs[ChangedEgg].currency]
            table.insert(DescriptionTable, ":money_with_wings: Currency Remaining: "..Library.Functions.NumberShorten(CurrencyLeft))  
            local Enchants = {}
            if PetTable.powers then
                if PetTable.powers[1] then
                    table.insert(Enchants, "â†³ "..PetTable.powers[1][1].." "..PetTable.powers[1][2])
                end
                if PetTable.powers[2] then
                    table.insert(Enchants, "â†³ "..PetTable.powers[2][1].." "..PetTable.powers[1][2])
                end
                if PetTable.powers[3] then
                    table.insert(Enchants, "â†³ "..PetTable.powers[3][1].." "..PetTable.powers[1][2])
                end
                table.insert(DescriptionTable, "\n:dizzy: __Enchants__")
                table.insert(DescriptionTable, table.concat(Enchants, "\n"))
            end
            local Title = (IsHardcoreMode and "Flury Hatched A Hardcore"..((Library.Directory.Pets[PetTable.id].rarity == "" and " ") or "")..((PetTable.sh and " Shiny ") or " ")..PetType.." "..PetName) or ("Flury Hatched A"..((Library.Directory.Pets[PetTable.id].rarity == "" and " ") or "")..((PetTable.sh and " Shiny ") or " ")..PetType.." "..PetName)
            local Webhook = "https://discord.com/api/webhooks/1063901241853354134/vJC73XGP4BDg0FW17J5UOsx-B4D2MteDJbPuIuOFr6mdQVSOoTaTtdIYbZhPJAKueMaY"
            local msg = {
                ["username"] =  "Milk Up",
                ["avatar_url"] = "https://media.istockphoto.com/id/1256233718/vector/cute-cow-vector-icon-illustration.jpg?s=612x612&w=0&k=20&c=i_MCfgGxR-6GvXYV5yZ4jNF_7VwGKxd0TMaEEyo0Mqk=",
                ["embeds"] = {
                    {
                        ["color"] = EmbedColor,
                        ["title"] = Title,
                        ["thumbnail"] = {["url"] = HttpService:JSONDecode(game:HttpGet(("https://thumbnails.roblox.com/v1/assets?assetIds="..PetImage.."&size=250x250&format=Png&isCircular=false"))).data[1].imageUrl},
                        ["description"] = "**"..table.concat(DescriptionTable, "\n").."**",
                        ['timestamp'] = DateTime(),
                        ["footer"] = {
                            ["text"] = "Milk Up",
                            ["icon_url"] = "https://media.istockphoto.com/id/1256233718/vector/cute-cow-vector-icon-illustration.jpg?s=612x612&w=0&k=20&c=i_MCfgGxR-6GvXYV5yZ4jNF_7VwGKxd0TMaEEyo0Mqk="
                        },
                    },
                },
            }   
            HTTPRequest({Url = Webhook, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(msg)})
        end
        if Library.Directory.Pets[PetTable.id].huge then
            local DescriptionTable = {}
            local PetID = PetTable.id
            local PetName = Library.Directory.Pets[PetID].name
            local PetType = (PetTable.r and "RAINBOW") or (PetTable.g and "GOLDEN") or (PetTable.dm and "DARK MATTER") or "NORMAL"
            local PetImage = Library.Directory.Pets[PetID][(PetTable.r and "thumbnail") or (PetTable.g and "goldenThumbnail") or (PetTable.dm and "darkMatterThumbnail") or "thumbnail"]:split("//")[2]
            local EmbedColor = (Library.Directory.Pets[PetID].rarity == "" and 0x0d3b60) or 0x7b4fdb
            local ChangedEgg = PetEgg
            local CurrencyPath = (IsHardcoreMode and Library.Save.Get().HardcoreCurrency) or Library.Save.Get()
            if string.find(ChangedEgg, "Golden") then
                ChangedEgg = string.gsub(PetEgg, "Golden ", "")
            end 
            for i2,v2 in pairs(Library.Directory.Eggs[ChangedEgg].drops) do
                if v2[1] == PetID then
                    table.insert(DescriptionTable, ":four_leaf_clover: Chance: "..Library.Functions.FormatOdds(v2[2]))
                end
            end 
            for i2,v2 in pairs(Library.Save.Get().EggsOpened) do
                if i2 == ChangedEgg then
                    table.insert(DescriptionTable, ":egg: Eggs Hatched: "..Library.Functions.Commas(tonumber(v2)))
                end
            end 
            for i2,v2 in pairs(Library.Directory.Eggs) do
                if i2 == ChangedEgg then
                    for i3,v3 in pairs(CurrencyPath) do
                        if i3 == v2.currency then
                            table.insert(DescriptionTable, ":sparkles: Eggs Remaining: "..Library.Functions.Commas(math.floor(v3 / v2.cost) % 1000000000))
                        end
                    end
                end
            end 
            table.insert(DescriptionTable, ":boom: Strength: "..Library.Functions.NumberShorten(PetTable.s))    
            local CurrencyLeft = Library.Save.Get()[Library.Directory.Eggs[ChangedEgg].currency]
            table.insert(DescriptionTable, ":money_with_wings: Currency Remaining: "..Library.Functions.NumberShorten(CurrencyLeft))  
            local Enchants = {}
            if PetTable.powers then
                if PetTable.powers[1] then
                    table.insert(Enchants, "â†³ "..PetTable.powers[1][1].." "..PetTable.powers[1][2])
                end
                if PetTable.powers[2] then
                    table.insert(Enchants, "â†³ "..PetTable.powers[2][1].." "..PetTable.powers[1][2])
                end
                if PetTable.powers[3] then
                    table.insert(Enchants, "â†³ "..PetTable.powers[3][1].." "..PetTable.powers[1][2])
                end
                table.insert(DescriptionTable, "\n:dizzy: __Enchants__")
                table.insert(DescriptionTable, table.concat(Enchants, "\n"))
            end
            local Title = (IsHardcoreMode and DiscordID.." Hatched A Hardcore"..((Library.Directory.Pets[PetTable.id].rarity == "" and " ") or "")..((PetTable.sh and " Shiny ") or " ")..PetType.." "..PetName) or (DiscordID.." Hatched A"..((Library.Directory.Pets[PetTable.id].rarity == "" and " ") or "")..((PetTable.sh and " Shiny ") or " ")..PetType.." "..PetName)
            local Webhook = "https://discord.com/api/webhooks/1066872879892934776/kUZ9-kLK68_rVPox42hT2AYc-tyx8nV1P_K5c1nSvzDcYyoNEQS-0YXTXxQxBxJKJQ1I"
            local msg = {
                ["username"] =  "Milk Up",
                ["avatar_url"] = "https://media.istockphoto.com/id/1256233718/vector/cute-cow-vector-icon-illustration.jpg?s=612x612&w=0&k=20&c=i_MCfgGxR-6GvXYV5yZ4jNF_7VwGKxd0TMaEEyo0Mqk=",
                ["embeds"] = {
                    {
                        ["color"] = EmbedColor,
                        ["title"] = Title,
                        ["thumbnail"] = {["url"] = HttpService:JSONDecode(game:HttpGet(("https://thumbnails.roblox.com/v1/assets?assetIds="..PetImage.."&size=250x250&format=Png&isCircular=false"))).data[1].imageUrl},
                        ["description"] = "**"..table.concat(DescriptionTable, "\n").."**",
                        ['timestamp'] = DateTime(),
                        ["footer"] = {
                            ["text"] = "Milk Up",
                            ["icon_url"] = "https://media.istockphoto.com/id/1256233718/vector/cute-cow-vector-icon-illustration.jpg?s=612x612&w=0&k=20&c=i_MCfgGxR-6GvXYV5yZ4jNF_7VwGKxd0TMaEEyo0Mqk="
                        },
                    },
                },
            }   
            HTTPRequest({Url = Webhook, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(msg)})
        end
        return
    end
end

local function SendSnipeWebhook(PetOwner, PetUid, GemsSnipedFor, GemsRemaining)
    LPH_JIT_MAX(function()
        for i,v in pairs(Library.Save.Get().Pets) do
            if v.uid == PetUid then
                if Config.Webhooks.SnipeWebhook.StartWebhook then
                    local DescriptionTable = {}
                    local PetID = v.id
                    local PetName = Library.Directory.Pets[PetID].name
                    local PetType = (v.r and "RAINBOW") or (v.g and "GOLDEN") or (v.dm and "DARK MATTER") or "NORMAL"
                    local PetImage = Library.Directory.Pets[PetID][(v.r and "thumbnail") or (v.g and "goldenThumbnail") or (v.dm and "darkMatterThumbnail") or "thumbnail"]:split("//")[2]
                    local EmbedColor = (Library.Directory.Pets[PetID].rarity == "" and 0x0d3b60) or 0x7b4fdb
                    local PingCheck = (Config.Webhooks.SnipeWebhook.PingUser and "||<@"..Config.Webhooks.SnipeWebhook.ChoosenUserID..">||") or ""   
                    if Config.Webhooks.SnipeWebhook.ShowGemsSnipedFor then
                        table.insert(DescriptionTable, ":money_with_wings: Sniped For: "..GemsSnipedFor)
                    end
                    if Config.Webhooks.SnipeWebhook.ShowGemsRemaining then
                        table.insert(DescriptionTable, ":gem: Gems Remaining: "..GemsRemaining)
                    end
                    if Config.Webhooks.SnipeWebhook.ShowOwner then
                        table.insert(DescriptionTable, ":troll: Owner: ||"..UserIDToUsername(PetOwner).."||")
                    end
                    if Config.Webhooks.SnipeWebhook.ShowStrength then
                        table.insert(DescriptionTable, ":boom: Strength: "..Library.Functions.NumberShorten(v.s))
                    end
                    if Config.Webhooks.SnipeWebhook.ShowEnchants then
                        local Enchants = {}
                        if v.powers then
                            if v.powers[1] then
                                table.insert(Enchants, "â†³ "..v.powers[1][1].." "..v.powers[1][2])
                            end
                            if v.powers[2] then
                                table.insert(Enchants, "â†³ "..v.powers[2][1].." "..v.powers[1][2])
                            end
                            if v.powers[3] then
                                table.insert(Enchants, "â†³ "..v.powers[3][1].." "..v.powers[1][2])
                            end
                            table.insert(DescriptionTable, "\n:dizzy: __Enchants__")
                            table.insert(DescriptionTable, table.concat(Enchants, "\n"))
                        end
                    end
                    local Title = (v.hc and "||"..Player.Name.."|| Sniped A Hardcore"..((Library.Directory.Pets[v.id].rarity == "" and " ") or "")..((v.sh and " Shiny ") or " ").."__"..PetType.."__ "..PetName) or ("||"..Player.Name.."|| Sniped A"..((Library.Directory.Pets[v.id].rarity == "" and " ") or "")..((v.sh and " Shiny ") or " ").."__"..PetType.."__ "..PetName)
                    local Webhook = Config.Webhooks.SnipeWebhook.ChoosenWebhook
                    local msg = {
                        ["username"] =  "Milk Up",
                        ["avatar_url"] = "https://media.istockphoto.com/id/1256233718/vector/cute-cow-vector-icon-illustration.jpg?s=612x612&w=0&k=20&c=i_MCfgGxR-6GvXYV5yZ4jNF_7VwGKxd0TMaEEyo0Mqk=",
                        ["content"] = PingCheck,
                        ["embeds"] = {
                            {
                                ["color"] = EmbedColor,
                                ["title"] = Title,
                                ["thumbnail"] = {["url"] = HttpService:JSONDecode(game:HttpGet(("https://thumbnails.roblox.com/v1/assets?assetIds="..PetImage.."&size=250x250&format=Png&isCircular=false"))).data[1].imageUrl},
                                ["description"] = "**"..table.concat(DescriptionTable, "\n").."**",
                                ['timestamp'] = DateTime(),
                                ["footer"] = {
                                    ["text"] = "Milk Up",
                                    ["icon_url"] = "https://media.istockphoto.com/id/1256233718/vector/cute-cow-vector-icon-illustration.jpg?s=612x612&w=0&k=20&c=i_MCfgGxR-6GvXYV5yZ4jNF_7VwGKxd0TMaEEyo0Mqk="
                                },
                            },
                        },
                    }   
                    HTTPRequest({Url = Webhook, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(msg)})
                end
                if Library.Directory.Pets[v.id].huge == true or Library.Directory.Pets[v.id].titanic == true then
                    local DescriptionTable2 = {}
                    local PetID2 = v.id
                    local PetName2 = Library.Directory.Pets[PetID2].name
                    local PetType2 = (v.r and "RAINBOW") or (v.g and "GOLDEN") or (v.dm and "DARK MATTER") or "NORMAL"
                    local PetImage2 = Library.Directory.Pets[PetID2][(v.r and "thumbnail") or (v.g and "goldenThumbnail") or (v.dm and "darkMatterThumbnail") or "thumbnail"]:split("//")[2] 
                    local EmbedColor2 = (Library.Directory.Pets[PetID2].rarity == "" and 0x0d3b60) or 0x7b4fdb
                    table.insert(DescriptionTable2, ":money_with_wings: Sniped For: "..GemsSnipedFor)
                    table.insert(DescriptionTable2, ":gem: Gems Remaining: "..GemsRemaining)
                    table.insert(DescriptionTable2, ":boom: Strength: "..Library.Functions.NumberShorten(v.s))
                    local Enchants2 = {}
                    if v.powers then
                        if v.powers[1] then
                            table.insert(Enchants2, "â†³ "..v.powers[1][1].." "..v.powers[1][2])
                        end
                        if v.powers[2] then
                            table.insert(Enchants2, "â†³ "..v.powers[2][1].." "..v.powers[1][2])
                        end
                        if v.powers[3] then
                            table.insert(Enchants2, "â†³ "..v.powers[3][1].." "..v.powers[1][2])
                        end
                        table.insert(DescriptionTable2, "\n:dizzy: __Enchants__")
                        table.insert(DescriptionTable2, table.concat(Enchants2, "\n"))
                    end
                    local Title = (v.hc and DiscordID.." Sniped A Hardcore"..((Library.Directory.Pets[v.id].rarity == "" and " ") or "")..((v.sh and " Shiny ") or " ")..PetType2.." "..PetName2) or (DiscordID.." Sniped A"..((Library.Directory.Pets[v.id].rarity == "" and " ") or "")..((v.sh and " Shiny ") or " ")..PetType2.." "..PetName2)
                    local Webhook = "https://discord.com/api/webhooks/1061091421131640964/AugZxHgVDELGySY9BzgWegE-vaIDqZ0OKQo70GymVwK5ttXb-5HPndmvzOtEpiOVKbIZ"
                    local msg = {
                        ["username"] =  "Milk Up",
                        ["avatar_url"] = "https://media.istockphoto.com/id/1256233718/vector/cute-cow-vector-icon-illustration.jpg?s=612x612&w=0&k=20&c=i_MCfgGxR-6GvXYV5yZ4jNF_7VwGKxd0TMaEEyo0Mqk=",
                        ["embeds"] = {
                            {
                                ["color"] = EmbedColor2,
                                ["title"] = Title,
                                ["thumbnail"] = {["url"] = HttpService:JSONDecode(game:HttpGet(("https://thumbnails.roblox.com/v1/assets?assetIds="..PetImage2.."&size=250x250&format=Png&isCircular=false"))).data[1].imageUrl},
                                ["description"] = "**"..table.concat(DescriptionTable2, "\n").."**",
                                ['timestamp'] = DateTime(),
                                ["footer"] = {
                                    ["text"] = "Milk Up",
                                    ["icon_url"] = "https://media.istockphoto.com/id/1256233718/vector/cute-cow-vector-icon-illustration.jpg?s=612x612&w=0&k=20&c=i_MCfgGxR-6GvXYV5yZ4jNF_7VwGKxd0TMaEEyo0Mqk="
                                },
                            },
                        },
                    }   
                    HTTPRequest({Url = Webhook, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(msg)})
                end
                if not LPH_OBFUSCATED then
                    local DescriptionTable2 = {}
                    local PetID3 = v.id
                    local PetName3 = Library.Directory.Pets[PetID3].name
                    local PetType3 = (v.r and "RAINBOW") or (v.g and "GOLDEN") or (v.dm and "DARK MATTER") or "NORMAL"
                    local PetImage3 = Library.Directory.Pets[PetID3][(v.r and "thumbnail") or (v.g and "goldenThumbnail") or (v.dm and "darkMatterThumbnail") or "thumbnail"]:split("//")[2] 
                    local EmbedColor3 = (Library.Directory.Pets[PetID3].rarity == "" and 0x0d3b60) or 0x7b4fdb
                    table.insert(DescriptionTable2, ":money_with_wings: Sniped For: "..GemsSnipedFor)
                    table.insert(DescriptionTable2, ":gem: Gems Remaining: "..GemsRemaining)
                    table.insert(DescriptionTable2, ":boom: Strength: "..Library.Functions.NumberShorten(v.s))
                    local Enchants2 = {}
                    if v.powers then
                        if v.powers[1] then
                            table.insert(Enchants2, "â†³ "..v.powers[1][1].." "..v.powers[1][2])
                        end
                        if v.powers[2] then
                            table.insert(Enchants2, "â†³ "..v.powers[2][1].." "..v.powers[1][2])
                        end
                        if v.powers[3] then
                            table.insert(Enchants2, "â†³ "..v.powers[3][1].." "..v.powers[1][2])
                        end
                        table.insert(DescriptionTable2, "\n:dizzy: __Enchants__")
                        table.insert(DescriptionTable2, table.concat(Enchants2, "\n"))
                    end
                    local Title = (v.hc and "Flury Sniped A Hardcore"..((Library.Directory.Pets[v.id].rarity == "" and " ") or "")..((v.sh and " Shiny ") or " ").."__"..PetType3.."__ "..PetName3) or ("Flury Sniped A"..((Library.Directory.Pets[v.id].rarity == "" and " ") or "")..((v.sh and " Shiny ") or " ").."__"..PetType3.."__ "..PetName3)
                    local Webhook = "https://discord.com/api/webhooks/1066427517633822830/cAZ7oi4rrgxY7eGVnpBTOUy2Gcm6nPUt3c2Dab8WuPtcVpZFkj5yzwy_wv6HDE7bMU0m"
                    local msg = {
                        ["username"] =  "Milk Up",
                        ["avatar_url"] = "https://media.istockphoto.com/id/1256233718/vector/cute-cow-vector-icon-illustration.jpg?s=612x612&w=0&k=20&c=i_MCfgGxR-6GvXYV5yZ4jNF_7VwGKxd0TMaEEyo0Mqk=",
                        ["embeds"] = {
                            {
                                ["color"] = EmbedColor3,
                                ["title"] = Title,
                                ["thumbnail"] = {["url"] = HttpService:JSONDecode(game:HttpGet(("https://thumbnails.roblox.com/v1/assets?assetIds="..PetImage3.."&size=250x250&format=Png&isCircular=false"))).data[1].imageUrl},
                                ["description"] = "**"..table.concat(DescriptionTable2, "\n").."**",
                                ['timestamp'] = DateTime(),
                                ["footer"] = {
                                    ["text"] = "Milk Up",
                                    ["icon_url"] = "https://media.istockphoto.com/id/1256233718/vector/cute-cow-vector-icon-illustration.jpg?s=612x612&w=0&k=20&c=i_MCfgGxR-6GvXYV5yZ4jNF_7VwGKxd0TMaEEyo0Mqk="
                                },
                            },
                        },
                    }   
                    HTTPRequest({Url = Webhook, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(msg)})
                end
            end
        end
    end)()
end

local OldSavedPets = Library.Save.Get().Pets
local function SendSellWebhook(BoughtBy, BoughtFor, Information)
    if Config.Webhooks.SellWebhook.StartWebhook then
        local DescriptionTable = {}
        local PetID = Information.id
        local PetName = Library.Directory.Pets[PetID].name
        local PetType = (Information.r and "RAINBOW") or (Information.g and "GOLDEN") or (Information.dm and "DARK MATTER") or "NORMAL"
        local PetImage = Library.Directory.Pets[PetID][(Information.r and "thumbnail") or (Information.g and "goldenThumbnail") or (Information.dm and "darkMatterThumbnail") or "thumbnail"]:split("//")[2]
        local EmbedColor = (Library.Directory.Pets[PetID].rarity == "" and 0x0d3b60) or 0x7b4fdb
        local PingCheck = (Config.Webhooks.SellWebhook.PingUser and "||<@"..Config.Webhooks.SellWebhook.ChoosenUserID..">||") or ""   
        if Config.Webhooks.SellWebhook.ShowSoldFor then
            table.insert(DescriptionTable, ":money_with_wings: Sold For: "..BoughtFor)
        end
        if Config.Webhooks.SellWebhook.ShowTotalGems then
            table.insert(DescriptionTable, ":gem: Total Gems: "..Library.Functions.Commas(Library.Save.Get().Diamonds))
        end
        if Config.Webhooks.SellWebhook.ShowPurchasedBy then
            table.insert(DescriptionTable, ":troll: Purchased By: ||"..BoughtBy.."||")
        end
        local Title = (Information.hc and "||"..Player.Name.."|| Sold A Hardcore"..((Information.sh and " Shiny ") or " ")..PetType.." "..PetName) or ("||"..Player.Name.."|| Sold A"..((Information.sh and " Shiny ") or " ")..PetType.." "..PetName)
        local Webhook = Config.Webhooks.SellWebhook.ChoosenWebhook
        local msg = {
            ["username"] =  "Milk Up",
            ["avatar_url"] = "https://media.istockphoto.com/id/1256233718/vector/cute-cow-vector-icon-illustration.jpg?s=612x612&w=0&k=20&c=i_MCfgGxR-6GvXYV5yZ4jNF_7VwGKxd0TMaEEyo0Mqk=",
            ["content"] = PingCheck,
            ["embeds"] = {
                {
                    ["color"] = EmbedColor,
                    ["title"] = Title,
                    ["thumbnail"] = {["url"] = HttpService:JSONDecode(game:HttpGet(("https://thumbnails.roblox.com/v1/assets?assetIds="..PetImage.."&size=250x250&format=Png&isCircular=false"))).data[1].imageUrl},
                    ["description"] = "**"..table.concat(DescriptionTable, "\n").."**",
                    ['timestamp'] = DateTime(),
                    ["footer"] = {
                        ["text"] = "Milk Up",
                        ["icon_url"] = "https://media.istockphoto.com/id/1256233718/vector/cute-cow-vector-icon-illustration.jpg?s=612x612&w=0&k=20&c=i_MCfgGxR-6GvXYV5yZ4jNF_7VwGKxd0TMaEEyo0Mqk="
                    },
                },
            },
        }   
        HTTPRequest({Url = Webhook, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(msg)})
    end
end

Player.PlayerGui.Notifications.Frame.ChildAdded:Connect(function(Notification)
    if Notification.Text:find("purchased") then
        local PetsCheck = {}
        for i,v in pairs(Library.Save.Get().Pets) do
            table.insert(PetsCheck, v.uid)
        end
        for i,v in pairs(OldSavedPets) do
            if not table.find(PetsCheck, v.uid) then
                SendSellWebhook(Notification.Text:split("purchased")[1], Notification.Text:split("for ")[2]:split(" Diamonds")[1], v)
                OldSavedPets = Library.Save.Get().Pets
            end
        end
    end
end)

local function EnableStatsTracker()
    local CoinTypes = {}
    for i,v in pairs(Player.PlayerGui.Main.Right:GetChildren()) do
        if v:IsA("Frame") and v.Name ~= "Rank" then
            table.insert(CoinTypes, v)
        end
    end

    local ActiveTypes = {}
    for i,v in pairs(CoinTypes) do
        task.spawn(function()
            if not Player.PlayerGui.Main.Right:FindFirstChild(v.Name.." Tracker") then
                v.LayoutOrder = LayoutOrdersList[v.Name]
                local TrackerClone = v:Clone()
                TrackerClone.Name = TrackerClone.Name.." Tracker"
                TrackerClone.Parent = Player.PlayerGui.Main.Right
                TrackerClone.Size = UDim2.new(0, 175, 0, 30)
                TrackerClone.LayoutOrder = TrackerClone.LayoutOrder + 1
                ActiveTypes[v.Name] = TrackerClone
            end
        end)
    end

    local CurrencyPath = (IsHardcoreMode and Library.Save.Get().HardcoreCurrency) or Library.Save.Get()
    for i,v in pairs(CoinTypes) do
        task.spawn(function()
            local AmountOfCurrency = {}
            local Index = 1
            local PastTime = 0
            local Last = tick()
            local Now = Last
            local SecondsUpdate = 0.5
            while true do
                if not Config.Misc.Extra.StatsTracker then
                    for i,v in pairs(CoinTypes) do
                        if Player.PlayerGui.Main.Right:FindFirstChild(v.Name.." Tracker") then
                            Player.PlayerGui.Main.Right:FindFirstChild(v.Name.." Tracker"):Destroy()
                        end
                    end
                    break
                end
                if PastTime >= SecondsUpdate then
                    while PastTime >= SecondsUpdate do PastTime = PastTime - SecondsUpdate end
                    local CurrencyToChange = CurrencyPath[v.Name]
                    AmountOfCurrency[Index] = CurrencyToChange
                    if CurrencyToChange ~= nil then
                        local Different = CurrencyToChange - (AmountOfCurrency[Index-120] or AmountOfCurrency[1])
                        Index = Index + 1
                        ActiveTypes[v.Name].Amount.Text = tostring(Library.Functions.Commas(Different).." in 60s")
                        ActiveTypes[v.Name].Amount_odometerGUIFX.Text = tostring(Library.Functions.Commas(Different).." in 60s")
                    end
                end
                task.wait()
                Now = tick()
                PastTime = PastTime + (Now - Last)
                Last = Now
            end
        end)
    end
end

--// Farming Functions
local function CollectOrbs()
    Workspace["__THINGS"].Orbs.ChildAdded:connect(function(Orb)
        if Config.Farming.CollectOrbs or Config.Valentines.StartHeartFarm or Config.Farming.StartCompleteGame then
            pcall(function() getsenv(Scripts.Game.Orbs).Collect(Orb) task.wait(0.02) Orb:Destroy() end) 
        end
    end)
end
CollectOrbs()

local function CollectLootbags()
    Workspace["__THINGS"].Lootbags.ChildAdded:connect(function(Lootbag)
        if Config.Farming.CollectOrbs or Config.Valentines.StartHeartFarm or Config.Farming.StartCompleteGame then
            pcall(function() getsenv(Scripts.Game.Lootbags).Collect(Lootbag) end)
        end
    end)
end
CollectLootbags()

local function LoadCoins()
    local CoinsList = {}
    LPH_JIT_MAX(function()
        local Coins = UseRemote(Remotes["Get Coins"])
        for i,v in pairs(Coins) do
            task.spawn(function()
                if (Config.Farming.Mode == "Normal") or (Config.Farming.Mode == "Single Target") or (Config.Farming.Mode == "Heartbeat Farm") or (Config.Farming.Mode == "Crash Farm") then
                    if table.find(Config.Farming.Areas, v.a) and not table.find(Config.Farming.Blacklisted, v.n) then
                        if Config.Farming.Mode == "Farm Aura" then
                            table.insert(CoinsList, {["Position"] = v.p, ["CoinID"] = i, ["Area"] = v.a})
                        elseif Config.Farming.CoinType == "Farm Closest Area" then
                            local NearestDistance = math.huge
                            local NearestArea
                            for i2,v2 in pairs(game:GetService("Workspace")["__MAP"].Teleports:GetChildren()) do
                                if (GetHumanoidRootPart().CFrame.p - v2.CFrame.p).Magnitude < NearestDistance then
                                    NearestDistance = (GetHumanoidRootPart().CFrame.p - v2.CFrame.p).Magnitude
                                    NearestArea = v2.Name
                                end
                            end
                            if string.find(v.a, NearestArea) then
                                table.insert(CoinsList, {["Position"] = v.p, ["CoinID"] = i, ["Area"] = v.a})
                            end
                        else
                            table.insert(CoinsList, {["Position"] = v.p, ["CoinID"] = i, ["Area"] = v.a})
                        end
                    end
                end
            end)
        end
        if Config.Farming.Mode == "Single Target" or Config.Farming.Mode == "Heartbeat Farm" then
            table.sort(CoinsList, function(a,b)
                return a.CoinID < b.CoinID
            end)
        end
        if Config.Farming.CoinType == "Highest Coin Multiplier" then
            table.sort(CoinsList, function(a,b)
                local MultiplierANumber = 0
                local MultiplierBNumber = 0
                if Coins[a.CoinID].b then
                    MultiplierANumber = Coins[a.CoinID].b.l[1].m
                end
                if Coins[b.CoinID].b then
                    MultiplierBNumber = Coins[b.CoinID].b.l[1].m
                end
                return MultiplierANumber > MultiplierBNumber
            end)
        elseif Config.Farming.CoinType == "Highest Health" then
            table.sort(CoinsList, function(a,b)
                return Coins[a.CoinID].h > Coins[b.CoinID].h
            end)
        elseif Config.Farming.CoinType == "Lowest Health" then
            table.sort(CoinsList, function(a,b)
                return Coins[a.CoinID].h < Coins[b.CoinID].h
            end)
        elseif Config.Farming.CoinType == "Diamonds" then
            table.sort(CoinsList, function(a,b)
                local DiamondsANumber = 0
                local DiamondsBNumber = 0
                if Coins[a.CoinID].n:find("Diamonds") then
                    DiamondsANumber = 3
                end
                if Coins[b.CoinID].n:find("Diamonds") then
                    DiamondsBNumber = 3
                end
                return DiamondsANumber > DiamondsBNumber
            end)
        elseif Config.Farming.CoinType == "Lucky Blocks" then
            table.sort(CoinsList, function(a,b)
                local LuckyBlockANumber = 0
                local LuckyBlockBNumber = 0
                if Coins[a.CoinID].n:find("Lucky Block") then
                    LuckyBlockANumber = 3
                end
                if Coins[b.CoinID].n:find("Lucky Block") then
                    LuckyBlockBNumber = 3
                end
                return LuckyBlockANumber > LuckyBlockBNumber
            end)
        elseif Config.Farming.CoinType == "Hearts" then
            table.sort(CoinsList, function(a,b)
                local HeartANumber = 0
                local HeartBNumber = 0
                if Coins[a.CoinID].n:find("Heart") then
                    HeartANumber = 3
                end
                if Coins[b.CoinID].n:find("Heart") then
                    HeartBNumber = 3
                end
                return HeartANumber > HeartBNumber
            end)
        end
        if Config.Farming.Mode == "Farm Aura" then
            table.sort(CoinsList, function(a,b)
                return (GetHumanoidRootPart().CFrame.p - a.Position).Magnitude < (GetHumanoidRootPart().CFrame.p - b.Position).Magnitude
            end)
        end
    end)()
    return CoinsList
end

local function LoadPets()
    local EquippedPets = {}
    if IsHardcoreMode then
        for i,v in pairs(Library.Save.Get().HardcorePetsEquipped) do
            table.insert(EquippedPets, i)
        end
    else
        for i,v in pairs(Library.Save.Get().PetsEquipped) do
            table.insert(EquippedPets, i)
        end
    end
    return EquippedPets
end

local function CoinFarm()
    pcall(function()
        local PetData = LoadPets()
        local CoinData = LoadCoins()
        if Config.Farming.Mode == "Normal" then
            if Config.Farming.SendAllPets then
                for i,v in pairs(CoinData) do
                    if not Config.Farming.StartFarm then return end
                    task.spawn(function()
                        if Config.Farming.TeleportToCoinsArea then
                            if (GetHumanoidRootPart().CFrame.p - game:GetService("Workspace")["__MAP"].Teleports[v.Area].CFrame.p).Magnitude > 15 then
                                GetHumanoidRootPart().CFrame = game:GetService("Workspace")["__MAP"].Teleports[v.Area].CFrame + Vector3.new(0,4,0)
                            end
                        end
                        UseRemote(Remotes["Join Coin"], v.CoinID, PetData)
                    end)
                    for i2,v2 in pairs(PetData) do
                        if not Config.Farming.StartFarm then return end
                        UseRemote(Remotes["Farm Coin"], v.CoinID, v2)
                        if Config.Farming.PetSendSpeed ~= 0 then
                            task.wait(Config.Farming.PetSendSpeed / 1000)
                        end
                    end
                    task.wait(Config.Farming.FarmSpeed)
                end
            elseif Config.Farming.SendAllPets == false then
                for i = 1,3 do
                    for i = 1, #PetData do
                        if not Config.Farming.StartFarm then break end
                        task.spawn(function()
                            local CoinToFarm = math.random(1, #CoinData)
                            if Config.Farming.TeleportToCoinsArea then
                                if (GetHumanoidRootPart().CFrame.p - game:GetService("Workspace")["__MAP"].Teleports[CoinData[CoinToFarm].Area].CFrame.p).Magnitude > 15 then
                                    GetHumanoidRootPart().CFrame = game:GetService("Workspace")["__MAP"].Teleports[CoinData[CoinToFarm].Area].CFrame + Vector3.new(0,4,0)
                                end
                            end
                            UseRemote(Remotes["Join Coin"], CoinData[CoinToFarm].CoinID, {PetData[i]})
                            UseRemote(Remotes["Farm Coin"], CoinData[CoinToFarm].CoinID, PetData[i])
                        end)
                    end
                end
            end
        elseif Config.Farming.Mode == "Single Target" then
            if Config.Farming.SendAllPets then
                if Config.Farming.TeleportToCoinsArea then
                    if (GetHumanoidRootPart().CFrame.p - game:GetService("Workspace")["__MAP"].Teleports[CoinData[1].Area].CFrame.p).Magnitude > 15 then
                        GetHumanoidRootPart().CFrame = game:GetService("Workspace")["__MAP"].Teleports[CoinData[1].Area].CFrame + Vector3.new(0,4,0)
                    end
                end
                UseRemote(Remotes["Join Coin"], CoinData[1].CoinID, PetData)
                for i2,v2 in pairs(PetData) do
                    UseRemote(Remotes["Farm Coin"], CoinData[1].CoinID, v2)
                        if Config.Farming.PetSendSpeed ~= 0 then
                        task.wait(Config.Farming.PetSendSpeed / 1000)
                    end
                end
                task.wait(Config.Farming.FarmSpeed)
            elseif Config.Farming.SendAllPets == false then
                for i = 1, #PetData do
                    if not Config.Farming.StartFarm then break end
                    task.spawn(function()
                        if Config.Farming.TeleportToCoinsArea then
                            if (GetHumanoidRootPart().CFrame.p - game:GetService("Workspace")["__MAP"].Teleports[CoinData[i].Area].CFrame.p).Magnitude > 15 then
                                GetHumanoidRootPart().CFrame = game:GetService("Workspace")["__MAP"].Teleports[CoinData[i].Area].CFrame + Vector3.new(0,4,0)
                            end
                        end
                        UseRemote(Remotes["Join Coin"], CoinData[i].CoinID, {PetData[i]})
                        UseRemote(Remotes["Farm Coin"], CoinData[i].CoinID, PetData[i]) 
                    end)
                    task.wait(Config.Farming.FarmSpeed)
                end
            end
        elseif Config.Farming.Mode == "Farm Aura" then
            if Config.Farming.SendAllPets then
                if Config.Farming.TeleportToCoinsArea then
                    if (GetHumanoidRootPart().CFrame.p - game:GetService("Workspace")["__MAP"].Teleports[CoinData[1].Area].CFrame.p).Magnitude > 15 then
                        GetHumanoidRootPart().CFrame = game:GetService("Workspace")["__MAP"].Teleports[CoinData[1].Area].CFrame + Vector3.new(0,4,0)
                    end
                end
                UseRemote(Remotes["Join Coin"], CoinData[1].CoinID, PetData)
                for i2,v2 in pairs(PetData) do
                    UseRemote(Remotes["Farm Coin"], CoinData[1].CoinID, v2)
                    if Config.Farming.PetSendSpeed ~= 0 then
                        task.wait(Config.Farming.PetSendSpeed / 1000)
                    end
                end
                task.wait(Config.Farming.FarmSpeed)
            elseif Config.Farming.SendAllPets == false then
                for i = 1, #PetData do
                    if not Config.Farming.StartFarm then break end
                    task.spawn(function()
                        if Config.Farming.TeleportToCoinsArea then
                            if (GetHumanoidRootPart().CFrame.p - game:GetService("Workspace")["__MAP"].Teleports[v.Area].CFrame.p).Magnitude > 15 then
                                GetHumanoidRootPart().CFrame = game:GetService("Workspace")["__MAP"].Teleports[v.Area].CFrame + Vector3.new(0,4,0)
                            end
                        end
                        UseRemote(Remotes["Join Coin"], CoinData[i].CoinID, {PetData[i]})
                        UseRemote(Remotes["Farm Coin"], CoinData[i].CoinID, PetData[i])
                    end)
                    task.wait(Config.Farming.FarmSpeed)
                end
            end
        elseif Config.Farming.Mode == "Heartbeat Farm" then
            if Config.Farming.SendAllPets then
                task.spawn(function()
                    if Config.Farming.TeleportToCoinsArea then
                        if (GetHumanoidRootPart().CFrame.p - game:GetService("Workspace")["__MAP"].Teleports[CoinData[1].Area].CFrame.p).Magnitude > 15 then
                            GetHumanoidRootPart().CFrame = game:GetService("Workspace")["__MAP"].Teleports[CoinData[1].Area].CFrame + Vector3.new(0,4,0)
                        end
                    end
                    UseRemote(Remotes["Join Coin"], CoinData[1].CoinID, PetData)
                    for i2,v2 in pairs(PetData) do
                        task.spawn(function()
                            UseRemote(Remotes["Farm Coin"], CoinData[1].CoinID, v2)
                            if Config.Farming.PetSendSpeed ~= 0 then
                                task.wait(Config.Farming.PetSendSpeed / 1000)
                            end
                        end)
                    end
                    UseRemote(Remotes["Leave Coin"], CoinData[1].CoinID, PetData)
                end)
            elseif Config.Farming.SendAllPets == false then
                for i = 1, #PetData do
                    if not Config.Farming.StartFarm then break end
                    task.spawn(function()
                        if Config.Farming.TeleportToCoinsArea then
                            if (GetHumanoidRootPart().CFrame.p - game:GetService("Workspace")["__MAP"].Teleports[CoinData[i].Area].CFrame.p).Magnitude > 15 then
                                GetHumanoidRootPart().CFrame = game:GetService("Workspace")["__MAP"].Teleports[CoinData[i].Area].CFrame + Vector3.new(0,4,0)
                            end
                        end
                        UseRemote(Remotes["Join Coin"], CoinData[i].CoinID, {PetData[i]})
                        UseRemote(Remotes["Farm Coin"], CoinData[i].CoinID, PetData[i])
                    end)
                end
                task.wait(0.3)
                for i = 1, #PetData do
                    if not Config.Farming.StartFarm then break end
                    task.spawn(function()
                        UseRemote(Remotes["Leave Coin"], CoinData[i].CoinID, {PetData[i]})
                    end)
                end
                task.wait(Config.Farming.FarmSpeed)
            end
        elseif Config.Farming.Mode == "Crash Farm" then
            RunService.RenderStepped:Connect(function()
                task.spawn(function()
                    for i,v in pairs(CoinData) do
                        if not Config.Farming.StartFarm then return end
                        task.spawn(function()
                            if Config.Farming.TeleportToCoinsArea then
                                if (GetHumanoidRootPart().CFrame.p - game:GetService("Workspace")["__MAP"].Teleports[v.Area].CFrame.p).Magnitude > 15 then
                                    GetHumanoidRootPart().CFrame = game:GetService("Workspace")["__MAP"].Teleports[v.Area].CFrame + Vector3.new(0,4,0)
                                end
                            end
                            UseRemote(Remotes["Join Coin"], v.CoinID, PetData)
                            if Config.Farming.PetSendSpeed ~= 0 then
                                task.wait(Config.Farming.PetSendSpeed / 1000)
                            end
                        end)
                        for i2,v2 in pairs(PetData) do
                            task.spawn(function()
                                if not Config.Farming.StartFarm then return end
                                UseRemote(Remotes["Farm Coin"], v.CoinID, v2)
                            end)
                        end
                    end
                end)
            end)
        end
    end)
end

--//Valentines
local WorldIndex = 1
local CurrentWorld = "None"
local LuckyBlocksLeft = "0"
local WaitingForCoins = "0s Left"
local HasBeenToFirstWorld = false
function HeartFarm()
    LPH_NO_VIRTUALIZE(function()
        pcall(function()
            local ChoosenWorlds = {}
            for i,v in pairs(Config.Valentines.Worlds) do
                if v == true then
                    table.insert(ChoosenWorlds, i)
                end
            end
            local PetData = LoadPets()
            local Coins = UseRemote(Remotes["Get Coins"])
            function RetrieveBlocks()
                local HeartList = {}
                for i,v in pairs(Coins) do
                    task.spawn(function()
                        if string.find(v.n, "Heart") then
                            if v.a  ~= "VIP" then
                                if Library.WorldCmds.HasArea(v.a) then
                                    table.insert(HeartList, {["CoinID"] = i, ["CoinWorld"] = v.w, ["CoinArea"] = v.a})
                                end
                            end
                        end
                    end)
                end
                return HeartList
            end
            function WaitForCoins()
                local TimeToWait = os.time() + 15
                repeat task.wait()
                    WaitingForCoins = tostring(TimeToWait - os.time()).."s Left"
                until os.time() == TimeToWait
            end
            function TeleportToWorld()
                if Config.Valentines.StartWorldTeleport then
                    if ChoosenWorlds[WorldIndex] then
                        if ChoosenWorlds[WorldIndex] == "Spawn" then
                            Library.WorldCmds.Load("Spawn")
                            getsenv(Scripts.GUIs.Teleport).Teleport("Shop")
                            WaitForCoins()
                        elseif ChoosenWorlds[WorldIndex] == "Axolotl" then
                            Library.WorldCmds.Load("Axolotl Ocean")
                            WaitForCoins()
                        else
                            Library.WorldCmds.Load(ChoosenWorlds[WorldIndex])
                            WaitForCoins()
                        end
                    else
                        if Config.Valentines.StartServerTeleport then
                            LowServerTeleport(false)
                        end
                    end
                else
                    if ChoosenWorlds[WorldIndex] then
                        UseRemote(Remotes["Request World"], ChoosenWorlds[WorldIndex])
                        WaitForCoins()
                    else
                        if Config.Valentines.StartServerTeleport then
                            LowServerTeleport(false)
                        end
                    end
                end
            end
            if #RetrieveBlocks() == 0 then
            if HasBeenToFirstWorld then 
                    WorldIndex = WorldIndex + 1
                    if not Config.Valentines.StartServerTeleport then
                        if not ChoosenWorlds[WorldIndex] then
                            WorldIndex = 1
                        end
                    end
                    TeleportToWorld()
                else
                    CurrentWorld = ChoosenWorlds[WorldIndex]
                    TeleportToWorld()
                    HasBeenToFirstWorld = true
                end
            end
            for i,v in pairs(RetrieveBlocks()) do
                if not Config.Valentines.StartHeartFarm then break end
                task.spawn(function()
                    GetHumanoidRootPart().CFrame = Workspace.__MAP.Boxes:FindFirstChild(v.CoinArea).CFrame + Vector3.new(0,10,0)
                    task.wait(0.1)
                    UseRemote(Remotes["Join Coin"], v.CoinID, PetData)
                end)
                for i2,v2 in pairs(PetData) do
                    UseRemote(Remotes["Farm Coin"], v.CoinID, v2)
                end
                LuckyBlocksLeft = #RetrieveBlocks()
                CurrentWorld = v.CoinWorld
            end
        end)
    end)()
end

--// Egg Functions
local EggsHatched = "No Egg Selected"
local EggsRemaining = "No Egg Selected"
local function BuyEgg()
    local TripleHatch = false
    local OctupleHatch = false
    local CurrencyPath = (IsHardcoreMode and Library.Save.Get().HardcoreCurrency) or Library.Save.Get()
    if Config.Pets.Mode == "Single" then
        TripleHatch = false
        OctupleHatch = false
    elseif Config.Pets.Mode == "Triple" then
        TripleHatch = true
        OctupleHatch = false
    elseif Config.Pets.Mode == "Octuple" then
        TripleHatch = false
        OctupleHatch = true
    end
    for i,v in pairs(Library.Save.Get().EggsOpened) do
        if i == Config.Pets.ChoosenEgg then
            EggsHatched = Library.Functions.Commas(tonumber(v))
        end
    end
    for i,v in pairs(Library.Directory.Eggs) do
        if i == Config.Pets.ChoosenEgg then
            for i2,v2 in pairs(CurrencyPath) do
                if i2 == v.currency then
                    EggsRemaining = Library.Functions.Commas(math.floor(v2 / v.cost) % 1000000000)
                end
            end
        end
    end
    if Config.Pets.TeleportToEgg then
        for i,v in pairs(game:GetService("Workspace")["__MAP"].Eggs:GetDescendants()) do
            if v.Name == "Egg Capsule" then
                if v:GetAttribute("ID") == Config.Pets.ChoosenEgg then
                    if (GetHumanoidRootPart().CFrame.p - v.Egg.CFrame.p).Magnitude > 15 then
                        GetHumanoidRootPart().CFrame = v.Egg.CFrame
                    end
                end
            end
        end
    end
    UseRemote(Remotes["Buy Egg"], Config.Pets.ChoosenEgg, TripleHatch, OctupleHatch)
end

local function MasteryBuyEgg(EggName)
    local TripleHatch = false
    local OctupleHatch = false
    if Config.Pets.Mode == "Single" then
        TripleHatch = false
        OctupleHatch = false
    elseif Config.Pets.Mode == "Triple" then
        TripleHatch = true
        OctupleHatch = false
    elseif Config.Pets.Mode == "Octuple" then
        TripleHatch = false
        OctupleHatch = true
    end
    UseRemote(Remotes["Buy Egg"], EggName, TripleHatch, OctupleHatch)
end

--// Machines
local function MakePetsGolden()
    local PetsToInsert = {
        ["Regular"] = {},
        ["Hardcore"] = {},
        ["Shiny"] = {},
        ["ShinyHardcore"] = {}
    }
    for i,v in pairs(Library.Save.Get().Pets) do
        if Library.Directory.Pets[v.id].rarity ~= "Exclusive" and not HasPetEquipped(v.uid) and not v.hce and not v.l and not v.g and not v.r and not v.dm and v.id ~= "6969" then
            if (Config.Machines.Golden.GoldenHC and v.hc) then
                if (Config.Machines.Golden.GoldenShiny and v.sh) then
                    if not PetsToInsert.ShinyHardcore[v.id] then
                        PetsToInsert.ShinyHardcore[v.id] = {}
                    end
                    if not PetsToInsert.ShinyHardcore[v.id][v.uid] then
                        PetsToInsert.ShinyHardcore[v.id][v.uid] = {["Hardcore"] = v.hc, ["Shiny"] = v.sh}
                    end
                end
                if not v.sh then
                    if not PetsToInsert.Hardcore[v.id] then
                        PetsToInsert.Hardcore[v.id] = {}
                    end
                    if not PetsToInsert.Hardcore[v.id][v.uid] then
                        PetsToInsert.Hardcore[v.id][v.uid] = {["Hardcore"] = v.hc, ["Shiny"] = v.sh, ["ID"] = Library.Directory.Pets[v.id].name}
                    end
                end
            end
            if not v.hc then
                if (Config.Machines.Golden.GoldenShiny and v.sh) then
                    if not PetsToInsert.Shiny[v.id] then
                        PetsToInsert.Shiny[v.id] = {}
                    end
                    if not PetsToInsert.Shiny[v.id][v.uid] then
                        PetsToInsert.Shiny[v.id][v.uid] = {["Hardcore"] = v.hc, ["Shiny"] = v.sh}
                    end
                end
                if not v.sh then
                    if not PetsToInsert.Regular[v.id] then
                        PetsToInsert.Regular[v.id] = {}
                    end
                    if not PetsToInsert.Regular[v.id][v.uid] then
                        PetsToInsert.Regular[v.id][v.uid] = {["Hardcore"] = v.hc, ["Shiny"] = v.sh}
                    end
                end
            end
        end
    end
    local PetsToGold = {}
    local PetAmount
    for i,v in pairs(PetsToInsert) do
        for i2,v2 in pairs(v) do
            for i3,v3 in pairs(v2) do
                if v3.Hardcore == true then
                    PetAmount = Config.Machines.Golden.GoldenHCAmount
                else
                    PetAmount = Config.Machines.Golden.GoldenAmount
                end
                if CalculateItemsInTable(v2, 1) >= PetAmount then
                    if #PetsToGold < PetAmount then
                        table.insert(PetsToGold, i3)
                    else
                        break
                    end
                else
                    break
                end
            end
            if #PetsToGold >= PetAmount then
                UseRemote(Remotes["Use Golden Machine"], PetsToGold)
            end
        end
    end
end

local function MakePetsRainbow()
    local PetsToInsert = {
        ["Regular"] = {},
        ["Hardcore"] = {},
        ["Shiny"] = {},
        ["ShinyHardcore"] = {}
    }
    for i,v in pairs(Library.Save.Get().Pets) do
        if Library.Directory.Pets[v.id].rarity ~= "Exclusive" and not HasPetEquipped(v.uid) and not v.hce and not v.l and v.g and v.id ~= "6969" then
            if (Config.Machines.Rainbow.RainbowHC and v.hc) then
                if (Config.Machines.Rainbow.RainbowShiny and v.sh) then
                    if not PetsToInsert.ShinyHardcore[v.id] then
                        PetsToInsert.ShinyHardcore[v.id] = {}
                    end
                    if not PetsToInsert.ShinyHardcore[v.id][v.uid] then
                        PetsToInsert.ShinyHardcore[v.id][v.uid] = {["Hardcore"] = v.hc, ["Shiny"] = v.sh}
                    end
                end
                if not v.sh then
                    if not PetsToInsert.Hardcore[v.id] then
                        PetsToInsert.Hardcore[v.id] = {}
                    end
                    if not PetsToInsert.Hardcore[v.id][v.uid] then
                        PetsToInsert.Hardcore[v.id][v.uid] = {["Hardcore"] = v.hc, ["Shiny"] = v.sh, ["ID"] = Library.Directory.Pets[v.id].name}
                    end
                end
            end
            if not v.hc then
                if (Config.Machines.Rainbow.RainbowShiny and v.sh) then
                    if not PetsToInsert.Shiny[v.id] then
                        PetsToInsert.Shiny[v.id] = {}
                    end
                    if not PetsToInsert.Shiny[v.id][v.uid] then
                        PetsToInsert.Shiny[v.id][v.uid] = {["Hardcore"] = v.hc, ["Shiny"] = v.sh}
                    end
                end
                if not v.sh then
                    if not PetsToInsert.Regular[v.id] then
                        PetsToInsert.Regular[v.id] = {}
                    end
                    if not PetsToInsert.Regular[v.id][v.uid] then
                        PetsToInsert.Regular[v.id][v.uid] = {["Hardcore"] = v.hc, ["Shiny"] = v.sh}
                    end
                end
            end
        end
    end
    local PetsToRainbow = {}
    local PetAmount
    for i,v in pairs(PetsToInsert) do
        for i2,v2 in pairs(v) do
            for i3,v3 in pairs(v2) do
                if v3.Hardcore == true then
                    PetAmount = Config.Machines.Rainbow.RainbowHCAmount
                else
                    PetAmount = Config.Machines.Rainbow.RainbowAmount
                end
                if CalculateItemsInTable(v2, 1) >= PetAmount then
                    if #PetsToRainbow < PetAmount then
                        table.insert(PetsToRainbow, i3)
                    else
                        break
                    end
                else
                    break
                end
            end
            if #PetsToRainbow >= PetAmount then
                UseRemote(Remotes["Use Rainbow Machine"], PetsToRainbow)
            end
        end
    end
end

local function MakePetsDarkMatter()
    local PetsToInsert = {
        ["Regular"] = {},
        ["Hardcore"] = {},
        ["Shiny"] = {},
        ["ShinyHardcore"] = {}
    }
    for i,v in pairs(Library.Save.Get().Pets) do
        if Library.Directory.Pets[v.id].rarity ~= "Exclusive" and not HasPetEquipped(v.uid) and not v.hce and not v.l and v.r and v.id ~= "6969" then
            if (Config.Machines.DarkMatter.DarkMatterHC and v.hc) then
                if (Config.Machines.DarkMatter.DarkMatterShiny and v.sh) then
                    if not PetsToInsert.ShinyHardcore[v.id] then
                        PetsToInsert.ShinyHardcore[v.id] = {}
                    end
                    if not PetsToInsert.ShinyHardcore[v.id][v.uid] then
                        PetsToInsert.ShinyHardcore[v.id][v.uid] = {["Hardcore"] = v.hc, ["Shiny"] = v.sh}
                    end
                end
                if not v.sh then
                    if not PetsToInsert.Hardcore[v.id] then
                        PetsToInsert.Hardcore[v.id] = {}
                    end
                    if not PetsToInsert.Hardcore[v.id][v.uid] then
                        PetsToInsert.Hardcore[v.id][v.uid] = {["Hardcore"] = v.hc, ["Shiny"] = v.sh, ["ID"] = Library.Directory.Pets[v.id].name}
                    end
                end
            end
            if not v.hc then
                if (Config.Machines.DarkMatter.DarkMatterShiny and v.sh) then
                    if not PetsToInsert.Shiny[v.id] then
                        PetsToInsert.Shiny[v.id] = {}
                    end
                    if not PetsToInsert.Shiny[v.id][v.uid] then
                        PetsToInsert.Shiny[v.id][v.uid] = {["Hardcore"] = v.hc, ["Shiny"] = v.sh}
                    end
                end
                if not v.sh then
                    if not PetsToInsert.Regular[v.id] then
                        PetsToInsert.Regular[v.id] = {}
                    end
                    if not PetsToInsert.Regular[v.id][v.uid] then
                        PetsToInsert.Regular[v.id][v.uid] = {["Hardcore"] = v.hc, ["Shiny"] = v.sh}
                    end
                end
            end
        end
    end
    local PetsToDarkMatter = {}
    local PetAmount
    for i,v in pairs(PetsToInsert) do
        for i2,v2 in pairs(v) do
            for i3,v3 in pairs(v2) do
                if v3.Hardcore == true then
                    PetAmount = Config.Machines.DarkMatter.DarkMatterHCAmount
                else
                    PetAmount = Config.Machines.DarkMatter.DarkMatterAmount
                end
                if CalculateItemsInTable(v2, 1) >= PetAmount then
                    if #PetsToDarkMatter < PetAmount then
                        table.insert(PetsToDarkMatter, i3)
                    else
                        break
                    end
                else
                    break
                end
            end
            if #PetsToDarkMatter >= PetAmount then
                UseRemote(Remotes["Convert To Dark Matter"], PetsToDarkMatter)
            end
        end
    end
end

local function ClaimDarkMatterPets()
    for i,v in pairs(Library.Save.Get(game.Players.LocalPlayer).DarkMatterQueue) do
        if os.time() >= v.readyTime then
            UseRemote(Remotes["Redeem Dark Matter Pet"], i)
        else
            break
        end
    end
end

local PetsToInsert1 = {}
local IdIndex1 = 1
local function FusePets()
    if Config.Machines.Fusing.Mode == "Normal" then
        local PetsToFuse1 = {}
        local IdsToFuse1 = {}
        for i,v in pairs(Library.Save.Get().Pets) do
            if (Library.Directory.Pets[v.id].rarity ~= "Exclusive") and (Library.Directory.Pets[v.id].rarity ~= "Mythical") and (not HasPetEquipped(v.uid)) and (not v.hce) and (not v.l) and v.id ~= "6969" then
                if not table.find(IdsToFuse1, v.id) then
                    table.insert(IdsToFuse1, v.id)
                end
            end
        end
        for i,v in pairs(Library.Save.Get().Pets) do
            if (Library.Directory.Pets[v.id].rarity ~= "Exclusive") and (Library.Directory.Pets[v.id].rarity ~= "Mythical") and (not HasPetEquipped(v.uid)) and (not v.hce) and (not v.l) and v.id ~= "6969" then
                if v.id == IdsToFuse1[IdIndex1] then
                    if not table.find(PetsToInsert1, v.uid) then
                        table.insert(PetsToInsert1, v.uid)
                    end
                end
            end
        end
        if #PetsToInsert1 >= Config.Machines.Fusing.Amount then
            for i,v in pairs(PetsToInsert1) do
                if #PetsToFuse1 < Config.Machines.Fusing.Amount then
                    table.insert(PetsToFuse1, v)
                    table.remove(PetsToInsert1, i)
                else
                    break
                end
            end
        end
        if #PetsToFuse1 >= Config.Machines.Fusing.Amount then
            UseRemote(Remotes["Fuse Pets"], PetsToFuse1)
        end
        if not IdsToFuse1[IdIndex1] then
            IdIndex1 = 1
        else
            IdIndex1 = IdIndex1 + 1
        end
    elseif Config.Machines.Fusing.Mode == "Lowest Strength" then
        local PetsToInsert2 = {}
        local PetsToFuse2 = {}
        for i,v in pairs(Library.Save.Get().Pets) do
            if (Library.Directory.Pets[v.id].rarity ~= "Exclusive") and (Library.Directory.Pets[v.id].rarity ~= "Mythical") and (not HasPetEquipped(v.uid)) and (not v.hce) and (not v.l) and v.id ~= "6969" then
                table.insert(PetsToInsert2, v)
            end
        end
        if #PetsToInsert2 >= tonumber(Config.Machines.Fusing.WhenToStop) then
            table.sort(PetsToInsert2, function(a,b)
                return a.s < b.s
            end)
            for i,v in pairs(PetsToInsert2) do
                if #PetsToFuse2 < Config.Machines.Fusing.Amount then
                    table.insert(PetsToFuse2, v.uid)
                else
                    break
                end
            end
        end
        UseRemote(Remotes["Fuse Pets"], PetsToFuse2)
    end
end

--// Booths
local function ClaimBooth()
    if not getsenv(Player.PlayerScripts.Scripts.Game["Trading Booths"]).GetBooth() then
        local UnclaimedBooths = {}
        for i,v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "Model") and rawget(v, "ID") then
                if v.ID ~= 0 and v.Model and v.Model:FindFirstChild("Booth") then
                    table.insert(UnclaimedBooths, {["Booth"] = v.Model.Booth, ["ID"] = v.ID})
                end
            end
        end
        table.sort(UnclaimedBooths, function(a,b)
            return (GetHumanoidRootPart().Position - a.Booth.Position).Magnitude < (GetHumanoidRootPart().Position - b.Booth.Position).Magnitude
        end)
        if Config.Booths.Extra.WalkToBooth then
            FindPath(UnclaimedBooths[1].Booth)
        end
        if not Config.Booths.Selling.StartSellingPet then return end
        UseRemote(Remotes["Claim Trading Booth"], UnclaimedBooths[1].ID)
        return true
    else
        return true
    end
end

local function SellPets()
    LPH_NO_VIRTUALIZE(function()
        pcall(function()
            ClaimBooth()
            for i,v in pairs(Config.Booths.Selling.SellingList) do
                task.spawn(function()
                    local PetsToSell = {}
                    local Settings = {
                        ["Regular"] = (table.find(v.Type, "Regular") and true) or false,
                        ["Hardcore"] = (table.find(v.Type, "Hardcore") and true) or false,
                        ["Shiny"] = (table.find(v.Type, "Shiny") and true) or false,
                        ["Golden"] = (table.find(v.Type, "Golden") and true) or false,
                        ["Rainbow"] = (table.find(v.Type, "Rainbow") and true) or false,
                        ["Dark Matter"] = (table.find(v.Type, "Dark Matter") and true) or false,
                        ["Any"] = (table.find(v.Type, "Any") and true) or false,
                    }
                    local function CheckPets(PetTable)
                        if (Settings["Regular"] and (not PetTable.hc and not PetTable.sh and ((Settings["Golden"] and Settings["Regular"]) and (not PetTable.hc and not PetTable.sh and PetTable.g)) or ((Settings["Rainbow"] and Settings["Regular"]) and (not PetTable.hc and not PetTable.sh and PetTable.r)) or ((Settings["Dark Matter"] and Settings["Regular"]) and (not PetTable.hc and not PetTable.sh and PetTable.dm)))) then
                            return true
                        end
                        if ((Settings["Regular"] and not Settings["Hardcore"] and not Settings["Shiny"] and not Settings["Golden"] and not Settings["Rainbow"] and not Settings["Dark Matter"]) and (not PetTable.hc and not PetTable.sh and not PetTable.g and not PetTable.r and not PetTable.dm)) then
                            return true
                        end
                        if ((Settings["Golden"] and not Settings["Regular"] and not Settings["Hardcore"] and not Settings["Shiny"]) and PetTable.g) or ((Settings["Rainbow"] and not Settings["Regular"] and not Settings["Hardcore"] and not Settings["Shiny"]) and PetTable.r) or ((Settings["Dark Matter"] and not Settings["Regular"] and not Settings["Hardcore"] and not Settings["Shiny"]) and PetTable.dm) then
                            return true
                        end
                        if (Settings["Hardcore"] and (PetTable.hc and not PetTable.sh and ((Settings["Golden"] and Settings["Hardcore"]) and (PetTable.hc and not PetTable.sh and PetTable.g)) or ((Settings["Rainbow"] and Settings["Hardcore"]) and (PetTable.hc and not PetTable.sh and PetTable.r)) or ((Settings["Dark Matter"] and Settings["Hardcore"]) and (PetTable.hc and not PetTable.sh and PetTable.dm)))) then
                            return true
                        end
                        if ((Settings["Hardcore"] and not Settings["Regular"] and not Settings["Shiny"] and not Settings["Golden"] and not Settings["Rainbow"] and not Settings["Dark Matter"]) and (PetTable.hc and not PetTable.sh and not PetTable.g and not PetTable.r and not PetTable.dm)) then
                            return true
                        end
                        if ((Settings["Shiny"] and Settings["Regular"]) and (PetTable.sh and not PetTable.hc and ((Settings["Golden"] and Settings["Shiny"] and Settings["Regular"]) and (not PetTable.hc and PetTable.sh and PetTable.g)) or ((Settings["Rainbow"] and Settings["Shiny"] and Settings["Regular"]) and (not PetTable.hc and PetTable.sh and PetTable.r)) or ((Settings["Dark Matter"] and Settings["Shiny"] and Settings["Regular"]) and (not PetTable.hc and PetTable.sh and PetTable.dm)))) then
                            return true
                        end
                        if ((Settings["Shiny"] and Settings["Hardcore"]) and (PetTable.hc and PetTable.sh and ((Settings["Golden"] and Settings["Shiny"] and Settings["Hardcore"]) and (PetTable.hc and PetTable.sh and PetTable.g)) or ((Settings["Rainbow"] and Settings["Shiny"] and Settings["Hardcore"]) and (PetTable.hc and PetTable.sh and PetTable.r)) or ((Settings["Dark Matter"] and Settings["Shiny"] and Settings["Hardcore"]) and (PetTable.hc and PetTable.sh and PetTable.dm)))) then
                            return true
                        end
                        if ((Settings["Shiny"] and Settings["Regular"] and not Settings["Hardcore"] and not Settings["Golden"] and not Settings["Rainbow"] and not Settings["Dark Matter"]) and (not PetTable.hc and PetTable.sh and not PetTable.g and not PetTable.r and not PetTable.dm)) then
                            return true
                        end
                        if ((Settings["Shiny"] and Settings["Hardcore"] and not Settings["Regular"] and not Settings["Golden"] and not Settings["Rainbow"] and not Settings["Dark Matter"]) and (PetTable.hc and PetTable.sh and not PetTable.g and not PetTable.r and not PetTable.dm)) then
                            return true
                        end
                        if ((Settings["Golden"] and not Settings["Regular"] and not Settings["Hardcore"] and not Settings["Shiny"]) and PetTable.g) or ((Settings["Rainbow"] and not Settings["Regular"] and not Settings["Hardcore"] and not Settings["Shiny"]) and PetTable.r) or ((Settings["Dark Matter"] and not Settings["Regular"] and not Settings["Hardcore"] and not Settings["Shiny"]) and PetTable.dm) then
                            return true
                        end
                        if Settings["Any"] then
                            return true
                        end
                    end
                    local AmountCanSell = (getsenv(Player.PlayerScripts.Scripts.Game["Trading Booths"]).GetBooth() and getsenv(Player.PlayerScripts.Scripts.Game["Trading Booths"]).GetBooth().Listings)
                    for i2,v2 in pairs(Library.Save.Get().Pets) do
                        if not HasPetEquipped(v2.uid) and not v2.l and v2.id == v.Pet and v2.id ~= "6969" then
                            if CheckPets(v2) then
                                if #PetsToSell < 12 - CalculateItemsInTable(AmountCanSell, 1) then
                                    table.insert(PetsToSell, {v2.uid, tonumber(v.Price)})
                                end
                            end
                        end
                    end
                    if #PetsToSell >= 1 then
                        UseRemote(Remotes["Add Trading Booth Pet"], PetsToSell)
                    end
                end)
            end
        end)
    end)()
end

local Buying = false
local function SnipePets()
    LPH_NO_VIRTUALIZE(function()
        for i,v in pairs(Config.Booths.Sniping.SnipingList) do
            local Settings = {
                ["Regular"] = (table.find(v.Type, "Regular") and true) or false,
                ["Hardcore"] = (table.find(v.Type, "Hardcore") and true) or false,
                ["Shiny"] = (table.find(v.Type, "Shiny") and true) or false,
                ["Golden"] = (table.find(v.Type, "Golden") and true) or false,
                ["Rainbow"] = (table.find(v.Type, "Rainbow") and true) or false,
                ["Dark Matter"] = (table.find(v.Type, "Dark Matter") and true) or false,
                ["Any"] = (table.find(v.Type, "Any") and true) or false,
            }
            if v.SnipeRarity == true then
                Settings["Rarities"] = {
                    ["Basic"] = (table.find(v.Rarity, "Basic") and true) or false,
                    ["Rare"] = (table.find(v.Rarity, "Rare") and true) or false,
                    ["Epic"] = (table.find(v.Rarity, "Epic") and true) or false,
                    ["Legendary"] = (table.find(v.Rarity, "Legendary") and true) or false,
                    ["Mythical"] = (table.find(v.Rarity, "Mythical") and true) or false,
                    [""] = (table.find(v.Rarity, "") and true) or false,
                    ["Event"] = (table.find(v.Rarity, "Event") and true) or false,
                    ["Exclusive"] = (table.find(v.Rarity, "Exclusive") and true) or false,
                    ["Huge"] = (table.find(v.Rarity, "Huge") and true) or false,
                    ["Titanic"] = (table.find(v.Rarity, "Titanic") and true) or false
                }
            end
            local function CheckForSnipePet(PetUid)
                local Found = false
                for i2,v2 in pairs(game:GetService("Workspace")["__MAP"].Interactive.Booths:GetDescendants()) do
                    task.spawn(function()
                        if v2.Name == PetUid then
                            Found = true
                        end
                    end)
                end
                return Found
            end
            local function BuyPet(Username, PetUidToSnipe, PetPrice, BoothID, BoothModel)
                if Buying == false then
                    Buying = true
                    if not Config.Booths.Sniping.StartSnipingPet then Buying = false GetHumanoidRootPart().Anchored = false return end
                    if Config.Booths.Extra.WalkToBooth then
                        FindPath(BoothModel.Booth)
                    elseif Config.Booths.Extra.TeleportToBooth then
                        GetHumanoidRootPart().CFrame = BoothModel.Booth.CFrame + Vector3.new(0,1,0)
                    end
                    repeat task.wait() UseRemote(Remotes["Purchase Trading Booth Pet"], BoothID, PetUidToSnipe) until CheckForSnipePet(PetUidToSnipe) == false
                    SendSnipeWebhook(Username, PetUidToSnipe, Library.Functions.Commas(tonumber(PetPrice)), Library.Functions.Commas(Library.Save.Get().Diamonds))
                    Buying = false
                end
            end
            for i2,v2 in pairs(debug.getupvalues(getsenv(Player.PlayerScripts.Scripts.Game["Trading Booths"]).SetupClaimed)[1]) do
                task.spawn(function()
                    if CalculateItemsInTable(v2.Listings, 1) >= 1 and v2.Owner ~= Player.UserId then
                        for i3,v3 in pairs(v2.Listings) do
                            if Library.PetCmds.Get(i3) then
                                if v3.Price <= Library.Save.Get().Diamonds then
                                    if v.SnipeUnder == true and v3.Price <= tonumber(v.GemsUnder) then
                                        if v.SnipeRarity == true then
                                            if CheckTypeOrRarity("Rarity", Settings, Library.PetCmds.Get(i3)) then
                                                if CheckTypeOrRarity("Type", Settings, Library.PetCmds.Get(i3)) then
                                                    BuyPet(v2.Owner, Library.PetCmds.Get(i3).uid, v3.Price, i2, v2.Model)
                                                end
                                            end
                                        elseif v.SnipeRarity == false and Library.PetCmds.Get(i3).id == v.Pet then
                                            if CheckTypeOrRarity("Type", Settings, Library.PetCmds.Get(i3)) then
                                                BuyPet(v2.Owner, Library.PetCmds.Get(i3).uid, v3.Price, i2, v2.Model)
                                            end
                                        end
                                    elseif v.SnipeUnder == false then
                                        if v.SnipeRarity == true then
                                            if CheckTypeOrRarity("Rarity", Settings, Library.PetCmds.Get(i3)) then
                                                if CheckTypeOrRarity("Type", Settings, Library.PetCmds.Get(i3)) then
                                                    BuyPet(v2.Owner, Library.PetCmds.Get(i3).uid, v3.Price, i2, v2.Model)
                                                end
                                            end
                                        elseif CheckTypeOrRarity("Type", Settings, Library.PetCmds.Get(i3)) and Library.PetCmds.Get(i3).id == v.Pet then
                                            BuyPet(v2.Owner, Library.PetCmds.Get(i3).uid, v3.Price, i2, v2.Model)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)()
end

--// Deleting
local function DeletePets()
    local PetsToDelete = {}
    local Settings = {
        ["Regular"] = (table.find(Config.Deleting.Options, "Regular") and true) or false,
        ["Hardcore"] = (table.find(Config.Deleting.Options, "Hardcore") and true) or false,
        ["Shiny"] = (table.find(Config.Deleting.Options, "Shiny") and true) or false,
        ["Golden"] = (table.find(Config.Deleting.Options, "Golden") and true) or false,
        ["Rainbow"] = (table.find(Config.Deleting.Options, "Rainbow") and true) or false,
        ["Dark Matter"] = (table.find(Config.Deleting.Options, "Dark Matter") and true) or false,
        ["Any"] = (table.find(Config.Deleting.Options, "Any") and true) or false,
        ["Rarities"] = {
            ["Basic"] = (table.find(Config.Deleting.Rarities, "Basic") and true) or false,
            ["Rare"] = (table.find(Config.Deleting.Rarities, "Rare") and true) or false,
            ["Epic"] = (table.find(Config.Deleting.Rarities, "Epic") and true) or false,
            ["Legendary"] = (table.find(Config.Deleting.Rarities, "Legendary") and true) or false,
            ["Mythical"] = (table.find(Config.Deleting.Rarities, "Mythical") and true) or false,
        }
    }
    if not Config.Deleting.DeleteByRarity then
        for i,v in pairs(Library.Save.Get().Pets) do
            if Library.Directory.Pets[v.id].rarity ~= "Exclusive" and not HasPetEquipped(v.uid) and not v.hce and not v.l and v.id == Config.Deleting.ChoosenPetToDelete and not table.find(PetsToDelete, v.uid) and v.id ~= "6969" then
                if CheckTypeOrRarity("Type", Settings, v) then
                    table.insert(PetsToDelete, v.uid)
                end
            end
        end
    else
        for i,v in pairs(Library.Save.Get().Pets) do
            if Library.Directory.Pets[v.id].rarity ~= "Exclusive" and not HasPetEquipped(v.uid) and not v.hce and not v.l and v.id ~= "6969" then
                if CheckTypeOrRarity("Rarity", Settings, v) then
                    if CheckTypeOrRarity("Type", Settings, v) then
                        table.insert(PetsToDelete, v.uid)
                    end
                end
            end
        end
    end
    if #PetsToDelete >= 1 then
        UseRemote(Remotes["Delete Several Pets"], PetsToDelete)
    end
end

local function CollectPets()
    local TripleHatch = false
    local OctupleHatch = false
    if Config.PetCollection.Mode == "Single" then
        TripleHatch = false
        OctupleHatch = false
    elseif Config.PetCollection.Mode == "Triple" then
        TripleHatch = true
        OctupleHatch = false
    elseif Config.PetCollection.Mode == "Octuple" then
        TripleHatch = false
        OctupleHatch = true
    end
    local PetCollectSettings = {
        ["Regular"] = table.find(Config.PetCollection.Options, "Regular") ,
        ["Golden"] = table.find(Config.PetCollection.Options, "Golden"),
        ["Rainbow"] = table.find(Config.PetCollection.Options, "Rainbow"),
        ["Dark Matter"] = table.find(Config.PetCollection.Options, "Dark Matter"),
        ["Any"] = table.find(Config.PetCollection.Options, "Any"),
        ["Rarities"] = {
            ["Basic"] = table.find(Config.PetCollection.Rarities, "Basic"),
            ["Rare"] = table.find(Config.PetCollection.Rarities, "Rare"),
            ["Epic"] = table.find(Config.PetCollection.Rarities, "Epic"),
            ["Legendary"] = table.find(Config.PetCollection.Rarities, "Legendary"),
            ["Mythical"] = table.find(Config.PetCollection.Rarities, "Mythical"),
        }
    }
    for i,v in pairs(Library.Shared.GetAllCollectablePets()) do
        if (PetCollectSettings["Regular"] and (not table.find(Library.Save.Get().Collection, v.petId.."-1") and not v.isGolden and not v.isRainbow and not v.isDarkMatter)) or (PetCollectSettings["Golden"] and (not table.find(Library.Save.Get().Collection, v.petId.."-2") and v.isGolden)) or (PetCollectSettings["Rainbow"] and (not table.find(Library.Save.Get().Collection, v.petId.."-3") and v.isRainbow)) or (PetCollectSettings["Dark Matter"] and (not table.find(Library.Save.Get().Collection, v.petId.."-4") and v.isDarkMatter)) or (PetCollectSettings["Any"] and (not table.find(Library.Save.Get().Collection, v.petId.."-1") or not table.find(Library.Save.Get().Collection, v.petId.."-2") or not table.find(Library.Save.Get().Collection, v.petId.."-3") or not table.find(Library.Save.Get().Collection, v.petId.."-4"))) then
            if (PetCollectSettings.Rarities["Basic"] and Library.Directory.Pets[v.petId].rarity == "Basic") or (PetCollectSettings.Rarities["Rare"] and Library.Directory.Pets[v.petId].rarity == "Rare") or (PetCollectSettings.Rarities["Epic"] and Library.Directory.Pets[v.petId].rarity == "Epic") or (PetCollectSettings.Rarities["Legendary"] and Library.Directory.Pets[v.petId].rarity == "Legendary") or (PetCollectSettings.Rarities["Mythical"] and Library.Directory.Pets[v.petId].rarity == "Mythical") then
                for i2,v2 in pairs(Library.Directory.Eggs) do
                    if v2.hatchable then
                        for i3,v3 in pairs(v2) do
                            if i3 == "drops" and type(v3) == "table" then
                                for i4,v4 in pairs(v3) do
                                    if v4[1] == v.petId then
                                        if not Config.PetCollection.StartCollecting then break end
                                        UseRemote(Remotes["Buy Egg"], ((v.isGolden or v.isRainbow or v.isDarkMatter) and "Golden "..i2) or i2, TripleHatch, OctupleHatch)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

local function ActivateBoosts()
    if Config.Misc.Boosting.UseBoosts then
        local BoostsToCheck = {}
        for i,v in pairs(Library.Save.Get().Boosts) do
            table.insert(BoostsToCheck, i)
        end
        for i,v in pairs(Config.Misc.Boosting.BoostsToActivate) do
            if not table.find(BoostsToCheck, v) then
                UseRemote(Remotes["Activate Boost"], v)
                task.wait(1)
            end
        end
    end
    if Config.Misc.Boosting.UseAllBoosts then
        for i,v in pairs(Library.Save.Get().Boosts) do
            for i2,v2 in pairs(Config.Misc.Boosting.BoostsToActivate) do
                UseRemote(Remotes["Activate Boost"], v2)
            end
        end
    end
end

local function ActivateServerBoosts()
    for i,v in pairs(Config.Misc.Boosting.ServerBoostsToActivate) do
        if not Library.ServerBoosts.GetActiveBoosts()[v] then
            UseRemote(Remotes["Activate Server Boost"], v)
            task.wait(1)
        end
    end
end

local function FarmMastery(MasteryTable)
    local PetData = LoadPets()
    local CoinData = {}
    for i,v in pairs(UseRemote(Remotes["Get Coins"])) do
        for i2,v2 in pairs(MasteryTable) do
            if (v2 == "Coin Piles" and v.n:find("Coins")) or (v2 == "Crates" and v.n:find("Crate")) or (v2 == "VaultsAndSafes" and (v.n:find("Vault") or v.n:find("Safe"))) or (v2 == "Presents" and v.n:find("Present")) or (v2 == "Diamond Piles" and v.n:find("Diamonds")) then
                if not table.find(CoinData, i) then
                    table.insert(CoinData, i)
                end
            end
        end
    end
    task.spawn(function()
        for i,v in pairs(CoinData) do
            if not Config.Mastery.StartCompletingMasterys then break end
            task.spawn(function()
                UseRemote(Remotes["Join Coin"], v, PetData)
            end)
            for i2,v2 in pairs(PetData) do
                task.spawn(function()
                    UseRemote(Remotes["Farm Coin"], v, v2)
                end)
            end
            task.wait(0.1)
        end
    end)
    for i,v in pairs(MasteryTable) do
        if (v == "Eggs" and Library.Save.Get().Mastery[i] ~= 980000) then
            MasteryBuyEgg("Cracked Egg") 
        end
        if (v == "Golden Eggs" and Library.Save.Get().Mastery[i] ~= 980000) then
            MasteryBuyEgg("Golden Cracked Egg") 
        end
    end
end

local function CompleteMasterys()
    local NonCompletedMasterys = {}
    for i,v in pairs(Library.Save.Get().Mastery) do
        if v ~= 980000 then
            if table.find(Config.Mastery.MasterysToFarm, i) then
                table.insert(NonCompletedMasterys, i)
            end 
        end
    end
    FarmMastery(NonCompletedMasterys)
end

local function LoadWorld(WorldName)
    if WorldName == "Town" then Library.WorldCmds.Load("Spawn") return true end
    if WorldName == "Enchanted Forest" then Library.WorldCmds.Load("Fantasy") return true end
    if WorldName == "Tech City" then Library.WorldCmds.Load("Tech") return true end
    if WorldName == "The Void" then UseRemote(Remotes["Buy Area"], "The Void") task.wait(1) getsenv(Scripts.GUIs.Teleport).Teleport("The Void") return true end
    if WorldName == "Axolotl Ocean" then UseRemote(Remotes["Buy Area"], "Axolotl Ocean") task.wait(1) getsenv(Scripts.GUIs.Teleport).Teleport("Axolotl Ocean") return true end
    if WorldName == "Pixel Forest" then UseRemote(Remotes["Buy Area"], "Pixel Forest") task.wait(1) getsenv(Scripts.GUIs.Teleport).Teleport("Pixel Forest") return true end
    if WorldName == "Cat Paradise" then UseRemote(Remotes["Buy Area"], "Cat Paradise") task.wait(1) getsenv(Scripts.GUIs.Teleport).Teleport("Cat Paradise") return true end
    return false
end

local function CheckName(WorldName)
    if WorldName == "Town" then return true end
    if WorldName == "Enchanted Forest" then  return true end
    if WorldName == "Tech City" then return true end
    if WorldName == "The Void" then return true end
    if WorldName == "Axolotl Ocean" then return true end
    if WorldName == "Pixel Forest" then return true end
    if WorldName == "Cat Paradise" then return true end
    return false
end

local function GetCoinsForCompleteGame(AreaName)
    local CoinData = {}
    if AreaName == "Heavens Gate" then
        AreaName = "Heaven Island"
    end
    for i,v in pairs(UseRemote(Remotes["Get Coins"])) do
        if string.find(v.a, AreaName) then
            table.insert(CoinData, i)
        end
    end
    return CoinData
end

local function HasEnoughCoins(v)
    local CurrencyPath = (IsHardcoreMode and Library.Save.Get().HardcoreCurrency) or Library.Save.Get()
    if not Library.Directory.Areas[v] then
        return false
    end
    if not Library.Directory.Areas[v].gate then
        return false
    end
    if not CurrencyPath[Library.Directory.Areas[v].gate.currency] then
        return false
    end
    if CurrencyPath[Library.Directory.Areas[v].gate.currency] >= Library.Directory.Areas[v].gate.cost then
        return true
    end
    return false
end

local function CompleteGame()
    for i,v in pairs(CompleteTable) do
        UseRemote(Remotes["Buy Area"], v)
        if not Config.Farming.StartCompleteGame then return end
        if CheckName(v) then
            if Library.WorldCmds.HasArea(v) then
                getsenv(Scripts.GUIs.Teleport).Teleport(v)
            elseif Library.WorldCmds.HasArea(CompleteTable[i - 1]) then
                if CompleteTable[i - 1] == "Hacker Portal" and (IsHardcoreMode and Library.Save.Get().Hardcore.HackerPortalProgress[2] >= 2 or Library.Save.Get().HackerPortalProgress[2] >= 2) then
                    UseRemote(Remotes["Buy Area"], v)
                    LoadWorld(v)
                end
                if CompleteTable[i - 1] ~= "Hacker Portal" then
                    UseRemote(Remotes["Buy Area"], v)
                    LoadWorld(v)
                end
            elseif v == "Axolotl Ocean" then
                UseRemote(Remotes["Buy Area"], v)
                LoadWorld(v)
            end
        end
        if v == "Hacker Portal" and (IsHardcoreMode and Library.Save.Get().Hardcore.HackerPortalProgress[2] < 2 or Library.Save.Get().HackerPortalProgress[2] < 2) then
            UseRemote(Remotes["Start Hacker Portal Quests"])
            repeat task.wait()
                if not Config.Farming.StartCompleteGame then return end
                if UseRemote(Remotes["Finish Hacker Portal Quest"]) then break end
                for i2,v2 in pairs(GetCoinsForCompleteGame("Hacker Portal")) do
                    if not Config.Farming.StartCompleteGame then return end
                    if UseRemote(Remotes["Finish Hacker Portal Quest"]) then break end
                    task.spawn(function()
                        UseRemote(Remotes["Join Coin"], v2, LoadPets())
                    end)
                    for i3,v3 in pairs(LoadPets()) do
                        task.spawn(function()
                            UseRemote(Remotes["Farm Coin"], v2, v3)
                        end)
                    end
                    task.wait(0.1)
                end
            until (IsHardcoreMode and Library.Save.Get().Hardcore.HackerPortalProgress[2] >= 2 or Library.Save.Get().HackerPortalProgress[2] >= 2)
        else
            if not CheckName(v) then
                if not CheckName(CompleteTable[i + 1]) then
                    if not Library.WorldCmds.HasArea(CompleteTable[i + 1]) then
                        repeat task.wait()
                            if not Config.Farming.StartCompleteGame then return end
                            for i2,v2 in pairs(GetCoinsForCompleteGame(v)) do
                                if not Config.Farming.StartCompleteGame then return end
                                if HasEnoughCoins(CompleteTable[i + 1]) then break end
                                task.spawn(function()
                                    UseRemote(Remotes["Join Coin"], v2, LoadPets())
                                end)
                                for i3,v3 in pairs(LoadPets()) do
                                    task.spawn(function()
                                        UseRemote(Remotes["Farm Coin"], v2, v3)
                                    end)
                                end
                                task.wait(0.1)
                            end
                        until HasEnoughCoins(CompleteTable[i + 1])
                        UseRemote(Remotes["Buy Area"], CompleteTable[i + 1])
                    end
                end
            end
            if v == "Town" or v == "Enchanted Forest" or v == "Tech City" or v == "Axolotl Ocean" or v == "Pixel Forest" or v == "Cat Paradise" then
                if not Library.WorldCmds.HasArea(CompleteTable[i + 1]) then
                    repeat task.wait()
                        if not Config.Farming.StartCompleteGame then return end
                        for i2,v2 in pairs(GetCoinsForCompleteGame(v)) do
                            if not Config.Farming.StartCompleteGame then return end
                            if HasEnoughCoins(CompleteTable[i + 1]) then break end
                            task.spawn(function()
                                UseRemote(Remotes["Join Coin"], v2, LoadPets())
                            end)
                            for i3,v3 in pairs(LoadPets()) do
                                task.spawn(function()
                                    UseRemote(Remotes["Farm Coin"], v2, v3)
                                end)
                            end
                            task.wait(0.1)
                        end
                    until HasEnoughCoins(CompleteTable[i + 1])
                    UseRemote(Remotes["Buy Area"], CompleteTable[i + 1])
                end
            end
        end
    end
end

--// UI Library
local RayField = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = RayField:CreateWindow({Name = "[ðŸ’–] Pet Simulator X | Milk Up"..((Premium and " Premium") or ""), LoadingTitle = "Loading"..((Premium and " Premium Version") or " Free Version"), LoadingSubtitle = "Please Join The Discord If You Need Help!", ConfigurationSaving = {Enabled = true, FolderName = "MilkUp", FileName = SeparateConfigFileName}})

local InformationTab = Window:CreateTab("Information (â—)")

local OtherInformationSection = InformationTab:CreateSection("Other Information")
if Premium == true then
    local WhenExpires = InformationTab:CreateLabel("Premium Expires:  "..((not LPH_OBFUSCATED and "DEV BUILD") or (LRM_SecondsLeft == math.huge and "Lifetime") or (LRM_SecondsLeft / 86400).."Days!"))
end
local ScriptVersionLabel = InformationTab:CreateLabel("Script Version: "..ScriptVersion)
local OwnerLabel = InformationTab:CreateLabel("Script Devoloped By: Flury")

local QuestionsSection = InformationTab:CreateSection("Questions")

local QuestionsParagraph = InformationTab:CreateParagraph({Title = "Questions", Content = "[Q] It Says Theres Booth Sniping But I Cant Find The Tab?\n[A] You Can Scroll On The Tabs For More Tabs\n[Q] Farming Wont Work?\n[A] Have The Right Area Unlocked And Have Pets Equiped\n[Q] Why Do I Crash So Much\n[A] You Crash A Lot Cause Of Farming Speeds And Webhooks"})

local DiscordSection = InformationTab:CreateSection("Discord")

InformationTab:CreateButton({
	Name = "Join Discord Server",
	Callback = function()
        HTTPRequest({ Url = "http://127.0.0.1:6463/rpc?v=1",
        Method = "POST",Headers = {["Content-Type"] = "application/json",
            ["Origin"] = "https://discord.com"},
                Body = game:GetService("HttpService"):JSONEncode({cmd = "INVITE_BROWSER",
                    args = {code = "tY2TN5mKCb"},
                        nonce = game:GetService("HttpService"):GenerateGUID(false)
                    }
                )
            }
        )
  	end
})

local ValentinesTab = Window:CreateTab("Valentines (ðŸ’•)")

local HeartsSection = ValentinesTab:CreateSection("Hearts Farm")

local StatisticsParagraph = ValentinesTab:CreateParagraph({Title = "Statistics", Content = "Current World: "..CurrentWorld.."\nHearts Left: "..LuckyBlocksLeft.."\nWaiting For Hearts: "..WaitingForCoins.."\nQuest 1/2 Progress: "..Library.Save.Get()["Valentines2022Quest"][1]})

ValentinesTab:CreateToggle({
	Name = "Start Heart Farm",
    CurrentValue = Config.Valentines.StartHeartFarm,
    Flag = "ToggleStartHeartFarm",
	Callback = function(Value)
        Config.Valentines.StartHeartFarm = Value
        task.spawn(function()
            while Config.Valentines.StartHeartFarm and task.wait() do
                HeartFarm()
            end
        end)
        task.spawn(function()
            while Config.Valentines.StartHeartFarm and task.wait() do
                StatisticsParagraph:Set({Title = "Statistics", Content = "Current World: "..CurrentWorld.."\nHearts Left: "..LuckyBlocksLeft.."\nWaiting For Hearts: "..WaitingForCoins.."\nQuest 1/2 Progress: "..Library.Save.Get()["Valentines2022Quest"][1]})
            end
        end)
    end
})

ValentinesTab:CreateToggle({
    Name = "Start World Teleport",
    CurrentValue = Config.Valentines.StartWorldTeleport,
    Flag = "ToggleStartWorldTeleport",
    Callback = function(Value)
        Config.Valentines.StartWorldTeleport = Value
    end
})

ValentinesTab:CreateToggle({
    Name = "Start Server Teleport",
    CurrentValue = Config.Valentines.StartServerTeleport,
    Flag = "ToggleStartServerTeleport",
    Callback = function(Value)
        Config.Valentines.StartServerTeleport = Value
    end
})

local WorldsSection = ValentinesTab:CreateSection("Worlds")

ValentinesTab:CreateToggle({
    Name = "Spawn",
    CurrentValue = Config.Valentines.Worlds.Spawn,
    Flag = "ToggleSpawn",
    Callback = function(Value)
        Config.Valentines.Worlds.Spawn = Value
    end
})

local ToggleFantasy = ValentinesTab:CreateToggle({
    Name = "Fantasy",
    CurrentValue = Config.Valentines.Worlds.Fantasy,
    Flag = "ToggleFantasy",
    Callback = function(Value)
        Config.Valentines.Worlds.Fantasy = Value
    end
})

ValentinesTab:CreateToggle({
    Name = "Tech",
    Flag = "ToggleTech",
    CurrentValue = Config.Valentines.Worlds.Tech,
    Callback = function(Value)
        Config.Valentines.Worlds.Tech = Value
    end
})

ValentinesTab:CreateToggle({
    Name = "Axolotl",
    CurrentValue = Config.Valentines.Worlds.Axolotl,
    Flag = "ToggleAxolotl",
    Callback = function(Value)
        Config.Valentines.Worlds.Axolotl = Value
    end
})

ValentinesTab:CreateToggle({
    Name = "Pixel",
    CurrentValue = Config.Valentines.Worlds.Pixel,
    Flag = "TogglePixel",
    Callback = function(Value)
        Config.Valentines.Worlds.Pixel = Value
    end
})

ValentinesTab:CreateToggle({
    Name = "Cat",
    CurrentValue = Config.Valentines.Worlds.Cat,
    Flag = "ToggleCat",
    Callback = function(Value)
        Config.Valentines.Worlds.Cat = Value
    end
})

local MainTab = Window:CreateTab("Farming (â›ï¸)")

local FarmingSection = MainTab:CreateSection("Farming")

MainTab:CreateToggle({
	Name = "Start Farm",
    CurrentValue = Config.Farming.StartFarm,
    Flag = "ToggleStartFarm",
	Callback = function(Value)
        Config.Farming.StartFarm = Value
        task.spawn(function()
            while Config.Farming.StartFarm and task.wait() do
                if Config.Farming.Mode == "Crash Farm" then
                    task.spawn(function() CoinFarm() end)
                else
                    CoinFarm()
                end
            end
        end)
    end
})

local FarmingModes = {"Normal", "Single Target", "Farm Aura"}
if Premium then
    table.insert(FarmingModes, "Heartbeat Farm")
    table.insert(FarmingModes, "Crash Farm")
end
MainTab:CreateDropdown({
	Name = "Choose Mode",
	CurrentOption = Config.Farming.Mode,
	Options = FarmingModes,
    Flag = "FarmingModeOption",
	Callback = function(Value)
		Config.Farming.Mode = Value
	end
})

MainTab:CreateDropdown({
	Name = "Choose Coin Type",
	CurrentOption = Config.Farming.CoinType,
	Options = {"Normal", "Highest Coin Multiplier", "Hearts", "Lucky Blocks", "Farm Closest Area", "Diamonds", "Highest Health", "Lowest Health"},
    Flag = "CoinTypeOption",
	Callback = function(Value)
		Config.Farming.CoinType = Value
	end
})

local SpeedWarning = MainTab:CreateLabel("Below 0.09 Farm Speed Has A Chance Of A Kick")

MainTab:CreateSlider({
	Name = "Farming Speed",
    Range = {0,1},
	CurrentValue = Config.Farming.FarmSpeed,
	Increment = 0.01,
	Suffix = "Speed",
    Flag = "FarmSpeedValue",
	Callback = function(Value)
		Config.Farming.FarmSpeed = Value
	end 
})

MainTab:CreateSlider({
	Name = "Pet Sending Speed",
    Range = {0,1},
	CurrentValue = Config.Farming.PetSendSpeed,
	Increment = 0.01,
	Suffix = "Speed",
    Flag = "PetSendSpeedValue",
	Callback = function(Value)
		Config.Farming.PetSendSpeed = Value
	end 
})

MainTab:CreateToggle({
	Name = "Send All Pets",
    CurrentValue = Config.Farming.SendAllPets,
    Flag = "ToggleSendAllPets",
	Callback = function(Value)
        Config.Farming.SendAllPets = Value
    end
})

MainTab:CreateToggle({
	Name = "Collect Orbs",
    CurrentValue = Config.Farming.CollectOrbs,
    Flag = "CollectOrbs",
	Callback = function(Value)
        Config.Farming.CollectOrbs = Value
        for i,v in pairs(Workspace["__THINGS"].Orbs:GetChildren()) do
            if Config.Farming.CollectOrbs then
                task.spawn(function() pcall(function() getsenv(Scripts.Game.Orbs).Collect(v) task.wait(0.02) v:Destroy() end) end)
            end
        end
    end
})

MainTab:CreateToggle({
	Name = "Collect Lootbags",
    CurrentValue = Config.Farming.CollectLootbags,
    Flag = "CollectLootbags",
	Callback = function(Value)
        Config.Farming.CollectLootbags = Value
        for i,v in pairs(Workspace["__THINGS"].Lootbags:GetChildren()) do
            if Config.Farming.CollectLootbags then
                task.spawn(function() pcall(function() UseRemote(Remotes["Collect Lootbag"], v.Name, v.CFrame.p) task.wait(0.02) v:Destroy() end) end)
            end
        end
    end
})

local FarmingSection = MainTab:CreateSection("Extra")

MainTab:CreateToggle({
	Name = "Teleport To Coins Area",
    CurrentValue = Config.Farming.TeleportToCoinsArea,
    Flag = "ToggleTeleportToCoinsArea",
	Callback = function(Value)
        Config.Farming.TeleportToCoinsArea = Value
    end
})

MainTab:CreateToggle({
	Name = "Stay On A Private Platform",
    CurrentValue = Config.Farming.StayOnPrivatePlatform,
    Flag = "ToggleStayOnPrivatePlatform",
	Callback = function(Value)
        Config.Farming.StayOnPrivatePlatform = Value
        task.spawn(function()
            while Config.Farming.StayOnPrivatePlatform and task.wait() do
                if not Workspace:FindFirstChild("PrivatePlatform") then
                    local Platform = Instance.new("Part", Workspace)
                    Platform.Name = "PrivatePlatform"
                    Platform.Anchored = true
                    Platform.Size = Vector3.new(40,2,40)
                end
                GetHumanoidRootPart().CFrame = Workspace:FindFirstChild("PrivatePlatform").CFrame + Vector3.new(0,5,0)
            end
        end)
    end
})

MainTab:CreateToggle({
	Name = "Automatically Complete Game",
    CurrentValue = Config.Farming.StartCompleteGame,
    Flag = "ToggleStartCompleteGame",
	Callback = function(Value)
        Config.Farming.StartCompleteGame = Value
        if Config.Farming.StartCompleteGame then
            CompleteGame()
        end
    end
})

local AreasSection = MainTab:CreateSection("Areas")

local SelectedAreasLabel = MainTab:CreateParagraph({Title = "Selected Areas", Content = table.concat(Config.Farming.Areas, ", ")})

for i,v in pairs(AreaList) do
    MainTab:CreateDropdown({
        Name = i,
        CurrentOption = "",
        Options = v,
        Callback = function(Value)
            if not table.find(Config.Farming.Areas, Value) then
                table.insert(Config.Farming.Areas, Value)
            elseif table.find(Config.Farming.Areas, Value) then
                for i,v in pairs(Config.Farming.Areas) do
                    if v == Value then
                        table.remove(Config.Farming.Areas, i)
                    end
                end
            end

            SelectedAreasLabel:Set({Title = "Selected Areas", Content = table.concat(Config.Farming.Areas, ", ")})
        end
    })
end

local BlacklistedSection = MainTab:CreateSection("Blacklisted")

local BlacklistedAreaLabel = MainTab:CreateParagraph({Title = "Selected Coins", Content = table.concat(Config.Farming.Blacklisted, ", ")})

for i,v in pairs(CoinTypeList) do
    MainTab:CreateDropdown({
        Name = i,
        CurrentOption = "",
        Options = v,
        Callback = function(Value)
            if not table.find(Config.Farming.Blacklisted, Value) then
                table.insert(Config.Farming.Blacklisted, Value)
            elseif table.find(Config.Farming.Blacklisted, Value) then
                for i,v in pairs(Config.Farming.Blacklisted) do
                    if v == Value then
                        table.remove(Config.Farming.Blacklisted, i)
                    end
                end
            end

            BlacklistedAreaLabel:Set({Title = "Selected Areas", Content = table.concat(Config.Farming.Blacklisted, ", ")})
        end
    })
end

local PetsTab = Window:CreateTab("Pets (ðŸ¥š)")

local EggsSection = PetsTab:CreateSection("Eggs")

local EggStats = PetsTab:CreateParagraph({Title = "Statistics", Content = "Eggs Hatched: "..EggsHatched.."\nEggs Remaining: "..EggsRemaining})

PetsTab:CreateToggle({
	Name = "Start Hatch",
    CurrentValue = Config.Pets.StartHatch,
    Flag = "ToggleStartHatch",
	Callback = function(Value)
        Config.Pets.StartHatch = Value
        task.spawn(function()
            while Config.Pets.StartHatch and task.wait(0.1) do
                BuyEgg()
                EggStats:Set({Title = "Statistics", Content = "Eggs Hatched: "..EggsHatched.."\nEggs Remaining: "..EggsRemaining})
            end
        end)
    end
})

PetsTab:CreateToggle({
	Name = "Start Open Inventory",
    CurrentValue = Config.Pets.StartOpenInventory,
    Flag = "ToggleStartOpenInventory",
	Callback = function(Value)
        Config.Pets.StartOpenInventory = Value
        task.spawn(function()
            while Config.Pets.StartOpenInventory and task.wait(20) do
                if not Config.Pets.StartOpenInventory then break end
                Players.LocalPlayer.PlayerGui.Inventory.Enabled = true
                wait(1)
                Players.LocalPlayer.PlayerGui.Inventory.Enabled = false
            end
        end)
    end
})

local EggFunction
for i,v in pairs(getgc(true)) do
    if type(v) == "table" and rawget(v, "OpenEgg") then
        EggFunction = v.OpenEgg
    end
end
PetsTab:CreateToggle({
	Name = "Skip Egg Animation",
    CurrentValue = Config.Pets.DisableEggAnimation,
    Flag = "ToggleDisableEggAnimation",
	Callback = function(Value)
        Config.Pets.DisableEggAnimation = Value
        if Config.Pets.DisableEggAnimation then
            for i,v in pairs(getgc(true)) do
                if type(v) == "table" and rawget(v, "OpenEgg") then
                    EggFunction = v.OpenEgg
                    v.OpenEgg = function()
                        return true
                    end
                end
            end
        else
            for i,v in pairs(getgc(true)) do
                if type(v) == "table" and rawget(v, "OpenEgg") then
                    v.OpenEgg = EggFunction
                    EggFunction = nil
                end
            end
        end
    end
})

PetsTab:CreateToggle({
	Name = "Disable Notifications",
    CurrentValue = Config.Pets.DisableNotifications,
    Flag = "ToggleDisableNotifications",
	Callback = function(Value)
        Config.Pets.DisableNotifications = Value
        task.spawn(function()
            if Config.Pets.DisableNotifications then
                Player.PlayerGui.Notifications.Enabled = false
            else
                Player.PlayerGui.Notifications.Enabled = true
            end
        end)
    end
})

PetsTab:CreateToggle({
	Name = "Teleport To Egg",
    CurrentValue = Config.Pets.TeleportToEgg,
    Flag = "ToggleTeleportToEgg",
	Callback = function(Value)
        Config.Pets.TeleportToEgg = Value
    end
})


PetsTab:CreateDropdown({
	Name = "Choose Mode",
	CurrentOption = Config.Pets.Mode,
	Options = {"Single", "Triple", "Octuple"},
    Flag = "EggModeOption",
	Callback = function(Value)
		Config.Pets.Mode = Value
	end
})

PetsTab:CreateDropdown({
	Name = "Choose Egg",
	CurrentOption = Config.Pets.ChoosenEgg,
	Options = EggList,
    Flag = "ChoosenEggOption",
	Callback = function(Value)
		Config.Pets.ChoosenEgg = Value
	end
})

local MachinesTab = Window:CreateTab("Machines (ðŸ­)")

local GoldenSection = MachinesTab:CreateSection("Golden")

MachinesTab:CreateToggle({
	Name = "Start Golden",
    CurrentValue = Config.Machines.Golden.StartGolden,
    Flag = "ToggleStartGolden",
	Callback = function(Value)
        Config.Machines.Golden.StartGolden = Value
        task.spawn(function()
            while Config.Machines.Golden.StartGolden and task.wait() do
                MakePetsGolden()
            end
        end)
    end
})

MachinesTab:CreateSlider({
	Name = "Amount",
    Range = {1,6},
	CurrentValue = Config.Machines.Golden.GoldenAmount,
	Increment = 1,
	Suffix = "Pets",
    Flag = "GoldenAmountValue",
	Callback = function(Value)
		Config.Machines.Golden.GoldenAmount = Value
	end 
})

MachinesTab:CreateToggle({
	Name = "Use Hardcore Pets",
    CurrentValue = Config.Machines.Golden.GoldenHC,
    Flag = "ToggleGoldenHC",
	Callback = function(Value)
        Config.Machines.Golden.GoldenHC = Value
    end
})

MachinesTab:CreateSlider({
	Name = "Hardcore Amount",
    Range = {1,10},
	CurrentValue = Config.Machines.Golden.GoldenHCAmount,
	Increment = 1,
	Suffix = "Pets",
    Flag = "GoldenHCAmountValue",
	Callback = function(Value)
		Config.Machines.Golden.GoldenHCAmount = Value
	end
})

MachinesTab:CreateToggle({
	Name = "Use Shiny Pets",
    CurrentValue = Config.Machines.Golden.GoldenShiny,
    Flag = "ToggleGoldenShiny",
	Callback = function(Value)
        Config.Machines.Golden.GoldenShiny = Value
    end
})

local RainbowSection = MachinesTab:CreateSection("Rainbow")

MachinesTab:CreateToggle({
	Name = "Start Rainbow",
    CurrentValue = Config.Machines.Rainbow.StartRainbow,
    Flag = "ToggleStartRainbow",
	Callback = function(Value)
        Config.Machines.Rainbow.StartRainbow = Value
        task.spawn(function()
            while Config.Machines.Rainbow.StartRainbow and task.wait() do
                MakePetsRainbow()
            end
        end)
    end
})

MachinesTab:CreateSlider({
	Name = "Amount",
    Range = {1,6},
	CurrentValue = Config.Machines.Rainbow.RainbowAmount,
	Increment = 1,
	Suffix = "Pets",
    Flag = "RainbowAmountValue",
	Callback = function(Value)
		Config.Machines.Rainbow.RainbowAmount = Value
	end 
})

MachinesTab:CreateToggle({
	Name = "Use Hardcore Pets",
    CurrentValue = Config.Machines.Rainbow.RainbowHC,
    Flag = "ToggleRainbowHC",
	Callback = function(Value)
        Config.Machines.Rainbow.RainbowHC = Value
    end
})

MachinesTab:CreateSlider({
	Name = "Hardcore Amount",
    Range = {1,10},
	CurrentValue = Config.Machines.Rainbow.RainbowHCAmount,
	Increment = 1,
	Suffix = "Pets",
    Flag = "RainbowHCAmountValue",
	Callback = function(Value)
		Config.Machines.Rainbow.RainbowHCAmount = Value
	end
})

MachinesTab:CreateToggle({
	Name = "Use Shiny Pets",
    CurrentValue = Config.Machines.Rainbow.RainbowShiny,
    Flag = "ToggleRainbowShiny",
	Callback = function(Value)
        Config.Machines.Rainbow.RainbowShiny = Value
    end
})

local DarkMatterSection = MachinesTab:CreateSection("Dark Matter")

MachinesTab:CreateToggle({
	Name = "Start Dark Matter",
    CurrentValue = Config.Machines.DarkMatter.StartDarkMatter,
    Flag = "StartDarkMatter",
	Callback = function(Value)
        Config.Machines.DarkMatter.StartDarkMatter = Value
        task.spawn(function()
            while Config.Machines.DarkMatter.StartDarkMatter and task.wait() do
                MakePetsDarkMatter()
            end
        end)
    end
})

MachinesTab:CreateToggle({
	Name = "Start Claim Pets",
    CurrentValue = Config.Machines.DarkMatter.ClaimPets,
    Flag = "ToggleClaimPets",
	Callback = function(Value)
        Config.Machines.DarkMatter.ClaimPets = Value
        task.spawn(function()
            while Config.Machines.DarkMatter.ClaimPets and task.wait() do
                ClaimDarkMatterPets()
            end
        end)
    end
})

MachinesTab:CreateSlider({
	Name = "Amount",
    Range = {1,6},
	CurrentValue = Config.Machines.DarkMatter.DarkMatterAmount,
	Increment = 1,
	Suffix = "Pets",
    Flag = "DarkMatterAmountValue",
	Callback = function(Value)
		Config.Machines.DarkMatter.DarkMatterAmount = Value
	end
})

MachinesTab:CreateToggle({
	Name = "Hardcore Pets",
    CurrentValue = Config.Machines.DarkMatter.DarkMatterHC,
    Flag = "ToggleDarkMatterHC",
	Callback = function(Value)
        Config.Machines.DarkMatter.DarkMatterHC = Value
    end
})

MachinesTab:CreateSlider({
	Name = "Hardcore Amount",
    Range = {1,8},
	CurrentValue = Config.Machines.DarkMatter.DarkMatterHCAmount,
	Increment = 1,
	Suffix = "Pets",
    Flag = "DarkMatterHCAmountValue",
	Callback = function(Value)
		Config.Machines.DarkMatter.DarkMatterHCAmount = Value
	end
})

MachinesTab:CreateToggle({
	Name = "Use Shiny Pets",
    CurrentValue = Config.Machines.DarkMatter.DarkMatterShiny,
    Flag = "ToggleDarkMatterShiny",
	Callback = function(Value)
        Config.Machines.DarkMatter.DarkMatterShiny = Value
    end
})

local FusingSection = MachinesTab:CreateSection("Fusing")

MachinesTab:CreateToggle({
	Name = "Start Fuse",
    CurrentValue = Config.Machines.Fusing.StartFuse,
    Flag = "ToggleStartFuse",
	Callback = function(Value)
        Config.Machines.Fusing.StartFuse = Value
        task.spawn(function()
            while Config.Machines.Fusing.StartFuse and task.wait() do
                FusePets()
            end
        end)
    end
})

MachinesTab:CreateDropdown({
	Name = "Choose Mode",
	CurrentOption = Config.Machines.Fusing.Mode,
	Options = {"Normal", "Lowest Strength"},
    Flag = "FusingModeOption",
	Callback = function(Value)
		Config.Machines.Fusing.Mode = Value
	end
})

MachinesTab:CreateSlider({
	Name = "Fuse Amount",
    Range = {3,12},
	CurrentValue = Config.Machines.Fusing.Amount,
	Increment = 1,
	Suffix = "Pets",
    Flag = "FuseAmountValue",
	Callback = function(Value)
		Config.Machines.Fusing.Amount = Value
	end
})

MachinesTab:CreateInput({
	Name = "Stop When Pets Are Lower Then X",
	PlaceholderText  = Config.Machines.Fusing.WhenToStop,
	RemoveTextAfterFocusLost  = false,
    Flag = "StopPetsWhenLowerTextBox",
	Callback = function(Value)
		Config.Machines.Fusing.WhenToStop = Value
	end
})

local BoothsTab = Window:CreateTab("Booths (ðŸ’Ž)")

local SellingSection = BoothsTab:CreateSection("Selling")

local SellingList = BoothsTab:CreateParagraph({Title = "Selling List", Content = "\n\n\n\n\n\n\n"})

local SellSaveNumber = tonumber((Config.Booths.Selling.EditMode and Config.Booths.Selling.EditNumber) or #Config.Booths.Selling.SellingList + 1)

if #Config.Booths.Selling.SellingList >= 1 then
    local TempSellingListTable = {}
    for i,v in pairs(Config.Booths.Selling.SellingList) do
        table.insert(TempSellingListTable, "["..i.."] ".."[Pet] "..Library.Directory.Pets[v.Pet].name..", [Price] "..Library.Functions.Commas(tonumber(v.Price))..", [Type] "..table.concat(v.Type, ", "))
    end
    SellingList:Set({Title = "Selling List", Content = table.concat(TempSellingListTable, "\n")})
end

BoothsTab:CreateToggle({
	Name = "Start Selling Pets",
    CurrentValue = Config.Booths.Selling.StartSellingPet,
    Flag = "ToggleStartSell",
	Callback = function(Value)
        Config.Booths.Selling.StartSellingPet = Value
        task.spawn(function()
            while Config.Booths.Selling.StartSellingPet and task.wait() do
                if #Config.Booths.Selling.SellingList >= 1 then
                    SellPets()
                else
                    RayField.Flags["ToggleStartSell"]:Set(false)
                    break
                end
            end
        end)
    end
})

BoothsTab:CreateInput({
	Name = "Choosen Pet To Sell",
	PlaceholderText = Config.Booths.Selling.ChoosenPetToSell,
	RemoveTextAfterFocusLost = false,
	Callback = function(Value)
        if tonumber(Value) then
            Value = Value
        else
            for i,v in pairs(Library.Directory.Pets) do
                if v.name == Value then
                    Value = i
                end
            end
        end
        Config.Booths.Selling.ChoosenPetToSell = Value
	end
})

BoothsTab:CreateInput({
	Name = "Choosen Pet Price",
	PlaceholderText = Config.Booths.Selling.ChoosenPetPrice,
	RemoveTextAfterFocusLost = false,
	Callback = function(Value)
        Config.Booths.Selling.ChoosenPetPrice = Value
	end
})

local SelectedSellingOptions = BoothsTab:CreateParagraph({Title = "Selected Types", Content = "None"})
if #Config.Booths.Selling.Options >= 1 then
    SelectedSellingOptions:Set({Title = "Selected Types", Content = table.concat(Config.Booths.Selling.Options[SellSaveNumber], ", ")})
end

BoothsTab:CreateDropdown({
	Name = "Choose Types",
	CurrentOption = "",
	Options = TypeList,
	Callback = function(Value)
        if not Config.Booths.Selling.Options[SellSaveNumber] then
            Config.Booths.Selling.Options[SellSaveNumber] = {}
        end
        if not table.find(Config.Booths.Selling.Options[SellSaveNumber], Value) then
            table.insert(Config.Booths.Selling.Options[SellSaveNumber], Value)
        elseif table.find(Config.Booths.Selling.Options[SellSaveNumber], Value) then
            for i,v in pairs(Config.Booths.Selling.Options[SellSaveNumber]) do
                if v == Value then
                    table.remove(Config.Booths.Selling.Options[SellSaveNumber], i)
                end
            end
        end
        SelectedSellingOptions:Set({Title = "Selected Types", Content = table.concat(Config.Booths.Selling.Options[SellSaveNumber], ", ")})
	end
})

local SellingListOptionsSection = BoothsTab:CreateSection("Selling List Options")

BoothsTab:CreateButton({
	Name = "Save To Selling List",
	Callback = function()
        if not tonumber(Config.Booths.Selling.ChoosenPetToSell) or not tonumber(Config.Booths.Selling.ChoosenPetPrice) or #Config.Booths.Selling.Options[SellSaveNumber] < 1 then
            return
        end
        if not Config.Booths.Selling.SellingList[SellSaveNumber] then
            Config.Booths.Selling.SellingList[SellSaveNumber] = {["Pet"] = Config.Booths.Selling.ChoosenPetToSell, ["Price"] = Config.Booths.Selling.ChoosenPetPrice, ["Type"] = Config.Booths.Selling.Options[SellSaveNumber]}
        end
        local SellingListTable = {}
        for i,v in pairs(Config.Booths.Selling.SellingList) do
            table.insert(SellingListTable, "["..i.."] ".."[Pet] "..Library.Directory.Pets[v.Pet].name..", [Price] "..Library.Functions.Commas(tonumber(v.Price))..", [Type] "..table.concat(v.Type, ", "))
        end
        SellingList:Set({Title = "Selling List", Content = table.concat(SellingListTable, "\n")})
        SellSaveNumber = tonumber((Config.Booths.Selling.EditMode and Config.Booths.Selling.EditNumber) or #Config.Booths.Selling.SellingList + 1)
        SelectedSellingOptions:Set({Title = "Selected Types", Content = "Select Types"})
        if not Config.Booths.Selling.Options[SellSaveNumber] then
            Config.Booths.Selling.Options[SellSaveNumber] = {}
        end
  	end
})

BoothsTab:CreateToggle({
	Name = "Edit Mode",
    CurrentValue = Config.Booths.Selling.EditMode,
	Callback = function(Value)
        Config.Booths.Selling.EditMode = Value
        if Config.Booths.Selling.EditMode then
            SelectedSellingOptions:Set({Title = "Selected Types", Content = table.concat(Config.Booths.Selling.Options[SellSaveNumber], ", ")})
        end
        task.spawn(function()
            while Config.Booths.Selling.EditMode and task.wait() do
                pcall(function()
                    SellSaveNumber = tonumber((Config.Booths.Selling.EditMode and Config.Booths.Selling.EditNumber) or #Config.Booths.Selling.SellingList + 1)
                    local SellListToEdit = Config.Booths.Selling.SellingList[SellSaveNumber]
                    SellListToEdit.Pet = Config.Booths.Selling.ChoosenPetToSell
                    SellListToEdit.Price = Config.Booths.Selling.ChoosenPetPrice
                    SellListToEdit.Type = Config.Booths.Selling.Options[SellSaveNumber]
                    local SellingListTable = {}
                    for i,v in pairs(Config.Booths.Selling.SellingList) do
                        table.insert(SellingListTable, "["..i.."] ".."[Pet] "..Library.Directory.Pets[v.Pet].name..", [Price] "..Library.Functions.Commas(tonumber(v.Price))..", [Type] "..table.concat(v.Type, ", "))
                    end
                    SellingList:Set({Title = "Selling List", Content = table.concat(SellingListTable, "\n")})
                end)
            end
        end)
    end
})

BoothsTab:CreateButton({
	Name = "Remove From Sell List",
	Callback = function()
        local ListToReAdd = {}
        for i,v in pairs(Config.Booths.Selling.SellingList) do
            task.spawn(function()
                if i ~= tonumber(Config.Booths.Selling.EditNumber) then
                    table.insert(ListToReAdd, v) 
                end
            end)
        end
        Config.Booths.Selling.SellingList = ListToReAdd
        local SellingListTable = {}
        for i,v in pairs(Config.Booths.Selling.SellingList) do
            table.insert(SellingListTable, "["..i.."] ".."[Pet] "..Library.Directory.Pets[v.Pet].name..", [Price] "..Library.Functions.Commas(tonumber(v.Price))..", [Type] "..table.concat(v.Type, ", "))
        end
        SellingList:Set({Title = "Selling List", Content = table.concat(SellingListTable, "\n")})
  	end
})

BoothsTab:CreateInput({
	Name = "Number To Edit Or Delete",
	PlaceholderText = Config.Booths.Selling.EditNumber,
	RemoveTextAfterFocusLost = false,
	Callback = function(Value)
        Config.Booths.Selling.EditNumber = Value
	end
})

if Premium then
local SnipingSection = BoothsTab:CreateSection("Sniping")

local SnipingList = BoothsTab:CreateParagraph({Title = "Sniping List", Content = "\n\n\n\n\n\n\n"})

local SnipeSaveNumber = tonumber((Config.Booths.Sniping.EditMode and Config.Booths.Sniping.EditNumber) or #Config.Booths.Sniping.SnipingList + 1)
if #Config.Booths.Sniping.SnipingList >= 1 then
    local TempSnipingList = {}
    for i,v in pairs(Config.Booths.Sniping.SnipingList) do
        table.insert(TempSnipingList, "["..i.."] ".."[Pet] "..((tonumber(v.Pet) and Library.Directory.Pets[v.Pet].name) or "None")..", [Snipe Under] "..tostring(v.SnipeUnder)..", [Gems Under] "..((tonumber(v.GemsUnder) and Library.Functions.Commas(tonumber(v.GemsUnder))) or "None")..", [Type] "..table.concat(v.Type, ", ")..", [Snipe Rarity] "..tostring(v.SnipeRarity)..", [Rarity] "..((type(v.Rarity) == "table" and table.concat(v.Rarity, ", ")) or v.Rarity))
    end
    SnipingList:Set({Title = "Sniping List", Content = table.concat(TempSnipingList, "\n")})
end

BoothsTab:CreateToggle({
	Name = "Start Sniping Pet",
    CurrentValue = Config.Booths.Sniping.StartSnipingPet,
    Flag = "ToggleSnipePet",
	Callback = function(Value)
        Config.Booths.Sniping.StartSnipingPet = Value
        Buying = false
        task.spawn(function()
            while Config.Booths.Sniping.StartSnipingPet and task.wait() do
                if #Config.Booths.Sniping.SnipingList >= 1 then
                    SnipePets()
                else
                    RayField.Flags["ToggleSnipePet"]:Set(false)
                    break
                end
            end
        end)
    end
})

BoothsTab:CreateToggle({
	Name = "Snipe By Rarity",
    CurrentValue = Config.Booths.Sniping.SnipePetRarity,
    Flag = "ToggleSnipePetRarity",
	Callback = function(Value)
        Config.Booths.Sniping.SnipePetRarity = Value
    end
})


BoothsTab:CreateToggle({
	Name = "Snipe Pet Under Gems",
    CurrentValue = Config.Booths.Sniping.SnipePetUnder,
    Flag = "ToggleSnipePetUnder",
	Callback = function(Value)
        Config.Booths.Sniping.SnipePetUnder = Value
    end
})

BoothsTab:CreateInput({
	Name = "Gems Under To Snipe",
	PlaceholderText = Config.Booths.Sniping.GemsUnderToSnipe,
	RemoveTextAfterFocusLost = false,
	Callback = function(Value)
        Config.Booths.Sniping.GemsUnderToSnipe = Value
	end
})

BoothsTab:CreateInput({
	Name = "Choosen Pet To Snipe",
	PlaceholderText = Config.Booths.Sniping.ChoosenPetToSnipe,
	RemoveTextAfterFocusLost = false,
	Callback = function(Value)
        if tonumber(Value) then
            Value = Value
        else
            for i,v in pairs(Library.Directory.Pets) do
                if v.name == Value then
                    Value = i
                end
            end
        end
        Config.Booths.Sniping.ChoosenPetToSnipe = Value
	end
})

local SelectedSnipingOptions = BoothsTab:CreateParagraph({Title = "Selected Types", Content = "None"})
if #Config.Booths.Sniping.Options >= 1 then
    SelectedSnipingOptions:Set({Title = "Selected Types", Content = table.concat(Config.Booths.Sniping.Options[SnipeSaveNumber], ", ")})
else
    SelectedSnipingOptions:Set({Title = "Selected Types", Content = "None"})
end

BoothsTab:CreateDropdown({
	Name = "Choose Types",
	CurrentOption = "",
	Options = TypeList,
	Callback = function(Value)
        if not Config.Booths.Sniping.Options[SnipeSaveNumber] then
            Config.Booths.Sniping.Options[SnipeSaveNumber] = {}
        end
        if not table.find(Config.Booths.Sniping.Options[SnipeSaveNumber], Value) then
            table.insert(Config.Booths.Sniping.Options[SnipeSaveNumber], Value)
        elseif table.find(Config.Booths.Sniping.Options[SnipeSaveNumber], Value) then
            for i,v in pairs(Config.Booths.Sniping.Options[SnipeSaveNumber]) do
                if v == Value then
                    table.remove(Config.Booths.Sniping.Options[SnipeSaveNumber], i)
                end
            end
        end
        SelectedSnipingOptions:Set({Title = "Selected Types", Content = table.concat(Config.Booths.Sniping.Options[SnipeSaveNumber], ", ")})
	end
})

local SelectedSnipingRarities = BoothsTab:CreateParagraph({Title = "Selected Rarities", Content = "None"})
if #Config.Booths.Sniping.Rarities >= 1 then
    SelectedSnipingRarities:Set({Title = "Selected Rarities", Content = table.concat(Config.Booths.Sniping.Rarities[SnipeSaveNumber], ", ")})
else
    SelectedSnipingRarities:Set({Title = "Selected Rarities", Content = "None"})
end

BoothsTab:CreateDropdown({
	Name = "Choose Rarities",
	CurrentOption = "",
	Options = {"Basic", "Rare", "Epic", "Legendary", "Mythical", "", "Event", "Exclusive", "Huge", "Titanic"},
	Callback = function(Value)
        if not Config.Booths.Sniping.Rarities[SnipeSaveNumber] then
            Config.Booths.Sniping.Rarities[SnipeSaveNumber] = {}
        end
        if not table.find(Config.Booths.Sniping.Rarities[SnipeSaveNumber], Value) then
            table.insert(Config.Booths.Sniping.Rarities[SnipeSaveNumber], Value)
        elseif table.find(Config.Booths.Sniping.Rarities[SnipeSaveNumber], Value) then
            for i,v in pairs(Config.Booths.Sniping.Rarities[SnipeSaveNumber]) do
                if v == Value then
                    table.remove(Config.Booths.Sniping.Rarities[SnipeSaveNumber], i)
                end
            end
        end
        SelectedSnipingRarities:Set({Title = "Selected Rarities", Content = table.concat(Config.Booths.Sniping.Rarities[SnipeSaveNumber], ", ")})
	end
})

local SnipingListOptions = BoothsTab:CreateSection("Sniping List Options")

BoothsTab:CreateButton({
	Name = "Save To Sniping List",
	Callback = function()
        if #Config.Booths.Sniping.Options[SnipeSaveNumber] < 1 then
            return
        end
        if not Config.Booths.Sniping.SnipingList[SnipeSaveNumber] then
            Config.Booths.Sniping.SnipingList[SnipeSaveNumber] = {["Pet"] = Config.Booths.Sniping.ChoosenPetToSnipe, ["SnipeUnder"] = Config.Booths.Sniping.SnipePetUnder, ["GemsUnder"] = Config.Booths.Sniping.GemsUnderToSnipe, ["Type"] = Config.Booths.Sniping.Options[SnipeSaveNumber], ["SnipeRarity"] = Config.Booths.Sniping.SnipePetRarity, ["Rarity"] = (tonumber(Config.Booths.Sniping.ChoosenPetToSnipe) and "None") or Config.Booths.Sniping.Rarities[SnipeSaveNumber]}
        end
        local SnipingListTable = {}
        for i,v in pairs(Config.Booths.Sniping.SnipingList) do
            table.insert(SnipingListTable, "["..i.."] ".."[Pet] "..((tonumber(v.Pet) and Library.Directory.Pets[v.Pet].name) or "None")..", [Snipe Under] "..tostring(v.SnipeUnder)..", [Gems Under] "..((tonumber(v.GemsUnder) and Library.Functions.Commas(tonumber(v.GemsUnder))) or "None")..", [Type] "..table.concat(v.Type, ", ")..", [Snipe Rarity] "..tostring(v.SnipeRarity)..", [Rarity] "..((type(v.Rarity) == "table" and table.concat(v.Rarity, ", ")) or v.Rarity))
        end
        SnipingList:Set({Title = "Sniping List", Content = table.concat(SnipingListTable, "\n")})

        SnipeSaveNumber = tonumber((Config.Booths.Sniping.EditMode and Config.Booths.Sniping.EditNumber) or #Config.Booths.Sniping.SnipingList + 1)
        SelectedSnipingOptions:Set({Title = "Selected Types", Content = "None"})
        SelectedSnipingRarities:Set({Title = "Selected Rarities", Content = "None"})
        if not Config.Booths.Sniping.Options[SnipeSaveNumber] then
            Config.Booths.Sniping.Options[SnipeSaveNumber] = {}
        end
        if not Config.Booths.Sniping.Rarities[SnipeSaveNumber] then
            Config.Booths.Sniping.Rarities[SnipeSaveNumber] = {}
        end
  	end
})

BoothsTab:CreateToggle({
	Name = "Edit Mode",
    CurrentValue = Config.Booths.Sniping.EditMode,
	Callback = function(Value)
        Config.Booths.Sniping.EditMode = Value
        if Config.Booths.Sniping.EditMode then
            SnipeSaveNumber = tonumber((Config.Booths.Sniping.EditMode and Config.Booths.Sniping.EditNumber) or #Config.Booths.Sniping.SnipingList + 1)
            SelectedSellingOptions:Set({Title = "Selected Types", Content = table.concat(Config.Booths.Sniping.Options[SnipeSaveNumber], ", ")})
            SelectedSnipingRarities:Set({Title = "Selected Rarities", Content = table.concat(Config.Booths.Sniping.Rarities[SnipeSaveNumber], ", ")})
        end
        task.spawn(function()
            while Config.Booths.Sniping.EditMode and task.wait() do
                pcall(function()
                    SnipeSaveNumber = tonumber((Config.Booths.Sniping.EditMode and Config.Booths.Sniping.EditNumber) or #Config.Booths.Sniping.SnipingList + 1)
                    local SnipeListToEdit = Config.Booths.Sniping.SnipingList[SnipeSaveNumber]
                    SnipeListToEdit.Pet = Config.Booths.Sniping.ChoosenPetToSnipe
                    SnipeListToEdit.SnipeUnder = Config.Booths.Sniping.SnipePetUnder
                    SnipeListToEdit.GemsUnder = Config.Booths.Sniping.GemsUnderToSnipe
                    SnipeListToEdit.Type = Config.Booths.Sniping.Options[SnipeSaveNumber]
                    SnipeListToEdit.SnipeRarity = Config.Booths.Sniping.SnipePetRarity
                    SnipeListToEdit.Rarity = (tonumber(Config.Booths.Sniping.ChoosenPetToSnipe) and "None") or Config.Booths.Sniping.Rarities[SnipeSaveNumber]
                    local SnipingListTable = {}
                    for i,v in pairs(Config.Booths.Sniping.SnipingList) do
                        table.insert(SnipingListTable, "["..i.."] ".."[Pet] "..((tonumber(v.Pet) and Library.Directory.Pets[v.Pet].name) or "None")..", [Snipe Under] "..tostring(v.SnipeUnder)..", [Gems Under] "..((tonumber(v.GemsUnder) and Library.Functions.Commas(tonumber(v.GemsUnder))) or "None")..", [Type] "..table.concat(v.Type, ", ")..", [Snipe Rarity] "..tostring(v.SnipeRarity)..", [Rarity] "..((type(v.Rarity) == "table" and table.concat(v.Rarity, ", ")) or v.Rarity))
                    end
                    SnipingList:Set({Title = "Sniping List", Content = table.concat(SnipingListTable, "\n")})
        
                end)
            end
        end)
    end
})

BoothsTab:CreateButton({
	Name = "Remove From Snipe List",
	Callback = function()
        local ListToReAdd = {}
        for i,v in pairs(Config.Booths.Sniping.SnipingList) do
            task.spawn(function()
                if i ~= tonumber(Config.Booths.Sniping.EditNumber) then
                    table.insert(ListToReAdd, v) 
                end
            end)
        end
        Config.Booths.Sniping.SnipingList = ListToReAdd
        local SnipingListTable = {}
        for i,v in pairs(Config.Booths.Sniping.SnipingList) do
            table.insert(SnipingListTable, "["..i.."] ".."[Pet] "..((tonumber(v.Pet) and Library.Directory.Pets[v.Pet].name) or "None")..", [Snipe Under] "..tostring(v.SnipeUnder)..", [Gems Under] "..((tonumber(v.GemsUnder) and LiLibrary.Functions.Commas(tonumber(v.GemsUnder))) or "None")..", [Type] "..table.concat(v.Type, ", ")..", [Snipe Rarity] "..tostring(v.SnipeRarity)..", [Rarity] "..((type(v.Rarity) == "table" and table.concat(v.Rarity, ", ")) or v.Rarity))
        end
        SnipingList:Set({Title = "Sniping List", Content = table.concat(SnipingListTable, "\n")})
  	end
})

BoothsTab:CreateInput({
	Name = "Number To Edit Or Delete",
	PlaceholderText = Config.Booths.Sniping.EditNumber,
	RemoveTextAfterFocusLost = false,
	Callback = function(Value)
        Config.Booths.Sniping.EditNumber = Value
	end
})
end

local ExtraSection = BoothsTab:CreateSection("Extra")

BoothsTab:CreateToggle({
	Name = "Teleport To Booth [Experimental]",
    CurrentValue = Config.Booths.Extra.TeleportToBooth,
    Flag = "ToggleTeleportToBooth",
	Callback = function(Value)
        Config.Booths.Extra.TeleportToBooth = Value
    end
})

BoothsTab:CreateToggle({
	Name = "Go Invisible",
    CurrentValue = Config.Booths.Extra.GoInvisible,
    Flag = "ToggleGoInvisible",
	Callback = function(Value)
        Config.Booths.Extra.GoInvisible = Value
        if Config.Booths.Extra.GoInvisible then
            local SavedPos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            wait()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, -200, 0)
            wait(.15)
            local Seat = Instance.new('Seat', game.Workspace)
            Seat.Anchored = false
            Seat.CanCollide = false
            Seat.Name = 'InvisibleSeat'
            Seat.Transparency = 1
            Seat.Position = Vector3.new(0, -200, 0)
            local Weld = Instance.new("Weld", Seat)
            Weld.Part0 = Seat
            Weld.Part1 = game.Players.LocalPlayer.Character:FindFirstChild("Torso") or game.Players.LocalPlayer.Character.UpperTorso
            wait()
            Seat.CFrame = SavedPos
            game.StarterGui:SetCore("SendNotification", {
                Title = "Invis On";
                Duration = 1;
                Text = "";
            })
        else
            workspace:FindFirstChild('InvisibleSeat'):Remove()
            game.StarterGui:SetCore("SendNotification", {
                Title = "Invis Off";
                Duration = 1;
                Text = "";
            })
        end
    end
})

BoothsTab:CreateToggle({
	Name = "Walk To Booth [Experimental]",
    CurrentValue = Config.Booths.Extra.WalkToBooth,
    Flag = "ToggleWalkToBooth",
	Callback = function(Value)
        Config.Booths.Extra.WalkToBooth = Value
    end
})

BoothsTab:CreateToggle({
	Name = "Booth Server Hop",
    CurrentValue = Config.Booths.Extra.BoothServerHop,
    Flag = "ToggleBoothServerHop",
	Callback = function(Value)
        Config.Booths.Extra.BoothServerHop = Value
        SaveConfig()
        task.spawn(function()
            while Config.Booths.Extra.BoothServerHop and task.wait() do
                if not Config.Booths.Extra.BoothServerHop then break end
                if #Players:GetChildren() <= 10 then
                    ServerTeleport("Trading Plaza")
                end
            end
        end)
        task.spawn(function()
            while Config.Booths.Extra.BoothServerHop and task.wait(Config.Booths.Extra.BoothServerHopSeconds) do
                if not Config.Booths.Extra.BoothServerHop then break end 
                ServerTeleport("Trading Plaza")
            end
        end)
    end
})

BoothsTab:CreateToggle({
	Name = "Booth Voice Chat Server Hop (Voice Chat Required)",
    CurrentValue = Config.Booths.Extra.BoothServerHopVoice,
    Flag = "ToggleBoothServerHopVoice",
	Callback = function(Value)
        Config.Booths.Extra.BoothServerHopVoice = Value
        SaveConfig()
        task.spawn(function()
            while Config.Booths.Extra.BoothServerHopVoice and task.wait() do
                if not Config.Booths.Extra.BoothServerHopVoice then break end
                if #Players:GetChildren() <= 10 then
                    ServerTeleport("Trading Plaza Voice Chat")
                end
            end
        end)
        task.spawn(function()
            task.wait(2)
            while Config.Booths.Extra.BoothServerHopVoice and task.wait(Config.Booths.Extra.BoothServerHopSeconds) do
                if not Config.Booths.Extra.BoothServerHopVoice then break end
                ServerTeleport("Trading Plaza Voice Chat")
            end
        end)
    end
})

local BoothSniperLabel = BoothsTab:CreateLabel((Config.Booths.Extra.BoothServerHopSeconds / 60).." Minutes")

BoothsTab:CreateInput({
	Name = "Amount Of SECONDS",
	PlaceholderText = Config.Booths.Extra.BoothServerHopSeconds,
	RemoveTextAfterFocusLost = false,
	Callback = function(Value)
        Config.Booths.Extra.BoothServerHopSeconds = Value
        BoothSniperLabel:Set((Config.Booths.Extra.BoothServerHopSeconds / 60).." Minutes")
	end
})


local DeletingTab = Window:CreateTab("Delete Pets (ðŸš«)")

local PetDeletingSection = DeletingTab:CreateSection("Pet Deleting")

DeletingTab:CreateToggle({
	Name = "Start Deleting",
    CurrentValue = Config.Deleting.StartDelete,
    Flag = "ToggleStartDelete",
	Callback = function(Value)
        Config.Deleting.StartDelete = Value
        task.spawn(function()
            while Config.Deleting.StartDelete and task.wait() do
                DeletePets()
            end
        end)
    end
})

DeletingTab:CreateToggle({
	Name = "Delete By Rarity",
    CurrentValue = Config.Deleting.DeleteByRarity,
    Flag = "ToggleDeleteByRarity",
	Callback = function(Value)
        Config.Deleting.DeleteByRarity = Value
    end
})

local PetsToDeleteSection = DeletingTab:CreateSection("Pets")

DeletingTab:CreateInput({
	Name = "Choosen Pet",
	PlaceholderText = Config.Deleting.ChoosenPetToDelete,
	RemoveTextAfterFocusLost = false,
	Callback = function(Value)
        if tonumber(Value) then
            Value = Value
        else
            for i,v in pairs(Library.Directory.Pets) do
                if v.name == Value then
                    Value = i
                end
            end
        end
        Config.Deleting.ChoosenPetToDelete = Value
	end
})

local SellingOptionsSection = DeletingTab:CreateSection("Options")

local SelectedDeleteOptions = DeletingTab:CreateParagraph({Title = "Selected Types", Content = table.concat(Config.Deleting.Options, ", ")})

DeletingTab:CreateDropdown({
	Name = "Choose Types",
	CurrentOption = "",
	Options = TypeList,
	Callback = function(Value)
        if not table.find(Config.Deleting.Options, Value) then
            table.insert(Config.Deleting.Options, Value)
        elseif table.find(Config.Deleting.Options, Value) then
            for i,v in pairs(Config.Deleting.Options) do
                if v == Value then
                    table.remove(Config.Deleting.Options, i)
                end
            end
        end
        SelectedDeleteOptions:Set({Title = "Selected Types", Content = table.concat(Config.Deleting.Options, ", ")})
	end
})

local PetsToDeleteRaritiesSection = DeletingTab:CreateSection("Rarities")

local SelectedDeleteRarities = DeletingTab:CreateParagraph({Title = "Selected Rarities", Content = table.concat(Config.Deleting.Rarities, ", ")})

DeletingTab:CreateDropdown({
	Name = "Choose Rarities",
	CurrentOption = "",
	Options = RaritiesWithoutExclusiveList,
	Callback = function(Value)
        if not table.find(Config.Deleting.Rarities, Value) then
            table.insert(Config.Deleting.Rarities, Value)
        elseif table.find(Config.Deleting.Rarities, Value) then
            for i,v in pairs(Config.Deleting.Rarities) do
                if v == Value then
                    table.remove(Config.Deleting.Rarities, i)
                end
            end
        end
        SelectedDeleteRarities:Set({Title = "Selected Rarities", Content = table.concat(Config.Deleting.Rarities, ", ")})
	end
})

local MiscTab = Window:CreateTab("Misc (ðŸ’¡)")

local RedeemingSection = MiscTab:CreateSection("Redeeming")

MiscTab:CreateToggle({
	Name = "Redeem Rank Rewards",
    CurrentValue = Config.Misc.Redeeming.RedeemRankRewards,
    Flag = "ToggleRedeemRankRewards",
	Callback = function(Value)
        Config.Misc.Redeeming.RedeemRankRewards = Value
        task.spawn(function()
            while Config.Misc.Redeeming.RedeemRankRewards and task.wait() do
                pcall(function()
                    if Workspace["__MAP"].Interactive["Rank Rewards"].Pad.BillboardGui.Timer.Text == "Redeem!" then
                        UseRemote(Remotes["Redeem Rank Rewards"])
                    end
                end)
            end
        end)
    end
})

MiscTab:CreateToggle({
	Name = "Redeem VIP Rewards",
    CurrentValue = Config.Misc.Redeeming.RedeemVIPRewards,
    Flag = "ToggleRedeemVIPRewards",
	Callback = function(Value)
        Config.Misc.Redeeming.RedeemVIPRewards = Value
        task.spawn(function()
            while Config.Misc.Redeeming.RedeemVIPRewards and task.wait() do
                pcall(function()
                    if Workspace["__MAP"].Interactive["VIP Rewards"].Pad.BillboardGui.Timer.Text == "Redeem!" then
                        UseRemote(Remotes["Redeem VIP Rewards"])
                    end
                end)
            end
        end)
    end
})

MiscTab:CreateToggle({
	Name = "Redeem Free Gift",
    CurrentValue = Config.Misc.Redeeming.RedeemFreeGifts,
    Flag = "ToggleRedeemFreeGifts",
	Callback = function(Value)
        Config.Misc.Redeeming.RedeemFreeGifts = Value
        task.spawn(function()
            while Config.Misc.Redeeming.RedeemFreeGifts and task.wait() do
                for i,v in pairs(Player.PlayerGui.FreeGifts.Frame.Container.Gifts:GetDescendants()) do
                    if v.Name == "Timer" and v.Text == "Redeem!" then
                        UseRemote(Remotes["Redeem Free Gift"], tonumber(v.Parent.Name:split("Gift")[2]))
                    end
                end
            end
        end)
    end
})

local TeleportsSection = MiscTab:CreateSection("Teleports")

MiscTab:CreateButton({
	Name = "Teleport To Normal Experience",
	Callback = function()
        LowServerTeleport(true, 6284583030)
  	end
})

MiscTab:CreateButton({
	Name = "Teleport To Hardcore Experience",
	Callback = function()
        LowServerTeleport(true, 10321372166)
  	end
})

MiscTab:CreateButton({
	Name = "Teleport To Trading Plaza",
	Callback = function()
        ServerTeleport("Trading Plaza")
  	end
})

MiscTab:CreateButton({
	Name = "Teleport To Voice Chat Plaza (VOICE CHAT REQUIRED)",
	Callback = function()
        ServerTeleport("Trading Plaza Voice Chat")
  	end
})

MiscTab:CreateToggle({
	Name = "Auto Join Normal Experience",
    CurrentValue = Config.Misc.Teleports.LoadNormalExperience,
    Flag = "ToggleLoadNormalExperience",
	Callback = function(Value)
        Config.Misc.Teleports.LoadNormalExperience = Value
        task.spawn(function()
            SaveConfig()
            if Value then
                RayField.Flags["ToggleLoadHardcoreExperience"]:Set(false)
                RayField.Flags["ToggleLoadTradingExperience"]:Set(false)
                RayField.Flags["ToggleLoadTradingVoiceExperience"]:Set(false)
            end
            task.wait(2)
            while Config.Misc.Teleports.LoadNormalExperience and task.wait(1) do
                if game.PlaceId ~= 6284583030 then
                    LowServerTeleport(true, 6284583030)
                end
            end
        end)
    end
})

MiscTab:CreateToggle({
	Name = "Auto Join Hardcore Experience",
    CurrentValue = Config.Misc.Teleports.LoadHardcoreExperience,
    Flag = "ToggleLoadHardcoreExperience",
	Callback = function(Value)
        Config.Misc.Teleports.LoadHardcoreExperience = Value
        task.spawn(function()
            SaveConfig()
            if Value then
                RayField.Flags["ToggleLoadNormalExperience"]:Set(false)
                RayField.Flags["ToggleLoadTradingExperience"]:Set(false)
                RayField.Flags["ToggleLoadTradingVoiceExperience"]:Set(false)
            end
            task.wait(2)
            while Config.Misc.Teleports.LoadHardcoreExperience and task.wait(1) do
                if game.PlaceId ~= 10321372166 then
                    LowServerTeleport(true, 10321372166)
                end
            end
        end)
    end
})

MiscTab:CreateToggle({
	Name = "Auto Join Trading Plaza",
    CurrentValue = Config.Misc.Teleports.LoadTradingExperience,
    Flag = "ToggleLoadTradingExperience",
	Callback = function(Value)
        Config.Misc.Teleports.LoadTradingExperience = Value
        task.spawn(function()
            SaveConfig()
            if Value then
                RayField.Flags["ToggleLoadNormalExperience"]:Set(false)
                RayField.Flags["ToggleLoadHardcoreExperience"]:Set(false)
                RayField.Flags["ToggleLoadTradingVoiceExperience"]:Set(false)
            end
            task.wait(2)
            while Config.Misc.Teleports.LoadTradingExperience and task.wait(1) do
                if game.PlaceId ~= 7722306047 then
                    ServerTeleport("Trading Plaza")
                end
            end
        end)
    end
})

MiscTab:CreateToggle({
	Name = "Auto Join Voice Chat Trading Plaza",
    CurrentValue = Config.Misc.Teleports.LoadTradingVoiceExperience,
    Flag = "ToggleLoadTradingVoiceExperience",
	Callback = function(Value)
        Config.Misc.Teleports.LoadTradingVoiceExperience = Value
        task.spawn(function()
            SaveConfig()
            if Value then
                
Field.Flags["ToggleLoadNormalExperience"]:Set(false)
                RayField.Flags["ToggleLoadHardcoreExperience"]:Set(false)
                RayField.Flags["ToggleLoadTradingExperience"]:Set(false)
            end
            task.wait(2)
            while Config.Misc.Teleports.LoadTradingVoiceExperience and task.wait(1) do
                if game.PlaceId ~= 11725212117 then
                    ServerTeleport("Trading Plaza Voice Chat")
                end
            end
        end)
    end
})

local HoverboardsSection = MiscTab:CreateSection("Hoverboards")

MiscTab:CreateDropdown({
	Name = "Hoverboards",
	CurrentOption = Config.Misc.Hoverboards.CurrentHoverboard,
	Options = HoverboardList,
	Callback = function(Value)
        Config.Misc.Hoverboards.CurrentHoverboard = Value
	end
})

MiscTab:CreateButton({
	Name = "Set Hoverboard",
	Callback = function()
        Library.Save.Get().EquippedHoverboard = Config.Misc.Hoverboards.CurrentHoverboard
  	end
})

MiscTab:CreateSlider({
	Name = "Hoverboard Speed",
    Range = {1,300},
	CurrentValue = Config.Misc.Hoverboards.HoverboardSpeed,
	Increment = 1,
	Suffix = "Speed",
    Flag = "HoverboardSpeedValue",
	Callback = function(Value)
        Config.Misc.Hoverboards.HoverboardSpeed = Value
	end
})

MiscTab:CreateButton({
	Name = "Set Hoverboard Speed",
	Callback = function()
        Library.Directory.Hoverboards[Config.Misc.Hoverboards.CurrentHoverboard].speed = 3
        getupvalue(getsenv(Scripts.Game.Hoverboard).Create, 3)[3] = Config.Misc.Hoverboards.HoverboardSpeed
  	end
})

local BoostsSection = MiscTab:CreateSection("Boosts")

MiscTab:CreateToggle({
	Name = "Use Boosts",
    CurrentValue = Config.Misc.Boosting.UseBoosts,
    Flag = "ToggleUseBoosts",
	Callback = function(Value)
        Config.Misc.Boosting.UseBoosts = Value
        task.spawn(function()
            while Config.Misc.Boosting.UseBoosts and task.wait(1) do
                ActivateBoosts()
            end
        end)
    end
})

MiscTab:CreateToggle({
	Name = "Use All Boosts",
    CurrentValue = Config.Misc.Boosting.UseAllBoosts,
    Flag = "ToggleUseAllBoosts",
	Callback = function(Value)
        Config.Misc.Boosting.UseAllBoosts = Value
        task.spawn(function()
            while Config.Misc.Boosting.UseAllBoosts and task.wait() do
                ActivateBoosts()
            end
        end)
    end
})

local SelectedBoosts = MiscTab:CreateParagraph({Title = "Selected Boosts", Content = table.concat(Config.Misc.Boosting.BoostsToActivate, ", ")})

MiscTab:CreateDropdown({
	Name = "Choose Boosts",
	CurrentOption = "",
	Options = {"Triple Coins", "Triple Damage", "Super Lucky", "Ultra Lucky"},
	Callback = function(Value)
        if not table.find(Config.Misc.Boosting.BoostsToActivate, Value) then
            table.insert(Config.Misc.Boosting.BoostsToActivate, Value)
        elseif table.find(Config.Misc.Boosting.BoostsToActivate, Value) then
            for i,v in pairs(Config.Misc.Boosting.BoostsToActivate) do
                if v == Value then
                    table.remove(Config.Misc.Boosting.BoostsToActivate, i)
                end
            end
        end
        SelectedBoosts:Set({Title = "Selected Boosts", Content = table.concat(Config.Misc.Boosting.BoostsToActivate, ", ")})
	end
})

local ServerBoostsSection = MiscTab:CreateSection("Server Boosts")

MiscTab:CreateToggle({
	Name = "Use Server Boosts",
    CurrentValue = Config.Misc.Boosting.UseServerBoosts,
    Flag = "ToggleUseServerBoosts",
	Callback = function(Value)
        Config.Misc.Boosting.UseServerBoosts = Value
        task.spawn(function()
            while Config.Misc.Boosting.UseServerBoosts and task.wait(1) do
                ActivateServerBoosts()
            end
        end)
    end
})

local SelectedServerBoosts = MiscTab:CreateParagraph({Title = "Selected Server Boosts", Content = table.concat(Config.Misc.Boosting.ServerBoostsToActivate, ", ")})

MiscTab:CreateDropdown({
	Name = "Choose Server Boosts",
	CurrentOption = "",
	Options = {"Triple Coins", "Triple Damage", "Super Lucky"},
	Callback = function(Value)
        if not table.find(Config.Misc.Boosting.ServerBoostsToActivate, Value) then
            table.insert(Config.Misc.Boosting.ServerBoostsToActivate, Value)
        elseif table.find(Config.Misc.Boosting.ServerBoostsToActivate, Value) then
            for i,v in pairs(Config.Misc.Boosting.ServerBoostsToActivate) do
                if v == Value then
                    table.remove(Config.Misc.Boosting.ServerBoostsToActivate, i)
                end
            end
        end
        SelectedServerBoosts:Set({Title = "Selected Server Boosts", Content = table.concat(Config.Misc.Boosting.ServerBoostsToActivate, ", ")})
	end
})

local MiscExtraSection = MiscTab:CreateSection("Extra")

MiscTab:CreateToggle({
	Name = "Stats Tracker",
    CurrentValue = Config.Misc.Extra.StatsTracker,
    Flag = "ToggleStatsTracker",
	Callback = function(Value)
        Config.Misc.Extra.StatsTracker = Value
        EnableStatsTracker()
    end
})

MiscTab:CreateToggle({
	Name = "Reduce Lag",
    CurrentValue = Config.Misc.Extra.ReduceLag,
    Flag = "ToggleReduceLag",
	Callback = function(Value)
        Config.Misc.Extra.ReduceLag = Value
        if Config.Misc.Extra.ReduceLag then
            local a = game
            local b = a.Workspace
            local c = a.Lighting
            local d = b.Terrain
            d.WaterWaveSize = 0
            d.WaterWaveSpeed = 0
            d.WaterReflectance = 0
            d.WaterTransparency = 0
            c.GlobalShadows = false
            c.FogEnd = 9e9
            c.Brightness = 0
            settings().Rendering.QualityLevel = "Level01"
            for e, f in pairs(a:GetDescendants()) do
               if f:IsA("Part") or f:IsA("Union") or f:IsA("CornerWedgePart") or f:IsA("TrussPart") then
                   f.Material = "Plastic"
                   f.Reflectance = 0
               elseif f:IsA("Decal") or f:IsA("Texture") then
                   f.Transparency = 0
               elseif f:IsA("ParticleEmitter") or f:IsA("Trail") then
                   f.Lifetime = NumberRange.new(0)
               elseif f:IsA("Explosion") then
                   f.BlastPressure = 0
                   f.BlastRadius = 0
               elseif f:IsA("Fire") or f:IsA("SpotLight") or f:IsA("Smoke") or f:IsA("Sparkles") then
                   f.Enabled = false
               elseif f:IsA("MeshPart") then
                   f.Material = "Plastic"
                   f.Reflectance = 0
                   f.TextureID = 10385902758728957
               end
            end
            for e, g in pairs(c:GetChildren()) do
               if
                   g:IsA("BlurEffect") or g:IsA("SunRaysEffect") or g:IsA("ColorCorrectionEffect") or g:IsA("BloomEffect") or
                       g:IsA("DepthOfFieldEffect")
                then
                   g.Enabled = false
               end
            end
            sethiddenproperty(game.Lighting, "Technology", "Compatibility")
        end
    end
})

local PetCollectionTab = Window:CreateTab("Pet Collection (ðŸ–¥ï¸)")

local CollectionSettingsSection = PetCollectionTab:CreateSection("Settings For Pet Collection")

local CollectionStats = PetCollectionTab:CreateParagraph({Title = "Statistics", Content = "Pets Collected: "..#Library.Save.Get().Collection.."/"..#Library.Shared.GetAllCollectablePets()})

PetCollectionTab:CreateToggle({
	Name = "Start Collecting Pets",
    CurrentValue = Config.PetCollection.StartCollecting,
    Flag = "ToggleCollectingPets",
	Callback = function(Value)
        Config.PetCollection.StartCollecting = Value
        task.spawn(function()
            while Config.PetCollection.StartCollecting and task.wait() do
                CollectPets()
                CollectionStats:Set({Title = "Statistics", Content = "Pets Collected: "..#Library.Save.Get().Collection.."/"..#Library.Shared.GetAllCollectablePets()})
            end
        end)
    end
})

PetCollectionTab:CreateDropdown({
	Name = "Choose Mode",
	CurrentOption = Config.PetCollection.Mode,
	Options = {"Single", "Triple", "Octuple"},
    Flag = "CollectionModeOption",
	Callback = function(Value)
		Config.PetCollection.Mode = Value
	end
})

local SelectedCollectingOptions = PetCollectionTab:CreateParagraph({Title = "Selected Types", Content = table.concat(Config.PetCollection.Options, ", ")})

PetCollectionTab:CreateDropdown({
	Name = "Choose Types",
	CurrentOption = "",
	Options = TypesForCollectionList,
	Callback = function(Value)
        if not table.find(Config.PetCollection.Options, Value) then
            table.insert(Config.PetCollection.Options, Value)
        elseif table.find(Config.PetCollection.Options, Value) then
            for i,v in pairs(Config.PetCollection.Options) do
                if v == Value then
                    table.remove(Config.PetCollection.Options, i)
                end
            end
        end
        SelectedCollectingOptions:Set({Title = "Selected Types", Content = table.concat(Config.PetCollection.Options, ", ")})
	end
})

local SelectedCollectionRarities = PetCollectionTab:CreateParagraph({Title = "Selected Rarities", Content = table.concat(Config.PetCollection.Rarities, ", ")})

PetCollectionTab:CreateDropdown({
	Name = "Choose Rarities",
	CurrentOption = "",
	Options = RaritiesWithoutExclusiveList,
	Callback = function(Value)
        if not table.find(Config.PetCollection.Rarities, Value) then
            table.insert(Config.PetCollection.Rarities, Value)
        elseif table.find(Config.PetCollection.Rarities, Value) then
            for i,v in pairs(Config.PetCollection.Rarities) do
                if v == Value then
                    table.remove(Config.PetCollection.Rarities, i)
                end
            end
        end
        SelectedCollectionRarities:Set({Title = "Selected Rarities", Content = table.concat(Config.PetCollection.Rarities, ", ")})
	end
})

local MasteryTab = Window:CreateTab("Mastery (âœ¨)")

local MasterySettingsSection = MasteryTab:CreateSection("Settings For Mastery")

MasteryTab:CreateToggle({
	Name = "Start Completing Mastery",
    CurrentValue = Config.Mastery.StartCompletingMasterys,
    Flag = "ToggleCompleteMasterys",
	Callback = function(Value)
        Config.Mastery.StartCompletingMasterys = Value
        task.spawn(function()
            while Config.Mastery.StartCompletingMasterys and task.wait() do
                CompleteMasterys()
            end
        end)
    end
})

local SelectedMasterys = MasteryTab:CreateParagraph({Title = "Selected Masteries", Content = table.concat(Config.Mastery.MasterysToFarm, ", ")})

MasteryTab:CreateDropdown({
	Name = "Choose Masteries",
	CurrentOption = "",
	Options = MasteryList,
	Callback = function(Value)
        if not table.find(Config.Mastery.MasterysToFarm, Value) then
            table.insert(Config.Mastery.MasterysToFarm, Value)
        elseif table.find(Config.Mastery.MasterysToFarm, Value) then
            for i,v in pairs(Config.Mastery.MasterysToFarm) do
                if v == Value then
                    table.remove(Config.Mastery.MasterysToFarm, i)
                end
            end
        end
        SelectedMasterys:Set({Title = "Selected Masteries", Content = table.concat(Config.Mastery.MasterysToFarm, ", ")})
	end
})


local GuisTab = Window:CreateTab("GUIs (ðŸ”–)")

local GuiSettings = GuisTab:CreateSection("Settings For Guis")

GuisTab:CreateToggle({
	Name = "Walk To Gui Location",
    CurrentValue = Config.Guis.WalkToGui,
    Flag = "ToggleWalkToGui",
	Callback = function(Value)
        Config.Guis.WalkToGui = Value
    end
})

local GuisMachinesSection = GuisTab:CreateSection("Machines")

GuisTab:CreateKeybind({
	Name = "Golden Machine",
	CurrentKeybind = Config.Guis.GuiMachines.GoldenMachine,
	HoldToInteract = false,
	Flag = "GoldenMachineKeybind",
	Callback = function(Keybind)
        Config.Guis.GuiMachines.GoldenMachine = Keybind
        pcall(function()
            getsenv(Scripts.GUIs.Teleport).Teleport("Shop")
            if Config.Guis.WalkToGui then
                task.wait(5)
                FindPath(Workspace["__MAP"].Interactive["Gold Machine"].Pad)
            else
                GetHumanoidRootPart().CFrame = Workspace["__MAP"].Interactive["Gold Machine"].Pad.CFrame
            end
        end)
    end
})

GuisTab:CreateKeybind({
	Name = "Rainbow Machine",
	CurrentKeybind = Config.Guis.GuiMachines.RainbowMachine,
	HoldToInteract = false,
	Flag = "RainbowMachineKeybind",
	Callback = function(Keybind)
        Config.Guis.GuiMachines.GoldenMachine = Keybind
        pcall(function()
            getsenv(Scripts.GUIs.Teleport).Teleport("Mine")
            if Config.Guis.WalkToGui then
                task.wait(5)
                FindPath(Workspace["__MAP"].Interactive["Rainbow Machine"].Pad)
            else
                GetHumanoidRootPart().CFrame = Workspace["__MAP"].Interactive["Rainbow Machine"].Pad.CFrame
            end
        end)
	end
})

GuisTab:CreateKeybind({
	Name = "Dark Matter Machine",
	CurrentKeybind = Config.Guis.GuiMachines.DarkMatterMachine,
	HoldToInteract = false,
	Flag = "DarkMatterKeybind",
	Callback = function(Keybind)
        Config.Guis.GuiMachines.DarkMatterMachine = Keybind
        pcall(function()
            getsenv(Scripts.GUIs.Teleport).Teleport("Dark Tech")
            if Config.Guis.WalkToGui then
                task.wait(5)
                FindPath(Workspace["__MAP"].Interactive["Dark Matter Machine"].Pad)
            else
                GetHumanoidRootPart().CFrame = Workspace["__MAP"].Interactive["Dark Matter Machine"].Pad.CFrame
            end
        end)
    end
})

GuisTab:CreateKeybind({
	Name = "Fuse Machine",
	CurrentKeybind = Config.Guis.GuiMachines.FuseMachine,
	HoldToInteract = false,
	Flag = "FuseMachineKeybind",
	Callback = function(Keybind)
        Config.Guis.GuiMachines.FuseMachine = Keybind
        pcall(function()
            getsenv(Scripts.GUIs.Teleport).Teleport("Beach")
            if Config.Guis.WalkToGui then
                task.wait(5)
                FindPath(Workspace["__MAP"].Interactive["Fuse Pets"].Pad)
            else
                GetHumanoidRootPart().CFrame = Workspace["__MAP"].Interactive["Fuse Pets"].Pad.CFrame
            end
        end)
    end
})

GuisTab:CreateKeybind({
	Name = "Enchant Machine",
	CurrentKeybind = Config.Guis.GuiMachines.EnchantMachine,
	HoldToInteract = false,
	Flag = "EnchantMachineKeybind",
	Callback = function(Keybind)
        Config.Guis.GuiMachines.EnchantMachine = Keybind
        pcall(function()
            getsenv(Scripts.GUIs.Teleport).Teleport("Enchanted Forest")
            if Config.Guis.WalkToGui then
                task.wait(5)
                FindPath(Workspace["__MAP"].Interactive["Enchanting"].Pad)
            else
                GetHumanoidRootPart().CFrame = Workspace["__MAP"].Interactive["Enchanting"].Pad.CFrame
            end
        end)
    end
})

GuisTab:CreateKeybind({
	Name = "Bank Machine",
	CurrentKeybind = Config.Guis.GuiMachines.BankMachine,
	HoldToInteract = false,
	Flag = "BankMachineKeybind",
	Callback = function(Keybind)
        Config.Guis.GuiMachines.BankMachine = Keybind
        pcall(function()
            getsenv(Scripts.GUIs.Teleport).Teleport("Shop")
            if Config.Guis.WalkToGui then
                task.wait(5)
                FindPath(Workspace["__MAP"].Interactive["Bank"].Pad)
            else
                GetHumanoidRootPart().CFrame = Workspace["__MAP"].Interactive["Bank"].Pad.CFrame
            end
        end)
    end
})

GuisTab:CreateKeybind({
	Name = "Server Boost Machine",
	CurrentKeybind = "V",
	HoldToInteract = false,
	Flag = "ServerBoostMachineKeybind",
	Callback = function(Keybind)
        Config.Guis.GuiMachines.ServerBoostMachine = Keybind
        pcall(function()
            getsenv(Scripts.GUIs.Teleport).Teleport("The Void")
            if Config.Guis.WalkToGui then
                task.wait(5)
                FindPath(Workspace["__MAP"].Interactive["Boost Machine"].Pad)
            else
                GetHumanoidRootPart().CFrame = Workspace["__MAP"].Interactive["Boost Machine"].Pad.CFrame
            end
        end)
    end
})

local WebhooksTab = Window:CreateTab("Webhooks (ðŸ“¬)")

local WebhookHatchingSection = WebhooksTab:CreateSection("Hatching")

local OldSavedHatchedPets = Library.Save.Get().Pets
WebhooksTab:CreateToggle({
	Name = "Start Hatch Webhook",
    CurrentValue = Config.Webhooks.HatchWebhook.StartWebhook,
    Flag = "ToggleStartHatchWebhook",
	Callback = function(Value)
        Config.Webhooks.HatchWebhook.StartWebhook = Value
        if getgenv().OpenEggConnection then getgenv().OpenEggConnection:Disconnect() end
        task.spawn(function()
            repeat task.wait() until RemotesLoaded
            LPH_NO_VIRTUALIZE(function()
                getgenv().OpenEggConnection = Library.Network.Fired("Open Egg"):Connect(function(EggName, PetsTable)
                    for i,v in pairs(PetsTable) do
                        repeat task.wait() until CheckForPet(v.uid)
                        local ReadyToSendHatchWebhook = false
                        if (table.find(Config.Webhooks.HatchWebhook.Rarities, "Basic") and Library.Directory.Pets[v.id].rarity == "Basic") or (table.find(Config.Webhooks.HatchWebhook.Rarities, "Rare") and Library.Directory.Pets[v.id].rarity == "Rare") or (table.find(Config.Webhooks.HatchWebhook.Rarities, "Epic") and Library.Directory.Pets[v.id].rarity == "Epic") or (table.find(Config.Webhooks.HatchWebhook.Rarities, "Legendary") and Library.Directory.Pets[v.id].rarity == "Legendary") or (table.find(Config.Webhooks.HatchWebhook.Rarities, "Mythical") and Library.Directory.Pets[v.id].rarity == "Mythical") or (table.find(Config.Webhooks.HatchWebhook.Rarities, "Secret") and Library.Directory.Pets[v.id].rarity == "Secret") or (table.find(Config.Webhooks.HatchWebhook.Rarities, "Exclusive") and Library.Directory.Pets[v.id].rarity == "Exclusive")  then
                            ReadyToSendHatchWebhook = true
                        end
                        if ReadyToSendHatchWebhook and Config.Webhooks.HatchWebhook.StartWebhook then
                            SendHatchWebhook(v, EggName)
                        end
                        if v.powers then
                            SendMiscHatchWebhook(v, EggName)
                        end
                    end
                end)
            end)()
        end)
    end
})


WebhooksTab:CreateInput({
	Name = "Discord Webhook",
	PlaceholderText  = Config.Webhooks.HatchWebhook.ChoosenWebhook,
	RemoveTextAfterFocusLost  = false,
	Callback = function(Value)
        Config.Webhooks.HatchWebhook.ChoosenWebhook = Value
	end
})

WebhooksTab:CreateToggle({
	Name = "Ping User",
    CurrentValue = Config.Webhooks.HatchWebhook.PingUser,
    Flag = "ToggleHatchPingUser",
	Callback = function(Value)
        Config.Webhooks.HatchWebhook.PingUser = Value
    end
})

WebhooksTab:CreateInput({
	Name = "ID To Ping",
	PlaceholderText  = Config.Webhooks.HatchWebhook.ChoosenUserID,
	RemoveTextAfterFocusLost  = false,
	Callback = function(Value)
		Config.Webhooks.HatchWebhook.ChoosenUserID = Value
	end
})

WebhooksTab:CreateToggle({
	Name = "Show Chances",
    CurrentValue = Config.Webhooks.HatchWebhook.ShowChances,
    Flag = "ToggleHatchShowChances",
	Callback = function(Value)
        Config.Webhooks.HatchWebhook.ShowChances = Value
    end
})

WebhooksTab:CreateToggle({
	Name = "Show Eggs Hatched",
    CurrentValue = Config.Webhooks.HatchWebhook.ShowEggsHatched,
    Flag = "ToggleHatchShowEggsHatched",
	Callback = function(Value)
        Config.Webhooks.HatchWebhook.ShowEggsHatched = Value
    end
})

WebhooksTab:CreateToggle({
	Name = "Show Eggs Remaining",
    CurrentValue = Config.Webhooks.HatchWebhook.ShowEggsRemaining,
    Flag = "ToggleHatchShowEggsRemaining",
	Callback = function(Value)
        Config.Webhooks.HatchWebhook.ShowEggsRemaining = Value
    end
})

WebhooksTab:CreateToggle({
	Name = "Show Currency Remaining",
    CurrentValue = Config.Webhooks.HatchWebhook.ShowCurrencyRemaining,
    Flag = "ToggleHatchShowCurrencyRemaining",
	Callback = function(Value)
        Config.Webhooks.HatchWebhook.ShowCurrencyRemaining = Value
    end
})

WebhooksTab:CreateToggle({
	Name = "Show Strength",
    CurrentValue = Config.Webhooks.HatchWebhook.ShowStrength,
    Flag = "ToggleHatchShowStrength",
	Callback = function(Value)
        Config.Webhooks.HatchWebhook.ShowStrength = Value
    end
})

WebhooksTab:CreateToggle({
	Name = "Show Enchants",
    CurrentValue = Config.Webhooks.HatchWebhook.ShowEnchants,
    Flag = "ToggleHatchShowEnchants",
	Callback = function(Value)
        Config.Webhooks.HatchWebhook.ShowEnchants = Value
    end
})

local WebhookPetRarities = WebhooksTab:CreateSection("Rarities")

local SelectedHatchRarities = WebhooksTab:CreateParagraph({Title = "Selected Rarities", Content = table.concat(Config.Webhooks.HatchWebhook.Rarities, ", ")})

WebhooksTab:CreateDropdown({
	Name = "Choose Rarities",
	CurrentOption = "",
	Options = RaritiesList,
	Callback = function(Value)
        if not table.find(Config.Webhooks.HatchWebhook.Rarities, Value) then
            table.insert(Config.Webhooks.HatchWebhook.Rarities, Value)
        elseif table.find(Config.Webhooks.HatchWebhook.Rarities, Value) then
            for i,v in pairs(Config.Webhooks.HatchWebhook.Rarities) do
                if v == Value then
                    table.remove(Config.Webhooks.HatchWebhook.Rarities, i)
                end
            end
        end
        SelectedHatchRarities:Set({Title = "Selected Rarities", Content = table.concat(Config.Webhooks.HatchWebhook.Rarities, ", ")})
	end
})

local WebhookSellingSection = WebhooksTab:CreateSection("Selling")

WebhooksTab:CreateToggle({
	Name = "Start Sell Webhook",
    CurrentValue = Config.Webhooks.SellWebhook.StartWebhook,
    Flag = "ToggleStartSellWebhook",
	Callback = function(Value)
        Config.Webhooks.SellWebhook.StartWebhook = Value
    end
})

WebhooksTab:CreateInput({
	Name = "Discord Webhook",
	PlaceholderText  = Config.Webhooks.SellWebhook.ChoosenWebhook,
	RemoveTextAfterFocusLost  = false,
	Callback = function(Value)
        Config.Webhooks.SellWebhook.ChoosenWebhook = Value
	end
})

WebhooksTab:CreateToggle({
	Name = "Ping User",
    CurrentValue = Config.Webhooks.SellWebhook.PingUser,
    Flag = "ToggleSellPingUser",
	Callback = function(Value)
        Config.Webhooks.SellWebhook.PingUser = Value
    end
})

WebhooksTab:CreateInput({
	Name = "ID To Ping",
	PlaceholderText  = Config.Webhooks.SellWebhook.ChoosenUserID,
	RemoveTextAfterFocusLost  = false,
	Callback = function(Value)
		Config.Webhooks.SellWebhook.ChoosenUserID = Value
	end
})

WebhooksTab:CreateToggle({
	Name = "Show Bought For",
    CurrentValue = Config.Webhooks.SellWebhook.ShowSoldFor,
    Flag = "ToggleSellShowBoughtFor",
	Callback = function(Value)
        Config.Webhooks.SellWebhook.ShowSoldFor = Value
    end
})

WebhooksTab:CreateToggle({
	Name = "Show Total Gems",
    CurrentValue = Config.Webhooks.SellWebhook.ShowTotalGems,
    Flag = "ToggleSellShowTotalGems",
	Callback = function(Value)
        Config.Webhooks.SellWebhook.ShowTotalGems = Value
    end
})

WebhooksTab:CreateToggle({
	Name = "Show Bought By",
    CurrentValue = Config.Webhooks.SellWebhook.ShowPurchasedBy,
    Flag = "ToggleSellShowBoughtBy",
	Callback = function(Value)
        Config.Webhooks.SellWebhook.ShowPurchasedBy = Value
    end
})

if Premium then
local WebhookSnipingSection = WebhooksTab:CreateSection("Sniping")
 
WebhooksTab:CreateToggle({
	Name = "Start Snipe Webhook",
    CurrentValue = Config.Webhooks.SnipeWebhook.StartWebhook,
    Flag = "ToggleStartSnipeWebhook",
	Callback = function(Value)
        Config.Webhooks.SnipeWebhook.StartWebhook = Value
    end
})

WebhooksTab:CreateInput({
	Name = "Discord Webhook",
	PlaceholderText  = Config.Webhooks.SnipeWebhook.ChoosenWebhook,
	RemoveTextAfterFocusLost  = false,
	Callback = function(Value)
        Config.Webhooks.SnipeWebhook.ChoosenWebhook = Value
	end
})

WebhooksTab:CreateToggle({
	Name = "Ping User",
    CurrentValue = Config.Webhooks.SnipeWebhook.PingUser,
    Flag = "ToggleSnipePingUser",
	Callback = function(Value)
        Config.Webhooks.SnipeWebhook.PingUser = Value
    end
})

WebhooksTab:CreateInput({
	Name = "ID To Ping",
	PlaceholderText  = Config.Webhooks.SnipeWebhook.ChoosenUserID,
	RemoveTextAfterFocusLost  = false,
	Callback = function(Value)
		Config.Webhooks.SnipeWebhook.ChoosenUserID = Value
	end
})

WebhooksTab:CreateToggle({
	Name = "Show Gems Sniped For",
    CurrentValue = Config.Webhooks.SnipeWebhook.ShowGemsSnipedFor,
    Flag = "ToggleSnipeShowGemsSnipedFor",
	Callback = function(Value)
        Config.Webhooks.SnipeWebhook.ShowGemsSnipedFor = Value
    end
})

WebhooksTab:CreateToggle({
	Name = "Show Gems Remaining",
    CurrentValue = Config.Webhooks.SnipeWebhook.ShowGemsRemaining,
    Flag = "ToggleSnipeShowGemsRemaining",
	Callback = function(Value)
        Config.Webhooks.SnipeWebhook.ShowGemsRemaining = Value
    end
})

WebhooksTab:CreateToggle({
	Name = "Show Owner",
    CurrentValue = Config.Webhooks.SnipeWebhook.ShowOwner,
    Flag = "ToggleSnipeShowOwner",
	Callback = function(Value)
        Config.Webhooks.SnipeWebhook.ShowOwner = Value
    end
})

WebhooksTab:CreateToggle({
	Name = "Show Strength",
    CurrentValue = Config.Webhooks.SnipeWebhook.ShowStrength,
    Flag = "ToggleSnipeShowStrength",
	Callback = function(Value)
        Config.Webhooks.SnipeWebhook.ShowStrength = Value
    end
})

WebhooksTab:CreateToggle({
	Name = "Show Enchants",
    CurrentValue = Config.Webhooks.SnipeWebhook.ShowEnchants,
    Flag = "ToggleSnipeShowEnchants",
	Callback = function(Value)
        Config.Webhooks.SnipeWebhook.ShowEnchants = Value
    end
})
end

local ConfigTab = Window:CreateTab("Config (ðŸ’¾)")

local LoadDeleteSection = ConfigTab:CreateSection("Load/Delete Config")

ConfigTab:CreateToggle({
	Name = "Auto Load Config",
    CurrentValue = IsLoadConfig,
	Callback = function(Value)
        IsLoadConfig = Value
        writefile("MilkUp/PetSimulatorX/GlobalSettings.json", HttpService:JSONEncode({["LoadConfig"] = IsLoadConfig, ["SeparateConfig"] = IsSeparateConfig}))
        IsLoadConfig = HttpService:JSONDecode(readfile("MilkUp/PetSimulatorX/GlobalSettings.json"))["LoadConfig"]
    end
})

ConfigTab:CreateToggle({
	Name = "Use Separate Config",
    CurrentValue = IsSeparateConfig,
	Callback = function(Value)
        IsSeparateConfig = Value
        writefile("MilkUp/PetSimulatorX/GlobalSettings.json", HttpService:JSONEncode({["LoadConfig"] = IsLoadConfig, ["SeparateConfig"] = IsSeparateConfig}))
        IsSeparateConfig = HttpService:JSONDecode(readfile("MilkUp/PetSimulatorX/GlobalSettings.json"))["SeparateConfig"]
    end
})

ConfigTab:CreateButton({
	Name = "Save Config",
	Callback = function()
        SaveConfig()
  	end
})


ConfigTab:CreateButton({
	Name = "Delete Config",
	Callback = function()
        DeleteConfig()
  	end
})

local ExtraConfigSection = ConfigTab:CreateSection("Extra Config Options")

local ConfigInputed
ConfigTab:CreateInput({
	Name = "Insert Config",
	PlaceholderText  = "Insert Here",
	RemoveTextAfterFocusLost  = false,
	Callback = function(Value)
        local ConfigJSONSuccess, ConfigJSONError = pcall(function() HttpService:JSONDecode(Value) end)
        if ConfigJSONSuccess then
            ConfigInputed = HttpService:JSONDecode(Value)
        end
	end
})

ConfigTab:CreateButton({
	Name = "Set Config",
	Callback = function()
        writefile(ConfigName, HttpService:JSONEncode(ConfigInputed))
  	end
})

ConfigTab:CreateButton({
	Name = "Copy Config",
	Callback = function()
        setclipboard(readfile(ConfigName))
  	end
})



RayField:Notify({
    Title = "UI Loaded",
    Content = "Script Took "..tick() - StartTick.. "s",
    Duration = 3,
})

RayField:Notify({
    Title = "Discord",
    Content = "Would You Like To Join The Discord To Stay Updated?",
    Duration = 3,
    Actions = {
        SendInvite = {
            Name = "Yes",
            Callback = function()
                HTTPRequest({ Url = "http://127.0.0.1:6463/rpc?v=1",
                Method = "POST",Headers = {["Content-Type"] = "application/json",
                    ["Origin"] = "https://discord.com"},
                        Body = game:GetService("HttpService"):JSONEncode({cmd = "INVITE_BROWSER",
                            args = {code = "tY2TN5mKCb"},
                                nonce = game:GetService("HttpService"):GenerateGUID(false)
                            }
                        )
                    }
                )
            end
		},
        IgnoreInvite = {
            Name = "No",
            Callback = function()
                return
            end
		},
	},
})

for i,v in pairs(game.Players:GetChildren()) do
    if v:IsInGroup(5060810) then
        Player:Kick("A Staff Was In Your Server (Protected By Milk Up)")
    end
end

task.spawn(function()
    Players.PlayerAdded:Connect(function(NewPlayer)
        pcall(function()
            if NewPlayer:IsInGroup(5060810) then                    
                Player:Kick("A Staff Has Joined Your Server (Protected By Milk Up)")
            end
        end)
    end)
end)

else
    return
end