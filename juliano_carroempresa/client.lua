
local Vehicles = {}
local Categories = {}
ESX = exports["es_extended"]:getSharedObject()

local PlayerData = {}


Citizen.CreateThread(function()
	-- while ESX == nil do
	-- 	TriggerEvent('esx:AcessoMythic', function(obj) ESX = obj end)
	-- 	Citizen.Wait(0)
    -- end
    
    Citizen.Wait(2500)
    ESX.TriggerServerCallback('esx_vehicleshop:getCategories', function (categories)
		Categories = categories
	end)

	ESX.TriggerServerCallback('esx_vehicleshop:getVehicles', function (vehicles)
		Vehicles = vehicles
	end)


	--PlayerData = ESX.GetPlayerData().job.name
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)
	

function GetVehicleDataByHash(modelHash)
	for k,v in ipairs(Vehicles) do
		if GetHashKey(v.model) == modelHash then
			return k,v
		end
	end
	return -1,nil
end

RegisterCommand('carroempresa',function(source, args)
   ESX.TriggerServerCallback('concegang:getPersonnalVehicles', function(vehicles, state)
        
		local elements = {}

       for i=1, #vehicles, 1 do
           local data = vehicles[i].car
           local dataIndex,vehData = GetVehicleDataByHash(data.model)

           table.insert(elements, {label = data.plate, index = data, state = 'nil'})
       end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'personnal_vehicle',
		{
			title    = 'Veículo pessoal',
			align    = 'top-left',
			elements = elements
		},
       function (data, menu) --Submit Cb

           local Option = OpenMenuEscolha()

			if Option then
				--print(ESX.DumpTable(data.current.index.plate))
				TriggerServerEvent('gang:sendcar', data.current.index)
				menu.close()
				MenuAberto = false
           end
       
		end,function(data, menu)
			MenuAberto = false
           menu.close()
       end)
               
   end)
end)





function OpenMenuEscolha()

	local escolha = 'nd'
	local loop = true
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu_escolha',
	{
		title    = 'Deseja mesmo enviar seu carro para a gang ?',
		align    = 'top-left',
		elements = {
			{label = 'Sim', value = 'yes'},
			{label = 'Não', value = 'no'}
		}	
	}, function(data, menu)
		if data.current.value == 'yes' then
			menu.close()
			escolha = true
		end
		if data.current.value == 'no' then
			menu.close()
			escolha = false
		end	
	end,function()
	end)

	while escolha == 'nd' do
		Citizen.Wait(50)
	end
	
	if escolha ~= 'nd' then
		return escolha
	end		
end	

local MenuAberto = false

Citizen.CreateThread(function()

	while true do
		local time = 750
		if ESX ~= nil then
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
		
			for k, v in pairs(Config.Locations) do
	
				
				if PlayerData.job ~= nil and PlayerData.job.name == k  then
					local dist = #(coords - v.location)
					if dist < 5.0 then
						time = 0

						DrawMarker(2, v.location,  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 30, 150, 30, 222, false, false, 0, true, false, false, false)

						DrawText3Ds(v.location.x, v.location.y, v.location.z + 0.2, "~g~[E]~w~ Abrir Garagem")

					
					end

					if dist < 1.5 and not MenuAberto then
						ESX.ShowHelpNotification('Pressione ~INPUT_CONTEXT~ para acessar a lista de veículos.')

						if IsControlJustReleased(0, 51) then
							MenuAberto = true
							OpenMenuVeh(v)
						end
					end
				end
			end
		end	
		Citizen.Wait(time)
	end
end)--]]

function DrawText3Ds(x,y,z, text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
  
	SetTextScale(0.4, 0.4)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(1)
	SetTextColour(255, 255, 255, 255)
	SetTextOutline()
  
	AddTextComponentString(text)
	DrawText(_x, _y)
  
	local factor = (string.len(text)) / 270
	DrawRect(_x, _y + 0.020, 0.005 + factor, 0.00, 31, 31, 31, 155)
  end 
  
function OpenMenuVeh(date)
    ESX.TriggerServerCallback('concegang:getVehGang', function(vehicles)
        
		local elements = {}

        for i=1, #vehicles, 1 do
            local data = vehicles[i].car
            local dataIndex,vehData = GetVehicleDataByHash(data.model)


            table.insert(elements, {label = data.plate, index = data, state = 'nil'})
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'personnal_vehicle',
		{
			title    = 'Veículo da GANG',
			align    = 'top-left',
			elements = elements
		},
        function (data, menu) --Submit Cb

			menu.close()
	
			ESX.Game.SpawnVehicle(data.current.index.model, date.SpawnPoint, date.h, function(vehicle)
			print(ESX.DumpTable(data.current.index))
			ESX.Game.SetVehicleProperties(vehicle, data.current.index)
				TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1) 
				MenuAberto = false
			end)
        
        end,function(data, menu)
		MenuAberto = false
            menu.close()
        end)
                
    end)
end

