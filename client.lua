local trailerEnt = nil
local trailers = {}
for k,v in ipairs(config.trailers) do
    table.insert(trailers, GetHashKey(v))
end

local boats = {}
for k,v in ipairs(config.boats) do
    table.insert(boats, GetHashKey(v))
end

local lastTruck = 0
local debug = false
local vehs = {}
for k,v in ipairs(config.water_vehicles) do
    table.insert(vehs, GetHashKey(v))
end


RegisterCommand(config.spawnCommand, function(source, args, rawCommand)
    local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 8.0, 0.5))
    local vehiclehash = GetHashKey(config.default.trailer)
    local boatHash  = GetHashKey(config.default.boat)
        RequestModel(vehiclehash)
        RequestModel(boatHash)
        Citizen.CreateThread(function() 
            local waiting = 0
            while not HasModelLoaded(vehiclehash) or not HasModelLoaded(boatHash) do
                waiting = waiting + 100
                Citizen.Wait(100)
                if waiting > 5000 then
                    ShowHelpText(config.safetySpawn, "REDNECK_SAFETYSPAWN")
                    break
                end
            end
            local vehiclecreated = CreateVehicle(vehiclehash, x, y, z, GetEntityHeading(PlayerPedId())+90, 1, 1)
            local boatLower = CreateVehicle(boatHash, x, y, z,0.0, 1, 1)
            local boatUpper = CreateVehicle(boatHash, x, y, z,0.0, 1, 1)
            SetEntityRotation(vehiclecreated,180.0,180.0,0.0,0,true)
            AttachEntityToEntity(boatLower,vehiclecreated,GetEntityBoneIndexByName(vehiclecreated,'misc_a'),config.offset.bottom,0.0,0.0,0.0,0,0,1,0,1,1)
            AttachEntityToEntity(boatUpper,vehiclecreated,GetEntityBoneIndexByName(vehiclecreated,'misc_b'),config.offset.top,0.0,0.0,0.0,0,0,1,0,1,1)

            SetModelAsNoLongerNeeded(veh)
            SetModelAsNoLongerNeeded(boatHash)
        end)
end)

Citizen.CreateThread(function()
    while true do
        waitTime = 750
        if not IsPedInAnyVehicle(PlayerPedId(), true) then
            local hit, coords, entity = RayCastGamePlayCamera(10.0)
            if hit == 1 then
                if GetEntityType(entity) ~= 0 then
                    if has_value(boats,GetEntityModel(entity)) then
                        waitTime = 8
                        if IsEntityAttachedToAnyVehicle(entity) then
                            ShowHelpText(config.pressButtonDetach, "REDNECK_DETACH")
                            if IsControlJustPressed(0,config.boatCommands) then
                                if has_value(trailers,GetEntityModel(GetEntityAttachedTo(entity))) then
                                    AttachEntityToEntity(entity,GetEntityAttachedTo(entity),GetEntityBoneIndexByName(GetEntityAttachedTo(entity),'misc_a'),config.offset.drop,0.0,0.0,0.0,0,0,1,0,1,1)
                                    DetachEntity(entity)
                                end
                            end
                        end
                    end
                end
            end
            if trailerEnt ~= nil then
                if #(GetEntityCoords(trailerEnt) - GetEntityCoords(PlayerPedId())) < 12.0 then
                    local hit, coords, entity = RayCastGamePlayCamera(20.0)
                    if hit == 1 then
                        if GetEntityType(entity) ~= 0 then
                            if has_value(boats,GetEntityModel(entity)) and not IsEntityAttachedToAnyVehicle(entity) then
                                waitTime = 8
                                ShowHelpText(config.pressButtonAttach, "REDNECK_ATTACH")
                                if IsControlJustPressed(0,config.boatCommands) then
                                    local position = {}
                                    position['top'],position['bottom'] = false,false
                                    local AllVehicles  = GetGamePool('CVehicle')

                                    for i=1,#AllVehicles,1 do
                                        if  has_value(boats,GetEntityModel(AllVehicles[i])) then
                                            if GetEntityAttachedTo(AllVehicles[i]) == trailerEnt then
                                                if GetEntityHeightAboveGround(AllVehicles[i]) > 1.9 then
                                                    position['top'] = true
                                                else
                                                    position['bottom'] = true
                                                end
                                            end
                                        end
                                    end
                                    if not position['top'] then
                                        AttachEntityToEntity(entity,trailerEnt,GetEntityBoneIndexByName(trailerEnt,'misc_b'),config.offset.top,0.0,0.0,0.0,0,0,1,0,1,1)
                                    elseif not position['bottom'] then
                                        AttachEntityToEntity(entity,trailerEnt,GetEntityBoneIndexByName(trailerEnt,'misc_a'),config.offset.bottom,0.0,0.0,0.0,0,0,1,0,1,1)
                                    else
                                        ShowText(config.occupied)
                                        position = {}
                                    end
                                    AllVehicles,position,entity = nil,nil,nil
                                end
                            end
                        end
                    end
                end
            end
        else
            local vehCheck = GetVehiclePedIsIn(PlayerPedId(),true)
                trailerAttached,trailerEnt = GetVehicleTrailerVehicle(vehCheck)
                if trailerAttached == 0 then
                    trailerEnt,trailerAttached = nil,nil
                end
        end
    Citizen.Wait(waitTime)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local letSleep = true
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, true)
        local pos = GetEntityCoords(ped)
        local vehLast = GetPlayersLastVehicle()
        local distanceToVeh = #(pos - GetEntityCoords(lastTruck))

        if veh and has_value(vehs, GetEntityModel(veh)) then
           lastTruck = veh
        end

        if not IsPedInAnyVehicle(ped, true) then
            if distanceToVeh < 6 then
                letSleep = false
                ShowHelpText(config.label, "REDNECK_TRUNKLIGHT")
                if IsControlJustPressed(0, 51) then 
                    if GetVehicleDoorAngleRatio(lastTruck, 5) > 0 then
                        SetVehicleDoorShut(lastTruck, 5, false)
                        if debug then
                            ShowText("[Vehicle] Trunk Closed.")
                        end
                    else
                        SetVehicleDoorOpen(lastTruck, 5, false, false)
                        if debug then
                            ShowText("[Vehicle] Trunk Opened.")
                        end
                    end
                end

                if IsControlJustPressed(0, 47) then 
                    if GetVehicleDoorAngleRatio(lastTruck, 4) > 0 then
                        SetVehicleDoorShut(lastTruck, 4, false)
                        if debug then
                            ShowText("[Vehicle] Light down.")
                        end
                    else
                        SetVehicleDoorOpen(lastTruck, 4, false, false)
                        if debug then
                            ShowText("[Vehicle] Light up.")
                        end
                    end
                end
            end
        end
        if letSleep then
            Citizen.Wait(500)
        end
    end
end)

function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
    local cameraCoord = GetGameplayCamCoord()
    local direction = RotationToDirection(cameraRotation)
    local destination =
    {
        x = cameraCoord.x + direction.x * distance,
        y = cameraCoord.y + direction.y * distance,
        z = cameraCoord.z + direction.z * distance
    }
    local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
    return b, c, e
end

function RotationToDirection(rotation)
    local adjustedRotation =
    {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z
    }
    local direction =
    {
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        z = math.sin(adjustedRotation.x)
    }
    return direction
end

function DrawMessage (message)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(0.0, 0.3)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(255, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(message)
    DrawText(0.035, 0.755)
end

function ShowText(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    DrawNotification(true, true)
end

function ShowHelpText(text, labelname)
    AddTextEntry(labelname, text)
    BeginTextCommandDisplayHelp(labelname)
    EndTextCommandDisplayHelp(0, 0, 1, -1)
end


function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end 
    end

    return false
end