local cashAmount = 0
local bankAmount = 0

RegisterNetEvent("redHudMoney")
AddEventHandler("redHudMoney", function(show, market2)
    if market2 == nil then
        market2 = false
    end
    
    SendNUIMessage({
        type = "money",
        show = show,
        money = cashAmount,
        market = market2
    })
end)

RegisterNetEvent("hud:client:SetMoney")
AddEventHandler("hud:client:SetMoney", function(nPlayerData)
    if PlayerData and PlayerData.money then
        cashAmount = QBCore.Shared.Round(PlayerData.money.cash)
    end
end)

RegisterNetEvent("hud:client:OnMoneyChange")
AddEventHandler("hud:client:OnMoneyChange", function(type, amount, isMinus)
    if type == "cash" then
        PlayerData = QBCore.Functions.GetPlayerData()
        cashAmount = QBCore.Shared.Round(PlayerData.money.cash)
        SendNUIMessage({
            type = "moneyUpdate",
            money = amount,
            newCashAmount = cashAmount,
            isMinus = isMinus
        })
    end
end)
