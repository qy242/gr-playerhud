PlayerData = {}
isLoggedIn, inVehicle, driverSeat, Show, phoneOpen = false, false, false, false, false
playerPed, vehicle, vehicleClass, Fuel, vehicleClass = 0, 0, 0, 0, 0

QBCore = nil
Citizen.CreateThread(function() 
    while QBCore == nil do
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(200)
    end
    DisplayRadar(false)
end)

local bigMap = false
local onMap = false
local minimap = nil

Citizen.CreateThread(function()
    while true do
        playerPed = PlayerPedId()
        inVehicle = false
        if IsPedInAnyVehicle(PlayerPedId(), false)  then
            vehicle = GetVehiclePedIsIn(playerPed, false)
            vehicleClass = GetVehicleClass(vehicle)
            inVehicle = not IsVehicleModel(vehicle, `wheelchair`) and vehicleClass ~= 13 and not IsVehicleModel(vehicle, `windsurf`)
            vehicleClass = GetVehicleClass(vehicle)
            driverSeat = GetPedInVehicleSeat(vehicle, -1) == playerPed
            Fuel = GetVehicleFuelLevel(vehicle)
        end
        SendNUIMessage({
            type = 'tick',
            heal = 1,
            zirh = GetPedArmour(PlayerPedId()),
            stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId()),
            oxy = IsPedSwimmingUnderWater(playerPed) and GetPlayerUnderwaterTimeRemaining(PlayerId()) or 100,
            vehicle = inVehicle,
            phoneOpen = phoneOpen
        })
        Citizen.Wait(200)
    end
end)

-- RegisterCommand("hudfix", function()
--     firstLogin()
-- end)

local miniMapUi = false
function UIStuff()
    Citizen.CreateThread(function()
        while Show do
            Citizen.Wait(0)

            if inVehicle and not onMap then
                SetPedConfigFlag(playerPed, 35, false)
                onMap = true
                DisplayRadar(true)
                SetBlipAlpha(GetNorthRadarBlip(), 0)
            elseif not inVehicle and onMap then
                onMap = false
                DisplayRadar(false)
            end

            BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
            ScaleformMovieMethodAddParamInt(3)
            EndScaleformMovieMethod()

            if IsPauseMenuActive() then
                if miniMapUi then
                    SendNUIMessage({type = "ui", show = false})
                    miniMapUi = false
                end
            elseif IsPedInAnyVehicle(PlayerPedId(), true) and not IsPauseMenuActive() then
                if not miniMapUi then
                    TriggerEvent('gr-hud:carui')
                    SendNUIMessage({type = "ui", show = true})
                    miniMapUi = true
                end
            elseif not IsPauseMenuActive() then
                if not miniMapUi then
                    SendNUIMessage({type = "ui", show = true})
                    miniMapUi = true
                end
            end
        end
        onMap = false
    end)
end

RegisterNetEvent('SaltyChat_VoiceRangeChanged')
AddEventHandler('SaltyChat_VoiceRangeChanged', function(seviye)
    if seviye == 2 then
        SendNUIMessage({type = 'voice', lvl = "1"})
    elseif seviye == 6 then
        SendNUIMessage({type = 'voice', lvl = "2"})
    elseif seviye == 18 then
        SendNUIMessage({type = 'voice', lvl = "3"})
    end
end)

local normalKonusmaAktif = false
RegisterNetEvent('SaltyChat_TalkStateChanged')
AddEventHandler('SaltyChat_TalkStateChanged', function(status)
    if status and not normalKonusmaAktif then
        normalKonusmaAktif = true
        SendNUIMessage({type = 'speak', active = true})
    elseif not status and normalKonusmaAktif then
        normalKonusmaAktif = false
        SendNUIMessage({type = 'speak', active = false})
    end
end)

RegisterNetEvent("SaltyChat_PluginStateChanged")
AddEventHandler("SaltyChat_PluginStateChanged", function(state2)
    SendNUIMessage({
        type = 'salty',
        state = state2,
    })
end)

RegisterNetEvent('gr-hud:UpdateStatus')
AddEventHandler('gr-hud:UpdateStatus', function(Status)
    SendNUIMessage({
        action = "updateStatus",
        st = Status,
    })
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    firstLogin()
end)

function firstLogin()
    PlayerData = QBCore.Functions.GetPlayerData()
    TriggerEvent("hud:client:SetMoney")
    UIStuff()
    isLoggedIn = true
    Show = true
    DisplayHud(true)
    TriggerEvent("gr-hud:load-data")
end

RegisterNetEvent('gr-hud:ui')
AddEventHandler('gr-hud:ui', function(open)
    if open then 
        UIStuff()
        Show = true
        SendNUIMessage({type = 'ui', show = true})
    else
        Show = false
        SendNUIMessage({type = 'ui', show = false})
        DisplayRadar(false)
    end
end)

RegisterNetEvent('gr-hud:open-hud')
AddEventHandler('gr-hud:open-hud', function()
    if not Show then
        PlayerData = QBCore.Functions.GetPlayerData()
        TriggerEvent("gr-hud:load-data")
        SendNUIMessage({action = 'showui'})
        UIStuff()
        isLoggedIn = true
        Show = true
    end
    SetNuiFocus(true, true)
    SendNUIMessage({action = 'showMenu'})
end)

RegisterNUICallback('close-ayar-menu', function()
    SetNuiFocus(false, false)
end)

local disSes = false
Citizen.CreateThread(function()
    RegisterKeyMapping('+raidoSpeaker', 'Telsiz Hoparlör Modu', 'keyboard', 'F5')
end)

RegisterCommand("+raidoSpeaker", function()
    disSes = not disSes
    TriggerServerEvent("ls-radio:set-disses", disSes)
    SendNUIMessage({action = 'disSes', disSes = disSes})
end, false)

RegisterNetEvent('gr-hud:parasut')
AddEventHandler('gr-hud:parasut', function()
	GiveWeaponToPed(playerPed, `gadget_parachute`, 1, false, false)
	SetPedComponentVariation(playerPed, 5, 8, 3, 0)
end)

RegisterNetEvent('gr-hud:carui')
AddEventHandler('gr-hud:carui', function()
    SendNUIMessage({
        type = "inVeh",
        data = true
    })
end)

RegisterNetEvent('phone:open')
AddEventHandler('phone:open', function(bool)
    phoneOpen = bool
    if not phoneOpen then Citizen.Wait(500) end
    SendNUIMessage({type = 'phone', phoneOpen = phoneOpen})
end)