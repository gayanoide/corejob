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
    if (ESX.PlayerData.job and ESX.PlayerData.job.name =='bell' and run) or (ESX.PlayerData.job2 and ESX.PlayerData.job2.name =='bell' and run) then
	if not blips2activ then
	local blip = AddBlipForCoord(bell.pos.Poulet.position.x, bell.pos.Poulet.position.y, bell.pos.Poulet.position.z)
		SetBlipSprite (blip, 502)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.5)
		SetBlipColour (blip, 63)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName("[RUN] bell | étape 1")
		EndTextCommandSetBlipName(blip)
		
	local blip2 = AddBlipForCoord(bell.pos.Deplume.position.x, bell.pos.Deplume.position.y, bell.pos.Deplume.position.z)
		SetBlipSprite (blip2, 503)
		SetBlipDisplay(blip2, 4)
		SetBlipScale  (blip2, 0.5)
		SetBlipColour (blip2, 63)
		SetBlipAsShortRange(blip2, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName("[RUN] bell | étape 2")
		EndTextCommandSetBlipName(blip2)
	
	local blip3 = AddBlipForCoord(bell.pos.Decoupe.position.x, bell.pos.Decoupe.position.y, bell.pos.Decoupe.position.z)
		SetBlipSprite (blip3, 504)
		SetBlipDisplay(blip3, 4)
		SetBlipScale  (blip3, 0.5)
		SetBlipColour (blip3, 63)
		SetBlipAsShortRange(blip3, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName("[RUN] bell | étape 3")
		EndTextCommandSetBlipName(blip3)
	
	local blip4 = AddBlipForCoord(bell.pos.Vente.position.x, bell.pos.Vente.position.y, bell.pos.Vente.position.z)
		SetBlipSprite (blip4, 505)
		SetBlipDisplay(blip4, 4)
		SetBlipScale  (blip4, 0.5)
		SetBlipColour (blip4, 63)
		SetBlipAsShortRange(blip4, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName("[RUN] bell | Vente")
		EndTextCommandSetBlipName(blip4)
		
	table.insert(blips2, blip)
	table.insert(blips2, blip2)
	table.insert(blips2, blip3)
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


local Blips = {}
function Menuf6bell()
    local hbellf6 = RageUI.CreateMenu("Clubin Bell", " ")
	local emotes = RageUI.CreateSubMenu(hbellf6, "Clubin Bell", " ") 
    RageUI.Visible(hbellf6, not RageUI.Visible(hbellf6))
    while hbellf6 do
        Citizen.Wait(0)
            RageUI.IsVisible(hbellf6, true, true, true, function()

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
                                    --exports["WaveShield"]:TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_bell', ("Cluckin Bell"), montant)
                                    TriggerServerEvent("okokBilling:CreateCustomInvoice", GetPlayerServerId(player), montant, 'Facture', 'Facture Cluckin Bell', 'society_bell', ('bell'))
                                    TriggerEvent('esx:showAdvancedNotification', 'Fl~g~ee~s~ca ~g~Bank', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~g~'..montant.. '$ ', 'CHAR_BANK_FLEECA', 9)
                                else
                                    ESX.ShowNotification("~r~Probleme~s~: Aucuns joueurs proche")
                                end
                            end
                        end
                    end
                end)

                RageUI.ButtonWithStyle("👤 Emotes rapide", nil, {RightLabel = "→"},true, function()
				end, emotes)
        
    
				RageUI.Separator("↓ Run ↓")
                RageUI.ButtonWithStyle("Lancer le run",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        SetNewWaypoint(vector3(bell.pos.Poulet.position.x, bell.pos.Poulet.position.y, bell.pos.Poulet.position.z))
                        RageUI.CloseAll()
                    end
                end)
                RageUI.ButtonWithStyle("Vente",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        SetNewWaypoint(vector3(bell.pos.Vente.position.x, bell.pos.Vente.position.y, bell.pos.Vente.position.z))
                        RageUI.CloseAll()
                    end
                end)
				
                end, function() 
                end)
                
                RageUI.IsVisible(emotes, true, true, true, function()                    
    
                    RageUI.ButtonWithStyle("Nettoyer",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ExecuteCommand('e clean')
                        end
                    end)                    
        
                    RageUI.ButtonWithStyle("Porter un plateau",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ExecuteCommand('e foodtraym')
                        end
                    end)                  
        
                    RageUI.ButtonWithStyle("Porter deux plateau",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ExecuteCommand('e foodtrayg')
                        end
                    end)                   
        
                    RageUI.ButtonWithStyle("Prendre des notes",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ExecuteCommand('e notepad')
                        end
                    end)                   
        
                    RageUI.ButtonWithStyle("Faire la cuisine",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ExecuteCommand('e bbqf')
                        end
                    end)                  
        
                    RageUI.ButtonWithStyle("Passer le balai",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ExecuteCommand('e broom4')
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
    
                if not RageUI.Visible(hbellf6) and not RageUI.Visible(emotes) then
                    hbellf6 = RMenu:DeleteType("bell", true)
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

AddEventHandler('bell:openmenu', function(type, data)
	Menuf6bell()
end)

function OpenPrendreMenubell()
    local PrendreMenu = RageUI.CreateMenu("Clubin Bell", "Nos produits")
    PrendreMenu:SetRectangleBanner(0, 13, 219)
        RageUI.Visible(PrendreMenu, not RageUI.Visible(PrendreMenu))
    while PrendreMenu do
        Citizen.Wait(0)
            RageUI.IsVisible(PrendreMenu, true, true, true, function()
            RageUI.Separator("Les ingredients")
            for k,v in pairs(Barbell.ingredients) do
                if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade >= v.gradelvl or ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade >= v.gradelvl then
                    RageUI.ButtonWithStyle(v.Label, nil, { RightLabel = '~g~' .. v.Price..'$' }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            exports["WaveShield"]:TriggerServerEvent('hbell:bar', v.Name, v.Price)
                        end
                    end)
                end
            end
			
            RageUI.Separator("Les utilitaires")
            for k,v in pairs(Barbell.liquide) do
                if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade >= v.gradelvl or ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade >= v.gradelvl then
                    RageUI.ButtonWithStyle(v.Label, nil, { RightLabel = '~g~' .. v.Price..'$' }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            exports["WaveShield"]:TriggerServerEvent('hbell:bar', v.Name, v.Price)
                        end
                    end)
                end
            end
			end, function() 
            end)
    
        if not RageUI.Visible(PrendreMenu) then
            PrendreMenu = RMenu:DeleteType("bell", true)
        end
    end
end


Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'bell' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'bell' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, bell.pos.MenuPrendre.position.x, bell.pos.MenuPrendre.position.y, bell.pos.MenuPrendre.position.z)
        if dist3 <= 7.0 and bell.jeveuxmarker then
            Timer = 0
            DrawMarker(20, bell.pos.MenuPrendre.position.x, bell.pos.MenuPrendre.position.y, bell.pos.MenuPrendre.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 13, 219, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist3 <= 1.0 then
                Timer = 0   
                SetTextComponentFormat('STRING')
			    AddTextComponentString("~INPUT_PICKUP~ pour ouvrir le stock")
			    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                if IsControlJustPressed(1,51) then           
                    OpenPrendreMenubell()
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




exports.ox_lib:registerContext({
    id = 'bellmenu',
    title = 'Faire une annonce',
    options = {
        {
            title = 'Ouvert',
            progress = '100',
            onSelect = function()
                --print("Pressed the button!")  	 
				exports["WaveShield"]:TriggerServerEvent('hbell:Ouvert')    
            end,
        },
        {
            title = 'Fermer',
            progress = '100',
            onSelect = function()
                --print("Pressed the button!") 
                exports["WaveShield"]:TriggerServerEvent('hbell:Fermer')  
            end,
        },
    },
})

RegisterNetEvent('bell:annonce')
AddEventHandler('bell:annonce', function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'bell' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'bell' then
       	exports.ox_lib:showContext('bellmenu')
	else
		ESX.ShowNotification("~y~ta pas acces miskin")
	end
end)

exports.ox_target:addBoxZone(
	{
        coords = vec3(-165.72, -268.78, 43.6),
        size = vec3(1, 1, 1),
        rotation = 45,
        debug = drawZones,
        options = {
            {
                name = 'poly',
                event = 'bell:annonce',
                icon = 'fa-solid fa-cube',
                label = 'Acceder a l\'ordinateur',
            },
        },
        minZ = 43.50,
        maxZ = 44.00,
    }
)