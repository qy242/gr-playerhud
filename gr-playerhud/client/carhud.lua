-- Lil Becha Bir Orospu Çocuğudur!
local tekerPatlak, sikiKemer, cruiseIsOn, seatbelt, vehIsMovingFwd, alarmset, engineRunning = false, false, false, false, false, false, false
local curSpeed, prevSpeed, kemerSayi, cruiseSpeed, speedLimit = 0.0, 0.0, 0, 999.0, 80.0
local prevVelocity = {x = 0.0, y = 0.0, z = 0.0}
local compassOn = true
local vehAcc = false
local inVehSetState = false
local clock = ""
local zoneNames = {
    AIRP = "Los Santos Uluslararası Havalimanı",
    ALAMO = "Alamo Denizi",
    ALTA = "Alta",
    ARMYB = "Fort Zancudo",
    BANHAMC = "Banham Kanyonu",
    BANNING = "Banning",
    BAYTRE = "Baytree Kanyonu", 
    BEACH = "Vespucci Sahili",
    BHAMCA = "Banham Kanyonu",
    BRADP = "Braddock Geçişi",
    BRADT = "Braddock Tüneli",
    BURTON = "Burton",
    CALAFB = "Calafia Köprüsü",
    CANNY = "Raton Kanyonu",
    CCREAK = "Cassidy Deresi",
    CHAMH = "Chamberlain Tepeleri",
    CHIL = "Vinewood Tepeleri",
    CHU = "Chumash",
    CMSW = "Chiliad Dağ Eyaleti",
    CYPRE = "Cypress Bölgesi",
    DAVIS = "Davis",
    DELBE = "Del Perro Sahili",
    DELPE = "Del Perro",
    DELSOL = "La Puerta",
    DESRT = "Grand Senora Çölü",
    DOWNT = "Downtown",
    DTVINE = "Downtown Vinewood",
    EAST_V = "Doğu Vinewood",
    EBURO = "El Burro Tepeleri",
    ELGORL = "El Gordo Deniz Feneri",
    ELYSIAN = "Elysian Adası",
    GALFISH = "Galilee",
    GALLI = "Galileo Parkı",
    golf = "GWC ve Golf Sosyetesi",
    GRAPES = "Grapeseed",
    GREATC = "Great Chaparral",
    HARMO = "Harmony",
    HAWICK = "Hawick",
    HORS = "Vinewood Yarış Pisti",
    HUMLAB = "Humane Laboratuvarı",
    JAIL = "Bolingbroke Arazisi",
    KOREAT = "Little Seoul",
    LACT = "Land Act Rezervuarı",
    LAGO = "Lago Zancudo",
    LDAM = "Land Act Barajı",
    LEGSQU = "Legion Meydanı",
    LMESA = "La Mesa",
    LOSPUER = "La Puerta",
    MIRR = "Mirror Parkı",
    MORN = "Morningwood",
    MOVIE = "Richards Majestic",
    MTCHIL = "Chiliad Dağı",
    MTGORDO = "Gordo Dağı",
    MTJOSE = "Josiah Dağı",
    MURRI = "Murrieta Tepeleri",
    NCHU = "North Chumash",
    NOOSE = "N.O.O.S.E",
    OCEANA = "Pasifik Okyanusu",
    PALCOV = "Paleto Koyu",
    PALETO = "Paleto Bay",
    PALFOR = "Paleto Ormanı",
    PALHIGH = "Palomino Tepeleri",
    PALMPOW = "Palmer-Taylor Enerji Santrali",
    PBLUFF = "Pasifik Uçurumu",
    PBOX = "Pillbox Tepesi",
    PROCOB = "Procopio Sahili",
    RANCHO = "Rancho",
    RGLEN = "Richman Glen",
    RICHM = "Richman",
    ROCKF = "Rockford Tepeleri",
    RTRAK = "Redwood Işıkları Pisti",
    SanAnd = "San Andreas",
    SANCHIA = "San Chianski Dağ Arazisi",
    SANDY = "Sandy Kıyıları",
    SKID = "Mission Row",
    SLAB = "Stab Şehri",
    STAD = "Maze Bank Arenası",
    STRAW = "Strawberry",
    TATAMO = "Tataviam Dağları",
    TERMINA = "Terminal",
    TEXTI = "Tekstil Şehri",
    TONGVAH = "Tongva Tepeleri",
    TONGVAV = "Tongva Vadisi",
    VCANA = "Vespucci Kanalları",
    VESP = "Vespucci",
    VINE = "Vinewood",
    WINDF = "Ron Alternates Rüzgar Çiftliği",
    WVINE = "West Vinewood",
    ZANCUDO = "Zancudo Deresi",
    ZP_ORT = "Güney Los Santos Limanı",
    ZQ_UAR = "Davis Quartz"
}

RegisterNetEvent("gr-hud:hizsabitle")
AddEventHandler("gr-hud:hizsabitle", function(args)
    if args[1] == nil then args[1] = 1 end
    if driverSeat and tonumber(args[1]) > 0 then
        if not IsVehicleTyreBurst(vehicle, 0) and not IsVehicleTyreBurst(vehicle, 1) and not IsVehicleTyreBurst(vehicle, 4) and not IsVehicleTyreBurst(vehicle, 5) then 
            cruiseIsOn = true
            cruiseSpeed = (tonumber(args[1] + 2) / 3.6)
        end
    end
end)

RegisterNetEvent("inventory:client:remove-item")
AddEventHandler("inventory:client:remove-item", function(item)
    if item == "kemer" then
        if sikiKemer then 
            if seatbelt then
                QBCore.Functions.Progressbar("seatbelt", "Sıkı Kemer Çıkartılıyor", 4000, false, false, { -- p1: menu name, p2: yazı, p3: ölü iken kullan, p4:iptal edilebilir
                    disableMovement = true,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function() -- Done
                    QBCore.Functions.Notify("Kemer Çıkarıldı", "error")
                    PlaySoundFrontend(-1, "Faster_Click", "RESPAWN_ONLINE_SOUNDSET", 1)
                    TriggerEvent('InteractSound_CL:PlayOnOne', 'kemercikar', 0.7)
                    seatbelt = false
                    sikiKemer = false
                end, function() -- Cancel
                end)
            end
        end
    end
end)

local offRoad = 0
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        if isLoggedIn then
            local hours = GetClockHours()
            local mins = GetClockMinutes()
            local cu = PlayerPedId()
            local arac = GetVehiclePedIsUsing(cu)
            if string.len(tostring(hours)) == 1 then hours = '0'..hours end
            if string.len(tostring(mins)) == 1 then mins = '0'..mins end
            clock = hours .. ':' .. mins

            local street = ""
            local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
            local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)
            local currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
            local intersectStreetName = GetStreetNameFromHashKey(intersectStreetHash)
            local zone = tostring(GetNameOfZone(x, y, z))
            
            if not zone then
                zone = "UNKNOWN"
                zoneNames['UNKNOWN'] = zone
            elseif not zoneNames[zone] then
                local undefinedZone = zone .. " " .. x .. " " .. y .. " " .. z
                zoneNames[zone] = "Bilinmiyor"
            end

            street = zoneNames[zone]
            
            if intersectStreetName ~= nil and intersectStreetName ~= "" then
                street = currentStreetName .. " | " .. intersectStreetName .. " | [" .. zoneNames[zone] .. "]"
            elseif currentStreetName ~= nil and currentStreetName ~= "" then
                street = currentStreetName .. " | [" .. zoneNames[zone] .. "]"
            else
                street = "[".. zoneNames[tostring(zone)] .. "]"
            end

            if inVehicle then 
                if not inVehSetState then
                    inVehSetState = true
                    SendNUIMessage({
                        type = "inVeh",
                        data = true
                    })
                end
                if GetIsVehicleEngineRunning(vehicle) then
                    if GetVehicleEngineHealth(vehicle) > 500 then
                        TriggerEvent('setCarIcon', 'engine', '#ffffff')
                    else
                        TriggerEvent('setCarIcon', 'engine', '#AD2323')
                    end
                else
                    TriggerEvent('setCarIcon', 'engine', '#ffffff40')
                end
                local sa, isik, ysx = GetVehicleLightsState(vehicle)
                if isik == 1 then
                    if ysx == 1 then
                        TriggerEvent('setCarIcon', 'headlight', '#4fc5f3')
                    elseif ysx == 0 then
                        TriggerEvent('setCarIcon', 'headlight', '#5bd510')
                    end
                elseif isik == 0 then
                    TriggerEvent('setCarIcon', 'headlight', '#ffffff40') 
                end
                local hubabibi = GetVehicleClass(vehicle)
                local trunk = GetVehicleDoorAngleRatio(vehicle, 5) > 0

                if trunk then
                    TriggerEvent('setCarIcon', 'trunk', '#ffffff') 
                else
                    TriggerEvent('setCarIcon', 'trunk', '#ffffff40')
                end

                local doors = (GetVehicleDoorAngleRatio(vehicle, 0) > 0 or GetVehicleDoorAngleRatio(vehicle, 1) > 0 or GetVehicleDoorAngleRatio(vehicle, 2) > 0 or GetVehicleDoorAngleRatio(vehicle, 3) > 0)
                if doors then
                    TriggerEvent('setCarIcon', 'doors', '#ffffff') 
                else
                    TriggerEvent('setCarIcon', 'doors', '#ffffff40')
                end

                -- araç arazi vs
                if DoesEntityExist(vehicle) then
                    local wheel_type = GetVehicleWheelType(vehicle)
                    if wheel_type ~= 3 and wheel_type ~= 4 and wheel_type ~= 6 then -- If have Off-road/Suv's/Motorcycles wheel grip its equal
                        if not cruiseIsOn then
                            local maxSpeed = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel")
                            SetEntityMaxSpeed(vehicle, maxSpeed)
                        end
        
                        local material_id = GetVehicleWheelSurfaceMaterial(vehicle, 1)
                        if material_id == 4 or material_id == 1 or material_id == 3 then -- All road (sandy/los santos/paleto bay)
                            offRoad = 0
                            SetVehicleGravityAmount(vehicle, 9.8000001907349) -- On road
                        else
                            offRoad = offRoad + 1
                            if offRoad > 4 then
                                SetVehicleGravityAmount(vehicle, 5.8000001907349) -- Off road
                            end
                        end
                    else
                        if not cruiseIsOn then
                            local maxSpeed = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel")
                            SetEntityMaxSpeed(vehicle, maxSpeed*0.7)
                        end
                    end

                    if Fuel < 20 then
                        TriggerEvent("CarFuelAlarm")
                    else
                        if Fuel < 10 then
                            TriggerEvent("CarFuelAlarm")
                        end
                    end
                end
       
                local p1,p2,lightsOn = GetVehicleLightsState(vehicle)
                if not engineRunning then
                    
                    SendNUIMessage({
                        type = "carHud",
                        street = street,
                        compass = degreesToIntercardinalDirection(),
                        time = clock,
                    }) 
                    SendNUIMessage({ -- benzin update
                        type = 'setFuel', 
                        fuel = GetVehicleFuelLevel(arac)
                    })
                    
                else
    
                    SendNUIMessage({
                        type = "carHud",
                        street = street,
                        compass = degreesToIntercardinalDirection(),
                        time = clock,
                    })  
                    SendNUIMessage({ -- benzin update
                        type = 'setFuel', 
                        fuel = GetVehicleFuelLevel(arac)
                    })
                end
            else
                if inVehSetState then
                    inVehSetState = false
                    SendNUIMessage({
                        type = "inVeh",
                        data = false
                    })
                else
                    SendNUIMessage({
                        type = "clockStreet",
                        time = clock,
                        street = street,
                        compass = degreesToIntercardinalDirection(),
                    })
                end
            end
        end
    end
end)

-- CODE --
local zone = "Unknown";
local time = "12:00"
local busy = false
local VehicleNormalMaxSpeed = false
local lastsikiKemer = false

Citizen.CreateThread(function()
    RegisterKeyMapping('+seatbelt', 'Araç (Kemer)', 'keyboard', 'k')
    RegisterKeyMapping('+cruise', 'Araç (Hız Sabitleme)', 'keyboard', 'y')
end)

RegisterCommand("-seatbelt", function()
    kemerSayi = 0
end, false)

RegisterCommand("+seatbelt", function()
    if inVehicle and vehicleClass and vehicleClass ~= 8 and not busy then
        Citizen.Wait(250)
        while IsControlPressed(0, 311) do
            if not seatbelt then
                if kemerSayi > 0 then
                    if sikiKemer then
                        QBCore.Functions.Notify('Sıkı Kemer Modu Kapatılıyor '..(3-kemerSayi)+1)
                    else
                        QBCore.Functions.Notify('Sıkı Kemer Modu Açılıyor '..(3-kemerSayi)+1)
                    end
                end
                if kemerSayi == 3 then
                    local result = nil
                    QBCore.Functions.TriggerCallback("gr-base:item-kontrol", function(data)
                        result = data
                    end,"kemer")
                    while result == nil do Citizen.Wait(1) end
                    if result > 0 then
                        if sikiKemer then
                            sikiKemer = false
                            QBCore.Functions.Notify('Sıkı Kemer Modu Devre Dışı', 'error')
                        else
                            if math.random(1,100) < 4 then
                                TriggerServerEvent("gr-basicneeds:esya-sil", "kemer")
                                QBCore.Functions.Notify('Sıkı Kemeri Bağlarken Koptu!', 'error')
                                return
                            else
                                sikiKemer = true
                                QBCore.Functions.Notify('Sıkı Kemer Modu Devrede', 'success')
                            end
                        end
                    else
                        QBCore.Functions.Notify('Üzerinde Kemer Yok!', 'error')
                        return
                    end
                    break
                end
                kemerSayi = kemerSayi + 1
            else
                QBCore.Functions.Notify('Kemer Takılı İken Kemer Modunu Değiştiremezsin!', 'error')
                return
            end
            Citizen.Wait(1000)
        end

        if sikiKemer or lastsikiKemer then 
            if seatbelt then
                busy = true
                QBCore.Functions.Progressbar("seatbelt", "Sıkı Kemer Çıkartılıyor", 4000, false, true, { -- p1: menu name, p2: yazı, p3: ölü iken kullan, p4:iptal edilebilir
                    disableMovement = true,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function() -- Done
                    QBCore.Functions.Notify("Kemer Çıkarıldı", "error")
                    PlaySoundFrontend(-1, "Faster_Click", "RESPAWN_ONLINE_SOUNDSET", 1)
                    TriggerEvent('InteractSound_CL:PlayOnOne', 'kemercikar', 0.7)
                    seatbelt = false
                    busy = false
                end, function() -- Cancel
                    busy = false
                end)
            else
                busy = true
                QBCore.Functions.Progressbar("seatbelt", "Sıkı Kemer Takılıyor", 4000, false, true, { -- p1: menu name, p2: yazı, p3: ölü iken kullan, p4:iptal edilebilir
                    disableMovement = true,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function() -- Done
                    QBCore.Functions.Notify("Kemer Bağlandı", "success")
                    TriggerEvent('InteractSound_CL:PlayOnOne', 'kemertak', 0.7)
                    PlaySoundFrontend(-1, "Faster_Click", "RESPAWN_ONLINE_SOUNDSET", 1)
                    seatbelt = true
                    busy = false
                end, function() -- Cancel
                    busy = false
                end)
            
            end
        else
            seatbelt = not seatbelt
            if seatbelt then
                QBCore.Functions.Notify("Kemer Bağlandı", "success")
                TriggerEvent('InteractSound_CL:PlayOnOne', 'kemertak', 0.7)
                PlaySoundFrontend(-1, "Faster_Click", "RESPAWN_ONLINE_SOUNDSET", 1)
                TriggerEvent('setCarIcon', 'seatbelt', '#FFFFFF')
            else
                QBCore.Functions.Notify("Kemer Çıkarıldı", "error")
                TriggerEvent('setCarIcon', 'seatbelt', '#FFFFFF40')
                PlaySoundFrontend(-1, "Faster_Click", "RESPAWN_ONLINE_SOUNDSET", 1)
                TriggerEvent('InteractSound_CL:PlayOnOne', 'kemercikar', 0.7)
            end
        end
        lastsikiKemer = sikiKemer
    end
end, false)

RegisterCommand("+cruise", function()
    if inVehicle and not cruiseIsOn then
         QBCore.Functions.Notify("Hız Sabitleyici Aktif", "success")
        cruiseSpeed = prevSpeed
        TriggerEvent('setCarIcon', 'cruise', '#FFFFFF')
        cruiseIsOn = not cruiseIsOn
    elseif cruiseIsOn then
        QBCore.Functions.Notify("Hız Sabitleyici Pasif", "error")
        TriggerEvent('setCarIcon', 'cruise', '#FFFFFF40')
        cruiseIsOn = not cruiseIsOn
    end
end, false)

RegisterNetEvent("CarFuelAlarm")
AddEventHandler("CarFuelAlarm",function()
    if not alarmset then
        alarmset = true
        local i = 5
        QBCore.Functions.Notify("Benzin az!", "error")
        while i > 0 do
            PlaySound(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
            i = i - 1
            Citizen.Wait(300)
        end
        Citizen.Wait(60000)
        alarmset = false
    end
end)

function degreesToIntercardinalDirection()
    local playerHeadingDegrees = 360.0 - GetEntityHeading(playerPed)
    local dgr = playerHeadingDegrees - 180 / 2
	local dgr = dgr % 360.0
	if (dgr >= 0.0 and dgr < 22.5) or dgr >= 337.5 then
		return "KD"
	elseif dgr >= 22.5 and dgr < 67.5 then
		return "D"
	elseif dgr >= 67.5 and dgr < 112.5 then
		return "GD"
	elseif dgr >= 112.5 and dgr < 157.5 then
		return "G"
	elseif dgr >= 157.5 and dgr < 202.5 then
		return "GB"
	elseif dgr >= 202.5 and dgr < 247.5 then
		return "B"
	elseif dgr >= 247.5 and dgr < 292.5 then
		return "KB"
	elseif dgr >= 292.5 and dgr < 337.5 then
		return "K"
	end
end

-- Carhud gözükme işlev vs.
Citizen.CreateThread(function()
    while true do
      Wait(25)

        local cu = PlayerPedId() -- cu kim?
        local arac = GetVehiclePedIsUsing(cu)
        local hiz = math.floor(GetEntitySpeed(arac) * 3.6)
        local cercevehiz = GetEntitySpeed(arac) * 3.6

        SendNUIMessage({ -- hız update
            type = 'setSpeedNumbers', 
            speed = hiz
        })

        SendNUIMessage({ -- çerçeve hız update
            type = 'setSpeedo', 
            speedPercentage = cercevehiz
        })
    end
end)

-- İcon renk güncelleme!  -- TriggerEvent('setCarIcon', 'seatbelt', '#ff3030')
AddEventHandler("setCarIcon",function(icon, color)
    SendNUIMessage({
        type = "setCarIcon",
        iconName = icon,
        iconColor = color,
    })
end)