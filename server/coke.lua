ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Register the server event
RegisterNetEvent('srp-cocaine:startProcessing')
AddEventHandler('srp-cocaine:startProcessing', function(processName)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local requiredItem1 = 'cocablad'     -- First item to remove
    local requiredAmount1 = 5            -- Amount of 'cocablad' required
    local requiredItem2 = 'kerosine'     -- Second item to remove
    local requiredAmount2 = 2            -- Amount of 'kerosine' required
    local rewardItem = 'cocaine'         -- Item to give
    local rewardAmount = 2               -- Amount to give

    -- Check if the player has at least the required amount of both items
    if xPlayer.getInventoryItem(requiredItem1).count >= requiredAmount1 and 
       xPlayer.getInventoryItem(requiredItem2).count >= requiredAmount2 then

        -- Send success notification before removing items
        TriggerClientEvent('srp-cocaine:sendNotification', _source, {
            title = 'Actie Succesvol',
            description = 'Je hebt cocaine ontvangen voor het succesvol verwerken.',
            type = 'success',
            duration = 5000
        })

        -- Remove the required items from the player's inventory
        xPlayer.removeInventoryItem(requiredItem1, requiredAmount1)
        xPlayer.removeInventoryItem(requiredItem2, requiredAmount2)

        -- Give the player the reward item
        xPlayer.addInventoryItem(rewardItem, rewardAmount)

    else
        -- Send failure notification for insufficient items
        TriggerClientEvent('srp-cocaine:sendNotification', _source, {
            title = 'Actie Mislukt',
            description = 'Je hebt niet genoeg bladeren of kerosine om dit proces uit te voeren.',
            type = 'error',
            duration = 5000
        })
    end
end)
