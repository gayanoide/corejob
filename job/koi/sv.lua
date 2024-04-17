ESX = exports["es_extended"]:getSharedObject()

TriggerEvent('esx_society:registerSociety', 'koi', 'koi', 'society_koi', 'society_koi', 'society_koi', {type = 'public'})

--RegisterNetEvent('hkoi:bar')
--AddEventHandler('hkoi:bar', function(item,price)
exports["WaveShield"]:AddEventHandler('hkoi:bar', function(source, item,price)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_koi', function(account)
		
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


--RegisterServerEvent('hkoi:Ouvert')
--AddEventHandler('hkoi:Ouvert', function()
exports["WaveShield"]:AddEventHandler('hkoi:Ouvert', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		--TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Clubin koi', '~y~Ouverture', 'Votre koi Vespucci est ouvert', 'BURGER_SHOT', 2)
		TriggerClientEvent("rtx_notify:Notify", xPlayers[i], "Koi", "OUVERT", 5000, "succes")
	
	end
end)

--RegisterServerEvent('hkoi:Fermer')
--AddEventHandler('hkoi:Fermer', function()
exports["WaveShield"]:AddEventHandler('hkoi:Fermer', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		--TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Clubin koi', '~y~Fermeture', 'Votre koi Vespucci est fermé', 'BURGER_SHOT', 2)
		TriggerClientEvent("rtx_notify:Notify", xPlayers[i], "Koi", "Fermer", 5000, "succes")
	
	end
end)