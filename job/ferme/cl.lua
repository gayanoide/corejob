ESX = exports["es_extended"]:getSharedObject()

local run = false

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

Citizen.CreateThread(function() 
    
	while true do
    if (ESX.PlayerData.job and ESX.PlayerData.job.name =='ferme' and run) or (ESX.PlayerData.job2 and ESX.PlayerData.job2.name =='ferme' and run) then
	if not blips2activ then
	local blip = AddBlipForCoord(ferme.pos.Fruit.position.x, ferme.pos.Fruit.position.y, ferme.pos.Fruit.position.z)
		SetBlipSprite (blip, 502)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.5)
		SetBlipColour (blip, 13)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName("[RUN] ferme | étape 1")
		EndTextCommandSetBlipName(blip)
		
	local blip2 = AddBlipForCoord(ferme.pos.FruitCage.position.x, ferme.pos.FruitCage.position.y, ferme.pos.FruitCage.position.z)
		SetBlipSprite (blip2, 503)
		SetBlipDisplay(blip2, 4)
		SetBlipScale  (blip2, 0.5)
		SetBlipColour (blip2, 13)
		SetBlipAsShortRange(blip2, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName("[RUN] ferme | étape 2")
		EndTextCommandSetBlipName(blip2)
	
	
	local blip4 = AddBlipForCoord(ferme.pos.Vente.position.x, ferme.pos.Vente.position.y, ferme.pos.Vente.position.z)
		SetBlipSprite (blip4, 504)
		SetBlipDisplay(blip4, 4)
		SetBlipScale  (blip4, 0.5)
		SetBlipColour (blip4, 13)
		SetBlipAsShortRange(blip4, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName("[RUN] ferme | Vente")
		EndTextCommandSetBlipName(blip4)
		
	table.insert(blips2, blip)
	table.insert(blips2, blip2)
	table.insert(blips2, blip4)
	blips2activ = true
	end
	else
	for i, blip2 in pairs(blips2) do
		RemoveBlip(blip2)
	end
	blips2 = {}	
	blips2activ = false
	end
  Citizen.Wait(10)
  end
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
function Menuf6ferme()
    local hfermef6 = RageUI.CreateMenu("ferme", " ")
    local run = RageUI.CreateMenu("ferme", " ")
    RageUI.Visible(hfermef6, not RageUI.Visible(hfermef6))
    while hfermef6 do
        Citizen.Wait(0)
            RageUI.IsVisible(hfermef6, true, true, true, function()

                RageUI.Separator("↓ ~y~Facture~s~ ↓")

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
                                    --exports["WaveShield"]:TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_ferme', ("ferme"), montant)
                                    TriggerServerEvent("okokBilling:CreateCustomInvoice", GetPlayerServerId(player), montant, 'Facture', 'Facture Ferme', 'society_ferme', ('ferme'))
                                    TriggerEvent('esx:showAdvancedNotification', 'Fl~g~ee~s~ca ~g~Bank', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~y~'..montant.. ' $ ', 'CHAR_BANK_FLEECA', 9)
                                else
                                    ESX.ShowNotification("~r~Probleme~s~: Aucuns joueurs proche")
                                end
                            end
                        end
                    end
                end)

				RageUI.Separator("↓ ~y~Run ~s~↓")
                
                RageUI.ButtonWithStyle("Lancer le run",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        SetNewWaypoint(vector3(ferme.pos.Fruit.position.x, ferme.pos.Fruit.position.y, ferme.pos.Fruit.position.z))
                        RageUI.CloseAll()
                    end
                end)
                RageUI.ButtonWithStyle("Traitement",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        SetNewWaypoint(vector3(ferme.pos.FruitCage.position.x, ferme.pos.FruitCage.position.y, ferme.pos.FruitCage.position.z))
                        RageUI.CloseAll()
                    end
                end)
                RageUI.ButtonWithStyle("Vente",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        SetNewWaypoint(vector3(ferme.pos.Vente.position.x, ferme.pos.Vente.position.y, ferme.pos.Vente.position.z))
                        RageUI.CloseAll()
                    end
                end)			
                end, function() 

            end)
    
                if not RageUI.Visible(hfermef6) and not RageUI.Visible(run) then
                    hfermef6 = RMenu:DeleteType("ferme", true)
        end
    end
end

function nextStep(gps)
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

AddEventHandler('ferme:openmenu', function(type, data)
	Menuf6ferme()
end)

function OpenPrendreMenferme()
    local PrendreMenu = RageUI.CreateMenu("ferme", "Nos produits", nil, nil, "aLib", "black")
        RageUI.Visible(PrendreMenu, not RageUI.Visible(PrendreMenu))
    while PrendreMenu do
        Citizen.Wait(0)
            RageUI.IsVisible(PrendreMenu, true, true, true, function()
            RageUI.Separator("Les ingredients")
            for k,v in pairs(Bar.ingredients) do
            RageUI.ButtonWithStyle(v.Label, nil, { RightLabel = '~g~' .. v.Price..'$' }, true, function(Hovered, Active, Selected)
              if (Selected) then
                exports["WaveShield"]:TriggerServerEvent('hferme:bar', v.Name, v.Price)
                end
            end)
            end
			
            RageUI.Separator("Les utilitaires")
            for k,v in pairs(Bar.liquide) do
            RageUI.ButtonWithStyle(v.Label, nil, { RightLabel = '~g~' .. v.Price..'$' }, true, function(Hovered, Active, Selected)
              if (Selected) then
                exports["WaveShield"]:TriggerServerEvent('hferme:bar', v.Name, v.Price)
                end
            end)
            end
			end, function() 
                end)
    
                if not RageUI.Visible(PrendreMenu) then
                    PrendreMenu = RMenu:DeleteType("ferme", true)
        end
    end
end


Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ferme' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'ferme' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, ferme.pos.MenuPrendre.position.x, ferme.pos.MenuPrendre.position.y, ferme.pos.MenuPrendre.position.z)
        if dist3 <= 7.0 and ferme.jeveuxmarker then
            Timer = 0
            DrawMarker(20, ferme.pos.MenuPrendre.position.x, ferme.pos.MenuPrendre.position.y, ferme.pos.MenuPrendre.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 147, 112, 219, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist3 <= 1.0 then
                Timer = 0   
                        SetTextComponentFormat('STRING')
			    AddTextComponentString("~INPUT_PICKUP~ pour ouvrir le stock")
			    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                if IsControlJustPressed(1,51) then           
                            OpenPrendreMenferme()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
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