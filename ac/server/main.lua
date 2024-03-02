-- SuperStars_AC SERVER

local BanList = {}
local BlacklistedPropList = {}
local WhitelistedPropList = {}
local BlacklistedExplosionsList = {}
local canbanforentityspawn = false

if SuperStars_AC.UseESX then
    ESX = nil
end

if SuperStars_AC.UseESX then
    TriggerEvent(SuperStars_AC.ESXTrigger, function(obj) ESX = obj end)
end

-- Threads 

Citizen.CreateThread(function()
    Citizen.Wait(3000)
    while true do
        loadBanList()
        Citizen.Wait(SuperStars_AC.ReloadBanListTime)
    end
end)

Citizen.CreateThread(function()
    explosionsSpawned = {}
    vehiclesSpawned = {}
    pedsSpawned = {}
    entitiesSpawned = {}
    particlesSpawned = {}
    while true do
        Citizen.Wait(10000) -- augment/lower this if you want.
        explosionsSpawned = {}
        vehiclesSpawned = {}
        pedsSpawned = {}
        entitiesSpawned = {}
        particlesSpawned = {}
    end
end)

-- Reload Ban List

RegisterCommand('reloadsuperbans', function(source)
    local _src = source
    if _src ~= 0 then
        if IsPlayerAceAllowed(_src, "superbypass") then
            loadBanList()
            TriggerClientEvent('chat:addMessage', _src, {args = {"^*^7[^1SuperStars-AC^7]: Ban List Reloaded"}})
        end
    else
        loadBanList()
        print("^7[^1SuperStars-AC^7]: Ban List Reloaded")
    end
end, false)

-- Events

RegisterNetEvent('7ZYhfWQtmoA369TBJ5G8')
AddEventHandler('7ZYhfWQtmoA369TBJ5G8', function(resource, info)
    local _src = source
    LogDetection(_src, "Injection detected in resource: "..resource.. " Type: "..info, "basic")
    --kickandbanuser(""..SuperStars_AC.bankickmessage.." Injection detected", _src)
end)

RegisterNetEvent('5a1Ltc8fUyH3cPvAKRZ8')
AddEventHandler('5a1Ltc8fUyH3cPvAKRZ8', function()
    local _src = source
    if IsPlayerUsingSuperJump(_src) then
        LogDetection(_src, "SuperJump Detected.", "basic")
        --kickandbanuser(""..SuperStars_AC.bankickmessage.." SuperJump Detected", _src)
    end
end)

RegisterNetEvent('pcIRIvXPEWe12SxRepMz')
AddEventHandler('pcIRIvXPEWe12SxRepMz', function(targetid, coords)
    local _src = source
    local _tchar = ESX.GetPlayerFromId(targetid)
    local _tjob = _tchar.job.name
    if _tjob ~= 'ambulance' then -- Ambulance job name right here
        if not coords then
            LogDetection(_src, "Revive Detected.", "basic")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.."Revive Detected", _src)
        else
            TriggerClientEvent('ZRQA3nmMqUBOIiKwH4I5:cancelnoclip')
        end
    end
end)

RegisterNetEvent('luaVRV3cccsj9q6227jN')
AddEventHandler('luaVRV3cccsj9q6227jN', function(isneargarage)
    local _src = source
    if not isneargarage then
        LogDetection(_src, "Vehicle Spawn Detected.", "basic")
        --kickandbanuser(""..SuperStars_AC.bankickmessage.." Vehicle Spawn Detected", _src)
    end
end)

RegisterNetEvent('SBmQ5ucMg4WGbpPHoSTl')
AddEventHandler('SBmQ5ucMg4WGbpPHoSTl', function()
    local _src = source
    if not canbanforentityspawn then
        canbanforentityspawn = true
    end
    if IsPlayerAceAllowed(_src, "superbypass") then
        TriggerClientEvent('MEBjy6juCnscQrxcDzvs', _src)
    end
end)

RegisterNetEvent('cq1PxSiVi0iCw0maULS3')
AddEventHandler('cq1PxSiVi0iCw0maULS3', function()
    if IsPlayerAceAllowed(source, "superbypass") then
        TriggerClientEvent('ZRQA3nmMqUBOIiKwH4I5:clearvehicles', -1)
    end
end)

RegisterNetEvent('xsc8yaDNYGoCMvAWogff')
AddEventHandler('xsc8yaDNYGoCMvAWogff', function()
    if IsPlayerAceAllowed(source, "superbypass") then
        TriggerClientEvent('ZRQA3nmMqUBOIiKwH4I5:clearprops', -1)
    end
end)

RegisterNetEvent('m0QCCVqpGuCSLNBc60Tc')
AddEventHandler('m0QCCVqpGuCSLNBc60Tc', function()
    if IsPlayerAceAllowed(source, "superbypass") then
        TriggerClientEvent('ZRQA3nmMqUBOIiKwH4I5:clearpeds', -1)
    end
end)

-- EVENT HANDLERS

AddEventHandler("respawnPlayerPedEvent", function(player)
    TriggerClientEvent("ZRQA3nmMqUBOIiKwH4I5:checknearbypeds", player)
end)

AddEventHandler('ptFxEvent', function(sender, data)
    local _src = sender
    particlesSpawned[_src] = (particlesSpawned[_src] or 0) + 1
    if particlesSpawned[_src] > SuperStars_AC.MaxParticlesPerUser then
        LogDetection(_src, "Has tried to spawn "..particlesSpawned[_src].." particles","model")
        --kickandbanuser(""..SuperStars_AC.bankickmessage.." Mass Particle Spawn", _src)
    end
end)

AddEventHandler('playerConnecting', function (playerName,setKickReason, deferrals)
    local steamID, license, xblid, playerip, discord, liveid = getidentifiers(source)

    for i = 1, #BanList, 1 do
        if ((tostring(BanList[i].license)) == tostring(license) or (tostring(BanList[i].identifier)) == tostring(steamID) or (tostring(BanList[i].liveid)) == tostring(liveid) or (tostring(BanList[i].xblid)) == tostring(xblid) or (tostring(BanList[i].discord)) == tostring(discord) or (tostring(BanList[i].playerip)) == tostring(playerip)) then
            if (tonumber(BanList[i].permanent)) == 1 then
                setKickReason("[SuperStars-AC] You've been banned for: " .. BanList[i].reason)
                CancelEvent()
                print("^6[SuperStars-AC] - ".. GetPlayerName(source) .." is trying to connect to the server, but he's banned.")
                break
            end
        end
    end
    if SuperStars_AC.AntiVPN then
        local _playerip = tostring(GetPlayerEndpoint(source))
        deferrals.defer()
        Wait(0)
        deferrals.update("[SuperStars-AC]: Checking and securing your connection...")
        PerformHttpRequest("https://blackbox.ipinfo.app/lookup/" .. _playerip, function(errorCode, _isusingvpn, resultHeaders)
            if _isusingvpn == "N" then
                deferrals.done()
            else
                print("^6[SuperStars-AC]^0: The user ^0" .. playerName .. " ^1has been kicked for using a VPN, ^8IP: ^0" .. _playerip .. "^0")
                deferrals.done("[SuperStars-AC]: We've detected a VPN connection in your machine, please disable it.")
            end
        end)
    end
end)

RegisterServerEvent("Ue53dCG6hctHvrOaJB5Q")
AddEventHandler("Ue53dCG6hctHvrOaJB5Q", function(type, item)
    local _type = type or "default"
    local _item = item or "none"
    local _src = source
    _type = string.lower(_type)

    if not IsPlayerAceAllowed(_src, "superbypass") then
        if (_type == "invisible") then
            LogDetection(_src, "Tried to be Invisible","basic")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.." Invisible Player Detected", _src)
        elseif (_type == "godmode") then
            LogDetection(_src, "Tried to use GodMode. Type: ".._item,"basic")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.." GodMode Detected", _src)
        elseif (_type == "antiragdoll") then
            LogDetection(_src, "Tried to activate Anti-Ragdoll","basic")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.." AntiRagdoll Detected", _src)
        elseif (_type == "displayradar") then
            LogDetection(_src, "Tried to activate Radar","basic")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.." Radar Detected", _src)
        elseif (_type == "explosiveweapon") then
            LogDetection(_src, "Tried to change bullet type","explosion")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.." Weapon Explosion Detected", _src)
        elseif (_type == "nocliporfly") then
            LogDetection(_src, "Tried to use NoClip or Fly","basic")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.." Noclip/Fly Detected", _src)
        elseif (_type == "spectatormode") then
            LogDetection(_src, "Tried to Spectate a Player","basic")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.." Spectate Detected", _src)
        elseif (_type == "speedhack") then
            LogDetection(_src, "Tried to SpeedHack","basic")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.." SpeedHack Detected", _src)
        elseif (_type == "blacklistedweapons") then
            LogDetection(_src, "Tried to spawn a Blacklisted Weapon","basic")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.." Weapon in Blacklist Detected", _src)
        elseif (_type == "thermalvision") then
            LogDetection(_src, "Tried to use Thermal Camera","basic")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.." Thermal Camera Detected", _src)
        elseif (_type == "nightvision") then
            LogDetection(_src, "Tried to use Night Vision","basic")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.." Night Vision Detected", _src)
        elseif (_type == "antiresourcestop") then
            LogDetection(_src, "Tried to stop/start a Resource","basic")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.." Resource Stopped", _src)
        elseif (_type == "licenseclear") then
            LogDetection(_src, "Tried to Clear His Licenses","basic")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.." AntiLicenseClear", _src)
        elseif (_type == "luainjection") then
            LogDetection(_src, "Tried to Inject a Menu","basic")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.." Injection Detected", _src)
        elseif (_type == "keyboardinjection") then
            LogDetection(_src, "(AntiKeyBoardInjection)","basic")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.." Injection Detected", _src)
        elseif (_type == "cheatengine") then
            LogDetection(_src, "Tried to use CheatEngine to change Vehicle Hash","basic")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.." CheatEngine Detected", _src)
        elseif (_type == "pedchanged") then
            LogDetection(_src, "Tried to change his PED","model")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.." Ped Changed", _src)
        elseif (_type == "freecam") then
            LogDetection(_src, "Tried to use Freecam (Fallout or similar)","basic")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.." FreeCam Detected", _src)
        elseif (_type == "noclip") then
            LogDetection(_src, "Tried to use NoClip","basic")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.." NoClip Detected", _src)
        elseif (_type == "playerblips") then
            LogDetection(_src, "Tried to put Player Blips","basic")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.." Blips Detected", _src)
        elseif (_type == "damagemodifier") then
            LogDetection(_src, "Tried to change Weapon's Bullet Damage. Type: ".._item,"basic")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.." Weapon Damage Modifier Detected", _src)
        elseif (_type == "clipmodifier") then
            LogDetection(_src, "Tried to modify a Weapon clip. Type: ".._item,"basic")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.." Weapon Clip Modifier Detected", _src)
        elseif (_type == "infiniteammo") then
            LogDetection(_src, "Tried to put Infinite Ammo","basic")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.." Infinite Ammo Detected", _src)
        elseif (_type == "vehiclemodifier") then
            if SuperStars_AC.UseESX then
                local _char = ESX.GetPlayerFromId(_src)
                local _job = _char.job.name
                if type == 1 or type == 2 or type == 3 or type == 4 then
                    LogDetection(_src, "Tried to modify vehicle features. Type: ".._item,"model")
                    --kickandbanuser(""..SuperStars_AC.bankickmessage.." Vehicle Modifier Detected.", _src)
                else
                    if _job ~= 'mechanic' then -- Mechanic job name right here
                        LogDetection(_src, "Tried to modify vehicle features. Type: ".._item,"model")
                        --kickandbanuser(""..SuperStars_AC.bankickmessage.." Vehicle Modifier Detected.", _src)
                    end
                end
            else
                if type == 1 or type == 2 or type == 3 or type == 4 then
                    LogDetection(_src, "Tried to modify vehicle features. Type: ".._item,"model")
                    --kickandbanuser(""..SuperStars_AC.bankickmessage.." Vehicle Modifier Detected.", _src)
                end
            end
        elseif (_type == "stoppedac") then
            LogDetection(_src, "Tried to stop the Anticheat","basic")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.." AntiResourceStop", _src)
        elseif (_type == "stoppedresource") then
            LogDetection(_src, "Tried to stop a resource: ".._item,"basic")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.." AntiResourceStop", _src)
        elseif (_type == "resourcestarted") then
            LogDetection(_src, "Tried to start a resource: ".._item,"basic")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.." AntiResourceStart", _src)
        elseif (_type == "commandinjection") then
            LogDetection(_src, "Tried to inject a command.","basic")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.." AntiCommandInjection", _src)
        elseif (_type == "menyoo") then
            LogDetection(_src, "Tried to inject Menyoo Menu.","basic")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.." Anti Menyoo", _src)
        elseif (_type == "antisuicide") then
            LogDetection(_src, "Tried to SUICIDE using a menu","basic")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.." Anti Suicide", _src)
        elseif (_type == "givearmour") then
            LogDetection(_src, "Tried to Give Armor.","basic")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.." Anti Give Armor", _src)
        elseif (_type == "devtools") then
            LogDetection(_src, "Tried to open NUI_Devtools!","basic")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.." Anti NUI_Devtools", _src)
        end
    end
end)

-- EVENT HANDLERS

AddEventHandler("explosionEvent", function(sender, exp)
    if SuperStars_AC.ExplosionProtection then
        if exp.damageScale ~= 0.0 then
            if inTable(BlacklistedExplosionsList, exp.explosionType) ~= false then
                CancelEvent()
                LogDetection(sender, "Tried to create an explosion - type : "..exp.explosionType,"explosion")
                --kickandbanuser(""..SuperStars_AC.bankickmessage.." Blacklisted Explosion", sender)
            else
                LogDetection(sender, "Explosion Detected.","explosion")
            end
            if exp.explosionType ~= 9 then
                explosionsSpawned[sender] = (explosionsSpawned[sender] or 0) + 1
                if explosionsSpawned[sender] > 3 then
                    LogDetection(sender, "Tried to spawn mass explosions - type : "..exp.explosionType,"explosion")
                    --kickandbanuser(""..SuperStars_AC.bankickmessage.." Mass Explosions", sender)
                    CancelEvent()
                end
            else
                explosionsSpawned[sender] = (explosionsSpawned[sender] or 0) + 1
                if explosionsSpawned[sender] > 3 then
                    LogDetection(sender, "Tried to spawn mass explosions - type: (gas pump)","explosion")
                    --kickandbanuser(""..SuperStars_AC.bankickmessage.." Mass Explosions", sender)
                    CancelEvent()
                end
            end
            if exp.isInvisible == true then
                LogDetection(sender, "Tried to spawn a invisible explosion - type : "..exp.explosionType,"explosion")
                --kickandbanuser(""..SuperStars_AC.bankickmessage.." Invisible Explosion Detected", sender)
            end
            if exp.isAudible == false then
                LogDetection(sender, "Tried to spawn a silent explosion - type : "..exp.explosionType,"explosion")
                --kickandbanuser(""..SuperStars_AC.bankickmessage.." Silent Explosion Detected", sender)
            end
            if exp.damageScale > 1.0 then
                LogDetection(sender, "Tried to spawn a mortal explosion - type : "..exp.explosionType,"explosion")
                --kickandbanuser(""..SuperStars_AC.bankickmessage.." Explosión Detected", sender)
            end
            CancelEvent()
        end
    end
end)

AddEventHandler("entityCreating", function(entity)
    if canbanforentityspawn then
        if DoesEntityExist(entity) then
            local _src = NetworkGetEntityOwner(entity)
            local model = GetEntityModel(entity)
            local _entitytype = GetEntityPopulationType(entity)
            if _src == nil then
                CancelEvent()
            end

            -- I found some of this code while searching on GitHub. 
            -- If you're the one who created this and you want to get credit for this, open a issue ticket in GitHub with proof and I'll give you credits :)
            -- Btw I have modified this so it's a little bit more optimized.
            
            if _entitytype == 0 then
                if inTable(WhitelistedPropList, model) == false then
                    if model ~= 0 and model ~= 225514697 then
                        LogDetection(_src, "Tried to spawn a blacklisted prop : " .. model,"model")
                        --kickandbanuser(""..SuperStars_AC.bankickmessage.." Blacklisted Prop", _src)
                        CancelEvent()

                        entitiesSpawned[_src] = (entitiesSpawned[_src] or 0) + 1
                        if entitiesSpawned[_src] > SuperStars_AC.MaxEntitiesPerUser then
                            LogDetection(_src, "Tried to Spawn "..entitiesSpawned[_src].." props","model")
                            --kickandbanuser(""..SuperStars_AC.bankickmessage.." Mass Prop Spawn", _src)
                            TriggerClientEvent("ZRQA3nmMqUBOIiKwH4I5:clearprops" , -1)
                        end
                    end
                end
            end
            
            if GetEntityType(entity) == 3 then
                if _entitytype == 6 or _entitytype == 7 then
                    if inTable(WhitelistedPropList, model) == false then
                        if model ~= 0 then
                            LogDetection(_src, "Tried to spawn a blacklisted prop: " .. model,"model")
                            --kickandbanuser(""..SuperStars_AC.bankickmessage.." Blacklisted Prop", _src)
                            CancelEvent()

                            entitiesSpawned[_src] = (entitiesSpawned[_src] or 0) + 1
                            if entitiesSpawned[_src] > SuperStars_AC.MaxPropsPerUser then
                                LogDetection(_src, "Ha intentado spawnear "..entitiesSpawned[_src].." props","model")
                                --kickandbanuser(""..SuperStars_AC.bankickmessage.." Has Spawneado Muchos Props", _src)
                                TriggerClientEvent("ZRQA3nmMqUBOIiKwH4I5:clearprops" , -1)
                            end
                        end
                    end
                end
            else
                if GetEntityType(entity) == 2 then
                    if _entitytype == 6 or _entitytype == 7 then
                        if inTable(BlacklistedPropList, model) ~= false then
                            if model ~= 0 then
                                LogDetection(_src, "Tried to spawn a blacklisted vehicle : " .. model,"model")
                                --kickandbanuser(""..SuperStars_AC.bankickmessage.." Blacklisted Vehicle", _src)
                                CancelEvent()
                            end
                        end
                        vehiclesSpawned[_src] = (vehiclesSpawned[_src] or 0) + 1
                        if vehiclesSpawned[_src] > SuperStars_AC.MaxVehiclesPerUser then
                            LogDetection(_src, "Tried to spawn "..vehiclesSpawned[_src].." vehicles","model")
                            --kickandbanuser(""..SuperStars_AC.bankickmessage.." Mass Vehicle Spawn", _src)
                            TriggerClientEvent("ZRQA3nmMqUBOIiKwH4I5:clearvehicles" , -1)
                            CancelEvent()
                        end

                        -- ANTIVEHICLESPAWN
                        TriggerClientEvent('ZRQA3nmMqUBOIiKwH4I5:checkifneargarage', _src)
                    end
                elseif GetEntityType(entity) == 1 then
                    if _entitytype == 6 or _entitytype == 7 then
                        if inTable(BlacklistedPropList, model) ~= false then
                            if model ~= 0 or model ~= 225514697 then
                                LogDetection(_src, "Tried to spawn a blacklisted ped : " .. model,"model")
                                --kickandbanuser(""..SuperStars_AC.bankickmessage.." Blacklisted Ped", _src)
                                CancelEvent()
                            end
                        end
                        pedsSpawned[_src] = (pedsSpawned[_src] or 0) + 1
                        if pedsSpawned[_src] > SuperStars_AC.MaxPedsPerUser then
                            LogDetection(_src, "Tried to spawn "..pedsSpawned[_src].." peds","model")
                            --kickandbanuser(""..SuperStars_AC.bankickmessage.." Mass Ped Spawn", _src)
                            TriggerClientEvent("ZRQA3nmMqUBOIiKwH4I5:clearpeds" , -1)
                        end
                    end
                else
                    if inTable(BlacklistedPropList, GetHashKey(entity)) ~= false then
                        if model ~= 0 or model ~= 225514697 then
                            LogDetection(_src, "Tried to spawn a blacklisted prop : " .. model,"model")
                            --kickandbanuser(""..SuperStars_AC.bankickmessage.." Blacklisted Prop", _src)
                            CancelEvent()
                        end
                    end
                end
            end
        end
    end
end)

AddEventHandler("giveWeaponEvent", function(sender, data)
    if SuperStars_AC.AntiGiveorRemoveWeapons then
        if data.givenAsPickup == false then
            LogDetection(sender, "Tried to give weapons to player","basic")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.." GiveWeaponToPed", sender)
            CancelEvent()
        end
    end
end)

AddEventHandler("RemoveWeaponEvent", function(sender, data)
    LogDetection(sender, "Tried to remove weapons from player.","basic")
    --kickandbanuser(""..SuperStars_AC.bankickmessage.." Remove Weapons from Player", sender)
    CancelEvent()
end)

AddEventHandler("RemoveAllWeaponsEvent", function(sender, data)
    LogDetection(sender, "Tried to remove all weapons from player.","basic")
    --kickandbanuser(""..SuperStars_AC.bankickmessage.." Remove All Weapons", sender)
    CancelEvent()
end)

AddEventHandler("chatMessage", function(source, name, message)
    local _src = source
    if SuperStars_AC.AntiBlacklistedWords then
        for k, word in pairs(SuperStars_AC.BlacklistedWords) do
            if string.match(message:lower(), word:lower()) then
                LogDetection(_src, "Tried to say a blacklisted word : " .. word,"basic")
                --kickandbanuser(""..SuperStars_AC.bankickmessage.." Blacklisted Word", _src)
            end
        end
    end
    if SuperStars_AC.AntiFakeChatMessages then
        local _playername = GetPlayerName(_src);
        if name ~= _playername then
            LogDetection(_src, "Tried to fake a chat message : " .. word,"basic")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.." Fake Chat Message", _src)
        end
    end
end)

AddEventHandler("clearPedTasksEvent", function(source, data)
    if SuperStars_AC.AntiClearPedTasks then
        if data.immediately then
            LogDetection(source, "Tried to Clear Ped Tasks Inmediately","basic")
            --kickandbanuser(""..SuperStars_AC.bankickmessage.." Clear Peds Tasks Inmediately", source)
            CancelEvent()
        else
            LogDetection(source, "Tried to Clear Ped Tasks","basic")
            CancelEvent()
        end
        local entity = NetworkGetEntityFromNetworkId(data.pedId)
        local sender = tonumber(source)
        if DoesEntityExist(entity) then
            local owner = NetworkGetEntityOwner(entity)
            if owner ~= sender then
                LogDetection(source, "Tried to Clear Ped Tasks","basic")
                --kickandbanuser(""..SuperStars_AC.bankickmessage.." Clear Peds Tasks", source)
                CancelEvent()
            end
        end
    end
end)

-- FUNCS

kickandbanuser = function(reason, servertarget)
    if not IsPlayerAceAllowed(servertarget, "superbypass") then
        local target
        local duration     = 0
        local reason    = reason

        if not reason then reason = "Not Specified" end

        if tostring(source) == "" then
            target = tonumber(servertarget)
        else
            target = source
        end

        if target and target > 0 then
            local ping = GetPlayerPing(target)

            if ping and ping > 0 then
                if duration and duration < 365 then
                    local sourceplayername = "SuperStars-AC"
                    local targetplayername = GetPlayerName(target)
                    local identifier, license, xblid, playerip, discord, liveid = getidentifiers(target)

                    if duration > 0 then

                        if SuperStars_AC.ScreenShotHackers then
                        exports["discord-screenshot"]:requestClientScreenshotUploadToDiscord(
                            GetPlayers()[1],
                            {
                                username = "SuperStars ScreenShot",
                                avatar_url = "https://cdn.discordapp.com/attachments/934896669630287892/934943021475180594/Proiect_nou_27.png",
                                content = "",
                            },
                            30000,
                            function(error)
                                if error then
                                    return print("^1ERROR: " .. error)
                                end
                                print("Sent screenshot successfully")
                            end
                        )
                        Citizen.Wait(100)
                    end

                        --ban_user(target,license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duration,reason,0)
                        DropPlayer(target, "[SuperStars-AC]: "..SuperStars_AC.bankickmessage.." Reason: " .. reason)
                    else

                        if SuperStars_AC.ScreenShotHackers then
                            exports["discord-screenshot"]:requestClientScreenshotUploadToDiscord(
                                GetPlayers()[1],
                                {
                                    username = "SuperStars ScreenShot",
                                    avatar_url = "https://cdn.discordapp.com/attachments/934896669630287892/934943021475180594/Proiect_nou_27.png",
                                    content = "",
                                },
                                30000,
                                function(error)
                                    if error then
                                        return print("^1ERROR: " .. error)
                                    end
                                    print("Sent screenshot successfully")
                                end
                            )
                        Citizen.Wait(100)
                    end

                        --ban_user(target,license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duration,reason,1)
                        DropPlayer(target, "[SuperStars-AC]:" .. reason)
                    end
                end
            end
        end
    end
end

    ban_user = function(source,license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duration,reason,permanent)
        local expiration = duration * 86400
        local timeat     = os.time()

        if expiration < os.time() then
            expiration = os.time()+expiration
        end

        exports.oxmysql:execute('INSERT INTO SuperStars_AC (license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,reason,expiration,timeat,permanent) VALUES (@license,@identifier,@liveid,@xblid,@discord,@playerip,@targetplayername,@sourceplayername,@reason,@expiration,@timeat,@permanent)',{
            ['@license']          = license,
            ['@identifier']       = identifier,
            ['@liveid']           = liveid,
            ['@xblid']            = xblid,
            ['@discord']          = discord,
            ['@playerip']         = playerip,
            ['@targetplayername'] = targetplayername,
            ['@sourceplayername'] = sourceplayername,
            ['@reason']           = reason,
            ['@expiration']       = expiration,
            ['@timeat']           = timeat,
            ['@permanent']        = permanent,
            }, function ()
        end)

    Citizen.Wait(500)

    loadBanList()
end

loadBanList = function()
    exports.oxmysql:execute('SELECT * FROM SuperStars_AC', {}, function (data)
        BanList = {}
        for i=1, #data, 1 do
            table.insert(BanList, {
                license    = data[i].license,
                identifier = data[i].identifier,
                liveid     = data[i].liveid,
                xblid      = data[i].xblid,
                discord    = data[i].discord,
                playerip   = data[i].playerip,
                reason     = data[i].reason,
                expiration = data[i].expiration,
                permanent  = data[i].permanent
            })
        end
    end)
end

LogDetection = function(playerId, reason,bantype)
    playerId = tonumber(playerId)
    local name = GetPlayerName(playerId)

    if name == nil then
        name = "Not Found"
    end

    local steamid, license, xbl, playerip, discord, liveid = getidentifiers(playerId)
    local discordlogimage = "https://i.imgur.com/nN5KGWl.png" -- CREAR UNA IMAGEN Y PONERLA
    
    local loginfo = {["color"] = "15158332", ["type"] = "rich", ["title"] = "A player has been banned by SuperStars-AC", ["description"] =  "**Name : **" ..name .. "\n **Reason : **" ..reason .. "\n **ID : **" ..playerId .. "\n **IP : **" ..playerip.. "\n **Steam Hex : **" ..steamid .. "\n **Xbox Live : **" .. xbl .. "\n **Live ID: **" .. liveid .. "\n **Rockstar License : **" .. license .. "\n **Discord : **" .. discord, ["footer"] = { ["text"] = " © SuperStars | by rvaly & hyper - "..os.date("%c").."" }}
    if name ~= "Unknown" then
        if bantype == "basic" then
            PerformHttpRequest(SuperStars_AC.GeneralBanWebhook, function(err, text, headers) end, "POST", json.encode({username = " SuperStars-AC", avatar_url = discordlogimage, embeds = {loginfo}}), {["Content-Type"] = "application/json"})
        elseif bantype == "model" then
            PerformHttpRequest(SuperStars_AC.EntitiesWebhookLog, function(err, text, headers) end, "POST", json.encode({username = " SuperStars-AC", avatar_url = discordlogimage, embeds = {loginfo}}), {["Content-Type"] = "application/json"})
        elseif bantype == "explosion" then 
            PerformHttpRequest( SuperStars_AC.ExplosionWebhookLog, function(err, text, headers) end, "POST", json.encode({username = " SuperStars-AC", avatar_url = discordlogimage, embeds = {loginfo}}), {["Content-Type"] = "application/json"} )
        end
    end
end

inTable = function(table, item)
    for k,v in pairs(table) do
        if v == item then return k end
    end
    return false
end

getidentifiers = function(player)
    local steamid = "Not Linked"
    local license = "Not Linked"
    local discord = "Not Linked"
    local xbl = "Not Linked"
    local liveid = "Not Linked"
    local ip = "Not Linked"

    for k, v in pairs(GetPlayerIdentifiers(player)) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
        elseif string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
        elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
            xbl = v
        elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            ip = string.sub(v, 4)
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discordid = string.sub(v, 9)
            discord = "<@" .. discordid .. ">"
        elseif string.sub(v, 1, string.len("live:")) == "live:" then
            liveid = v
        end
    end

    return steamid, license, xbl, ip, discord, liveid
end

-- Resource Started Print (Don't remove this 😢)                                         

AddEventHandler('onResourceStart', function(resourceName)
    Citizen.Wait(1000)

    if GetCurrentResourceName() == resourceName then
        
        for k, v in pairs(SuperStars_AC.BlacklistedModels) do
            table.insert(BlacklistedPropList, GetHashKey(v))
        end
        
        for k,v in pairs(SuperStars_AC.WhitelistedProps) do
            table.insert(WhitelistedPropList, GetHashKey(v))
        end

        for k,v in pairs(SuperStars_AC.BlockedExplosions) do
            table.insert(BlacklistedExplosionsList, v)
        end

        if SuperStars_AC.AntiBlacklistedTriggers then

            for k, trigger in pairs(SuperStars_AC.BlacklistedTriggers) do
                RegisterServerEvent(trigger)
                AddEventHandler(trigger, function()
                    LogDetection(source, "Tried to execute a blacklisted trigger : " .. trigger,"basic")
                    --kickandbanuser(""..SuperStars_AC.bankickmessage.." Blacklisted Trigger", source)
                    CancelEvent()
                end)
            end

        end

        print([[
^5 SuperStars AC was started! Enjoy your AntiCheat. <3
^2 If you have any isues please join our discord server https://discord.gg/Tz8naH7YkN .
]])   

    end
end)  



-- SuperStars-AC INSTALLATION FUNCS

RegisterCommand("superuninstall", function(source, args, rawCommand)
    if source == 0 then
        count = 0
        skip = 0
        if args[1] then
            local filetodelete = args[1] .. ".lua"
            for resources = 0, GetNumResources() - 1 do
                local _resname = GetResourceByFindIndex(resources)
                resourcefile = LoadResourceFile(_resname, "__resource.lua")
                resourcefile2 = LoadResourceFile(_resname, "fxmanifest.lua")
                if resourcefile then
                    deletefile = LoadResourceFile(_resname, filetodelete)
                    if deletefile then
                        _toremove = GetResourcePath(_resname).."/"..filetodelete
                        Wait(100)
                        os.remove(_toremove)
                        print("^1[SuperStars-AC]: Anti Injection Uninstalled on ".._resname)
                        count = count + 1
                    else
                        skip = skip + 1
                        print("[SuperStars-AC]: Skipped Resource: " .._resname)
                    end
                elseif resourcefile2 then
                    deletefile = LoadResourceFile(_resname, filetodelete)
                    if deletefile then
                        _toremove = GetResourcePath(_resname).."/"..filetodelete
                        Wait(100)
                        os.remove(_toremove)
                        print("^1[SuperStars-AC]: Anti Injection Uninstalled on ".._resname)
                        count = count + 1
                    else
                        skip = skip + 1
                        print("[SuperStars-AC]: Skipped Resource: " .._resname)
                    end
                else
                    skip = skip + 1
                    print("[SuperStars-AC]: Skipped Resource: ".._resname)
                end
            end
            print("[SuperStars-AC] UNINSTALLATION has finished. Succesfully uninstalled Anti-Injection in "..count.." Resources. Skipped: "..skip.." Resources. Enjoy!")
        else
            print("[SuperStars-AC] You must write the file name to uninstall Anti-Injection!")
        end
    end
end)

RegisterCommand("superinstall", function(source)
    count = 0
    skip = 0
    if source == 0 then
        local randomtextfile = RandomLetter(12) .. ".lua"
        _antiinjection = LoadResourceFile(GetCurrentResourceName(), "SuperStars-AC(AntiInjection).lua")
        for resources = 0, GetNumResources() - 1 do
            local _resname = GetResourceByFindIndex(resources)
            _resourcemanifest = LoadResourceFile(_resname, "__resource.lua")
            _resourcemanifest2 = LoadResourceFile(_resname, "fxmanifest.lua")
            if _resourcemanifest then
                Wait(100)
                _toadd = _resourcemanifest .. "\n\nclient_script '" .. randomtextfile .. "'"
                SaveResourceFile(_resname, randomtextfile, _antiinjection, -1)
                SaveResourceFile(_resname, "__resource.lua", _toadd, -1)
                print("^1[SuperStars-AC]: Anti Injection Installed on ".._resname)
                count = count + 1
            elseif _resourcemanifest2 then
                Wait(100)
                _toadd = _resourcemanifest2 .. "\n\nclient_script '" .. randomtextfile .. "'"
                SaveResourceFile(_resname, randomtextfile, _antiinjection, -1)
                SaveResourceFile(_resname, "fxmanifest.lua", _toadd, -1)
                print("^1[SuperStars-AC]: Anti Injection Installed on ".._resname)
                count = count + 1
            else
                skip = skip + 1
                print("[SuperStars-AC]: Skipped Resource: " .._resname)
            end
        end
        print("[SuperStars-AC] Installation has finished. Succesfully installed Anti-Injection in "..count.." Resources. Skipped: "..skip.." Resources. Enjoy!")
    end
end)

local Charset = {}
for i = 65, 90 do
    table.insert(Charset, string.char(i))
end
for i = 97, 122 do
    table.insert(Charset, string.char(i))
end

RandomLetter = function(length)
    if length > 0 then
        return RandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
    end
    return ""
end


RegisterServerEvent('cooltrigger')
AddEventHandler('cooltrigger', function()
    local _source = source
    if SuperStars_AC.AntiDevTools then
            DropPlayer(_source, 'You got kicked because you used NUI-DEVTOOLS.')
    end
end)