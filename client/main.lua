local ESX = exports.es_extended:getSharedObject()
local previewVeh, cam
local isPreviewing = false

CreateThread(function()
    if Config.Blip.enabled then
        local blip = AddBlipForCoord(Config.Shop.coords)
        SetBlipSprite(blip, Config.Blip.sprite)
        SetBlipColour(blip, Config.Blip.color)
        SetBlipScale(blip, Config.Blip.scale)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(Config.Blip.label)
        EndTextCommandSetBlipName(blip)
    end

    lib.requestModel(Config.Shop.ped)
    local ped = CreatePed(0, Config.Shop.ped, Config.Shop.coords.x, Config.Shop.coords.y, Config.Shop.coords.z - 1.0, 0.0, false, false)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    exports.ox_target:addLocalEntity(ped, {
        {
            label = 'Katso valikoimaa',
            icon = 'fa-solid fa-car',
            onSelect = openShop
        }
    })
end)

CreateThread(function()
    while true do
        if isPreviewing then
            Wait(0)
            if IsControlJustPressed(0, 322) then -- ESC
                lib.hideContext()
                closePreview()
            end
        else
            Wait(500)
        end
    end
end)

function openShop()
    local options = {}

    for _, v in pairs(Config.Vehicles) do
        options[#options+1] = {
            title = v.label,
            description = ('$%s'):format(v.price),
            onSelect = function()
                previewVehicle(v)
            end
        }
    end

    lib.registerContext({
        id = 'vehicle_shop',
        title = 'Autokauppa',
        options = options
    })

    lib.showContext('vehicle_shop')
end

function previewVehicle(vehicle)
    deletePreview()
    isPreviewing = true

    lib.requestModel(vehicle.model)
    previewVeh = CreateVehicle(vehicle.model, Config.Shop.preview.xyz, Config.Shop.preview.w, false, false)
    SetVehicleDoorsLocked(previewVeh, 2)
    SetEntityInvincible(previewVeh, true)
    FreezeEntityPosition(previewVeh, true)

    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamCoord(cam, Config.Shop.preview.x + 3.0, Config.Shop.preview.y + 3.0, Config.Shop.preview.z + 1.5)
    PointCamAtEntity(cam, previewVeh)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)

    lib.registerContext({
        id = 'vehicle_preview',
        title = vehicle.label,
        options = {
            {
                title = 'Osta',
                onSelect = function()
                    TriggerServerEvent('ox_vehicleshop:buyVehicle', vehicle, ESX.Game.GetVehicleProperties(previewVeh))
                    closePreview()
                end
            },
            {
                title = 'Ei sittenkää',
                onSelect = closePreview
            }
        }
    })

    lib.showContext('vehicle_preview')
end

function closePreview()
    isPreviewing = false
    deletePreview()
    RenderScriptCams(false, true, 500, true, true)
    DestroyCam(cam)
    cam = nil
end

function deletePreview()
    if previewVeh and DoesEntityExist(previewVeh) then
        DeleteEntity(previewVeh)
        previewVeh = nil
    end
end
