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
			if ESX.PlayerData.job and ESX.PlayerData.job.name == "ferme" or  ESX.PlayerData.job2 and ESX.PlayerData.job2.name == "ferme" then
            local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
            local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, ferme.pos.Fruit.position.x, ferme.pos.Fruit.position.y, ferme.pos.Fruit.position.z)

            if dist3 <= 50.0 then
                Timer = 0
                DrawMarker(ferme.pos.Fruit.position.Type, ferme.pos.Fruit.position.x, ferme.pos.Fruit.position.y, ferme.pos.Fruit.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, ferme.pos.Fruit.position.r, ferme.pos.Fruit.position.g, ferme.pos.Fruit.position.b, 255, 0, 1, 2, 0, nil, nil, 0)
                end

                if dist3 <= 3.0 then                    
                    --RageUI.Text({ message = "~y~[E]~s~ pour ~o~Recolter", time_display = 1 })
                Timer = 0   
					if IsControlJustPressed(1,51) then 
                        Timer = 0	
						ExecuteCommand("e pickup")
						Citizen.Wait(1000)
						exports["WaveShield"]:TriggerServerEvent("hferme:giveitem")
						--TriggerServerEvent("hferme:giveitem")
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
			if ESX.PlayerData.job and ESX.PlayerData.job.name == "ferme" or  ESX.PlayerData.job2 and ESX.PlayerData.job2.name == "ferme" then

            local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
            local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, ferme.pos.FruitCage.position.x, ferme.pos.FruitCage.position.y, ferme.pos.FruitCage.position.z)

            if dist3 <= 50.0 then
                Timer = 0
                DrawMarker(ferme.pos.FruitCage.position.Type, ferme.pos.FruitCage.position.x, ferme.pos.FruitCage.position.y, ferme.pos.FruitCage.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, ferme.pos.FruitCage.position.r, ferme.pos.FruitCage.position.g, ferme.pos.FruitCage.position.b, 255, 0, 1, 2, 0, nil, nil, 0)

                end

                if dist3 <= 3.0 then
                    --RageUI.Text({ message = "~y~[E]~s~ pour ~o~Traiter", time_display = 1 })
                Timer = 0   

					if IsControlJustPressed(1,51) then 
                        Timer = 0
						ExecuteCommand("e cleanhands")
						Citizen.Wait(2000)
						exports["WaveShield"]:TriggerServerEvent('hferme:exchange')
						--TriggerServerEvent('hferme:exchange')
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
			if ESX.PlayerData.job and ESX.PlayerData.job.name == "ferme" or  ESX.PlayerData.job2 and ESX.PlayerData.job2.name == "ferme" then

            local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
            local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, ferme.pos.Vente.position.x, ferme.pos.Vente.position.y, ferme.pos.Vente.position.z)

            if dist3 <= 50.0 then
                Timer = 0
                DrawMarker(ferme.pos.Vente.position.Type, ferme.pos.Vente.position.x, ferme.pos.Vente.position.y, ferme.pos.Vente.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, ferme.pos.Vente.position.r, ferme.pos.Vente.position.g, ferme.pos.Vente.position.b, 255, 0, 1, 2, 0, nil, nil, 0)

                end

                if dist3 <= 3.0 then
                    --RageUI.Text({ message = "~y~[E]~s~ pour ~o~Vendre", time_display = 1 })
                Timer = 0   

					if IsControlJustPressed(1,51) then  
                        Timer = 0			
						ExecuteCommand("e pickup")
						Citizen.Wait(1000)
						exports["WaveShield"]:TriggerServerEvent("hferme:sell")
						--TriggerServerEvent("hferme:sell")
						ExecuteCommand("emotecancel")
                    end  
                end
            end 
	    Citizen.Wait(Timer)
	 end
end)