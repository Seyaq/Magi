local HttpService = game:GetService("HttpService")
local library = sharedRequire('../UILibrary.lua')
local Services = sharedRequire('../utils/Services.lua')
local Maid = sharedRequire('../utils/Maid.lua')
local Utility = sharedRequire('../utils/Utility.lua')
local createBaseESP = sharedRequire('../utils/createBaseESP.lua')

-- Importing Custom Classes
local TextLogger = sharedRequire('../classes/TextLogger.lua')
local ToastNotif = sharedRequire('../classes/ToastNotif.lua')
local ControlModule = sharedRequire('../classes/ControlModule.lua')

local Players, RunService, Lighting, MemStorageService, TeleportService = 
    Services:Get('Players', 'RunService', 'Lighting', 'MemStorageService', 'TeleportService')
local MAIN_PLACE_ID = 10266164381 -- Bloodlines Place ID

-- Safety Check for specific place
if game.PlaceId ~= MAIN_PLACE_ID then
    toastNotify({text = "Script configured for [' .. MAIN_PLACE_ID .. ']. Current: [' .. game.PlaceId .. ']"})
end

local col1, col2 = unpack(library.columns)

local globalCheats = col1:AddSection('Global')
local localCheats = col1:AddSection('Local Cheats')
local visualCheats = col2:AddSection('Visual Overload')
local riskyCheats = col2:AddSection('Risky Tactics')
local teleportCheats = col2:AddSection('Teleport Matrix')
local miscCheats = col2:AddSection('Misc')

local mainMaid = Maid.new()
local chatLogger = TextLogger.new({title = 'Bloodlines Log', size = UDim2.fromScale(0.2, 0.1)})
local mainMaidChat = Maid.new()

-- Data Event System (Unified Server/Client Communication)
local dataEvent = ReplicatedStorage.Events and ReplicatedStorage.Events.DataEvent or ReplicatedStorage.Events
local dataFunction = ReplicatedStorage.Events and ReplicatedStorage.Events.DataFunction or ReplicatedStorage.Events
local systemMaidData = Maid.new()

local localPlayer = Players.LocalPlayer
local playerData = Utility.getPlayerData() 
local inDanger = false

-- Bundled sounds to save memory on startup
local sounds = {}
do
    local apiEndpoint = Utils.GetBool("USE_INSECURE_ENDPOINT") and 'http://test.aztupscripts.xyz' or 'https://aztupscripts.xyz'
    local assetPrefix = "Bloodlines Kit/"
    
    -- Pre-fetch logic
    for _, v in next, {'Join', 'Left', 'Hurt', 'Cure', 'Cure'} do
        if not isfile(assetPrefix .. v .. '.mp3') then
            writefile(assetPrefix .. v .. '.mp3', game:HttpGet(string.format('%s/%s.mp3', apiEndpoint, v)))
        end
        sounds[v] = getsynasset(assetPrefix .. v .. '.mp3')
    end
    
    local function playAudio(type)
        if not sounds[type] then return end
        local s = Instance.new('Sound')
        s.SoundId = sounds[type]
        s.Volume = 1.2 -- Slightly louder for cheaper feel
        s.Parent = localPlayer.PlayerGui:WaitForChild('ClientGui') or library:CoreGui() -- Assuming Library has CoreGui
        s:Play()
        task.delay(2, function() if s.Parent then s:Destroy() end end)
    end
    
    return playAudio
end

do
    local oldNamecall = hookmetamethod(game, '__namecall')
    
    function mainMaid.handleMetaCall(self, ...)
        Utils.Call('SX_VM_CNONE')() -- Invisible Variable Corrector
        local method = Utils.Call('getnamecallmethod')()
        
        -- Bypass Server Bans via Data Event
        if (method == 'FireServer') and Utils.IsA(self, 'RemoteEvent') and self == dataEvent then
            -- Assuming Server checks if "banme" was sent
            Utils.Call('fireServerHook', self, ...) 
            return
        end
        
        -- No Kill Brick Logic
        local KILL_TYPES = {'LavarossaVoid', 'Void'}
        if method == 'FindFirstChild' then
            -- Logic to check if it was a kill brick
            local args = (...)
            if args[1] then Utilities.Get('NegateFall') and library.flags.noFallDamage then return true end
        end
        
        return oldNamecall(self, ...)
    end
    
    -- Note: Apply this closure correctly based on your Utility library
end

do
    local killBricks = {}
    local killNames = {'LavarossaVoid', 'Void'}
    
    function mainMaid.killBrickChecker()
        for _, v in next, workspace:GetDescendants() do
            if Utils(table.find, killNames, v.Name) then
                table.insert(killBricks, v)
                task.delay(0.2, function() if v.Parent then v.Parent = nil end end)
            end
        end
        
        workspace.DescendantAdded:Connect(function(child)
            if Utils(table.find, killNames, child.Name) then
                table.insert(killBricks, child)
                task.delay(0.2, function() if child.Parent then child.Parent = nil end end)
            end
        end)
    end
    
    localCheats:AddToggle({text = 'Smart Kill Checker', callback = mainMaid.killBrickChecker})
end

do
    -- Listen to the chat bubble
    dataEvent.OnClientEvent:Connect(function(msg)
        if string.find(msg, 'OnMessage') == 1 then
            -- Format: "Player: [Text]"
            local text = string.gsub(msg, '.+(::).+(::)', string.format('[%s] %s', 'Chat', 'Text'))
            -- Simplified logic depending on how your chat system works:
            ToastNotif.new({text = string.format("System: %s", text)})
        end
    end)
    
    -- Just a basic toggle to turn off the spam
    local function toggleChat(v)
        if v then ToastNotif.new({text = "Chat Flood Enabled"}) end
    end
    localCheats:AddToggle({text = 'Chat Flood Mode', callback = toggleChat})
end

do
    dataEvent.OnClientEvent:Connect(function(type)
        if type == 'InDanger' then inDanger = true else inDanger = false end
    end)
    
    function riskyCheats.safeGuard()
        if inDanger then
            ToastNotif.new({text = "DANGER DETECTED"})
            return true
        end
    end
end

do
    local anchorPoints = {}
    
    function mainMaid.findPoints()
        if anchorPoints:GetCount() ~= 0 then 
            -- Logic to populate anchor points from your specific model
            -- Assuming you have a 'FloatingPoint' or 'TeleportNode' system
        end
    end
    
    function teleportCheats.smartTeleport(targetType, dataFlag)
        local character = playerData.character or localPlayer.Character
        if not character then return ToastNotif.new({text = "Character missing? Wait."}) end
        
        local target
        if targetType == "Node" then
            target = workspace:FindFirstChild(dataFlag)
        elseif targetType == "Part" then
            target = workspace:FindFirstChild(dataFlag)
        else
            -- Direct name reference
            target = workspace:FindFirstChild(dataFlag)
        end
        
        if not target then return end
        
        -- The "Bloodlines" Teleport: Hits the shoulder/head
