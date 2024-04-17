ESX = exports["es_extended"]:getSharedObject()
local firstSpawn = true
isDead, isSearched, medic = false, false, 0

local ped = {
    { ["x"] = 310.54, ["y"] = -585.79, ["z"] = 43.27, ["h"] = 98.86, ["model"] = "s_m_m_doctor_01", ["anim"] = "mini@strip_club@idles@bouncer", ["base"] = "base", ["nord"] = false  },
    --{ ["x"] = 1671.46, ["y"] = 3654.17, ["z"] = 35.34, ["h"] = 314.57, ["model"] = "s_m_m_doctor_01", ["anim"] = "mini@strip_club@idles@bouncer", ["base"] = "base", ["nord"] = true  },
}

Citizen.CreateThread(function()
   

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
	while ESX.GetPlayerData().job2 == nil do
        Citizen.Wait(10)
    end
    ESX.PlayerData = ESX.GetPlayerData()
end)

local blips2 = {}
local blips2activ = false


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


local isDead, isBusy = false, false
local appellist = {}

local Blips = {}

local function getInfoReport()
    local info = {}
    ESX.TriggerServerCallback('HuidEMS:infoReport', function(info)
        appellist = info
    end)
end

function Menuf6ambulance()
    getInfoReport()
    local hambulancef6 = RageUI.CreateMenu("L.S.E.S", " ")
    local emotes = RageUI.CreateSubMenu(hambulancef6, "L.S.E.S", " ")
    local factures = RageUI.CreateSubMenu(hambulancef6, "L.S.E.S", " ")
    local reasoins = RageUI.CreateSubMenu(hambulancef6, "L.S.E.S", " ")
    RageUI.Visible(hambulancef6, not RageUI.Visible(hambulancef6))
    while hambulancef6 do
        Citizen.Wait(0)
            RageUI.IsVisible(hambulancef6, true, true, true, function()


                RageUI.ButtonWithStyle("Acces a la tablette",nil, {RightLabel = "→"}, true, function(_,_,s)                    
                    if s then
                        ExecuteCommand("panel")                 
                        RageUI.CloseAll()
                        Citizen.Wait(2000)
                        ExecuteCommand("emotecancel")
                        ClearPedTasks(GetPlayerPed(-1))
                    end
                end)

                RageUI.ButtonWithStyle("👤 Emotes rapide",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                end, emotes)

                RageUI.Separator("↓ Citoyens ↓")

                RageUI.ButtonWithStyle("👤 Facture",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                end, factures)

                RageUI.ButtonWithStyle("👤 Facture",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                end, reasoins)

                RageUI.Separator("↓ Annonce ↓")


                RageUI.ButtonWithStyle("Disponible",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                    if Selected then       
                        exports["WaveShield"]:TriggerServerEvent('hambulance:sudo')
                    end
                end)
        
                RageUI.ButtonWithStyle("Indisponible",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                    if Selected then      
                        exports["WaveShield"]:TriggerServerEvent('hambulance:sudf')
                    end
                end)

                
   
                end, function() end)

                
                RageUI.IsVisible(emotes, true, true, true, function()
                    
                end, function()
                end)

                
                RageUI.IsVisible(factures, true, true, true, function()
                    
                    RageUI.ButtonWithStyle("Facture - soin",nil, {RightLabel = "~y~300~s~$"}, true, function(_,_,s)
                        local player, distance = ESX.Game.GetClosestPlayer()
                        if s then
                            local montant = 300
                                    if player ~= -1 and distance <= 3.0 then
                                        --exports["WaveShield"]:TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_ambulance', ("LSHD"), montant)
                                        TriggerEvent('esx:showAdvancedNotification', 'Fl~g~ee~s~ca ~g~Bank', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~g~'..montant.. ' $ ', 'CHAR_BANK_FLEECA', 9)
                                        TriggerServerEvent("okokBilling:CreateCustomInvoice", GetPlayerServerId(player), montant, 'Facture', 'L.S.E.S', 'society_ambulance', ('ambulance'))
                                    else
                                        ESX.ShowNotification("~o~Probleme~s~: Aucuns joueurs proche")
                                    end
                                    
                                RageUI.CloseAll()
                        end
                    end)
    
                    RageUI.ButtonWithStyle("Facture - Réanimation",nil, {RightLabel = "~y~600~s~$"}, true, function(_,_,s)
                        local player, distance = ESX.Game.GetClosestPlayer()
                        if s then
                            local montant = 600
                                    if player ~= -1 and distance <= 3.0 then
                                        --exports["WaveShield"]:TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_ambulance', ("LSHD"), montant)
                                        TriggerEvent('esx:showAdvancedNotification', 'Fl~g~ee~s~ca ~g~Bank', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~g~'..montant.. ' $ ', 'CHAR_BANK_FLEECA', 9)
                                        TriggerServerEvent("okokBilling:CreateCustomInvoice", GetPlayerServerId(player), montant, 'Facture', 'L.S.E.S', 'society_ambulance', ('ambulance'))
                                    else
                                        ESX.ShowNotification("~o~Probleme~s~: Aucuns joueurs proche")
                                    end
                                    
                                RageUI.CloseAll()
                        end
                    end)
    
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
                                        --exports["WaveShield"]:TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_ambulance', ("LSHD"), montant)
                                        TriggerEvent('esx:showAdvancedNotification', 'Fl~g~ee~s~ca ~g~Bank', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~g~'..montant.. ' $ ', 'CHAR_BANK_FLEECA', 9)
                                        TriggerServerEvent("okokBilling:CreateCustomInvoice", GetPlayerServerId(player), montant, 'Facture', 'L.S.E.S', 'society_ambulance', ('ambulance'))
                                    else
                                        ESX.ShowNotification("~õ~Probleme~s~: Aucuns joueurs proche")
                                    end
                                end
                            end
                        end
                    end)

                end, function()
                end)

                
                RageUI.IsVisible(reasoins, true, true, true, function()  
                
                RageUI.ButtonWithStyle("Réanimer la personne", nil, { RightLabel = "" },true, function(Hovered, Active, Selected)
                    if Selected then 
                        ESX.TriggerServerCallback("HuidEMS:checkitem", function(haveitem)
                            if haveitem then
                                Canrevive = true
                            end
                        end, "medikit")
                
                        if Canrevive then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            if closestPlayer == -1 or closestDistance > 1.0 then
                                ESX.ShowNotification('Aucune Personne à Proximité')
                            else
                                TriggerServerEvent("HuidEMS:delitem", "medikit")
                                revivePlayer(closestPlayer)
                                TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')
                            end
                        else
                            ESX.ShowNotification('Vous n\'avez pas de kit médical')
                        end
                
                    end
                end)

                RageUI.ButtonWithStyle("Soigner la personne", nil, { RightLabel = "" },true, function(Hovered, Active, Selected)
                    if (Selected) then 
                        ESX.TriggerServerCallback("HuidEMS:checkitem", function(haveitem)
                            if haveitem then
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                if closestPlayer == -1 or closestDistance > 1.0 then
                                    ESX.ShowNotification('Aucune Personne à Proximité')
                                else

                                    local closestPlayerPed = GetPlayerPed(closestPlayer)
                                    local health = GetEntityHealth(closestPlayerPed)
                                    if health > 0 then
                                        local playerPed = PlayerPedId()
                                        TriggerServerEvent("HuidEMS:delitem", "bandage")

                                        ESX.ShowNotification('vous soignez...')
                                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                                        Citizen.Wait(10000)
                                        ClearPedTasks(playerPed)

                                        TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')
                                        ESX.ShowNotification("Vous avez soigné "..GetPlayerName(closestPlayer))
                                    else
                                        ESX.ShowNotification('Cette personne est inconsciente!')
                                    end
                                end
                            else
                                ESX.ShowNotification('Vous n\'avez pas de bandage')
                            end
                        end, "bandage")
                    end
                end)
                
                RageUI.Separator("↓ LifeGuard ↓")

                RageUI.ButtonWithStyle("Mettre un masque de plongée",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                    if Selected then
                        ExecuteCommand("e facepalm4")
                        Wait(3000)
                        vambu()
                        ExecuteCommand("emotecancel")
                        RageUI.CloseAll()
                    end
                end)

                RageUI.ButtonWithStyle("Retirer le masque de plongée",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                    if Selected then
                        ExecuteCommand("e facepalm4")
                        Wait(3000)
                        vcivil()
                        ExecuteCommand("emotecancel")
                        RageUI.CloseAll()
                    end
                end) 

                end, function()
                end)

                

                if not RageUI.Visible(hambulancef6) and not RageUI.Visible(emotes) and not RageUI.Visible(factures) and not RageUI.Visible(reasoins) then
                    hambulancef6 = RMenu:DeleteType("L.S.E.S", true)
        end
    end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(200)

		if isDead then
			DisableAllControlActions(0)
			EnableControlAction(0, 47, true)
			EnableControlAction(0, 245, true)
			EnableControlAction(0, 38, true)
			DisableControlAction(0, 288, true)
		end
	end
end)

AddEventHandler('esx:onPlayerSpawn', function()
    if firstSpawn then
        firstSpawn = false
        if Config.SaveDeathStatus then
            while not ESX.IsPlayerLoaded() do
                Wait(1000)
            end

            ESX.TriggerServerCallback('esx_ambulancejob:getDeathStatus', function(shouldDie)
                if shouldDie then
                    Wait(1000)
                    SetEntityHealth(PlayerPedId(), 0)
                else 
                    ESX.TriggerServerCallback('esx_ambulancejob:getCurrentHealth', function(currentHealth)
                        Wait(1000)
                        SetEntityHealth(PlayerPedId(), currentHealth)
                    end)
                end
            end)
        end
    end
end)

AddEventHandler('LSES:Emyrevive', function(data)
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer == -1 or closestDistance > 1.0 then
            ESX.ShowNotification('Aucune Personne à Proximité')
        else
            TriggerServerEvent("HuidEMS:delitem", "medikit")
            revivePlayer(closestPlayer)
            TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')
        end
end)

function revivePlayer(closestPlayer)

    local closestPlayerPed = GetPlayerPed(closestPlayer)
    if IsPedDeadOrDying(closestPlayerPed, 1) then
        local playerPed = PlayerPedId()
        local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'
        ESX.ShowNotification('Réanimation en cours')

        for i=1, 15 do
            Citizen.Wait(900)

            ESX.Streaming.RequestAnimDict(lib, function()
                TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
            end)
        end

        TriggerServerEvent('esx_ambulancejob:revive', GetPlayerServerId(closestPlayer))
    else
        ESX.ShowNotification('N\'est pas inconscient')
    end
end

AddEventHandler('esx:onPlayerDeath', function(data)
	OnPlayerDeath()
end)

function OnPlayerDeath()
	isDead = true
	ESX.UI.Menu.CloseAll()
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', true)

	StartDeathTimer()
	StartDistressSignal()

	StartScreenEffect('DeathFailOut', 0, false)
end

RegisterNetEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function(isAdmin)
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)
    isDead = false

    if not isAdmin then
        TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')
    end

	DoScreenFadeOut(800)

	while not IsScreenFadedOut() do
		Citizen.Wait(50)
	end

	local formattedCoords = {
		x = ESX.Math.Round(coords.x, 1),
		y = ESX.Math.Round(coords.y, 1),
		z = ESX.Math.Round(coords.z, 1)
	}

	RespawnPed(playerPed, formattedCoords, 0.0)

	StopScreenEffect('DeathFailOut')
	DoScreenFadeIn(800)
end)

RegisterNetEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(healType, quiet)
	local playerPed = PlayerPedId()
	local maxHealth = GetEntityMaxHealth(playerPed)

	if healType == 'small' then
		local health = GetEntityHealth(playerPed)
		local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 8))
		SetEntityHealth(playerPed, newHealth)
	elseif healType == 'big' then
		SetEntityHealth(playerPed, maxHealth)
	elseif healType == 'pharmacy' then
		SetEntityHealth(GetPlayerPed(-1), math.floor(maxHealth / 2))
	end

	if not quiet then
		ESX.ShowNotification('Vous avez été soigné.')
	end
end)

function StartDistressSignal()
	Citizen.CreateThread(function()
		local timer = 240000

		while timer > 0 and isDead do
			Citizen.Wait(0)
			timer = timer - 30

			SetTextFont(4)
			SetTextScale(0.45, 0.45)
			SetTextColour(185, 185, 185, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			BeginTextCommandDisplayText('STRING')
			--AddTextComponentSubstringPlayerName('[~y~G~s~] pour envoyer un signal de détresse')
			EndTextCommandDisplayText(0.405, 0.855)

			if IsControlJustReleased(0, 47) then
				--SendDistressSignal()
                --ExecuteCommand('dead Un citoyen a besoin d\'aide')
				break
			end
		end
	end)
end

RegisterNetEvent("Huidems:envoielanotif")
AddEventHandler("Huidems:envoielanotif", function(idAppel)
    ESX.ShowAdvancedNotification("EMS", "~y~Demande d'EMS", "L'appel numéro "..idAppel.." à été ouvert", "CHAR_CALL911", 8)
end)

RegisterNetEvent("Huidems:envoielanotifclose")
AddEventHandler("Huidems:envoielanotifclose", function(nom)
    ESX.ShowAdvancedNotification("EMS", "~b~Fermeture d'un appel", "L'appel de "..nom.." a été ferme par " .. GetPlayerName(PlayerId()), "CHAR_CALL911", 8)
end)

function SendDistressSignal()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    ESX.ShowAdvancedNotification("Détresse", "~y~LSHD", "Ta position a était envoyer aux Ambulanciers en service", "CHAR_CALL911", 7)
    TriggerServerEvent('Huidems:envoyersingal', coords)
    --ESX.ShowAdvancedNotification("LSHD", "~y~Demande d'EMS", "Quelqu'un a besoin d'un ems !", "CHAR_CALL911", 8)
    --TriggerServerEvent('Huidems:emsAppel')
end

--[[function SendDistressSignal()
    local playerPed = PlayerPedId()
  local coords = GetEntityCoords(playerPed)
  local message = "Une personne a besoin d'un ems. Nom du patient : "..GetPlayerName(PlayerId()) -- The message that will be received.
  local alert = {
      message = message,
      -- img = "img url", -- You can add image here (OPTIONAL).
      location = coords,
  }

  TriggerServerEvent('qs-smartphone:server:sendJobAlert', alert, "ambulance") -- "Your ambulance job"
  TriggerServerEvent('qs-smartphone:server:AddNotifies', {
      head = "Alerte central", -- Message name.
      msg = message,
      app = 'business'
  })
end]]

function DrawGenericTextThisFrame()
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
end

function secondsToClock(seconds)
	local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format('%02.f', math.floor(seconds / 3600))
		local mins = string.format('%02.f', math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format('%02.f', math.floor(seconds - hours * 3600 - mins * 60))

		return mins, secs
	end
end

function RemoveItemsAfterRPDeath()
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)

	Citizen.CreateThread(function()
		DoScreenFadeOut(1000)

		while not IsScreenFadedOut() do
			Citizen.Wait(10)
		end

		local formattedCoords = {
            x = ambulance.RespawnPoint.coords.x,
            y = ambulance.RespawnPoint.coords.y,
            z = ambulance.RespawnPoint.coords.z
        }

		ESX.SetPlayerData('loadout', {})
		RespawnPed(PlayerPedId(), formattedCoords, ambulance.RespawnPoint.heading)
        
        TriggerServerEvent('esx_ambulancejob:revive')

		StopScreenEffect('DeathFailOut')
		DoScreenFadeIn(60000)
        ExecuteCommand('e sleep')
        ExecuteCommand('walk injured')
        Wait(60000)
        ExecuteCommand('emotecancel')
	end)
end

function RespawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	ClearPedBloodDamage(ped)

	TriggerServerEvent('esx:onPlayerSpawn')
	TriggerEvent('esx:onPlayerSpawn')
	TriggerEvent('playerSpawned') -- compatibility with old scripts, will be removed soon
end

function StartDeathTimer()
	local canPayFine = false

		ESX.TriggerServerCallback('esx_ambulancejob:checkBalance', function(canPay)
			canPayFine = canPay
		end)

	local earlySpawnTimer = ESX.Math.Round(15 * 60)
	local bleedoutTimer = ESX.Math.Round(60 * 60)

	Citizen.CreateThread(function()
		-- early respawn timer
		while earlySpawnTimer > 0 and isDead do
			Citizen.Wait(1000)

			if earlySpawnTimer > 0 then
				earlySpawnTimer = earlySpawnTimer - 1
			end
		end

		-- bleedout timer
		while bleedoutTimer > 0 and isDead do
			Citizen.Wait(1000)

			if bleedoutTimer > 0 then
				bleedoutTimer = bleedoutTimer - 1
			end
		end
	end)

	Citizen.CreateThread(function()
		local text, timeHeld

		-- early respawn timer
		while earlySpawnTimer > 0 and isDead do
			Citizen.Wait(0)
			text = ('Réanimation possible dans %s minutes %s secondes \n\n [~y~G~s~] pour envoyer un signal de détresse'):format(secondsToClock(earlySpawnTimer))
			DrawGenericTextThisFrame()
			BeginTextCommandDisplayText('STRING')
			AddTextComponentSubstringPlayerName(text)
			DrawText(0.5, 0.8)      

			if IsControlJustReleased(0, 47) then
				--SendDistressSignal()
                text = ('Réanimation possible dans %s minutes %s secondes'):format(secondsToClock(earlySpawnTimer))
			    DrawGenericTextThisFrame()
			    BeginTextCommandDisplayText('STRING')
			    AddTextComponentSubstringPlayerName(text)
			    DrawText(0.5, 0.8)
                ExecuteCommand('dead Un citoyen a besoin d\'aide')
                ESX.ShowNotification('Votre balise a été activé')
				break
			end
		end

		-- bleedout timer
		while bleedoutTimer > 0 and isDead do
			Citizen.Wait(0)
			text = ('Vous allez souffrir d\'une hémorragie dans %s minutes %s secondes\n'):format(secondsToClock(bleedoutTimer))

			if canPayFine then
				text = text .. ('Maintenez [~y~E~s~] pour réapparaitre ($ 1000)')

				if IsControlPressed(0, 38) and timeHeld > 60 then
					TriggerServerEvent('esx_ambulancejob:payFine')
					RemoveItemsAfterRPDeath()
					break
                    ExecuteCommand('e sleep')
                    ExecuteCommand('walk injured')
                    Wait(60000)
                    ExecuteCommand('emotecancel')
				end
			end

			if IsControlPressed(0, 38) then
				timeHeld = timeHeld + 1
			else
				timeHeld = 0
			end

			DrawGenericTextThisFrame()

			BeginTextCommandDisplayText('STRING')
			AddTextComponentSubstringPlayerName(text)
			DrawText(0.5, 0.8)
		end
        if bleedoutTimer < 1 and isDead then
			RemoveItemsAfterRPDeath()
            ExecuteCommand('e sleep')
            ExecuteCommand('walk injured')
            Wait(60000)
            ExecuteCommand('emotecancel')
		end
	end)
end

---- Ascenseur
Citizen.CreateThread(function()
    while true do

        local Ascenceur1 = {
            x = ambulance.Ascenceur1.coords.x,
            y = ambulance.Ascenceur1.coords.y,
            z = ambulance.Ascenceur1.coords.z
        }


        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'ambulance' then
            local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
            local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, ambulance.Ascenceur2.coords.x, ambulance.Ascenceur2.coords.y, ambulance.Ascenceur2.coords.z)
            if dist3 <= 7.0 and ambulance.jeveuxmarker then
                Timer = 0
                DrawMarker(20, ambulance.Ascenceur2.coords.x, ambulance.Ascenceur2.coords.y, ambulance.Ascenceur2.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 55, 95, 255, 0, 1, 2, 0, nil, nil, 0)
                if dist3 <= 1.0 then
                    Timer = 0   
                    SetTextComponentFormat('STRING')
                    AddTextComponentString("~INPUT_PICKUP~ monter sur le toit")
                    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                    if IsControlJustPressed(1,51) then           
                        RespawnPed(PlayerPedId(), Ascenceur1, ambulance.Ascenceur1.heading)
                    end   
                end
            end 


            local Ascenceur2 = {
                x = ambulance.Ascenceur2.coords.x,
                y = ambulance.Ascenceur2.coords.y,
                z = ambulance.Ascenceur2.coords.z
            }
            local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
            local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, ambulance.Ascenceur1.coords.x, ambulance.Ascenceur1.coords.y, ambulance.Ascenceur1.coords.z)
            if dist3 <= 7.0 and ambulance.jeveuxmarker then
                Timer = 0
                DrawMarker(20, ambulance.Ascenceur1.coords.x, ambulance.Ascenceur1.coords.y, ambulance.Ascenceur1.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 55, 95, 255, 0, 1, 2, 0, nil, nil, 0)
                if dist3 <= 1.0 then
                    Timer = 0   
                    SetTextComponentFormat('STRING')
                    AddTextComponentString("~INPUT_PICKUP~ monter sur le toit 3")
                    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                    if IsControlJustPressed(1,51) then           
                        RespawnPed(PlayerPedId(), Ascenceur2, ambulance.Ascenceur2.heading)
                    end   
                end
            end 
        end
        Citizen.Wait(Timer)
    end
end)


Citizen.CreateThread(function()
    for i = 1, #ped, 1 do
        RequestModel(ped[i]["model"])
        while not HasModelLoaded(ped[i]["model"]) do Wait(10) end
        local npc = CreatePed(4, ped[i]["model"], ped[i]["x"], ped[i]["y"], ped[i]["z"]-0.99, ped[i]["model"], false, true)
        SetEntityHeading(npc, ped[i]["h"])
        FreezeEntityPosition(npc, true)
        SetEntityInvincible(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
        TaskPlayAnim(npc, ped[i]["anim"], ped[i]["base"], 8.0, 1.0, -1, 2, 0, 0, 0, 0);
    end
end)
local service = 0


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        TriggerServerEvent('esx_ambulancejob:setCurrentHealth', GetEntityHealth(PlayerPedId()))
    end
end)

AddEventHandler('ambulance:openmenu', function(type, data)
	Menuf6ambulance()
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
--[[
local knockedOut = false
local wait = 15
local count = 60

Citizen.CreateThread(function()
	while true do
		Wait(1)
        local myPed = GetPlayerPed(-1)
        -- With melee weapon or unarmed only
        if IsPedInMeleeCombat(myPed) then
            -- Without any kind of weapon {UNARMED ONLY}
            if (HasPedBeenDamagedByWeapon(myPed, GetHashKey("WEAPON_UNARMED"), 0) )then
                -- Health to be knocked out
                if GetEntityHealth(myPed) < 145 then
                    SetPlayerInvincible(PlayerId(), false)
                    -- Position taken by your Ped
					SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
					--  Effect 
					ShakeGameplayCam('LARGE_EXPLOSION_SHAKE', 2.5)
					-- Time to wait
                    wait = 15
                    --** Add progress Bar here if you want **--
					knockedOut = true
					-- Health after knockout preferably dont make it more than 150 (50 %) because people will abuse with it {No need to go to hospital or so}
					SetEntityHealth(myPed, 145)
				end
			end
		end
		
		if knockedOut == true then		
			--Your ped is able to die
			SetPlayerInvincible(PlayerId(), false)
			DisablePlayerFiring(PlayerId(), true)
			SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
			ResetPedRagdollTimer(myPed)
			-- Red Cam
			SetTimecycleModifier("REDMIST")
			-- Cam vibration
			ShakeGameplayCam("VIBRATE_SHAKE", 1.0)
			if wait >= 0 then
				count = count - 1
                if count == 0 then
                    
					count = 60
					wait = wait - 1
					--- in case bark
                    if GetEntityHealth(myPed) <= 50 then
                        -- Ped healing 
						SetEntityHealth(myPed, GetEntityHealth(myPed)+2)
						
					end
				end
            else
                -- Remove red cam
				SetTimecycleModifier("")
                SetTransitionTimecycleModifier("")		
                -- Ped Able to die again
				SetPlayerInvincible(PlayerId(), false)
				knockedOut = false
			end
		end

	end
end)]]

RegisterNetEvent('ambulance:soin')
AddEventHandler('ambulance:soin', function(type, data)	
    exports["rtx_notify"]:Notify(" ", "Le medecin vous soigne . . .", 10000, "info")
    Wait(10000)
    exports["rtx_notify"]:Notify(" ", "ah l'enculé il m'a pris 1000 balles", 7000, "success")
    exports["WaveShield"]:TriggerServerEvent('emy:pay', GetPlayerServerId(PlayerId()))
    SetEntityHealth(GetPlayerPed(-1), 200)  
end)

exports.ox_target:addBoxZone(
    {
        coords = vec3(310.54, -585.79, 43.27),
        size = vec3(1, 1, 1),
        rotation = 0,
        debug = drawZones,
        options = {
            {
                name = 'box',
                event = 'ambulance:soin',
                icon = 'fa-solid fa-cube',
                label = 'Demander un soin',
            },
        },
        minZ = 43.20,
        maxZ = 44.20,
    }
)

function vcivil()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
        TriggerEvent('skinchanger:getSkin', function(skin)
            if model == GetHashKey("mp_m_freemode_01") then
                clothesSkin = {
                    ['glasses_1'] = -1,    ['glasses_2'] = 0,
                }
            else
                clothesSkin = {
                    ['glasses_1'] = -1,    ['glasses_2'] = 0,
                }
            end
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            SetPedMaxTimeUnderwater(GetPlayerPed(-1), 60.00)
        end)
    end)
end



function vambu()
	local model = GetEntityModel(GetPlayerPed(-1))
	TriggerEvent('skinchanger:getSkin', function(skin)
		if model == GetHashKey("mp_m_freemode_01") then
			clothesSkin = {
				['glasses_1'] = 26,    ['glasses_2'] = 6,
			}
		else
			clothesSkin = {
				['glasses_1'] = 28,    ['glasses_2'] = 6,
				}
		end
		TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)		
		SetPedMaxTimeUnderwater(GetPlayerPed(-1), 600.00)
	end)
end
