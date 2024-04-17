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
function Menuf6xero()
    local hxerof6 = RageUI.CreateMenu("xero", " ")
	local emotes = RageUI.CreateSubMenu(hxerof6, "Xero", " ")  

    RageUI.Visible(hxerof6, not RageUI.Visible(hxerof6))
    while hxerof6 do
        Citizen.Wait(0)
            RageUI.IsVisible(hxerof6, true, true, true, function()

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
                                    --exports["WaveShield"]:TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_xero', ("Cluckin xero"), montant)
                                    TriggerServerEvent("okokBilling:CreateCustomInvoice", GetPlayerServerId(player), montant, 'Facture', 'Facture xero', 'society_xero', ('xero'))
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
				
                end, function() 
                end)
                
                RageUI.IsVisible(emotes, true, true, true, function()                    

                    RageUI.ButtonWithStyle("prendre la tablet",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ExecuteCommand('e tablet2')
                        end
                    end)                    
        
                    RageUI.ButtonWithStyle("Attendre",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ExecuteCommand('e wait')
                        end
                    end)                   
        
                    RageUI.ButtonWithStyle("mettre ses main au contoir",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ExecuteCommand('e leanbar3')
                        end
                    end)                  
        
                    RageUI.ButtonWithStyle("sortir une chaise de camping",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ExecuteCommand('e sitchairf2')
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
    
                if not RageUI.Visible(hxerof6) and not RageUI.Visible(emotes) then
                    hxerof6 = RMenu:DeleteType("xero", true)
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

AddEventHandler('xero:openmenu', function(type, data)
	Menuf6xero()
end)

function OpenPrendreMenuxero()
    local PrendreMenu = RageUI.CreateMenu("xero", "Nos produits")
        RageUI.Visible(PrendreMenu, not RageUI.Visible(PrendreMenu))
    while PrendreMenu do
        Citizen.Wait(0)

            RageUI.IsVisible(PrendreMenu, true, true, true, function()
            RageUI.Separator("Disponible")
            for k,v in pairs(Barxero.ingredients) do
                if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade >= v.gradelvl or ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade >= v.gradelvl then
                    RageUI.ButtonWithStyle(v.Label, nil, { RightLabel = '~y~' .. v.Price..' $' }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            --exports["WaveShield"]:TriggerServerEvent('hxero:bar', v.Name, v.Price)
                            TriggerServerEvent('hxero:bar', v.Name, v.Price)
                        end
                    end)
                end
            end

			end, function() 
            end)
    
        if not RageUI.Visible(PrendreMenu) then
            PrendreMenu = RMenu:DeleteType("xero", true)
        end
    end
end


Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'xero' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'xero' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, xero.pos.MenuPrendre.position.x, xero.pos.MenuPrendre.position.y, xero.pos.MenuPrendre.position.z)
        if dist3 <= 7.0 and xero.jeveuxmarker then
            Timer = 0
            DrawMarker(20, xero.pos.MenuPrendre.position.x, xero.pos.MenuPrendre.position.y, xero.pos.MenuPrendre.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 13, 219, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist3 <= 1.0 then
                Timer = 0   
                SetTextComponentFormat('STRING')
			    AddTextComponentString("~INPUT_PICKUP~ pour ouvrir le stock")
			    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                if IsControlJustPressed(1,51) then           
                    OpenPrendreMenuxero()
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
    id = 'xeromenu',
    title = 'Faire une annonce',
    options = {
        {
            title = 'Ouvert',
            progress = '100',
            onSelect = function()
                --print("Pressed the button!")  	 
				exports["WaveShield"]:TriggerServerEvent('hxero:Ouvert')    
            end,
        },
        {
            title = 'Fermer',
            progress = '100',
            onSelect = function()
                --print("Pressed the button!") 
                exports["WaveShield"]:TriggerServerEvent('hxero:Fermer')  
            end,
        },
    },
})

RegisterNetEvent('xero:annonce')
AddEventHandler('xero:annonce', function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'xero' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'xero' then
       	exports.ox_lib:showContext('xeromenu')
	else
		ESX.ShowNotification("~y~ta pas acces miskin")
	end
end)

RegisterNetEvent('xero:import')
AddEventHandler('xero:import', function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'xero' and ESX.PlayerData.job2.grade_name == 'boss' then        
        OpenPrendreMenuxero()
	else
		ESX.ShowNotification("~y~ta pas acces miskin")
	end
end)

exports.ox_target:addBoxZone(
	{
        coords = vec3(301.03, -1268.13, 29.31),
        size = vec3(1, 1, 1),
        rotation = 45,
        debug = drawZones,
        options = {
            {
                name = 'poly',
                event = 'xero:annonce',
                icon = 'fa-solid fa-cube',
                label = 'Faire une annonce',
            },
        },
        minZ = 43.50,
        maxZ = 44.00,
    },    
	{
        coords = vec3(292.76, -1272.05, 29.63),
        size = vec3(1, 1, 1),
        rotation = 45,
        debug = drawZones,
        options = {
            {
                name = 'poly',
                event = 'xero:import',
                icon = 'fa-solid fa-cube',
                label = 'Ouvrir l\'espace de commande',
            },
        },
        minZ = 43.50,
        maxZ = 44.00,
    }
)