local QBCore = exports['qb-core']:GetCoreObject()
ElevatorZone = {}
ShowDrawText = false

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        PlayerJob = QBCore.Functions.GetPlayerData().job
        if Config.UseTarget then
            RunTargetThread()
        else
            RunDrawtextThread()
        end
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
    if Config.UseTarget then
        RunTargetThread()
    else
        RunDrawtextThread()
    end
end)

function RunTargetThread()
    CreateThread(function()
        for k,v in pairs(Config.Elevators) do
            if v.Floors then
                for d,j in pairs(v.Floors) do
                    ElevatorZone["ElevatorZone"..k..d..j.Coords.x] =
	                exports['qb-target']:AddBoxZone("ElevatorZone"..k..d..j.Coords.x, vector3(j.Coords.x,j.Coords.y,j.Coords.z), 2.0, 2.0, {name = "ElevatorZone"..k..d,heading = 0,debugPoly = Config.DebugPoly,minZ=j.Coords.z-1,maxZ=j.Coords.z+1,}, {
	                	options = {{ action = function() PrepElevatorUI(k,v,d) end,icon = "fas fa-hand",label = Config.ElevatorLabel},},
	                	distance = 1.5
	                })
                end
            end
        end
    end)
end

function RunDrawtextThread()
    CreateThread(function()
        while true do
            Wait(0)
            local playerCoords = GetEntityCoords(PlayerPedId())
            local inRange = false

            local function handleElevator(k, v, d, j, label)
                if #(playerCoords - vector3(j.Coords.x,j.Coords.y,j.Coords.z)) < 2 then
                    if not ShowDrawText then
                        exports['qb-core']:DrawText(label, 'left')
                        ShowDrawText = true
                    end
                    if IsControlJustReleased(0, 38) then
                        exports['qb-core']:HideText()
                        PrepElevatorUI(k,v,d)
                    end
                    return true
                end
                return false
            end

            for k, v in pairs(Config.Elevators) do
                if v.Floors then
                    for d, j in pairs(v.Floors) do
                        if handleElevator(k, v, d, j, "[E] "..Config.ElevatorLabel) then
                            inRange = true
                        end
                    end
                end
            end

            if not inRange and ShowDrawText then
                exports['qb-core']:HideText()
                ShowDrawText = false
            end
        end
    end)
end

local function TeleportToFloor(x, y, z, h,Label)
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Wait(10)
    end
    Wait(1000)
    SetEntityCoords(PlayerPedId(), x, y, z, false, false, false, false)
    SetEntityHeading(PlayerPedId(), h)
    if Config.UseElevatorSound then
        TriggerEvent('InteractSound_CL:PlayOnOne',Config.UseElevatorSound,Config.SoundVolume)
    end
    Wait(100)
    DoScreenFadeIn(1000)
end

function PrepElevatorUI(elevatorID, elevatorOptions, floorID)
    local floors = elevatorOptions.Floors
    local current = floorID
    local elevator = elevatorID
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "open-elevator",
        CurrentFloor = current,
        Floors = floors,
        UIPosition = Config.UIPosition,
    })
end

RegisterNUICallback('go-to-floor', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
    local floor = data.floor
    local Label = floor.Label
    local Coords = floor.Coords
    local x = Coords.x
    local y = Coords.y
    local z = Coords.z
    local w = Coords.w
    TeleportToFloor(x,y,z,w,Label)
end)

AddEventHandler('onResourceStop', function(t) if t ~= GetCurrentResourceName() then return end
	for k in pairs(ElevatorZone) do exports['qb-target']:RemoveZone(k) end
end)