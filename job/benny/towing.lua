--[[local player = PlayerPedId()
local playerCoords = GetEntityCoords(player)
local radius = 5.0
local vehicle = nil
local vehicleCoords = GetEntityCoords(vehicle)
vehicle = getClosestVehicle(playerCoords)

local dist = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, true)
if dist < 5 then
    DrawMarker(1, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 200, 0, 0, 0, 0)
end]]

local whitelist = {
    'FLATBED',
    'wastelander', -- WASTELANDER
    --'MULE',
    --'MULE2',
    --'MULE3',
    --'MULE4'
}

local offsets = {
    {model = 'FLATBED', offset = {x = 0.0, y = -9.0, z = -1.25}},
    {model = 'wastelander', offset = {x = 0.0, y = -7.2, z = -0.9}},
    --{model = 'MULE', offset = {x = 0.0, y = -7.0, z = -1.75}},
    --{model = 'MULE2', offset = {x = 0.0, y = -7.0, z = -1.75}},
    --{model = 'MULE3', offset = {x = 0.0, y = -7.0, z = -1.75}},
    --{model = 'MULE4', offset = {x = 0.0, y = -7.0, z = -1.75}},
}

local rampHash = 'imp_prop_flatbed_ramp'

RegisterCommand('deployramp', function ()
    local player = PlayerPedId()
    local playerCoords = GetEntityCoords(player)
    local radius = 10.0

    local vehicle = nil

    if IsAnyVehicleNearPoint(playerCoords, radius) then
        local vehicle = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 10.0, 0, 127)
        local vehicleName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)) -- 

        drawNotification("Essayer de déployer une rampe pour: " .. vehicleName)

        if contains(vehicleName, whitelist) then
            local vehicleCoords = GetEntityCoords(vehicle)

            local ramp = CreateObject(rampHash, vector3(vehicleCoords), true, false, false)
            for _, value in pairs(offsets) do
                if vehicleName == value.model then
                    AttachEntityToEntity(ramp, vehicle, GetEntityBoneIndexByName(vehicle, 'chassis'), value.offset.x, value.offset.y, value.offset.z , 180.0, 180.0, 0.0, 0, 0, 1, 0, 0, 1)
                end
            end

            drawNotification("La rampe a été déployée.")
            return
        end
        drawNotification("Vous ne pouvez pas déployer de rampe pour ce véhicule.")
        return
    end
end)

RegisterCommand('ramprm', function()
    local player = PlayerPedId()
    local playerCoords = GetEntityCoords(player)

    local object = GetClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, 5.0, rampHash, false, 0, 0)

    if not IsPedInAnyVehicle(player, false) then
        if GetHashKey(rampHash) == GetEntityModel(object) then
            DeleteObject(object)
            drawNotification("Rampe retirée avec succès.")
            return
        end
    end

    drawNotification("Sortez de votre véhicule ou rapprochez-vous de la rampe.")
end)

RegisterCommand('attach', function()
    local player = PlayerPedId()
    local vehicle = nil

    if IsPedInAnyVehicle(player, false) then
        vehicle = GetVehiclePedIsIn(player, false)
        if GetPedInVehicleSeat(vehicle, -1) == player then
            local vehicleCoords = GetEntityCoords(vehicle)
            local vehicleOffset = GetOffsetFromEntityInWorldCoords(vehicle, 1.0, 0.0, -1.5)
            local belowEntity = GetVehicleBelowMe(vehicleCoords, vehicleOffset)
            local vehicleBelowName = GetDisplayNameFromVehicleModel(GetEntityModel(belowEntity))

            local vehiclesOffset = GetOffsetFromEntityGivenWorldCoords(belowEntity, vehicleCoords)

            if contains(vehicleBelowName, whitelist) then
                if not IsEntityAttached(vehicle) then
                    AttachEntityToEntity(vehicle, belowEntity, GetEntityBoneIndexByName(belowEntity, 'chassis'), vehiclesOffset, 0.0, 0.0, 0.0, false, false, true, false, 0, true)
                    return drawNotification('Véhicule correctement attaché.')
                end
                return drawNotification('Véhicule déjà attaché.')
            end
            return drawNotification('Impossible de s\'attacher à cette entité: ' .. vehicleBelowName)
        end
        return drawNotification('Pas dans le siège du conducteur.')
    end
    drawNotification('Vous n\'êtes pas dans un véhicule.')
end)

RegisterCommand('detach', function()
    local player = PlayerPedId(-1)
    local vehicle = nil

    if IsPedInAnyVehicle(player, false) then
        vehicle = GetVehiclePedIsIn(player, false)
        if GetPedInVehicleSeat(vehicle, -1) == player then
            if IsEntityAttached(vehicle) then
                DetachEntity(vehicle, false, true)
                DeleteObject(vehicle, false, true)
                
                return drawNotification('Le véhicule a été détaché avec succès.')
            else
                return drawNotification('Le véhicule n\'est attaché à rien.')
            end
        else
            return drawNotification('Vous n\'êtes pas dans le siège du conducteur.')
        end
    else
        return drawNotification('Vous n\'êtes pas dans un véhicule.')
    end
end)

function getClosestVehicle(coords)
    local ped = PlayerPedId()
    local vehicles = GetGamePool('CVehicle')
    local closestDistance = -1
    local closestVehicle = -1
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(ped)
    end
    for i = 1, #vehicles, 1 do
        local vehicleCoords = GetEntityCoords(vehicles[i])
        local distance = #(vehicleCoords - coords)

        if closestDistance == -1 or closestDistance > distance then
            closestVehicle = vehicles[i]
            closestDistance = distance
        end
    end
    return closestVehicle, closestDistance
end

function GetVehicleBelowMe(cFrom, cTo) -- Function to get the vehicle under me
    local rayHandle = CastRayPointToPoint(cFrom.x, cFrom.y, cFrom.z, cTo.x, cTo.y, cTo.z, 10, PlayerPedId(), 0) -- Sends raycast under me
    local _, _, _, _, vehicle = GetRaycastResult(rayHandle) -- Stores the vehicle under me
    return vehicle -- Returns the vehicle under me
end

function contains(item, list)
    for _, value in ipairs(list) do
        if value == item then return true end
    end
    return false
end

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(true, false)
end