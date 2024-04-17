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


local Blips = {}
function Menuf6taxi()
    local htaxif6 = RageUI.CreateMenu("taxi", " ")
    RageUI.Visible(htaxif6, not RageUI.Visible(htaxif6))
    while htaxif6 do
        Citizen.Wait(0)
            RageUI.IsVisible(htaxif6, true, true, true, function()

                RageUI.Separator("↓ Facture ↓")

                RageUI.ButtonWithStyle("Facture",nil, {RightLabel = "→"}, true, function(_,_,s)
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
                                    --exports["WaveShield"]:TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_taxi', ("Cluckin taxi"), montant)
                                    TriggerServerEvent("okokBilling:CreateCustomInvoice", GetPlayerServerId(player), montant, 'Facture', 'Facture taxi', 'society_taxi', ('taxi'))
                                    TriggerEvent('esx:showAdvancedNotification', 'Fl~g~ee~s~ca ~g~Bank', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~g~'..montant.. '$ ', 'CHAR_BANK_FLEECA', 9)
                                else
                                    ESX.ShowNotification("~r~Probleme~s~: Aucuns joueurs proche")
                                end
                            end
                        end
                    end
                end)

                RageUI.Separator("↓ RUN ↓")
        
                RageUI.ButtonWithStyle("Lancer un Run",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then 
                        local playerPed = PlayerPedId()
                        local vehicle   = GetVehiclePedIsIn(playerPed, false)
            
                                if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
                                    if tonumber(ESX.PlayerData.job.grade or ESX.PlayerData.job2.grade) >= 0 then
                                        StartTaxiJob()
                                    else
                                        if IsInAuthorizedVehicle() then
                                            StartTaxiJob()
                                        else
                                            RageUI.Popup({
                                                message = "Tu dois être dans un taxi !"})
                                        end
                                    end
                                else
                                    if tonumber(ESX.PlayerData.job.grade or ESX.PlayerData.job2.grade) >= 0 then
                                        ESX.ShowNotification('vous devez être dans un véhicule pour commencer la mission')
                                    else
                                        RageUI.Popup({
                                            message = "Tu dois être dans un taxi !"})
                                    end
                                end
                            
                        
                    end
                end)
				
                end, function() 
                end)
    
                if not RageUI.Visible(htaxif6) then
                    htaxif6 = RMenu:DeleteType("taxi", true)
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

AddEventHandler('taxi:openmenu', function(type, data)
	Menuf6taxi()
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


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if OnJob then
			if CurrentCustomer == nil then
				DrawSub('conduisez à la recherche de ~y~passagers', 5000)

				if IsPedInAnyVehicle(playerPed, false) and GetEntitySpeed(playerPed) > 0 then
					local waitUntil = GetGameTimer() + GetRandomIntInRange(15000, 20000)

					while OnJob and waitUntil > GetGameTimer() do
						Citizen.Wait(0)
					end

					if OnJob and IsPedInAnyVehicle(playerPed, false) and GetEntitySpeed(playerPed) > 0 then
						CurrentCustomer = GetRandomWalkingNPC()

						if CurrentCustomer ~= nil then
							CurrentCustomerBlip = AddBlipForEntity(CurrentCustomer)

							SetBlipAsFriendly(CurrentCustomerBlip, true)
							SetBlipColour(CurrentCustomerBlip, 2)
							SetBlipCategory(CurrentCustomerBlip, 3)
							SetBlipRoute(CurrentCustomerBlip, true)

							SetEntityAsMissionEntity(CurrentCustomer, true, false)
							ClearPedTasksImmediately(CurrentCustomer)
							SetBlockingOfNonTemporaryEvents(CurrentCustomer, true)

							local standTime = GetRandomIntInRange(1, 1)
							TaskStandStill(CurrentCustomer, standTime)

							ESX.ShowNotification('vous avez ~g~trouvé~s~ un client, conduisez jusqu\'à ce dernier')
						end
					end
				end
			else
				if IsPedFatallyInjured(CurrentCustomer) then
					ESX.ShowNotification('votre client est ~r~inconscient~s~. Cherchez-en un autre.')

					if DoesBlipExist(CurrentCustomerBlip) then
						RemoveBlip(CurrentCustomerBlip)
					end

					if DoesBlipExist(DestinationBlip) then
						RemoveBlip(DestinationBlip)
					end

					SetEntityAsMissionEntity(CurrentCustomer, false, true)

					CurrentCustomer, CurrentCustomerBlip, DestinationBlip, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, targetCoords = nil, nil, nil, false, false, false, nil
				end

				if IsPedInAnyVehicle(playerPed, false) then
					local vehicle          = GetVehiclePedIsIn(playerPed, false)
					local playerCoords     = GetEntityCoords(playerPed)
					local customerCoords   = GetEntityCoords(CurrentCustomer)
					local customerDistance = #(playerCoords - customerCoords)

					if IsPedSittingInVehicle(CurrentCustomer, vehicle) then
						if CustomerEnteredVehicle then
							local targetDistance = #(playerCoords - targetCoords)

							if targetDistance <= 10.0 then
								TaskLeaveVehicle(CurrentCustomer, vehicle, 0)

								ESX.ShowNotification('vous êtes ~g~arrivé~s~ à destination')

								TaskGoStraightToCoord(CurrentCustomer, targetCoords.x, targetCoords.y, targetCoords.z, 1.0, -1, 0.0, 0.0)
								SetEntityAsMissionEntity(CurrentCustomer, false, true)
								--TriggerServerEvent('EMYTaxi:success')
								exports["WaveShield"]:TriggerServerEvent('EMYTaxi:success')
								RemoveBlip(DestinationBlip)

								local scope = function(customer)
									ESX.SetTimeout(60000, function()
										DeletePed(customer)
									end)
								end

								scope(CurrentCustomer)

								CurrentCustomer, CurrentCustomerBlip, DestinationBlip, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, targetCoords = nil, nil, nil, false, false, false, nil
							end

							if targetCoords then
								DrawMarker(36, targetCoords.x, targetCoords.y, targetCoords.z + 1.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 234, 223, 72, 155, false, false, 2, true, nil, nil, false)
							end
						else
							RemoveBlip(CurrentCustomerBlip)
							CurrentCustomerBlip = nil
							targetCoords = taxi.pos.JobLocations[GetRandomIntInRange(1, #taxi.pos.JobLocations)]
							local distance = #(playerCoords - targetCoords)
							while distance < 750 do
								Citizen.Wait(5)

								targetCoords = taxi.pos.JobLocations[GetRandomIntInRange(1, #taxi.pos.JobLocations)]
								distance = #(playerCoords - targetCoords)
							end

							local street = table.pack(GetStreetNameAtCoord(targetCoords.x, targetCoords.y, targetCoords.z))
							local msg    = nil

							if street[2] ~= 0 and street[2] ~= nil then
								msg = string.format('~s~Emmenez-moi à~y~ %s~s~, près de~y~ %s', GetStreetNameFromHashKey(street[1]), GetStreetNameFromHashKey(street[2]))
							else
								msg = string.format('~s~Emmenez-moi à~y~ %s', GetStreetNameFromHashKey(street[1]))
							end

							ESX.ShowNotification(msg)

							DestinationBlip = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

							BeginTextCommandSetBlipName('STRING')
							AddTextComponentSubstringPlayerName('Destination')
							EndTextCommandSetBlipName(blip)
							SetBlipRoute(DestinationBlip, true)

							CustomerEnteredVehicle = true
						end
					else
						DrawMarker(36, customerCoords.x, customerCoords.y, customerCoords.z + 1.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 234, 223, 72, 155, false, false, 2, true, nil, nil, false)

						if not CustomerEnteredVehicle then
							if customerDistance <= 40.0 then

								if not IsNearCustomer then
									ESX.ShowNotification('vous êtes à proximité du client, approchez-vous de lui')
									IsNearCustomer = true
								end

							end

							if customerDistance <= 20.0 then
								if not CustomerIsEnteringVehicle then
									ClearPedTasksImmediately(CurrentCustomer)

									local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

									for i=maxSeats - 1, 0, -1 do
										if IsVehicleSeatFree(vehicle, i) then
											freeSeat = i
											break
										end
									end

									if freeSeat then
										TaskEnterVehicle(CurrentCustomer, vehicle, -1, freeSeat, 2.0, 0)
										CustomerIsEnteringVehicle = true
									end
								end
							end
						end
					end
				else
					DrawSub('veuillez remonter dans votre véhicule pour continuer la mission', 5000)
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function IsInAuthorizedVehicle()
	local playerPed = PlayerPedId()
	local vehModel  = GetEntityModel(GetVehiclePedIsIn(playerPed, false))
	
	for i=1, #Config.AuthorizedVehicles, 1 do
		if vehModel == GetHashKey(Config.AuthorizedVehicles[i].model) then
			return true
		end
	end
	return false
end

function ClearCurrentMission()
	if DoesBlipExist(CurrentCustomerBlip) then
		RemoveBlip(CurrentCustomerBlip)
	end
	if DoesBlipExist(DestinationBlip) then
		RemoveBlip(DestinationBlip)
	end
	CurrentCustomer           = nil
	CurrentCustomerBlip       = nil
	DestinationBlip           = nil
	IsNearCustomer            = false
	CustomerIsEnteringVehicle = false
	CustomerEnteredVehicle    = false
	targetCoords              = nil
end


function StartTaxiJob()
	ShowLoadingPromt('Prise de service', 5000, 3)
	ClearCurrentMission()

	OnJob = true
end

function GetRandomWalkingNPC()
	local search = {}
	local peds   = ESX.Game.GetPeds()

	for i=1, #peds, 1 do
		if IsPedHuman(peds[i]) and IsPedWalking(peds[i]) and not IsPedAPlayer(peds[i]) then
			table.insert(search, peds[i])
		end
	end

	if #search > 0 then
		return search[GetRandomIntInRange(1, #search)]
	end

	for i=1, 250, 1 do
		local ped = GetRandomPedAtCoord(0.0, 0.0, 0.0, math.huge + 0.0, math.huge + 0.0, math.huge + 0.0, 26)

		if DoesEntityExist(ped) and IsPedHuman(ped) and IsPedWalking(ped) and not IsPedAPlayer(ped) then
			table.insert(search, ped)
		end
	end

	if #search > 0 then
		return search[GetRandomIntInRange(1, #search)]
	end
end

function StopTaxiJob()
	local playerPed = PlayerPedId()

	if IsPedInAnyVehicle(playerPed, false) and CurrentCustomer ~= nil then
		local vehicle = GetVehiclePedIsIn(playerPed,  false)
		TaskLeaveVehicle(CurrentCustomer,  vehicle,  0)
		if CustomerEnteredVehicle then
			TaskGoStraightToCoord(CurrentCustomer,  targetCoords.x,  targetCoords.y,  targetCoords.z,  1.0,  -1,  0.0,  0.0)
		end
	end

	ClearCurrentMission()
	OnJob = false
	DrawSub('Mission terminée', 5000)
end

function ShowLoadingPromt(msg, time, type)
	Citizen.CreateThread(function()
		Citizen.Wait(0)

		BeginTextCommandBusyspinnerOn('STRING')
		AddTextComponentSubstringPlayerName(msg)
		EndTextCommandBusyspinnerOn(type)
		Citizen.Wait(time)

		BusyspinnerOff()
	end)
end

function DrawSub(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, 1)
end


exports.ox_lib:registerContext({
    id = 'annoncemenu',
    title = 'Faire une annonce',
    options = {
        {
            title = 'Ouvert',
            progress = '100',
            onSelect = function()
                --print("Pressed the button!")  				
				exports["WaveShield"]:TriggerServerEvent('htaxi:Ouvert')    
            end,
        },
        {
            title = 'Fermer',
            progress = '100',
            onSelect = function()
                --print("Pressed the button!") 
                exports["WaveShield"]:TriggerServerEvent('htaxi:Fermer')  
            end,
        },
    },
})

RegisterNetEvent('taxi:annonce')
AddEventHandler('taxi:annonce', function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'taxi' then
       	exports.ox_lib:showContext('annoncemenu')
	else
		ESX.ShowNotification("~y~ta pas acces miskin")
	end
end)

exports.ox_target:addBoxZone(
	{
        coords = vec3(900.00, -160.22, 74.15),
        size = vec3(1, 1, 1),
        rotation = 45,
        debug = drawZones,
        options = {
            {
                name = 'poly',
                event = 'taxi:annonce',
                icon = 'fa-solid fa-cube',
                label = 'Acceder a l\'ordinateur',
            },
        },
        minZ = 74.50,
        maxZ = 75.00,
    }
)