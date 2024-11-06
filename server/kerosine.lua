ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Define the maximum inventory weight
local MAX_INVENTORY_WEIGHT = 40.0  -- 40kg limit

-- Server event to grant kerosine
RegisterNetEvent('srp-cocaine:grantKerosine')
AddEventHandler('srp-cocaine:grantKerosine', function(k)
    local xPlayer = ESX.GetPlayerFromId(source)
    local rewardItem = 'kerosine'
    local rewardAmount = 2  -- Amount of kerosine to give

    -- Check if adding the reward will exceed the inventory weight limit
    local currentWeight = xPlayer.getWeight()  -- Current inventory weight in kg
    local itemWeight = xPlayer.getInventoryItem(rewardItem).weight  -- Weight of one unit of kerosine

    -- Calculate total weight after adding kerosine
    local totalWeight = currentWeight + (itemWeight * rewardAmount)

    -- Only give the item if the new weight is within the limit
    if totalWeight <= MAX_INVENTORY_WEIGHT then
        xPlayer.addInventoryItem(rewardItem, rewardAmount)

        -- Success notification
        TriggerClientEvent('srp-cocaine:sendNotification', source, {
            title = 'Kerosine verkregen',
            description = 'Je hebt succesvol kerosine ontvangen.',
            type = 'success',
            duration = 5000
        })
    else
        -- Failure notification for inventory full
        TriggerClientEvent('srp-cocaine:sendNotification', source, {
            title = 'Actie Mislukt',
            description = 'Je hebt niet genoeg ruimte in je inventaris voor meer kerosine.',
            type = 'error',
            duration = 5000
        })
    end
end)
