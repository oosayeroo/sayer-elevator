local QBCore = exports['qb-core']:GetCoreObject()
ElevatorZone = {}

CreateThread(function()
    for k,v in pairs(Config.Elevators) do
        if v.Floors then
            for d,j in pairs(v.Floors) do
                ElevatorZone["ElevatorZone"..k..d] =
	            exports['qb-target']:AddBoxZone("ElevatorZone"..k..d, vector3(j.Coords.x,j.Coords.y,j.Coords.z), 2.0, 2.0, {name = "ElevatorZone"..k..d,heading = 0,debugPoly = Config.DebugPoly,minZ=j.Coords.z-1,maxZ=j.Coords.z+1,}, {
	            	options = {{ action = function() OpenElevatorMenu(j.Label,v.Floors) end,icon = "fas fa-hand",label = "Use Elevator",job = v.JobCode,},},
	            	distance = 1.5
	            })
            end
        end
    end
end)

function OpenElevatorMenu(label,floors)
    local columns = {
        {
            header = label,
            isMenuHeader = true,
        },
    }
    for k, v in ipairs(floors) do

        local item = {}
        item.header = v.Label

        local text = ""
        text = text .. "Take Elevator To "..v.Label.." "
        item.text = text

        item.params = {
            event = 'sayer-elevator:TpToFloor',
            args = {
                floor = v.Coords,
                FLabel = v.Label,
            }
        }
        table.insert(columns, item)
    end

    exports['qb-menu']:openMenu(columns)
end

RegisterNetEvent('sayer-elevator:TpToFloor', function(args)
    local ped = PlayerPedID()
    local coords = args.floor
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Wait(10)
    end
    if Config.UseElevatorSound then
        TriggerEvent('InteractSound_CL:PlayOnOne',Config.UseElevatorSound,Config.SoundVolume)
    end
    TeleportToFloor(coords.x, coords.y, coords.z, coords.w,args.FLabel)
end)

local function TeleportToFloor(x, y, z, h,Floor)
    CreateThread(function()
        SetEntityCoords(PlayerPedId(), x, y, z, false, false, false, false)
        SetEntityHeading(PlayerPedId(), h)

        Wait(100)

        DoScreenFadeIn(1000)
        QBCore.Functions.Notify("Arrived on "..Floor.."!",'success')
    end)
end

AddEventHandler('onResourceStop', function(t) if t ~= GetCurrentResourceName() then return end
	for k in pairs(ElevatorZone) do exports['qb-target']:RemoveZone(k) end
end)