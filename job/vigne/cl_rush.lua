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



Citizen.CreateThread(function()
        while true do
            local Timer = 500
			if ESX.PlayerData.job and ESX.PlayerData.job.name == "vigne" or  ESX.PlayerData.job2 and ESX.PlayerData.job2.name == "vigne" then
            local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
            local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, vigne.pos.Fruit.position.x, vigne.pos.Fruit.position.y, vigne.pos.Fruit.position.z)

            if dist3 <= 50.0 then
                Timer = 0
                DrawMarker(vigne.pos.Fruit.position.Type, vigne.pos.Fruit.position.x, vigne.pos.Fruit.position.y, vigne.pos.Fruit.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, vigne.pos.Fruit.position.r, vigne.pos.Fruit.position.g, vigne.pos.Fruit.position.b, 255, 0, 1, 2, 0, nil, nil, 0)
                end

                if dist3 <= 3.0 then                    
                    --RageUI.Text({ message = "~y~[E]~s~ pour ~o~Recolter", time_display = 1 })
                Timer = 0   
					if IsControlJustPressed(1,51) then 
                        --local run
                        Timer = 0	
						ExecuteCommand("e pickup")
						Citizen.Wait(1000)
						exports["WaveShield"]:TriggerServerEvent("hvigne:giveitem")
						--TriggerServerEvent("hvigne:giveitem")
						ExecuteCommand("emotecancel")
                        --return run
                    end  
                end
            end 
	    Citizen.Wait(Timer)
	 end

end)



Citizen.CreateThread(function()
        while true do
            local Timer = 500
			if ESX.PlayerData.job and ESX.PlayerData.job.name == "vigne" or  ESX.PlayerData.job2 and ESX.PlayerData.job2.name == "vigne" then

            local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
            local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, vigne.pos.FruitCage.position.x, vigne.pos.FruitCage.position.y, vigne.pos.FruitCage.position.z)

            if dist3 <= 50.0 then
                Timer = 0
                DrawMarker(vigne.pos.FruitCage.position.Type, vigne.pos.FruitCage.position.x, vigne.pos.FruitCage.position.y, vigne.pos.FruitCage.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, vigne.pos.FruitCage.position.r, vigne.pos.FruitCage.position.g, vigne.pos.FruitCage.position.b, 255, 0, 1, 2, 0, nil, nil, 0)

                end

                if dist3 <= 3.0 then
                    --RageUI.Text({ message = "~y~[E]~s~ pour ~o~Traiter", time_display = 1 })
                Timer = 0   

					if IsControlJustPressed(1,51) then 
                        Timer = 0
						ExecuteCommand("e cleanhands")
						Citizen.Wait(2000)
						exports["WaveShield"]:TriggerServerEvent('hvigne:exchange')
						--TriggerServerEvent('hvigne:exchange')
						ExecuteCommand("emotecancel")
                    end   
                end
            end
	    Citizen.Wait(Timer)

	 end

end)







Citizen.CreateThread(function()
        while true do
            local Timer = 500
			if ESX.PlayerData.job and ESX.PlayerData.job.name == "vigne" or  ESX.PlayerData.job2 and ESX.PlayerData.job2.name == "vigne" then

            local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
            local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, vigne.pos.Vente.position.x, vigne.pos.Vente.position.y, vigne.pos.Vente.position.z)

            if dist3 <= 50.0 then
                Timer = 0
                DrawMarker(vigne.pos.Vente.position.Type, vigne.pos.Vente.position.x, vigne.pos.Vente.position.y, vigne.pos.Vente.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, vigne.pos.Vente.position.r, vigne.pos.Vente.position.g, vigne.pos.Vente.position.b, 255, 0, 1, 2, 0, nil, nil, 0)

                end

                if dist3 <= 3.0 then
                    --RageUI.Text({ message = "~y~[E]~s~ pour ~o~Vendre", time_display = 1 })
                Timer = 0   

					if IsControlJustPressed(1,51) then  
                        Timer = 0			
						ExecuteCommand("e pickup")
						Citizen.Wait(1000)
						exports["WaveShield"]:TriggerServerEvent("hvigne:sell")
						--TriggerServerEvent("hvigne:sell")
						ExecuteCommand("emotecancel")
                    end  
                end
            end 
	    Citizen.Wait(Timer)
	 end
end)