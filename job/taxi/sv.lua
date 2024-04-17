ESX = exports["es_extended"]:getSharedObject()

TriggerEvent('esx_society:registerSociety', 'taxi', 'taxi', 'society_taxi', 'society_taxi', 'society_taxi', {type = 'public'})




--RegisterServerEvent('htaxi:Ouvert')
--AddEventHandler('htaxi:Ouvert', function()
exports["WaveShield"]:AddEventHandler('htaxi:Ouvert', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		--TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Clubin taxi', '~y~Ouverture', 'Votre taxi Vespucci est ouvert', 'BURGER_SHOT', 2)
		TriggerClientEvent("rtx_notify:Notify", xPlayers[i], "LS Transit", "OUVERT", 5000, "succes")
	
	end
end)

--RegisterServerEvent('htaxi:Fermer')
--AddEventHandler('htaxi:Fermer', function()
exports["WaveShield"]:AddEventHandler('htaxi:Fermer', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		--TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Clubin taxi', '~y~Fermeture', 'Votre taxi Vespucci est fermé', 'BURGER_SHOT', 2)
		TriggerClientEvent("rtx_notify:Notify", xPlayers[i], "LS Transit", "Fermer", 5000, "succes")
	
	end
end)

--RegisterNetEvent('EMYTaxi:success')
--AddEventHandler('EMYTaxi:success', function()
exports["WaveShield"]:AddEventHandler('EMYTaxi:success', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local timeNow = os.clock()
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_taxi', function(account)
		if account then
			local playerMoney = math.random(200,210)
			local societyMoney = math.random(70,75)
				xPlayer.addAccountMoney('bank', playerMoney)
				--xPlayer.addMoney(playerMoney)
				account.addMoney(societyMoney)					
				TriggerClientEvent('esx:showNotification', source, '- Votre société a gagné ~g~'..societyMoney..' $~s~ ~n~- Vous avez recu ~g~'..playerMoney..' $~s~ comme pourboire.')
			end
		end)
end)