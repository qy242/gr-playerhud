QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent('gr-hud:car:eject-other-player-car')
AddEventHandler('gr-hud:car:eject-other-player-car', function(table, velocity)
    for i=1, #table do
        TriggerClientEvent("gr-hud:car:eject-other-player-car-client", table[i], velocity)
    end
end)

QBCore.Commands.Add("hızsabitle", "Aracın Hızını Sabitle.", {{ name="Sabitlenecek Hız", help="Aracın Hızını Sabitlemek İçin Bir Değer Girin"}}, false, function(source, args) -- name, help, arguments, argsrequired,  end sonuna persmission
    TriggerClientEvent("gr-hud:hizsabitle", source, args)
end, perm)

QBCore.Commands.Add("fulle", "Can Fulle", {}, false, function(source, args) -- name, help, arguments, argsrequired,  end sonuna persmission
    local xPlayer = QBCore.Functions.GetPlayer(source, item)
    TriggerEvent('DiscordBot:ToDiscord', 'adminlog', '/fulle', source, item)
    TriggerClientEvent("gr-hud:fulle", xPlayer.PlayerData.source, item)
end, "god")

QBCore.Commands.Add("aclik", "Oyuncunun açlığını doldurur.", {{name="id", help="Oyuncu ID"}}, false, function(source, args)
    TriggerEvent('DiscordBot:ToDiscord', 'adminlog', '/aclik', source)
	if args[1] == nil then
		TriggerClientEvent('gr-hud:aclik', source, true)
	else
		TriggerClientEvent('gr-hud:aclik', tonumber(args[1]), true)
	end
end, "admin")

RegisterNetEvent("gr-basicneeds:bilgilerKaydet")
AddEventHandler("gr-basicneeds:bilgilerKaydet", function(yemek, su, sarhos, zirh, heal, oyunSuresi)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)	
    if xPlayer then
        xPlayer.Functions.SetMetaData("hunger", yemek)
        xPlayer.Functions.SetMetaData("thirst", su)
        xPlayer.Functions.SetMetaData("armor", zirh)
        xPlayer.Functions.SetMetaData("drunk", sarhos)
        xPlayer.Functions.SetMetaData("heal", heal)
        if xPlayer.PlayerData.job.onduty then
            xPlayer.Functions.SetMetaData("dutytime", xPlayer.PlayerData.metadata["dutytime"] + 1)
        end
        xPlayer.Functions.SetSure(oyunSuresi)
    end
end)

RegisterNetEvent("gr-basicneeds:esya-sil")
AddEventHandler("gr-basicneeds:esya-sil", function(item, item2)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    if xPlayer then
        xPlayer.Functions.RemoveItem(item, 1)
        if item2 then
            xPlayer.Functions.RemoveItem(item2, 1)
        end
    end
end)

QBCore.Functions.CreateCallback("gr-basicneeds:esya-sil-cb", function(source, cb, item)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    if xPlayer then
        if xPlayer.Functions.RemoveItem(item, 1) then
            cb(true)
        else
            cb(false)
        end
    end
end)

RegisterNetEvent("gr-basicneeds:give-item")
AddEventHandler("gr-basicneeds:give-item", function(item, key)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    if QBCore.Functions.kickHacKer(src, key) then -- QBCore.Key
        if xPlayer then
            xPlayer.Functions.AddItem(item, 1)
        end
    end
end)

QBCore.Functions.CreateUseableItem('cigarette', function(source, item)
    local xPlayer = QBCore.Functions.GetPlayer(source, item)
    if xPlayer.Functions.GetItemByName("lighter").amount > 0 then
        if math.random(1,100) < 2 then
            xPlayer.Functions.RemoveItem('lighter', 1, xPlayer.Functions.GetItemByName("lighter").slot)
            TriggerClientEvent("QBCore:Notify", xPlayer.PlayerData.source, "Çakmağın Gazı Bitti")
        else
            xPlayer.Functions.RemoveItem('cigarette', 1, xPlayer.Functions.GetItemByName("cigarette").slot)
            TriggerClientEvent('gr-basicneeds:sigara', xPlayer.PlayerData.source, item)
        end 
    else
        TriggerClientEvent("QBCore:Notify", xPlayer.PlayerData.source, "Sigarayı Yakmak İçin Çakmağın Yok")
    end
end)

function removeItemHud(src, item)
    local xPlayer = QBCore.Functions.GetPlayer(src)
    xPlayer.Functions.RemoveItem(item, 1)
end

-- QBCore.Functions.CreateUseableItem('book', function(source, item)
--     TriggerClientEvent("dpemotes:play-anim", source, {"kitap"})
-- end)

QBCore.Functions.CreateUseableItem('baston', function(source, item)
    TriggerClientEvent("dpemotes:set-walk", source, "Lester")
    TriggerClientEvent("dpemotes:play-anim", source, {"baston"})
end)

QBCore.Functions.CreateUseableItem('umbrella', function(source, item)
    TriggerClientEvent("dpemotes:play-anim", source, {"şemsiye"})
end)

QBCore.Functions.CreateUseableItem('water', function(source, item)
	TriggerClientEvent('gr-basicneeds:eatOrDrink', source, item.name, "drink", 1250, 0.3)
end)

QBCore.Functions.CreateUseableItem('atom', function(source, item)
	TriggerClientEvent('gr-basicneeds:eatOrDrink', source, item.name, "drink", 3250, 2)
end)

QBCore.Functions.CreateUseableItem('portakal_suyu', function(source, item)
	TriggerClientEvent('gr-basicneeds:eatOrDrink', source, item.name, "drink", 2000, 0.3)
end)

QBCore.Functions.CreateUseableItem('kola', function(source, item)
	TriggerClientEvent('gr-basicneeds:eatOrDrink', source, item.name, "drink", 2000, 0.3)
end)

QBCore.Functions.CreateUseableItem('ayran', function(source, item)
	TriggerClientEvent('gr-basicneeds:eatOrDrink', source, item.name, "drink", 2000, 0.3)
end)

QBCore.Functions.CreateUseableItem('sandwich', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('gr-basicneeds:eatOrDrink', source, item.name, "eat", 7500, 3)
end)

QBCore.Functions.CreateUseableItem('burgerm', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('gr-basicneeds:eatOrDrink', source, item.name, "eat", 7500, 3)
end)

QBCore.Functions.CreateUseableItem('burgerl', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('gr-basicneeds:eatOrDrink', source, item.name, "eat", 10000, 3)
end)

QBCore.Functions.CreateUseableItem('burgers', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('gr-basicneeds:eatOrDrink', source, item.name, "eat", 5000, 3)
end)

QBCore.Functions.CreateUseableItem('burgerxl', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('gr-basicneeds:eatOrDrink', source, item.name, "eat", 15000, 3)
end)

QBCore.Functions.CreateUseableItem('tacom', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('gr-basicneeds:eatOrDrink', source, item.name, "eat", 7500, 3)
end)

QBCore.Functions.CreateUseableItem('tacol', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('gr-basicneeds:eatOrDrink', source, item.name, "eat", 10000, 3)
end)

QBCore.Functions.CreateUseableItem('ekmek', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('gr-basicneeds:eatOrDrink', source, item.name, "eat", 1500, 0.7)
end)

QBCore.Functions.CreateUseableItem('tacos', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('gr-basicneeds:eatOrDrink', source, item.name, "eat", 5000, 3)
end)

QBCore.Functions.CreateUseableItem('tacoxl', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('gr-basicneeds:eatOrDrink', source, item.name, "eat", 15000, 3)
end)

QBCore.Functions.CreateUseableItem('jailfood', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('gr-basicneeds:eatOrDrink', source, item.name, "eat", 7500, 3)
end)

QBCore.Functions.CreateUseableItem('friesl', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('gr-basicneeds:eatOrDrink', source, item.name, "eat", 8500, 3)
end)
QBCore.Functions.CreateUseableItem('friesm', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('gr-basicneeds:eatOrDrink', source, item.name, "eat", 7500, 3)
end)

QBCore.Functions.CreateUseableItem('friess', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('gr-basicneeds:eatOrDrink', source, item.name, "eat", 5000, 3)
end)

QBCore.Functions.CreateUseableItem('friesxl', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('gr-basicneeds:eatOrDrink', source, item.name, "eat", 10000, 3)
end)

QBCore.Functions.CreateUseableItem('nos', function(source, item)
    TriggerClientEvent("QBCore:Notify", source, 'Böyle bir kullanım yöntemi de var tabi :D')
    TriggerClientEvent('kfzeu-basicneeds:nosAnimation', source, item)
end)

QBCore.Functions.CreateUseableItem('parasut', function(source, item)
    local xPlayer = QBCore.Functions.GetPlayer(source, item)
    xPlayer.Functions.RemoveItem('parasut', 1)
    TriggerClientEvent("QBCore:Notify", source, "Paraşütü Giydin! Tekrar Paraşüt Kullanmamaya Dikkat Et! (Eline Silah vs Alırsan Paraşütün Gider)", "error")
    TriggerClientEvent('gr-hud:parasut', source)
end)

QBCore.Functions.CreateUseableItem('su_alti', function(source)
    TriggerClientEvent('qy:usableitems:onDalgictupu', source)
end)

local cigpacket = 20
QBCore.Functions.CreateUseableItem('cigpacket', function(source)
    local xPlayer = QBCore.Functions.GetPlayer(source)

    if cigpacket == 0 then
        xPlayer.Functions.RemoveItem("cigpacket", 1)
    else
        local info = {sigara = cigpacket,}
        cigpacket = cigpacket - 1,
        xPlayer.Functions.RemoveItem("cigpacket", 1)
        xPlayer.Functions.AddItem("cigpacket", 1, nil, info)
        xPlayer.Functions.AddItem("cigarette", 1)
    end
end)

function checkDurubality(item, src)
    if item.info then
        local durubality = 1
        if item.info.durubality then
            local date = item.info.durubality + 172800
            local durubality_frist = (date - os.time()) / (60 * 60 * 24)
            durubality = 100 - ((2 - durubality_frist)*50)
        end
        if durubality > 0 then
            return true
        else
            TriggerClientEvent("QBCore:Notify", src, item.label.." Bozulmuş", "error")
            local xPlayer = QBCore.Functions.GetPlayer(src)	
            xPlayer.Functions.RemoveItem(item.name, 1, item.slot)
            return false
        end
    end
    return true
end