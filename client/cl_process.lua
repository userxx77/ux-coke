local processing = false

function onEnter(self)
    lib.showTextUI('[E] - Verwerken')
end

function onExit(self)
    lib.hideTextUI()
end

-- Client-side event to handle notifications from the server
RegisterNetEvent('srp-cocaine:sendNotification')
AddEventHandler('srp-cocaine:sendNotification', function(data)
    lib.notify({
        title = data.title,
        description = data.description,
        type = data.type,
        duration = data.duration or 5000  -- Optional: default duration
    })
end)


function inside(self)
    if processing == false then
        if IsControlJustReleased(0, 51) then
            if HasIngredients() then
                if IsPedInAnyVehicle(PlayerPedId()) then
                    lib.notify({ title = "Actie Mislukt", description = "Je kan niet in een voertuig verwerken!", type = "error", duration = 5000 })
                    return
                end

                processing = true
                local success = lib.skillCheck({'easy', 'easy', 'easy'}, {'w', 'a', 's', 'd'})

                if success then
                    TriggerServerEvent('srp-cocaine:startProcessing', self.name)
                    processing = false
                else
                    lib.notify({
                        title = 'Actie mislukt',
                        description = 'Je hebt de ingrediënten niet goed bij elkaar gemixed. Probeer het opnieuw.',
                        type = 'error'
                    })
                    processing = false
                end
            else
                lib.notify({
                    title = 'Actie mislukt',
                    description = 'Je hebt niet de juiste ingrediënten bij je om dit te doen.',
                    type = 'error'
                })
            end
        end
    end
end

local boxOne = lib.zones.box({
	name = "coke_verwerk",
	coords = vec3(-913.98, -2039.42, 9.40),
	size = vec3(16.25, 7.75, 10.25),
	rotation = 350.0,
    inside = inside,
    onEnter = onEnter,
    onExit = onExit
})

local boxTwo = lib.zones.box({
	name = "coke_verwerk2",
	coords = vec3(448.18, -1785.97, 28.59),
	size = vec3(16.25, 7.75, 10.25),
	rotation = 350.0,
    inside = inside,
    onEnter = onEnter,
    onExit = onExit
})

local boxThree = lib.zones.box({
	name = "coke_verwerk3",
	coords = vec3(-1169.41, -1389.29, 3.92),
	size = vec3(16.25, 7.75, 10.25),
	rotation = 350.0,
    inside = inside,
    onEnter = onEnter,
    onExit = onExit
})

function HasIngredients()
    return exports.ox_inventory:Search('count', 'cocablad') >= 5 and exports.ox_inventory:Search('count', 'kerosine') >= 2
end