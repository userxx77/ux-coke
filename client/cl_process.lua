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
        if IsControlJustReleased(0, 51) then  -- E key to process
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
    coords = vec3(1552.7427, 3513.4272, 36.0177),
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

-- NPC setup to spawn and maintain them in specific locations (no changes to NPC code)
local pedOne, pedTwo, pedThree, pedPawnShop = nil, nil, nil, nil

Citizen.CreateThread(function()
    -- Cocaine Processing Locations
    -- Location 1

    pedOne = ESX.Game.SpawnPed(`g_m_m_chicold_01`, vec3(1552.6427, 3513.4272, 35.0177), 30.0)
    SetupDealerPed(pedOne, "Dealer Joe")
    exports.qtarget:AddTargetEntity(pedOne, {
        options = {
            {
                label = "Verwerken",
                event = "srp-cocaine:client:startProcessing",
                icon = "fas fa-flask",
            },
        },
        distance = 2.5
    })

    -- Location 2
    local blipTwo = AddBlipForCoord(448.18, -1785.97, 28.59)
    SetBlipSprite(blipTwo, 272)
    SetBlipScale(blipTwo, 0.65)
    SetBlipColour(blipTwo, 5)
    SetBlipAsShortRange(blipTwo, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Cocaine Processing")
    EndTextCommandSetBlipName(blipTwo)

    pedTwo = ESX.Game.SpawnPed(`g_m_m_chicold_01`, vec3(448.18, -1785.97, 28.59 - 1.0), 90.0)
    SetupDealerPed(pedTwo, "Dealer Mike")
    exports.qtarget:AddTargetEntity(pedTwo, {
        options = {
            {
                label = "Start Processing Cocaine",
                event = "srp-cocaine:client:startProcessing",
                icon = "fas fa-flask",
            },
        },
        distance = 2.5
    })

    -- Location 3
    local blipThree = AddBlipForCoord(-1169.41, -1389.29, 3.92)
    SetBlipSprite(blipThree, 272)
    SetBlipScale(blipThree, 0.65)
    SetBlipColour(blipThree, 5)
    SetBlipAsShortRange(blipThree, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Cocaine Processing")
    EndTextCommandSetBlipName(blipThree)

    pedThree = ESX.Game.SpawnPed(`g_m_m_chicold_01`, vec3(-1169.41, -1389.29, 3.92 - 1.0), 270.0)
    SetupDealerPed(pedThree, "Dealer Tony")
    exports.qtarget:AddTargetEntity(pedThree, {
        options = {
            {
                label = "Start Processing Cocaine",
                event = "srp-cocaine:client:startProcessing",
                icon = "fas fa-flask",
            },
        },
        distance = 2.5
    })

    -- Pawn Shop NPC
    local pawnBlip = AddBlipForCoord(Config.NPCLocation.coords)
    SetBlipSprite(pawnBlip, 605) -- Adjusted to represent a shop
    SetBlipScale(pawnBlip, 0.65)
    SetBlipColour(pawnBlip, 1)
    SetBlipAsShortRange(pawnBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Pawn Shop")
    EndTextCommandSetBlipName(pawnBlip)

    pedPawnShop = ESX.Game.SpawnPed(`a_m_m_afriamer_01`, Config.NPCLocation.coords, Config.NPCLocation.heading)
    SetupDealerPed(pedPawnShop, "Pawn Shop Clerk")
    exports.qtarget:AddTargetEntity(pedPawnShop, {
        options = {
            {
                label = "Open Pawn Shop",
                event = "sten-pawnshop:client:openPawnShop",
                icon = "fas fa-shop",
            },
        },
        distance = 2.5
    })
end)

-- Helper function to set up a dealer ped
function SetupDealerPed(ped, name)
    SetPedDiesWhenInjured(ped, true)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
    SetPedRelationshipGroupHash(ped, "MISSION8")
    SetRelationshipBetweenGroups(0, "MISSION8", "PLAYER")
    SetBlockingOfNonTemporaryEvents(ped, true)
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_DRUG_DEALER", 0, true)
end

-- Cleanup on Resource Stop
AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    if DoesEntityExist(pedOne) then DeletePed(pedOne) end
    if DoesEntityExist(pedTwo) then DeletePed(pedTwo) end
    if DoesEntityExist(pedThree) then DeletePed(pedThree) end
    if DoesEntityExist(pedPawnShop) then DeletePed(pedPawnShop) end
end)
