local trailerEnt = nil
RegisterCommand('dblTrailer', function(source, args, rawCommand)
    local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 8.0, 0.5))
    local veh = 'doubletrailer'
    vehiclehash = GetHashKey(veh)
    boatHash  = GetHashKey('zodiac')
        RequestModel(vehiclehash)
        RequestModel(boatHash)
        Citizen.CreateThread(function() 
            local waiting = 0
            while not HasModelLoaded(vehiclehash) or not HasModelLoaded(boatHash) do
                waiting = waiting + 100
                Citizen.Wait(100)
                if waiting > 5000 then
                    ShowNotification("~r~Could not load the vehicle model in time, a crash was prevented.")
                    break
                end
            end
            local vehiclecreated = CreateVehicle(vehiclehash, x, y, z, GetEntityHeading(PlayerPedId())+90, 1, 1)
            local boatLower = CreateVehicle(boatHash, x, y, z,0.0, 1, 1)
            local boatUpper = CreateVehicle(boatHash, x, y, z,0.0, 1, 1)
            SetEntityRotation(vehiclecreated,180.0,180.0,0.0,0,true)
            AttachEntityToEntity(boatLower,vehiclecreated,GetEntityBoneIndexByName(vehiclecreated,'misc_a'),0.0,-1.0,-0.2,0.0,0.0,0.0,0,0,1,0,1,1)
            AttachEntityToEntity(boatUpper,vehiclecreated,GetEntityBoneIndexByName(vehiclecreated,'misc_b'),0.0,-1.0,-0.2,0.0,0.0,0.0,0,0,1,0,1,1)

            SetModelAsNoLongerNeeded(veh)
            SetModelAsNoLongerNeeded(boatHash)
        end)
end)

Citizen.CreateThread(function()
    while true do
        waitTime = 500
        if not IsPedInAnyVehicle(PlayerPedId(), true) then
            local hit, coords, entity = RayCastGamePlayCamera(10.0)
            if hit == 1 then
                if GetEntityType(entity) ~= 0 then
                    if GetEntityModel(entity)  == GetHashKey('zodiac') then
                        waitTime = 1
                        if IsEntityAttachedToAnyVehicle(entity) then
                            DrawMessage('Druk op ~g~E~w~ a bla bla')
                            if IsControlJustPressed(0,38) then
                                if GetEntityModel(GetEntityAttachedTo(entity)) == GetHashKey('doubletrailer') then
                                    AttachEntityToEntity(entity,GetEntityAttachedTo(entity),GetEntityBoneIndexByName(GetEntityAttachedTo(entity),'misc_a'),0.0,-7.5,-1.0,0.0,0.0,0.0,0,0,1,0,1,1)
                                    DetachEntity(entity)
                                end
                            end
                        end
                    end
                end
            end
            if trailerEnt ~= nil then

                    local hit, coords, entity = RayCastGamePlayCamera(20.0)
                    if hit == 1 then
                        if GetEntityType(entity) ~= 0 then
                            if GetEntityModel(entity) == GetHashKey('zodiac') then
                                DrawMessage('Druk op ~g~E~w~ a bla bla')
                                if IsControlJustPressed(0,38) then
                                    local boatUpper = GetWorldPositionOfEntityBone(trailerEnt,GetEntityBoneIndexByName(trailerEnt,'misc_b'))
                                    if not IsAnyVehicleNearPoint(boatUpper,1.5) then
                                        AttachEntityToEntity(entity,trailerEnt,GetEntityBoneIndexByName(trailerEnt,'misc_b'),0.0,-1.0,-0.2,0.0,0.0,0.0,0,0,1,0,1,1)

                                    else
                                        local boatLower = GetWorldPositionOfEntityBone(trailerEnt,GetEntityBoneIndexByName(trailerEnt,'misc_a'))
                                        if not IsAnyVehicleNearPoint(boatLower,0.66219) then
                                            AttachEntityToEntity(entity,trailerEnt,GetEntityBoneIndexByName(trailerEnt,'misc_a'),0.0,-1.0,-0.2,0.0,0.0,0.0,0,0,1,0,1,1)
                                        end
                                    end
                                end
                            end
                        end
                    end
            end
        else
            local vehCheck = GetVehiclePedIsIn(PlayerPedId(),true)
            if GetEntityModel(vehCheck) == GetHashKey('f550swr') then
                trailerAttached,trailerEnt = GetVehicleTrailerVehicle(vehCheck)
            end
        end
    Citizen.Wait(waitTime)
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
    DrawLine(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z,255,0,0,255)
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


