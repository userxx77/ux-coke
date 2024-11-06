local isStealing = false                         -- Is the player currently in the act of stealing kerosine?
local stealLocations = Config.Kerosine.locations -- Get the available locations from the config.lua

RegisterNetEvent('srp-cocaine:stealKerosine')
AddEventHandler('srp-cocaine:stealKerosine', function(k)


    -- Checks if the player is already stealing
    if isStealing then
        lib.notify({
            title = 'Foutmelding',
            description = 'Je bent al bezig met het stelen van kerosine.',
            type = 'error'
        })
        return
    end

    isStealing = true

    --TaskStartScenarioInPlace(PlayerPedId(), 'p4_ver1_mechanic', 0, false)

    if lib.progressCircle({
        duration = 3000,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
            mouse = true,
        },
        anim = {
            dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
            clip = 'machinic_loop_mechandplayer'
        }
    }) then
        local data = Config.Kerosine.locations[k]

        if #(GetEntityCoords(PlayerPedId()) - data.coords) > 20 then
            return
        end
        
        TriggerServerEvent('srp-cocaine:grantKerosine', k)

        if data.amount > 1 then
            lib.notify({
                title = 'Kerosine',
                description = 'Je hebt succesvol '..tostring(data.amount)..' jerrycans met kerosine gestolen.',
                type = 'success'
            })
        else
            lib.notify({
                title = 'Kerosine',
                description = 'Je hebt succesvol een jerrycan met kerosine gestolen.',
                type = 'success'
            })
        end
    end

    ClearPedTasks(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(), false)

    isStealing = false

end)

for k, v in ipairs(stealLocations) do
    exports.ox_target:addBoxZone({
        name = v.name,
        coords = v.coords,
        size = v.size,
        rotation = v.rotation,
        options = {
            {
                name = 'stealKerosine',
                icon = 'fa-solid fa-user-ninja',
                label = 'Kerosine stelen',
                onSelect = function()
                  TriggerEvent('srp-cocaine:stealKerosine', k)
                end
            }
        }
    })
end
