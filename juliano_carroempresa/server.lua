ESX = exports["es_extended"]:getSharedObject()


RegisterServerEvent('gang:sendcar')
AddEventHandler('gang:sendcar',function(vehicle)
	
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Sync.execute('DELETE FROM `owned_vehicles` WHERE `plate` = @plate', {
		['@plate'] = vehicle.plate
	})

MySQL.Async.execute('INSERT INTO vehicles_gang (gang, vehicle, plate) VALUES (@gang, @vehicle, @plate)',
    {
        ['@gang']   = xPlayer.job.name,
        ['@vehicle'] = json.encode(vehicle),
        ['@plate'] = vehicle.plate

    })

	TriggerClientEvent('esx:showNotification', _source, 'O veículo foi para a sua ~y~Gang~w~ com sucesso.')
end)

ESX.RegisterServerCallback('concegang:getPersonnalVehicles', function(source, cb)

	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner',
	{
		['@owner'] = xPlayer.identifier
	},
	function(result)

		local vehicles = {}
		local state = {}
		for i=1, #result, 1 do
			local vehicleData = json.decode(result[i].vehicle)
			local plate = result[i].plate


			table.insert(vehicles, {
				car = vehicleData,
				plate = plate
			})
		
		end
		cb(vehicles)
	end)
end)


ESX.RegisterServerCallback('concegang:getVehGang', function(source, cb)

	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM vehicles_gang WHERE gang = @gang',
	{
		['@gang'] = xPlayer.job.name
	},
	function(result)

		local vehicles = {}

		for i=1, #result, 1 do
			local vehicleData = json.decode(result[i].vehicle)

			table.insert(vehicles, {
				car = vehicleData
			})
		
		end
		cb(vehicles)
	end)
end)