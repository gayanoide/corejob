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
function Menuf6tps()
    local htpsf6 = RageUI.CreateMenu("tps", " ")
    RageUI.Visible(htpsf6, not RageUI.Visible(htpsf6))
    while htpsf6 do
        Citizen.Wait(0)
            RageUI.IsVisible(htpsf6, true, true, true, function()

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
                                    --exports["WaveShield"]:TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_tps', ("Cluckin tps"), montant)
                                    TriggerServerEvent("okokBilling:CreateCustomInvoice", GetPlayerServerId(player), montant, 'Facture', 'Facture tps', 'society_tps', ('tps'))
                                    TriggerEvent('esx:showAdvancedNotification', 'Fl~g~ee~s~ca ~g~Bank', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~g~'..montant.. '$ ', 'CHAR_BANK_FLEECA', 9)
                                else
                                    ESX.ShowNotification("~r~Probleme~s~: Aucuns joueurs proche")
                                end
                            end
                        end
                    end
                end)  
                RageUI.ButtonWithStyle("Props / objet",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        ExecuteCommand('props_menu')
                        RageUI.CloseAll()
                    end
                end)    
				
                end, function() 
                end)
    
                if not RageUI.Visible(htpsf6) then
                    htpsf6 = RMenu:DeleteType("tps", true)
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

AddEventHandler('tps:openmenu', function(type, data)
	Menuf6tps()
end)

function OpenPrendreMenutps()
    local PrendreMenu = RageUI.CreateMenu("tps", "Nos produits")
        RageUI.Visible(PrendreMenu, not RageUI.Visible(PrendreMenu))
    while PrendreMenu do
        Citizen.Wait(0)
            RageUI.IsVisible(PrendreMenu, true, true, true, function()
            RageUI.Separator("Les ingredients")
            for k,v in pairs(Bartps.ingredients) do
                if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade >= v.gradelvl or ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade >= v.gradelvl then
                    RageUI.ButtonWithStyle(v.Label, nil, { RightLabel = '~g~' .. v.Price..'$' }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            --exports["WaveShield"]:TriggerServerEvent('htps:bar', v.Name, v.Price)
                            TriggerServerEvent('htps:bar', v.Name, v.Price)
                        end
                    end)
                end
            end
			end, function() 
            end)
    
        if not RageUI.Visible(PrendreMenu) then
            PrendreMenu = RMenu:DeleteType("tps", true)
        end
    end
end


Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'tps' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'tps' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, tps.pos.MenuPrendre.position.x, tps.pos.MenuPrendre.position.y, tps.pos.MenuPrendre.position.z)
        if dist3 <= 7.0 and tps.jeveuxmarker then
            Timer = 0
            DrawMarker(20, tps.pos.MenuPrendre.position.x, tps.pos.MenuPrendre.position.y, tps.pos.MenuPrendre.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 13, 219, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist3 <= 1.0 then
                Timer = 0   
                SetTextComponentFormat('STRING')
			    AddTextComponentString("~INPUT_PICKUP~ pour ouvrir le stock")
			    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                if IsControlJustPressed(1,51) then           
                    OpenPrendreMenutps()
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
    id = 'tpsmenu',
    title = 'Faire une annonce',
    options = {
        {
            title = 'Ouvert',
            progress = '100',
            onSelect = function()
                --print("Pressed the button!")  	 
				exports["WaveShield"]:TriggerServerEvent('htps:Ouvert')    
            end,
        },
        {
            title = 'Fermer',
            progress = '100',
            onSelect = function()
                --print("Pressed the button!") 
                exports["WaveShield"]:TriggerServerEvent('htps:Fermer')  
            end,
        },
    },
})

RegisterNetEvent('tps:annonce')
AddEventHandler('tps:annonce', function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'tps' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'tps' then
       	exports.ox_lib:showContext('tpsmenu')
	else
		ESX.ShowNotification("~y~ta pas acces miskin")
	end
end)

exports.ox_target:addBoxZone(
	{
        coords = vec3(2735.01, 3463.85, 55.93),
        size = vec3(1, 1, 1),
        rotation = 45,
        debug = drawZones,
        options = {
            {
                name = 'poly',
                event = 'tps:annonce',
                icon = 'fa-solid fa-cube',
                label = 'Acceder a l\'ordinateur',
            },
        },
        minZ = 43.50,
        maxZ = 44.00,
    }
)