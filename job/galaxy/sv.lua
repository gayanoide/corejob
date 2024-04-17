ESX = exports["es_extended"]:getSharedObject()

TriggerEvent('esx_society:registerSociety', 'galaxy', 'galaxy', 'society_galaxy', 'society_galaxy', 'society_galaxy', {type = 'public'})

--RegisterNetEvent('hgalaxy:bar')
--AddEventHandler('hgalaxy:bar', function(item,price)
exports["WaveShield"]:AddEventHandler('hgalaxy:bar', function(source, item,price)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_galaxy', function(account)
		
    if account.money >= price then
    if xPlayer.canCarryItem(item, 1) then
        account.removeMoney(price)
        xPlayer.addInventoryItem(item, 1)
        TriggerClientEvent('esx:showNotification', source, "~g~Achat~w~ effectué !")
	else
	    TriggerClientEvent('esx:showNotification', source, "Vous ne pouvez pas porter d'avantage")
	end
    else
         TriggerClientEvent('esx:showNotification', source, "Votre société n'a plus d'argent")
    end
	end)
end)


--RegisterServerEvent('hgalaxy:Ouvert')
--AddEventHandler('hgalaxy:Ouvert', function()
exports["WaveShield"]:AddEventHandler('hgalaxy:Ouvert', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		--TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Clubin galaxy', '~y~Ouverture', 'Votre galaxy Vespucci est ouvert', 'BURGER_SHOT', 2)
		TriggerClientEvent("rtx_notify:Notify", xPlayers[i], "galaxy", "OUVERT", 5000, "succes")
	
	end
end)

--RegisterServerEvent('hgalaxy:Fermer')
--AddEventHandler('hgalaxy:Fermer', function()
exports["WaveShield"]:AddEventHandler('hgalaxy:Fermer', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		--TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Clubin galaxy', '~y~Fermeture', 'Votre galaxy Vespucci est fermé', 'BURGER_SHOT', 2)
		TriggerClientEvent("rtx_notify:Notify", xPlayers[i], "galaxy", "Fermer", 5000, "succes")
	
	end
end)