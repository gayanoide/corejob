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

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
        Wait(0)
	end
end


local Blips = {}
function Menuf6benny()
    local hbennyf6 = RageUI.CreateMenu("benny", " ")
    local emotes = RageUI.CreateSubMenu(hbennyf6, "benny", " ")
    local factures = RageUI.CreateSubMenu(hbennyf6, "benny", " ")
    local entretien = RageUI.CreateSubMenu(hbennyf6, "benny", " ")
    local plateau = RageUI.CreateSubMenu(hbennyf6, "benny", " ")
    RageUI.Visible(hbennyf6, not RageUI.Visible(hbennyf6))
    while hbennyf6 do
        Citizen.Wait(0)
            RageUI.IsVisible(hbennyf6, true, true, true, function()

                RageUI.Checkbox("Prendre son service", nil, service, {}, function(Hovered, Ative, Selected, Checked)
                    if Selected then
                        service = Checked
                        if Checked then
                            onservice = true
                            ESX.ShowNotification('Vous venez de prendre votre service.')
                            local info = 'prisebennys'
                            TriggerServerEvent('benny:PriseEtFinservice', info)
                            --exports["WaveShield"]:TriggerServerEvent('hbenny:Ouvert')
                        else
                            local info = 'finbennys'
                            TriggerServerEvent('benny:PriseEtFinservice', info)
                            onservice = false
                            ESX.ShowNotification('Vous venez de mettre fin à votre service.')
                        end
                    end
                end)
                
                RageUI.Separator(" ")

            if onservice then

                local playerPed = PlayerPedId()
                local vehicle   = GetVehiclePedIsIn(playerPed, false)
                if IsPedInAnyVehicle(playerPed, false) then

                    RageUI.ButtonWithStyle("Allumer le moteur", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then      
					    	SetVehicleEngineOn(vehicle, true, true)
                        end
                    end)

                    RageUI.ButtonWithStyle("Eteindre le moteur", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then      
					    	SetVehicleEngineOn(vehicle, false, false)
                        end
                    end)

                    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                    local vehe = GetVehicleEngineHealth(veh) / 10
                    local vehf = GetVehicleFuelLevel(veh)
                    local vehp = GetVehicleEngineTemperature(veh)
                    local veht = GetVehicleClass(veh)
                    local vehn = GetVehicleDoorLockStatus(veh)
                    local pVeh2 = GetVehiclePedIsIn(PlayerPedId(), false)
                    local pPed = PlayerPedId()
                    local pVeh = GetVehiclePedIsUsing(pPed)
                    local vModel = GetEntityModel(pVeh)
                    local vName = GetDisplayNameFromVehicleModel(vModel)

                    RageUI.Separator(" ")
                    RageUI.Separator("Nom du vehicule : ~y~"..vName)
                    RageUI.Separator("Plaque : ~y~"..GetVehicleNumberPlateText(pVeh2))
                    if vehe == 10 then
                        RageUI.Separator("État du véhicule : ~y~0"..math.ceil(vehe).."~w~ %")
                    else                        
                        RageUI.Separator("État du véhicule : ~y~"..math.ceil(vehe).."~w~ %")
                    end


                    --RageUI.Separator(" ")
                    --RageUI.Separator(" tu dois etre a l'exterieur ") 
                    --RageUI.Separator(" pour faire le reste ")
                    RageUI.Separator(" ") 
                end

                
                local playerPed = PlayerPedId()
                local vehicle   = GetVehiclePedIsIn(playerPed, false)
                if not IsPedInAnyVehicle(playerPed, false) then

                    RageUI.ButtonWithStyle("👤 Emotes rapide",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    end, emotes)

                    RageUI.ButtonWithStyle("🔧 Menu Facture",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    end, factures)

                    RageUI.ButtonWithStyle("🔧 Menu entretien",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    end, entretien)

                    RageUI.ButtonWithStyle("🚘 Plateau",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    end, plateau)                    

                    RageUI.ButtonWithStyle("Mettre en fourriere", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local playerPed = PlayerPedId()
                            local vehicle = ESX.Game.GetClosestVehicle()
                            if IsPedSittingInAnyVehicle(playerPed) then
                                RageUI.Popup({message = "Vous ne pouvez pas effectuer cette action depuis un véhicule !"})
                                return
                            end
                            if DoesEntityExist(vehicle) then
                                local vehicle_plate = ESX.Game.GetVehicleProperties(vehicle)['plate']
                                ExecuteCommand("e clipboard")
                                Citizen.Wait(20000)
                                ClearPedTasks(GetPlayerPed(-1))
                                ClearPedTasksImmediately(playerPed)
                                ESX.TriggerServerCallback('esx_policejob:SendVehicleToImpound', function(is_owned) 
                                    if is_owned then 
                                        ESX.ShowNotification('Vehicule mis en fourrière')
                                    else
                                        ESX.ShowNotification('Vehicule mis en fourrière')
                                    end
                                    ESX.Game.DeleteVehicle(vehicle)
                                end, vehicle_plate)
                            else
                                ESX.ShowNotification('vous devez être près d\'un véhicule')
                            end
                            RageUI.CloseAll()                            
                            end
                        end)                    
                
                    RageUI.ButtonWithStyle("🏁 Lancer le run", nil, {RightLabel = ""}, true, function(_, _, selected)
                        if selected then
                            startrun()
                            RageUI.CloseAll()
                        end
                    end)   


                end

                







                














            end   
				
                end, function() 
                end)


                RageUI.IsVisible(plateau, true, true, true, function()                    

                    RageUI.ButtonWithStyle("🚘 Deployer les rampes", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ExecuteCommand("deployramp")
                        end
                    end)

                    RageUI.ButtonWithStyle("🚘 Retirer les rampes", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ExecuteCommand("ramprm")
                        end
                    end)

                    RageUI.ButtonWithStyle("🚘 Attacher le vehicule", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ExecuteCommand("attach")
                        end
                    end)

                    RageUI.ButtonWithStyle("🚘 Dettacher le vehicule", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ExecuteCommand("detach")
                        end
                    end)
                    
                end, function() 
                end)

                
                RageUI.IsVisible(emotes, true, true, true, function()

                    RageUI.ButtonWithStyle("🧽 Nettoyer ses main", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ExecuteCommand("e cleanhands")
                        end
                    end)
                    
                    RageUI.ButtonWithStyle("🧽 Planche a prise de note", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ExecuteCommand("e clipboard")
                        end
                    end)
                                
                    RageUI.Separator() 
                    RageUI.ButtonWithStyle("Annuler l'emote",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ExecuteCommand('emotecancel')
                            RageUI.CloseAll()
                            ClearPedTasks(GetPlayerPed(-1))
                        end
                    end) 
                
                end, function() 
                end)






                RageUI.IsVisible(entretien, true, true, true, function()

                    RageUI.Separator("↓ Entretien ↓")  

                    RageUI.ButtonWithStyle("🧽 Nettoyer", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local playerPed = PlayerPedId()
                            local vehicle = GetClosestVehicle(GetEntityCoords(playerPed), 4.0, 0, 127)
                            
                            TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
				    	    Citizen.CreateThread(function()
				        		Citizen.Wait(10000)	
					    	    SetVehicleDirtLevel(vehicle, 0)
					    	    ClearPedTasksImmediately(playerPed)	
                                ClearPedTasks(GetPlayerPed(-1))
				    		RageUI.Popup({message = "Véhicule ~g~nettoyé"})
				    	    end)
                        end
                    end)

                    RageUI.ButtonWithStyle("🔧 Réparation debout", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local playerPed = PlayerPedId()
                            local vehicle = GetClosestVehicle(GetEntityCoords(playerPed), 4.0, 0, 127)
                            local animDict = "mini@repair"
                            local animName = "fixing_a_ped"
                        
                            loadAnimDict(animDict)
                            TaskPlayAnim(playerPed, animDict, animName, 5.0, 1.5, 20000, 0, 0.0, 0, 0, 0)
				    	    Citizen.CreateThread(function()
				    		    Citizen.Wait(10000)
				    		    SetVehicleFixed(vehicle)
				    		    SetVehicleDeformationFixed(vehicle)
					    	    SetVehicleUndriveable(vehicle, false)
					    	    SetVehicleEngineOn(vehicle, false, false)
					    	    ClearPedTasksImmediately(playerPed)
                                ClearPedTasks(GetPlayerPed(-1))
					    	RageUI.Popup({message = "Véhicule ~g~réparé"})
                            RageUI.CloseAll()
					        end)
                        end
                    end)
                
                    RageUI.ButtonWithStyle("🔧 Réparation à genoux", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local playerPed = PlayerPedId()
                            local vehicle = GetClosestVehicle(GetEntityCoords(playerPed), 4.0, 0, 127)
                            local animDict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@'
                            local animName = 'machinic_loop_mechandplayer'
                        
                            loadAnimDict(animDict)
                            TaskPlayAnim(playerPed, animDict, animName, 5.0, 1.5, 20000, 0, 0.0, 0, 0, 0)
				    	    Citizen.CreateThread(function()
				    		    Citizen.Wait(10000)
				    		    SetVehicleFixed(vehicle)
				    		    SetVehicleDeformationFixed(vehicle)
					    	    SetVehicleUndriveable(vehicle, false)
					    	    SetVehicleEngineOn(vehicle, false, false)
					    	    ClearPedTasksImmediately(playerPed)
                                ClearPedTasks(GetPlayerPed(-1))
					    	RageUI.Popup({message = "Véhicule ~g~réparé"})
                            RageUI.CloseAll()
                            end)
                        end
                    end)
                
                    RageUI.ButtonWithStyle("🔧 Réparation allonger", nil, {RightLabel = "~y~soon"}, true, function(Hovered, Active, Selected)
                        --if Selected then
                        --    local playerPed = PlayerPedId()
                        --    local vehicle = GetClosestVehicle(GetEntityCoords(playerPed), 4.0, 0, 127)
                        --    local animDict = 'amb@world_human_vehicle_mechanic@male@base'
                        --    local animName = 'base'
                                           
                        --    local heading = GetHeadingFromVector_2d(x, y)
                        --    SetEntityHeading(playerPed, heading+180.0)
                        --    loadAnimDict(animDict)
                        --    TaskPlayAnim(playerPed, animDict, animName, 5.0, 1.5, 20000, 0, 0.0, 0, 0, 0)
				    	--    Citizen.CreateThread(function()
				    	--	    Citizen.Wait(20000)
				    	--	    SetVehicleFixed(vehicle)
				    	--	    SetVehicleDeformationFixed(vehicle)
				    	--	    SetVehicleUndriveable(vehicle, false)
				    	--	    SetVehicleEngineOn(vehicle, true, true)
				    	--	    ClearPedTasksImmediately(playerPed)
                        --      ClearPedTasks(GetPlayerPed(-1))
				    	--	RageUI.Popup({message = "Véhicule ~g~réparé"})
                        --    RageUI.CloseAll()
                        --    end)
                        --end
                    end)

                end, function()
                end)

                RageUI.IsVisible(factures, true, true, true, function()

                    RageUI.ButtonWithStyle("Facture Personnalisé",nil, {RightLabel = "→"}, true, function(_,_,s)
                        local player, distance = ESX.Game.GetClosestPlayer()
                        if s then
                            local montant = 0
                            AddTextEntry("FMMC_MPM_NA", "Montant de la facture")
                            DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Indiquez le montant de la facture :", "", "", "", "", 30)
                            while (UpdateOnscreenKeyboard() == 0) do
                                DisableAllControlActions(0)
                                Wait(0)
                            end
                            if (GetOnscreenKeyboardResult()) then
                                result = GetOnscreenKeyboardResult()
                                if result then
                                    montant = result
                                    result = nil
                                    if player ~= -1 and distance <= 3.0 then
                                        --exports["WaveShield"]:TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_benny', ("Cluckin benny"), montant)
                                        TriggerServerEvent("okokBilling:CreateCustomInvoice", GetPlayerServerId(player), montant, 'Facture', 'Facture benny', 'society_benny', ('benny'))
                                        TriggerEvent('esx:showAdvancedNotification', 'Fl~g~ee~s~ca ~g~Bank', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~g~'..montant.. '$ ', 'CHAR_BANK_FLEECA', 9)
                                    else
                                        ESX.ShowNotification("~r~Probleme~s~: Aucuns joueurs proche")
                                    end
                                end
                            end
                        end
                    end)
                                
                    RageUI.ButtonWithStyle("Facture Reparation",nil, {RightLabel = " "}, true, function(_,_,s)    
                        local player, distance = ESX.Game.GetClosestPlayer()
                        if s then
                            local montant = 350
                                if player ~= -1 and distance <= 3.0 then                                    
                                    TriggerServerEvent("okokBilling:CreateCustomInvoice", GetPlayerServerId(player), montant, 'Facture', 'Facture Benny\'s', 'society_benny', ('benny'))
                                    --exports["WaveShield"]:TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_benny', ("benny"), montant)
                                    TriggerEvent('esx:showAdvancedNotification', 'Fl~g~ee~s~ca ~g~Bank', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~g~'..montant.. ' $ ', 'CHAR_BANK_FLEECA', 9)
                                else
                                    ESX.ShowNotification("~o~Probleme~s~: Aucuns joueurs proche")
                                end
                                    
                            RageUI.CloseAll()
                        end
                    end)

                end, function()
                end)
    
                if not RageUI.Visible(hbennyf6) and not RageUI.Visible(plateau) and not RageUI.Visible(emotes) and not RageUI.Visible(factures) and not RageUI.Visible(entretien) then
                    hbennyf6 = RMenu:DeleteType("benny", true)
        end
    end
end

function nextStepBurger(gps)
	if gps ~= 0 then
		if Blips['delivery'] ~= nil then
			RemoveBlip(Blips['delivery'])
			Blips['delivery'] = nil
		end

		Blips['delivery'] = AddBlipForCoord(gps.x, gps.y, gps.z)
		SetBlipRoute(Blips['delivery'], true)
		ESX.ShowNotification("Rends toi à ce point")
	elseif gps == nil then end
end

AddEventHandler('benny:openmenu', function(type, data)
	Menuf6benny()
end)


function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    blockinput = true
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(0)
    end 
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end







































exports.ox_lib:registerContext({
    id = 'bennymenu',
    title = 'Faire une annonce',
    options = {
        {
            title = 'Ouvert',
            progress = '100',
            onSelect = function()
                --print("Pressed the button!")  	 
				exports["WaveShield"]:TriggerServerEvent('hbenny:Ouvert')    
            end,
        },
        {
            title = 'Fermer',
            progress = '100',
            onSelect = function()
                --print("Pressed the button!") 
                exports["WaveShield"]:TriggerServerEvent('hbenny:Fermer')  
            end,
        },
        {
            title = 'Deplacement dispo',
            progress = '100',
            onSelect = function()
                --print("Pressed the button!") 
                exports["WaveShield"]:TriggerServerEvent('hbenny:deplacement')  
            end,
        },
    },
})

RegisterNetEvent('benny:annonce')
AddEventHandler('benny:annonce', function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'benny' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'benny' then
       	exports.ox_lib:showContext('bennymenu')
	else
		ESX.ShowNotification("~y~ta pas acces miskin")
	end
end)

exports.ox_target:addBoxZone(
	{
        coords = vec3(-350.47, -131.01, 39.21),
        size = vec3(1, 1, 1),
        rotation = 45,
        debug = drawZones,
        options = {
            {
                name = 'poly',
                event = 'benny:annonce',
                icon = 'fa-solid fa-cube',
                label = 'Passer une annonce',
            },
        },
        minZ = 43.50,
        maxZ = 44.00,
    }
)