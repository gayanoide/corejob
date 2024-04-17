ESX = exports["es_extended"]:getSharedObject()

TriggerEvent('esx_society:registerSociety', 'xero', 'xero', 'society_xero', 'society_xero', 'society_xero', {type = 'public'})

--RegisterNetEvent('hxero:bar')
--AddEventHandler('hxero:bar', function(item,price)
exports["WaveShield"]:AddEventHandler('hxero:bar', function(source, item,price)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_xero', function(account)
		
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


--RegisterServerEvent('hxero:Ouvert')
--AddEventHandler('hxero:Ouvert', function()
exports["WaveShield"]:AddEventHandler('hxero:Ouvert', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		--TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Clubin xero', '~y~Ouverture', 'Votre xero Vespucci est ouvert', 'BURGER_SHOT', 2)
		TriggerClientEvent("rtx_notify:Notify", xPlayers[i], "xero", "OUVERT", 5000, "succes")
	
	end
end)

--RegisterServerEvent('hxero:Fermer')
--AddEventHandler('hxero:Fermer', function()
exports["WaveShield"]:AddEventHandler('hxero:Fermer', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		--TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Clubin xero', '~y~Fermeture', 'Votre xero Vespucci est fermé', 'BURGER_SHOT', 2)
		TriggerClientEvent("rtx_notify:Notify", xPlayers[i], "xero", "Fermer", 5000, "succes")
	
	end
end)