local ESX = exports.es_extended:getSharedObject()

RegisterNetEvent('ox_vehicleshop:buyVehicle', function(vehicle, props)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer.getMoney() < vehicle.price then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Autokauppa',
            description = 'Ei tarpeeks rahaa',
            type = 'error'
        })
        return
    end

    local plate = Config.PlatePrefix .. math.random(1000,9999)
    props.plate = plate

    xPlayer.removeMoney(vehicle.price)

    MySQL.insert('INSERT INTO owned_vehicles (owner, plate, vehicle, type, stored) VALUES (?, ?, ?, ?, ?)',
        { xPlayer.identifier, plate, json.encode(props), 'car', 1 }
    )

    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Autokauppa',
        description = ('Ostettu! %s [%s]'):format(vehicle.label, plate),
        type = 'success'
    })
end)
