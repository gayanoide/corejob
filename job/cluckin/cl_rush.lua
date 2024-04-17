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
        if ESX.PlayerData.job and ESX.PlayerData.job.name == "bell" or ESX.PlayerData.job2 and
            ESX.PlayerData.job2.name == "bell" then
            local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
            local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, bell.pos.Poulet.position.x,
                bell.pos.Poulet.position.y, bell.pos.Poulet.position.z)
            if dist3 <= 50.0 then
                Timer = 0
                DrawMarker(bell.pos.Poulet.position.Type, bell.pos.Poulet.position.x,
                    bell.pos.Poulet.position.y, bell.pos.Poulet.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    bell.pos.Poulet.position.Taille, bell.pos.Poulet.position.Taille,
                    bell.pos.Poulet.position.Taille, bell.pos.Poulet.position.r,
                    bell.pos.Poulet.position.g, bell.pos.Poulet.position.b, 255, 0, 1, 2, 0, nil, nil, 0)
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
                    exports["WaveShield"]:TriggerServerEvent("hbell:giveitem")
                    --TriggerServerEvent("hbell:giveitem")
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
        if ESX.PlayerData.job and ESX.PlayerData.job.name == "bell" or ESX.PlayerData.job2 and
            ESX.PlayerData.job2.name == "bell" then
            local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
            local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, bell.pos.Deplume.position.x,
                bell.pos.Deplume.position.y, bell.pos.Deplume.position.z)
            if dist3 <= 50.0 then
                Timer = 0
                DrawMarker(bell.pos.Deplume.position.Type, bell.pos.Deplume.position.x,
                    bell.pos.Deplume.position.y, bell.pos.Deplume.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    bell.pos.Deplume.position.Taille, bell.pos.Deplume.position.Taille,
                    bell.pos.Deplume.position.Taille, bell.pos.Deplume.position.r,
                    bell.pos.Deplume.position.g, bell.pos.Deplume.position.b, 255, 0, 1, 2, 0, nil, nil, 0)
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
                    --TriggerServerEvent("hbell:exchange")
                    exports["WaveShield"]:TriggerServerEvent("hbell:exchange")
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
        if ESX.PlayerData.job and ESX.PlayerData.job.name == "bell" or ESX.PlayerData.job2 and
            ESX.PlayerData.job2.name == "bell" then
            local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
            local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, bell.pos.Vente.position.x,
                bell.pos.Vente.position.y, bell.pos.Vente.position.z)
            if dist3 <= 50.0 then
                Timer = 0
                DrawMarker(bell.pos.Vente.position.Type, bell.pos.Vente.position.x,
                    bell.pos.Vente.position.y, bell.pos.Vente.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    bell.pos.Vente.position.Taille, bell.pos.Vente.position.Taille,
                    bell.pos.Vente.position.Taille, bell.pos.Vente.position.r,
                    bell.pos.Vente.position.g, bell.pos.Vente.position.b, 255, 0, 1, 2, 0, nil, nil, 0)
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
                    --TriggerServerEvent("hbell:sell")
                    exports["WaveShield"]:TriggerServerEvent("hbell:sell")
                    ExecuteCommand("emotecancel")
                end
            end
        end
        Citizen.Wait(Timer)
    end
end)