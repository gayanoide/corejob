ESX = exports["es_extended"]:getSharedObject()

local CurrentActionData = {}
local come, model, isAttached, inanimation, balle, ped, getball, isInVehicle, PetSelected, PlayerData = false, nil, false, false, false, {}, false, false, {}, {}

local prevDrawable, prevTexture, prevPalette = 0, 0, 0
local maleHash, femaleHash = `mp_m_freemode_01`, `mp_f_freemode_01`


local policeDog = false
local followingDogs = false
local PlayerData = {}

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	ESX.PlayerData.job2 = job2
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	PlayerData.job2 = job2
end)


function GetCloseVehi()
    local player = GetPlayerPed(-1)
    local vehicle = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 5.0, 0, 127)
    local vCoords = GetEntityCoords(vehicle)
    DrawMarker(2, vCoords.x, vCoords.y, vCoords.z + 1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 102, 0, 170, 0, 1, 2, 0, nil, nil, 0)
end

local function LoadAnimDict(dictname)
	if not HasAnimDictLoaded(dictname) then
		RequestAnimDict(dictname) 
		while not HasAnimDictLoaded(dictname) do 
			Citizen.Wait(1)
		end
	end
end

-----------------------------------------
--- BLIPS ---
-----------------------------------------

local blipsCops = {}
local Blips = {}

-- Create blip for colleagues
function createBlip(id)
	local ped = GetPlayerPed(id)
	local blip = GetBlipFromEntity(ped)

	if not DoesBlipExist(blip) then -- Add blip and create head display on player
		blip = AddBlipForEntity(ped)
		SetBlipSprite(blip, 1)
		ShowHeadingIndicatorOnBlip(blip, true) -- Player Blip indicator
		SetBlipRotation(blip, math.ceil(GetEntityHeading(ped))) -- update rotation
		SetBlipNameToPlayerName(blip, id) -- update blip name
		SetBlipScale(blip, 0.8) -- set scale
		SetBlipAsShortRange(blip, true)

		table.insert(blipsCops, blip) -- add blip to array so we can remove it later
	end
end

-----------------------------------------
---------------- Logs -------------------
-----------------------------------------

local function prisedeservice()
    TriggerServerEvent("priseservice")
end
  
local function findeservice()
    TriggerServerEvent("finservice")
end

local function amendelol()
    TriggerServerEvent("LogsAmende")
end

-----------------------------------------
---------------- Plainte ----------------
-----------------------------------------

local function reset()
    FirstName = nil
    LastName = nil
    Subject = nil
    Desc = nil
    cansend = false
    tel = nil
end

-----------------------------------------

local function Notification(title, subject, msg, icon, iconType)
	AddTextEntry('showAdNotification', msg)
	SetNotificationTextEntry('showAdNotification')
	SetNotificationMessage(icon, icon, false, iconType, title, subject)
	DrawNotification(false, false)
end

-----------------------------------------

local function SetVehicleMaxMods(vehicle)
    local props = {
      modEngine       = 2,
      modBrakes       = 2,
      modTransmission = 2,
      modSuspension   = 3,
      modTurbo        = true,
    }
    ESX.Game.SetVehicleProperties(vehicle, props)
end

-----------------------------------------

local function ApplySkin(infos)
	TriggerEvent('skinchanger:getSkin', function(skin)
		local uniformObject

		if skin.sex == 0 then
			uniformObject = infos.variations.male
		else
			uniformObject = infos.variations.female
		end

		if uniformObject then
			TriggerEvent('skinchanger:loadClothes', skin, uniformObject)
		end

		infos.onEquip()
	end)
end

---------------------------------------------------------------------------------

local dragStatus = {}
dragStatus.isDragged = false
local isHandcuffed = false
--DragStatus.dragger = tonumber(draggerId)
local handcuffTimer = {}

shieldActive = false
shieldEntity = nil
local animDict = 'combat@gestures@gang@pistol_1h@beckon'
local animName = '0'
local prop = 'Prop_jpolice_Shield'

local ped = PlayerPedId()
local vehicle = GetVehiclePedIsIn( ped, false )
local blip = nil
local policeDog = false
local PlayerData = {}
local currentTask = {}
local closestDistance, closestEntity = -1, nil

loadDict = function(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
end



local Items = {}      -- Item que le joueur possède (se remplit lors d'une fouille)
local Armes = {}    -- Armes que le joueur possède (se remplit lors d'une fouille)
local ArgentSale = {}  -- Argent sale que le joueur possède (se remplit lors d'une fouille)


local function MarquerJoueur()
	local ped = GetPlayerPed(ESX.Game.GetClosestPlayer())
	local pos = GetEntityCoords(ped)
	local target, distance = ESX.Game.GetClosestPlayer()
	if distance <= 4.0 then
	DrawMarker(Config.MarkerType, pos.x, pos.y, pos.z+1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 170, 0, 1, 2, 1, nil, nil, 0)
end
end

function getInformations(player)
	ESX.TriggerServerCallback('finalpolice:getOtherPlayerData', function(data)
		identityStats = data
	end, GetPlayerServerId(player))
end

local function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
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

local current = "lspd"
local dangerosityTable = {[1] = "Coopératif",[2] = "Dangereux",[3] = "Dangereux et armé",[4] = "Terroriste"}
lspdADRDangerosities = {"Coopératif","Dangereux","Dangereux et armé","Terroriste"}
lspdADRBuilder = {dangerosity = 1}
lspdCJBuilder = {dangerosity = 1}
lspdADRData = nil
lspdCJData = nil
lspdADRindex = 0
lspdCJindex = 0
colorVar = "~o~"

function getDangerosityNameByInt(dangerosity)
    if dangerosityTable[dangerosity] ~= nil then
        return dangerosityTable[dangerosity]
    else
        return dangerosity
    end
end

RegisterNetEvent("corp:adrGet")
AddEventHandler("corp:adrGet", function(result)
    local found = 0
    for k,v in pairs(result) do
        found = found + 1
    end
    if found > 0 then lspdADRData = result end
end)

RegisterNetEvent("corp:cjGet")
AddEventHandler("corp:cjGet", function(result)
    local found = 0
    for k,v in pairs(result) do
        found = found + 1
    end
    if found > 0 then lspdCJData = result end
end)

-----------------------------------------------------------------------------------------------
function Menuf6Police()
	local PPAListe3 = 1
	local PPAListe2 = 1
	local PPAListe = 1
	local qdqdq = false
	local mf6p = RageUI.CreateMenu("L.S.P.D", " ")
	local inter = RageUI.CreateSubMenu(mf6p, "L.S.P.D", " ")
	local info = RageUI.CreateSubMenu(mf6p, "L.S.P.D", " ")
	local props = RageUI.CreateSubMenu(mf6p, "L.S.P.D", " ")
	local renfort = RageUI.CreateSubMenu(mf6p, "L.S.P.D", " ")
	local voiture = RageUI.CreateSubMenu(mf6p, "L.S.P.D", " ")
	local object = RageUI.CreateSubMenu(mf6p, "L.S.P.D", " ")
	local npc = RageUI.CreateSubMenu(mf6p, "L.S.P.D", " ")
	local gererlicenses = RageUI.CreateSubMenu(inter, "L.S.P.D", " ")
	local lspd_main = RageUI.CreateSubMenu(mf6p, "L.S.P.D", " ")
	local lspd_adrcheck = RageUI.CreateSubMenu(lspd_main, "L.S.P.D", " ")
	local lspd_adr = RageUI.CreateSubMenu(lspd_main, "L.S.P.D", " ")
	local lspd_adrlaunch = RageUI.CreateSubMenu(lspd_main, "L.S.P.D", " ")
	local emotes = RageUI.CreateSubMenu(mf6p, "L.S.P.D", " ")   

	RageUI.Visible(mf6p, not RageUI.Visible(mf6p))
	while mf6p do
		Citizen.Wait(0)
			RageUI.IsVisible(mf6p, true, true, true, function()
				RageUI.Checkbox("Prendre/Quitter son service",nil, service,{},function(Hovered,Ative,Selected,Checked)
					if Selected then
						service = Checked
						if Checked then
							onservice = true
							ExecuteCommand ("e radio")
							Citizen.Wait(1000)
							ExecuteCommand ("emotecancel")
							ClearPedTasks(GetPlayerPed(-1))
							local info = 'prise'
							TriggerServerEvent('police:PriseEtFinservice', info) 
							prisedeservice()                       
						else
							onservice = false
							ExecuteCommand ("e radio")
							Citizen.Wait(1000)
							ExecuteCommand ("emotecancel")
							ClearPedTasks(GetPlayerPed(-1))
							local info = 'fin'
							TriggerServerEvent('police:PriseEtFinservice', info)
							findeservice()
							RageUI.CloseAll()
						end
					end
				end)

			if onservice then

				RageUI.ButtonWithStyle("👤 Intéractions sur civil", nil, {RightLabel = ""},true, function()
				end, inter)

				RageUI.ButtonWithStyle("🎙 Demande de renfort", nil, {RightLabel = ""},true, function()
				end, info)

				RageUI.ButtonWithStyle("🚘 Gestions véhicule ", nil, {RightLabel = ""},true, function()
				end, voiture)

                RageUI.ButtonWithStyle("👤 Emotes rapide", nil, {RightLabel = "→"},true, function()
				end, emotes) 

			end
    end, function()
	end)

	RageUI.IsVisible(emotes, true, true, true, function()                    

		RageUI.ButtonWithStyle("Saluer",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
			if Selected then
				ExecuteCommand('e salute')
			end
		end)                    

		RageUI.ButtonWithStyle("Repos",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
			if Selected then
				ExecuteCommand('e valet3')
			end
		end)                   

		RageUI.ButtonWithStyle("Faire la circulation",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
			if Selected then
				ExecuteCommand('e copbeacon')
			end
		end)                    

		RageUI.ButtonWithStyle("Main sur l'arme",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
			if Selected then
				ExecuteCommand('e holster')
			end
		end)                   

		RageUI.ButtonWithStyle("Sortir la lampe",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
			if Selected then
				ExecuteCommand('e holster8')
			end
		end)       

		RageUI.ButtonWithStyle("Montrer son badge",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
			if Selected then
				ExecuteCommand('e idcardh')
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

	RageUI.IsVisible(inter, true, true, true, function()
		
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		RageUI.ButtonWithStyle("📝 Facture",nil, {RightLabel = ""},  closestPlayer ~= -1 and closestDistance <= 3.0, function(Hovered, Active, Selected)
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
                            --exports["WaveShield"]:TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_staff', ("Cluckin staff"), montant)
                            TriggerServerEvent("okokBilling:CreateCustomInvoice", GetPlayerServerId(player), montant, 'Facture', 'Facture LSPD', 'society_lspd', ('lspd'))
                            TriggerEvent('esx:showAdvancedNotification', 'Fl~g~ee~s~ca ~g~Bank', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~g~'..montant.. '$ ', 'CHAR_BANK_FLEECA', 9)
                        else
                            ESX.ShowNotification("~r~Probleme~s~: Aucuns joueurs proche")
                        end
                    end
    	        end
            end
		end)

			RageUI.ButtonWithStyle("📋 Vérification licence(s)", nil, {RightLabel = ""}, closestPlayer ~= -1 and closestDistance <= 3.0, function(_, a, s)
				if s then
					getInformations(closestPlayer)
					player = closestPlayer
				end
			end, gererlicenses)

			RageUI.ButtonWithStyle("🔍 Fouiller la personne", nil, {RightLabel = ""}, closestPlayer ~= -1 and closestDistance <= 3.0, function(Hovered, Active, Selected)
                if (Selected) then
					if closestPlayer ~= -1 and closestDistance <= 3.0 then
						exports.ox_inventory:openInventory('player', GetPlayerServerId(closestPlayer))
						RageUI.CloseAll()
					end
            	end
        	end)
			
			RageUI.ButtonWithStyle("🔐 Menotter/démenotter", nil, {RightLabel = ""}, closestPlayer ~= -1 and closestDistance <= 3.0, function(Hovered, Active, Selected)
                if (Selected) then
					if closestPlayer ~= -1 and closestDistance <= 3.0 then
						TriggerServerEvent('esx_policejob:handcuff', GetPlayerServerId(closestPlayer))
						TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'a_uncuff', 8.0, -8.0, -1, 33, 0.0, false, false, false)
						Citizen.Wait(3500)
						ClearPedTasks(PlayerPedId())
					end
            	end
        	end)

			RageUI.ButtonWithStyle("👥 Escorter", nil, {RightLabel = ""}, closestPlayer ~= -1 and closestDistance <= 3.0, function(Hovered, Active, Selected)
                if (Selected) then
					if closestPlayer ~= -1 and closestDistance <= 3.0 then
						TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
					end
            	end
        	end)

        RageUI.ButtonWithStyle("🚘 Mettre dans un véhicule", nil, {RightLabel = ""}, closestPlayer ~= -1 and closestDistance <= 3.0, function(Hovered, Active, Selected)
			if (Selected) then
				if closestPlayer ~= -1 and closestDistance <= 3.0 then
					TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(closestPlayer))
				end
				end
			end)

            RageUI.ButtonWithStyle("🚘 Sortir du véhicule", nil, {RightLabel = ""}, closestPlayer ~= -1 and closestDistance <= 3.0, function(Hovered, Active, Selected)
                if (Selected) then
					if closestPlayer ~= -1 and closestDistance <= 3.0 then
                TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(closestPlayer))
			else
				ESX.ShowNotification('Peronne autour')
				end
            end
        end)		
    end, function()
	end)


	RageUI.IsVisible(gererlicenses, true, true, true, function()

		local data = identityStats
		if identityStats == nil then
			RageUI.Separator("")
			RageUI.Separator("~o~En attente des données...")
			RageUI.Separator("")
		else
			if data.licenses ~= nil then
				RageUI.Separator("↓ ~o~Licence ~s~↓")
				if data.licenses ~= nil then
					for i = 1, #data.licenses, 1 do
						if data.licenses[i].label ~= nil and data.licenses[i].type ~= nil then
							RageUI.ButtonWithStyle(data.licenses[i].label ,nil, {RightLabel = "Revoqué ~s~"}, true, function(_,_,s)
								if s then
									TriggerServerEvent('esx_license:removeLicense', GetPlayerServerId(player), data.licenses[i].type)


									ESX.SetTimeout(300, function()
										RageUI.CloseAll()
										identityStats = nil
										Wait(500)
										RageUI.Visible(RMenu:Get("Police","main"), true)
									end)
								end
							end)
						end
					end
				else
					RageUI.Separator("")
					RageUI.Separator("~o~La personne n'as pas de licence...")
					RageUI.Separator("")
				end
			end
		end

	end, function()
	end)

	RageUI.IsVisible(object, true, true, true, function()

		RageUI.Separator("↓ ~b~Gestion de la circulation~s~ ↓")

		RageUI.ButtonWithStyle("Activer/désactiver props editor", nil, {RightLabel = ""}, true, function(_,_,s)
			if s then
				inPropsEditor = not inPropsEditor
				StartPropsEditor()
			end
		end)
		RageUI.line()
		for k,v in pairs(cfg_police.props) do
		RageUI.ButtonWithStyle(v.label, nil, {RightLabel = ""}, true, function(_,_,s)
			if s then
				TriggerEvent("core:PlaceObject", v.prop)
			end
		end)
	end

	end, function()    
	end, 1)

		RageUI.IsVisible(props, true, true, true, function()
			local coords  = GetEntityCoords(PlayerPedId())
	
			RageUI.ButtonWithStyle("Supprimer le props", nil, { RightLabel = "" }, true, function(Hovered, Active, Selected)
				if Selected then
				local SpeedZone = {}
				local Objects = {}
				local NearestObject = nil
				local NearestCoords = nil
				local NearestDistance = nil
				local Scale = nil
					RemoveSpeedZone(SpeedZone[NearestObject])
					TriggerServerEvent("esx:deleteEntity", NetworkGetNetworkIdFromEntity(NearestObject))
					DeleteEntity(NearestObject)
					for i,Ob in pairs(Objects) do
						if Ob == NearestObject then
							Objects[i] = nil
						end
					end
					ShowHelpNotification("Objet supprimé !")
				end
			end)

			RageUI.ButtonWithStyle("Barrière", "~r~Attention l'objet et freeze~s~", {RightLabel = ""}, true, function(Hovered, Active, Selected)
				if Selected then 
					local playerPed = PlayerPedId()
					local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
					local objectCoords = (coords + forward * 1.0)
	
					ESX.Game.SpawnObject('prop_mp_barrier_02b', objectCoords, function(obj)
						SetEntityHeading(obj, GetEntityHeading(playerPed))
						PlaceObjectOnGroundProperly(obj)
						FreezeEntityPosition(obj, true)
					end)
				end
			end)
		
		end, function()
		end)

		RageUI.IsVisible(info, true, true, true, function()

			RageUI.ButtonWithStyle("~y~Effacer la position G.P.S", nil, {RightLabel = "🗺"}, true, function(Hovered, Active, Selected)
				if Selected then
					RemoveBlip(Blips['delivery'])
					Blips['delivery'] = nil
				end
			end)
		
			RageUI.ButtonWithStyle("🟢 Niveau 1",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
				if Selected then
					local playerPed = PlayerPedId()
					local coords  = GetEntityCoords(playerPed)
					ExecuteCommand ("e radio")
					Citizen.Wait(700)
					ClearPedTasks(GetPlayerPed(-1))
					TriggerServerEvent('Huid_police:DemandeRenfortPolice', coords, 'Niveau 1', 'Demande de renfort sur la position')
			
				end
			end)
					
			RageUI.ButtonWithStyle("🟠 Niveau 2",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
				if Selected then
					local playerPed = PlayerPedId()
					local coords  = GetEntityCoords(playerPed)
					ExecuteCommand ("e radio")
					Citizen.Wait(700)
					ClearPedTasks(GetPlayerPed(-1))
					TriggerServerEvent('Huid_police:DemandeRenfortPolice', coords, 'Niveau 2', 'Demande de renfort sur la position')
				
				end
			end)
					
			RageUI.ButtonWithStyle("🔴 Niveau 3",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
				if Selected then
					local playerPed = PlayerPedId()
					local coords  = GetEntityCoords(playerPed)
					ExecuteCommand ("e radio")
					Citizen.Wait(700)
					ClearPedTasks(GetPlayerPed(-1))
					TriggerServerEvent('Huid_police:DemandeRenfortPolice', coords, 'Niveau 3', 'Demande de renfort sur la position')
				
				end
			end)
		end, function() end)

	RageUI.IsVisible(voiture, true, true, true, function()

		RageUI.ButtonWithStyle("🚧 Procédure de mise en fourrière",nil, {RightLabel = ""}, true, --[[not IsPedSittingInAnyVehicle(PlayerPedId())]] function(Hovered, Active, Selected)
		if Selected then
			local playerPed = PlayerPedId()
			local vehicle = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 4.0, 0, 127)
			local coords    = GetEntityCoords(playerPed)
			if IsPedSittingInAnyVehicle(playerPed) then
				RageUI.Popup({message = "Vous ne pouvez pas effectuer cette action depuis un véhicule !"})
				return
			end
			local playerPed = PlayerPedId()
			if IsPedSittingInAnyVehicle(playerPed) then
				local vehicle = GetVehiclePedIsIn(playerPed, true)

				if GetPedInVehicleSeat(vehicle, -1) == playerPed then
					TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
					Citizen.Wait(20000)
					ClearPedTasks(playerPed)
					local info = ESX.Game.GetVehicleProperties(vehicle)
					TriggerServerEvent('hhayes:SetFourriere', info.plate)
					ESX.ShowNotification('vehicule ~r~mis en fourrière')
					ESX.Game.DeleteVehicle(vehicle)
				else
					ESX.ShowNotification('must_seat_driver')
				end
			else
				local vehicle = GetVehiclePedIsIn(playerPed, true)

				if DoesEntityExist(vehicle) then
					TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)	
					Citizen.Wait(20000)
					ClearPedTasks(playerPed)
					ESX.ShowNotification('vehicule ~r~mis en fourrière')
					ESX.Game.DeleteVehicle(vehicle)
				else
					ESX.ShowNotification('vous devez être ~r~près d\'un véhicule')
				end
			end
		end
	end)

	RageUI.ButtonWithStyle("🔎 Rechercher une plaque", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
		if Selected then
			local numplaque = KeyboardInput("Nom de la plaque", "", 10)
			local length = string.len(numplaque)
			if not numplaque then
				ESX.ShowNotification("Ce n'est ~r~pas~s~ un ~y~numéro d'enregistrement valide~s~")
			else
				Rechercherplaquevoiture(numplaque)
				RageUI.CloseAll()
			end
		end
	end)

	RageUI.ButtonWithStyle("🧷 Crocheter le véhicule ", nil, {RightLabel = ""},true, function(Hovered, Active, Selected)
		if Selected then
			crochetagevehicle()
		end
	end)

	end, function()    
	end, 1)


	if not RageUI.Visible(mf6p) and not RageUI.Visible(emotes) and not RageUI.Visible(inter) and not RageUI.Visible(info) and not RageUI.Visible(npc) and not RageUI.Visible(object) and not RageUI.Visible(impayees) and not RageUI.Visible(props) and not RageUI.Visible(renfort) and not RageUI.Visible(chien) and not RageUI.Visible(voiture) and not RageUI.Visible(chien2) and not RageUI.Visible(gererlicenses) and not RageUI.Visible(lspd_main) and not RageUI.Visible(lspd_adrcheck) and not RageUI.Visible(lspd_adr) and not RageUI.Visible(lspd_adrlaunch) and not RageUI.Visible(fouiller) then
		mf6p = RMenu:DeleteType("mf6p", true)
	end
end
end

Citizen.CreateThread(function()
    while true do
        if coord ~= nil then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local targetDistance = #(playerCoords - vector3(coord.x, coord.y, coord.z))
            if targetDistance <= 5 then
                RemoveBlip(Blips['delivery'])
                Blips['delivery'] = nil

            end
        end
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('Huid_Police:AlertLSPD')
AddEventHandler('Huid_Police:AlertLSPD', function(pos, titre, raison)
    local timer = GetGameTimer()
--    ESX.ShowAdvancedNotification('911', '~y~' .. titre, raison, 'CHAR_AGENT14', 5)
	ESX.ShowAdvancedNotification('911', '~y~' .. titre, raison.."\n~g~,~s~ pour accepter\n~r~N~s~ pour refuser", 'CHAR_AGENT14', 5)
   -- ESX.ShowNotification('~g~,~s~ pour accepter\n~r~N~s~ pour refuser')
    Citizen.CreateThread(function()
        while true do
            local timer2 = GetGameTimer() - timer
            if timer2 >= 5000 then
                return
            end
            Citizen.Wait(0)
            if IsControlJustPressed(1, 244) then
                SetPos(pos)
                return
            elseif IsControlJustPressed(1, 306) then
                ESX.ShowNotification("Tu as refusé l'appel")
                return
            end
        end
    end)
end)

function SetPos(gps)
    if gps ~= 0 then
        if Blips['delivery'] ~= nil then
            RemoveBlip(Blips['delivery'])
            Blips['delivery'] = nil
        end

        Blips['delivery'] = AddBlipForCoord(gps.x, gps.y, gps.z)
        coord = vector3(gps.x, gps.y, gps.z)
        SetBlipRoute(Blips['delivery'], true)
        ESX.ShowNotification("Position GPS mis à jour")
        print(json.encode(Blips['delivery']))
    elseif gps == nil then
    end
end

function attached()
	local GroupHandle = GetPlayerGroup(PlayerId())
	SetGroupSeparationRange(GroupHandle, 1.9)
	SetPedNeverLeavesGroup(policeDog, false)
	FreezeEntityPosition(policeDog, true)
	loadDict("creatures@rottweiler@amb@world_dog_sitting@base")
	TaskPlayAnim(policeDog, "creatures@rottweiler@amb@world_dog_sitting@base", "base", 8.0, -8, -1, 1, 0, false, false, false)
end

function detached()
	local GroupHandle = GetPlayerGroup(PlayerId())
	SetGroupSeparationRange(GroupHandle, 999999.9)
	SetPedNeverLeavesGroup(policeDog, true)
	SetPedAsGroupMember(policeDog, GroupHandle)
	FreezeEntityPosition(policeDog, false)
end


AddEventHandler('lspd:openmenu', function(type, data)
    Menuf6Police()
end)

RegisterNetEvent('Huid_police:Alertpolice')
AddEventHandler('Huid_police:Alertpolice', function(pos, titre, raison)
    local timer = GetGameTimer()
    ESX.ShowAdvancedNotification('911', '~y~' .. titre, raison.."\n~g~Y~s~ pour accepter\n~r~N~s~ pour refuser", 'CHAR_AGENT14', 5)
   -- ESX.ShowNotification('~g~Y~s~ pour accepter\n~r~N~s~ pour refuser')
    Citizen.CreateThread(function()
        while true do
        local timer2 = GetGameTimer() - timer
        if timer2 >= 10000 then return end
            Citizen.Wait(0)
            if IsControlJustPressed(1, 246) then
                SetPos(pos)
                return
            elseif IsControlJustPressed(1, 306) then
                ESX.ShowNotification("Tu as refusé l'appel")
                return
            end
        end
    end)
end)

RegisterNetEvent('police:InfoService')
AddEventHandler('police:InfoService', function(service, nom)
	if service == 'prise' then
		local shot, shotStr = ESX.Game.GetPedMugshot(PlayerPedId())
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('Central', '~b~L.S.P.D', 'Agent : ~y~'..nom..'~w~ à ~g~pris son service', 'CHAR_AGENT14', 1)
		UnregisterPedheadshot(shot)
		Wait(1000)
	elseif service == 'fin' then
		local shot, shotStr = ESX.Game.GetPedMugshot(PlayerPedId())
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('Central', '~b~L.S.P.D', 'Agent : ~y~'..nom..'~w~ à ~r~quitter son service', "CHAR_AGENT14", 1)
		UnregisterPedheadshot(shot)
		Wait(1000)
	end
end)

RegisterNetEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function()
	local plyPed = PlayerPedId()
	local coords = GetEntityCoords(plyPed, false)

	if IsAnyVehicleNearPoint(coords, 5.0) then
		local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

		if DoesEntityExist(vehicle) then
			local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
			local freeSeat = nil

			for i = maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat ~= nil then
				dragStatus.isDragged = false
				DetachEntity(plyPed, true, false)
				TaskWarpPedIntoVehicle(plyPed, vehicle, freeSeat)
			end
		end
	end
end)

RegisterNetEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(copId)
	if isHandcuffed then
		dragStatus.isDragged = not dragStatus.isDragged
		dragStatus.CopId = copId
	end
end)

CreateThread(function()
	local wasDragged

	while true do
		local Sleep = 2

		if isHandcuffed and dragStatus.isDragged then
			Sleep = 3
			local targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.CopId))

			if DoesEntityExist(targetPed) and IsPedOnFoot(targetPed) and not IsPedDeadOrDying(targetPed, true) then
				if not wasDragged then
					AttachEntityToEntity(PlayerPedId(), targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
					wasDragged = true
				else
					Wait(3)
				end
			else
				wasDragged = false
				dragStatus.isDragged = false
				DetachEntity(PlayerPedId(), true, false)
			end
		elseif wasDragged then
			wasDragged = false
			DetachEntity(PlayerPedId(), true, false)
		end
	Wait(Sleep)
	end
end)

RegisterNetEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function()
	local plyPed = PlayerPedId()

	if not IsPedSittingInAnyVehicle(plyPed) then
		return
	end

	dragStatus.isDragged = false
	DetachEntity(plyPed, true, false)
	local vehicle = GetVehiclePedIsIn(plyPed, false)
	TaskLeaveVehicle(plyPed, vehicle, 10)
end)

function Rechercherplaquevoiture(plaquerechercher)
    local PlaqueMenu = RageUI.CreateMenu("Informations - plaque", "Informations")
    ESX.TriggerServerCallback('rPolice:getVehicleInfos', function(retrivedInfo)
        RageUI.Visible(PlaqueMenu, not RageUI.Visible(PlaqueMenu))
        while PlaqueMenu do
            Citizen.Wait(0)
            RageUI.IsVisible(PlaqueMenu, true, true, true, function()
                local hashvoiture = retrivedInfo.vehicle.model
                local nomvoituremodele = GetDisplayNameFromVehicleModel(hashvoiture)
                local nomvoituretexte = GetLabelText(nomvoituremodele)
                RageUI.ButtonWithStyle("Numéro de la plaque : ", nil, {
                    RightLabel = retrivedInfo.plate
                }, true, function(Hovered, Active, Selected)
                    if Selected then
                    end
                end)

                if not retrivedInfo.owner then
                    RageUI.ButtonWithStyle("Propriétaire : ", nil, {
                        RightLabel = "Inconnu"
                    }, true, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end)
                else
                    RageUI.ButtonWithStyle("Propriétaire : ", nil, {
                        RightLabel = retrivedInfo.owner
                    }, true, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end)

                    RageUI.ButtonWithStyle("Modèle du véhicule : ", nil, {
                        RightLabel = nomvoituretexte
                    }, true, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end)
                end
            end, function()
            end)
            if not RageUI.Visible(PlaqueMenu) then
                PlaqueMenu = RMenu:DeleteType("plaque d'immatriculation", true)
            end
        end
    end, plaquerechercher)
end


RegisterNetEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function()
	isHandcuffed = not isHandcuffed
	local playerPed = PlayerPedId()

	if isHandcuffed then
		
		RequestAnimDict('mp_arresting')
		while not HasAnimDictLoaded('mp_arresting') do
			Citizen.Wait(5)
		end
		
		SetEnableHandcuffs(playerPed, true)
		DisablePlayerFiring(playerPed, true)
		SetPedCanPlayGestureAnims(playerPed, false)

		if Config.EnableHandcuffTimer then
			if handcuffTimer.active then
				ESX.ClearTimeout(handcuffTimer.task)
			end

			StartHandcuffTimer()
		end
	else
		if Config.EnableHandcuffTimer and handcuffTimer.active then
			ESX.ClearTimeout(handcuffTimer.task)
		end

		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)
	end
end)

RegisterNetEvent('esx_policejob:unrestrain')
AddEventHandler('esx_policejob:unrestrain', function()
	if isHandcuffed then
		local playerPed = PlayerPedId()
		isHandcuffed = false

		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)

		-- end timer
		if Config.EnableHandcuffTimer and handcuffTimer.active then
			ESX.ClearTimeout(handcuffTimer.task)
		end
	end
end)

-- Handcuff
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if isHandcuffed then
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1
			DisableControlAction(0, 56, true) -- F9
			DisableControlAction(0, 75, true)
			DisableControlAction(0, 145, true)
			DisableControlAction(0, 185, true)
			DisableControlAction(0, 49, true)
			DisableControlAction(1, 75, true)
			DisableControlAction(1, 57, true)
			DisableControlAction(1, 145, true)
			DisableControlAction(1, 185, true)
			DisableControlAction(1, 49, true)
			DisableControlAction(0, 232, true)
			DisableControlAction(0, 236, true)
			DisableControlAction(0, 140, true)
			DisableControlAction(0, 29, true)
			DisableControlAction(0, 58, true)
			DisableControlAction(0, 113, true)
			DisableControlAction(0, 183, true)
			DisableControlAction(0, 47, true)
			DisableControlAction(0, 79, true)
			DisableControlAction(0, 253, true)
			DisableControlAction(0, 324, true)
			DisableControlAction(0, 144, true)
			DisableControlAction(0, 145, true)
			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 102, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 0, true) -- Disable changing view
			DisableControlAction(0, 26, true) -- Disable looking behind
			DisableControlAction(0, 73, true) -- Disable clearing animation
			DisableControlAction(2, 199, true) -- Disable pause screen
			DisableControlAction(0, 75, true) -- Disable pause screen
			DisableControlAction(0, 288, true) -- Cover
			DisableControlAction(0, 299, true) -- Select Weapon
			DisableControlAction(0, 170, true) -- F2
			DisableControlAction(0, 168, true) -- F6
			DisableControlAction(0, 166, true) -- Disable changing view
			DisableControlAction(0, 167, true) -- Disable looking behind
			DisableControlAction(0, 204, true) -- Disable clearing animation
			DisableControlAction(2, 211, true) -- Disable pause screen
			DisableControlAction(0, 192, true) -- Disable pause screen
			DisableControlAction(0, 10, true) -- Disable pause screen
			DisableControlAction(0, 11, true) -- Disable pause screen
			DisableControlAction(0, 47, true) -- Disable pause screen
			DisableControlAction(0, 167, true) -- Disable looking behind
			DisableControlAction(0, 204, true) -- Disable clearing animation
			DisableControlAction(2, 211, true) -- Disable pause screen
			DisableControlAction(0, 192, true) -- Disable pause screen
			DisableControlAction(0, 10, true) -- Disable pause screen
			DisableControlAction(0, 11, true) -- Disable pause screen
			DisableControlAction(0, 47, true) -- Disable pause screen
			DisableControlAction(0, 157, true) -- Disable clearing animation
			DisableControlAction(2, 158, true) -- Disable pause screen
			DisableControlAction(0, 159, true) -- Disable pause screen
			DisableControlAction(0, 160, true) -- Disable pause screen
			DisableControlAction(0, 161, true) -- Disable pause screen
			DisableControlAction(0, 121, true) -- Disable pause screen
			DisableControlAction(0, 137, true) -- Disable pause screen
			DisableControlAction(0, 132, true) -- Disable pause screen
			DisableControlAction(0, 121, true) -- Disable pause screen
			DisableControlAction(0, 121, true) -- Disable pause screen
			DisableControlAction(0, 157, true) -- Disable pause screen
			DisableControlAction(0, 158, true) -- Disable pause screen
			DisableControlAction(0, 160, true) -- Disable pause screen
			DisableControlAction(0, 164, true) -- Disable pause screen
			DisableControlAction(0, 165, true) -- Disable pause screen
			DisableControlAction(0, 289, true) -- Disable pause screen
			DisableControlAction(27, 75, true) -- Disable exit vehicle

			if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 then
				ESX.Streaming.RequestAnimDict('mp_arresting', function()
					TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
				end)
			end
		else
			Citizen.Wait(5)
		end
	end
end)

RegisterCommand('debug', function()
	ESX.UI.Menu.CloseAll()
	TriggerEvent('policebadge:open')
end, false)

local PlayerData = {}
local societypolicemoney = nil

function notNilString(str)
    if str == nil then
        return ""
    else
        return str
    end
end

Citizen.CreateThread(function()
    PlayerData = ESX.GetPlayerData()
    while true do
        local sleep = 3500
        if DoesEntityExist(policeDog) then
            if GetDistanceBetweenCoords(GetEntityCoords(policeDog), GetEntityCoords(PlayerPedId()), true) >= 50 and not IsEntityPlayingAnim(policeDog, 'creatures@rottweiler@amb@world_dog_sitting@base', 'base', 3) and not IsPedInAnyVehicle(policeDog, false) then
                SetEntityCoords(policeDog, GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -1.0, -0.98))
            end
            if GetDistanceBetweenCoords(GetEntityCoords(policeDog), GetEntityCoords(PlayerPedId()), true) >= 2.0 and not IsPedInAnyVehicle(policeDog, true) and not IsEntityPlayingAnim(policeDog, 'creatures@rottweiler@amb@world_dog_sitting@base', 'base', 3) and IsPedStill(policeDog) then
                TaskGoToCoordAnyMeans(policeDog, GetEntityCoords(PlayerPedId()), 5.0, 0, 0, 786603, 0xbf800000)
            end
        end
        Wait(sleep)
    end
end)

RegisterNetEvent('esx_policedog:hasDrugs')
AddEventHandler('esx_policedog:hasDrugs', function(hadIt)
    if hadIt then
        ESX.ShowNotification('De la drogue a été ~g~trouvée !')
        loadDict('missfra0_chop_find')
        TaskPlayAnim(policeDog, 'missfra0_chop_find', 'chop_bark_at_ballas', 8.0, -8, -1, 0, 0, false, false, false)
    else
        ESX.ShowNotification('~r~Pas de drogues~s~ sur la personne !')
    end
end)

loadDict = function(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
end

function spawnObject(name)
	local plyPed = PlayerPedId()
	local coords = GetEntityCoords(plyPed, false) + (GetEntityForwardVector(plyPed) * 1.0)

	ESX.Game.SpawnObject(name, coords, function(obj)
		SetEntityHeading(obj, GetEntityPhysicsHeading(plyPed))
		PlaceObjectOnGroundProperly(obj)
	end)
end

-- handcuff timer, unrestrain the player after an certain amount of time
function StartHandcuffTimer()
	if Config.EnableHandcuffTimer and handcuffTimer.active then
		ESX.ClearTimeout(handcuffTimer.task)
	end

	handcuffTimer.active = true

	handcuffTimer.task = ESX.SetTimeout(Config.HandcuffTimer, function()
		ESX.ShowNotification('vous sentez que vos menottes deviennent fragiles.')
		TriggerEvent('esx_policejob:unrestrain')
		handcuffTimer.active = false
	end)
end

function crochetagevehicle()
	local playerPed = PlayerPedId()
	local vehicle = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 4.5, 0, 127)
	local coords    = GetEntityCoords(playerPed)

    if IsPedSittingInAnyVehicle(playerPed) then
		RageUI.Popup({message = "Vous ne pouvez pas effectuer cette action depuis un véhicule !"})
        return
    end

    if DoesEntityExist(vehicle) then
        isBusy = true
        local dict, anim = "veh@break_in@0h@p_m_two@","std_locked_ds"
        ESX.Streaming.RequestAnimDict(dict)
       -- createProgressBar("Crochetage en cours", 0, 255, 185, 120, 10000)
        ESX.ShowNotification('Crochetage en cours')
        TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, 8.0, -1, 1, 1, 0, 0, 0)
        Citizen.CreateThread(function()
            Citizen.Wait(10000)

            SetVehicleDoorsLocked(vehicle, 1)
            SetVehicleDoorsLockedForAllPlayers(vehicle, false)
            ClearPedTasksImmediately(playerPed)
            PlaySoundFrontend(-1, 'Drill_Pin_Break', 'DLC_HEIST_FLEECA_SOUNDSET', false)

            ESX.ShowNotification('Le ~g~véhicule~s~ a bien ete ~b~dévérouillé')
            isBusy = false
        end)
    end
end


---------------- FONCTIONS ------------------

local bossmenu = {
    vector3(467.9045, -975.3659, 35.8859)
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
            for k in pairs(bossmenu) do
				if ESX.PlayerData.job and ESX.PlayerData.job.name == 'lspd' and ESX.PlayerData.job.grade_name == 'boss'
				or ESX.PlayerData.job and ESX.PlayerData.job2.name == 'lspd' and ESX.PlayerData.job2.grade_name == 'boss' then
			local plyCoords = GetEntityCoords(PlayerPedId(), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, bossmenu[k].x, bossmenu[k].y, bossmenu[k].z)

			if dist <= 10 then 
				--DrawMarker(6, 462.5404, -996.5221, 29.68981, 0, 0, 0, -90, 0, 0, 0.8, 0.8, 0.8, 255, 124, 0, 140, 0, 1, 2, false, false, true)
				DrawMarker(6, 467.9045, -975.3659, 34.8859, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 0.8, 0.8, 0.8, 0, 0, 255, 140, 0, 1, 2, 0, nil, nil, 0)
				--ESX.ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour vous soigner")
				if dist < 0.8 then
					ESX.Game.Utils.DrawText3D(bossmenu[k], "Appuyez sur ~b~E~w~ pour ~b~accéder aux actions patron", 0.4)
						if IsControlJustPressed(1, 38) then
							BossPolice()
						end
					end
				end
			end
		end
	end
end)

function BossPolice()
	local rPolice = RageUI.CreateMenu("Actions Patron", "Police")
  
	  RageUI.Visible(rPolice, not RageUI.Visible(rPolice))
  
			  while rPolice do
				  Citizen.Wait(0)
					  RageUI.IsVisible(rPolice, true, true, true, function()
  
					  
					  RageUI.ButtonWithStyle("Retirer argent de société",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						  if Selected then
							  local amount = KeyboardInput("Montant", "", 10)
							  amount = tonumber(amount)
							  if amount == nil then
								  RageUI.Popup({message = "Montant invalide"})
							  else
								  TriggerServerEvent('esx_society:withdrawMoney', 'lspd', amount)
								  RefreshpoliceMoney()
							  end
						  end
					  end)
  
					  RageUI.ButtonWithStyle("Déposer argent de société",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						  if Selected then
							  local amount = KeyboardInput("Montant", "", 10)
							  amount = tonumber(amount)
							  if amount == nil then
								  RageUI.Popup({message = "Montant invalide"})
							  else
								  TriggerServerEvent('esx_society:depositMoney', 'lspd', amount)
								  RefreshpoliceMoney()
							  end
						  end
					  end) 
  
					  RageUI.ButtonWithStyle("Accéder aux actions de management",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						  if Selected then
							  policeboss()
							  RageUI.CloseAll()
						  end
					  end)
				  end, function()
			  end)
			  if not RageUI.Visible(rPolice) then
			  rPolice = RMenu:DeleteType("Actions Patron", true)
		  end
	  end
  end 


function RefreshpoliceMoney()
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            UpdateSocietypoliceMoney(money)
        end, ESX.PlayerData.job.name)
    end
end

function UpdateSocietypoliceMoney(money)
    societypolicemoney = ESX.Math.GroupDigits(money)
end

function policeboss()
    TriggerEvent('esx_society:openBossMenu', 'lspd', function(data, menu)
        menu.close()
    end, {wash = false})
end

RegisterNetEvent('lspd:annonce')
AddEventHandler('lspd:annonce', function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'lspd' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'lspd' then
       	exports.ox_lib:showContext('lspdmenu')
	else
		ESX.ShowNotification("~y~ta pas acces miskin")
	end
end)

exports.ox_target:addBoxZone(
	{
        coords = vec3(440.13, -974.67, 30.56),
        size = vec3(1, 1, 1),
        rotation = 45,
        debug = drawZones,
        options = {
            {
                name = 'poly',
                event = 'lspd:annonce',
                icon = 'fa-solid fa-cube',
                label = 'Acceder a l\'ordinateur',
            },
        },
        minZ = 43.50,
        maxZ = 44.00,
    }
)

exports.ox_lib:registerContext({
    id = 'lspdmenu',
    title = 'Faire une annonce',
    options = {
        {
            title = 'Ouvert',
            progress = '100',
            onSelect = function()
                --print("Pressed the button!")  	 
				exports["WaveShield"]:TriggerServerEvent('hlspd:Ouvert')    
            end,
        },
        {
            title = 'Fermer',
            progress = '100',
            onSelect = function()
                --print("Pressed the button!") 
                exports["WaveShield"]:TriggerServerEvent('hlspd:Fermer')  
            end,
        },
    },
})