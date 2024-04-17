ESX = exports["es_extended"]:getSharedObject()



Citizen.CreateThread(function()
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

	while ESX.GetPlayerData().job2 == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	ESX.PlayerData.job2 = job2
end)

local disablecontrol = false
Citizen.CreateThread(function()
	while true do
	Citizen.Wait(0)
	    if disablecontrol then
	    	DisableAllControlActions(0)
		end
	end
end)
local Blips = {}
local run = false
local spawn = false
local pay = false
local oldtask = { x = 0.0 }
local task 
local oldtask = 0
local tasktype
local models = "" 
local engine
local taskok = false
function startrun()
    run = true
    task = RandomTask()
	ClearAreaOfVehicles(task.x, task.y, task.z, 3.0, false, false, false, false, false)
	models = RandomVehicle()
	tasktype = RandomType()
	if tasktype == "moteur" then
		ESX.ShowNotification("On nous a appelé pour un problème moteur, rends toi sur site pour voir ce qu'il se passe", 3000)
	elseif tasktype == "porte" then
		ESX.ShowNotification("On nous a appelé pour une porte manquante, rends toi sur site pour voir ce qu'il se passe", 3000)
	elseif tasktype == "sale" then
		ESX.ShowNotification("On nous a appelé pour un nettoyage important, rends toi sur site pour voir ce qu'il se passe", 3000)
	end
	nextStepRunbenny(task) 
end

function RandomTask()
	local id = GetRandomIntInRange(1, #(benny.pos.Cars)+1)
	if oldtask == id then
		if id >= #(benny.pos.Cars) then
			id = id+1
		else
			id = id-1
		end
	end

	print(GetRandomIntInRange(1, #(benny.pos.Cars)+1))
	print(id)
	oldtask = id
	return benny.pos.Cars[id]
end

function RandomVehicle()
	return benny.pos.Models[math.random(#benny.pos.Models)]
end

function RandomType()
	return benny.pos.TaskType[math.random(#benny.pos.TaskType)]
end

function stoprun()
    run = false
    RemoveBlip(Blips['delivery'])
	Blips['delivery'] = nil
	task = nil
	spawn = false
	engine = nil
	pay = false
	tasktype = nil
	taskok = false
end



function nextStepRunbenny(gps)
	if gps ~= 0 then
		if Blips['delivery'] ~= nil then
			RemoveBlip(Blips['delivery'])
			Blips['delivery'] = nil
		end
		Blips['delivery'] = AddBlipForCoord(gps.x, gps.y, gps.z)
		SetBlipRoute(Blips['delivery'], true)
	end
end 

Citizen.CreateThread(function()
	while true do
		if run then
            local playerPed = PlayerPedId()
		    local playerCoords = GetEntityCoords(playerPed)
			local targetDistance = #(playerCoords - vector3(task.x, task.y, task.z))
			if targetDistance <= 100 and not spawn then
				ESX.Streaming.RequestModel(models)
				engine = CreateVehicle(models, task.x, task.y, task.z, task.h, true, false)
				print(json.encode(tasktype))
				if tasktype == "moteur" then
					SetVehicleEngineHealth(engine, -299) 
					SetVehicleDoorOpen(engine, 4, false, false)
				elseif tasktype == "porte" then
					local door = GetRandomIntInRange(0, 5)
					SetVehicleBodyHealth(engine, 0)
					SetVehicleDoorBroken(engine, door, true)
				elseif tasktype == "sale" then
					SetVehicleDirtLevel(engine, 15.0)
				end
				spawn = true
				local engineheal = ESX.Game.GetVehicleProperties(engine)
            end

            if targetDistance <= 10 then
				local engineheal = ESX.Game.GetVehicleProperties(engine)
				if engineheal.engineHealth >= 1000.0 and tasktype == "moteur" then
					taskok = true
				elseif engineheal.bodyHealth >= 1000.0 and tasktype == "porte" then
					taskok = true
				elseif GetVehicleDirtLevel(engine) <= 0.0 and tasktype == "sale" then
					taskok = true
				end

				if taskok then
					if not pay then
						pay = true
						local MoneyPay = GetRandomIntInRange(100, 200)
						local MoneyPay2 = GetRandomIntInRange(200, 200)
						ESX.TriggerServerCallback('hbenny:Paye', function(data) 
							DeleteEntity(engine)
							stoprun()
						end, MoneyPay, MoneyPay2)
					end
				end
                RemoveBlip(Blips['delivery'])
	            Blips['delivery'] = nil
            end
        end
	    Citizen.Wait(0)
    end
end)