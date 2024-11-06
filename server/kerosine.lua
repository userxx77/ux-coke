-- kerosine.lua

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Server event to grant kerosine
RegisterNetEvent('srp-cocaine:grantKerosine')
AddEventHandler('srp-cocaine:grantKerosine', function(k)
    local xPlayer = ESX.GetPlayerFromId(source)
    local rewardItem = 'kerosine'
    local rewardAmount = 2  -- Give 2 units of kerosine

    -- Give the player 2 units of kerosine
    xPlayer.addInventoryItem(rewardItem, rewardAmount)
end)
