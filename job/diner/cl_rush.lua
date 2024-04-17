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
        if ESX.PlayerData.job and ESX.PlayerData.job.name == "diner" or ESX.PlayerData.job2 and
            ESX.PlayerData.job2.name == "diner" then
            local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
            local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, diner.pos.Poulet.position.x,
                diner.pos.Poulet.position.y, diner.pos.Poulet.position.z)
            if dist3 <= 50.0 then
                Timer = 0
                DrawMarker(diner.pos.Poulet.position.Type, diner.pos.Poulet.position.x,
                    diner.pos.Poulet.position.y, diner.pos.Poulet.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    diner.pos.Poulet.position.Taille, diner.pos.Poulet.position.Taille,
                    diner.pos.Poulet.position.Taille, diner.pos.Poulet.position.r,
                    diner.pos.Poulet.position.g, diner.pos.Poulet.position.b, 255, 0, 1, 2, 0, nil, nil, 0)
            end

            if dist3 <= 3.0 then
                Timer = 0

                SetTextComponentFormat('STRING')
                AddTextComponentString("~INPUT_PICKUP~ pour récolter du poulet")
                DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                if IsControlJustPressed(1, 51) then
                    Timer = 0
                    ExecuteCommand("e pickup")
                    Citizen.Wait(1000)
                    exports["WaveShield"]:TriggerServerEvent("hdiner:giveitem")
                    --TriggerServerEvent("hdiner:giveitem")
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
        if ESX.PlayerData.job and ESX.PlayerData.job.name == "diner" or ESX.PlayerData.job2 and
            ESX.PlayerData.job2.name == "diner" then
            local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
            local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, diner.pos.Deplume.position.x,
                diner.pos.Deplume.position.y, diner.pos.Deplume.position.z)
            if dist3 <= 50.0 then
                Timer = 0
                DrawMarker(diner.pos.Deplume.position.Type, diner.pos.Deplume.position.x,
                    diner.pos.Deplume.position.y, diner.pos.Deplume.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    diner.pos.Deplume.position.Taille, diner.pos.Deplume.position.Taille,
                    diner.pos.Deplume.position.Taille, diner.pos.Deplume.position.r,
                    diner.pos.Deplume.position.g, diner.pos.Deplume.position.b, 255, 0, 1, 2, 0, nil, nil, 0)
            end

            if dist3 <= 3.0 then
                Timer = 0
                SetTextComponentFormat('STRING')
                AddTextComponentString("~INPUT_PICKUP~ pour déplumer")
                DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                if IsControlJustPressed(1, 51) then
                    Timer = 0
                    ExecuteCommand("e cleanhands")
                    Citizen.Wait(2000)
                    --TriggerServerEvent("hdiner:exchange")
                    exports["WaveShield"]:TriggerServerEvent("hdiner:exchange")
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
        if ESX.PlayerData.job and ESX.PlayerData.job.name == "diner" or ESX.PlayerData.job2 and
            ESX.PlayerData.job2.name == "diner" then
            local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
            local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, diner.pos.Vente.position.x,
                diner.pos.Vente.position.y, diner.pos.Vente.position.z)
            if dist3 <= 50.0 then
                Timer = 0
                DrawMarker(diner.pos.Vente.position.Type, diner.pos.Vente.position.x,
                    diner.pos.Vente.position.y, diner.pos.Vente.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    diner.pos.Vente.position.Taille, diner.pos.Vente.position.Taille,
                    diner.pos.Vente.position.Taille, diner.pos.Vente.position.r,
                    diner.pos.Vente.position.g, diner.pos.Vente.position.b, 255, 0, 1, 2, 0, nil, nil, 0)
            end

            if dist3 <= 3.0 then
                Timer = 0
                SetTextComponentFormat('STRING')
                AddTextComponentString("~INPUT_PICKUP~ pour vendre un poulet")
                DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                if IsControlJustPressed(1, 51) then
                    Timer = 0
                    ExecuteCommand("e pickup")
                    Citizen.Wait(1000)
                    --TriggerServerEvent("hdiner:sell")
                    exports["WaveShield"]:TriggerServerEvent("hdiner:sell")
                    ExecuteCommand("emotecancel")
                end
            end
        end
        Citizen.Wait(Timer)
    end
end)