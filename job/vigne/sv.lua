ESX = exports["es_extended"]:getSharedObject()

TriggerEvent('esx_society:registerSociety', 'vigne', 'vigne', 'society_vigne', 'society_vigne', 'society_vigne', {type = 'public'})

--RegisterNetEvent('hvigne:bar')
--AddEventHandler('hvigne:bar', function(item, price)
exports["WaveShield"]:AddEventHandler('hvigne:bar', function(source, item, price)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_vigne', function(account)
        if account.money >= price then
            if xPlayer.canCarryItem(item, 1) then
                account.removeMoney(price)
                xPlayer.addInventoryItem(item, 1)
                TriggerClientEvent('esx:showNotification', _source, "~g~Achat~w~ effectué !")
            else
                TriggerClientEvent('esx:showNotification', _source, "Vous ne pouvez pas porter d'avantage")
            end
        else
            TriggerClientEvent('esx:showNotification', _source, "Votre société n'a plus d'argent")
        end
    end)
end)


--RegisterServerEvent('hvigne:Ouvert')
--AddEventHandler('hvigne:Ouvert', function()
exports["WaveShield"]:AddEventHandler('hvigne:Ouvert', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		--TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'L\'vigne', '~y~Ouverture', 'Votre club l\'vigne est ouvert', 'vigne', 2)
		TriggerClientEvent("rtx_notify:Notify", xPlayers[i], "Vignoble Remanbussa", "OUVERT", 5000, "succes")
	
	end
end)

--RegisterServerEvent('hvigne:Fermer')
--AddEventHandler('hvigne:Fermer', function()
exports["WaveShield"]:AddEventHandler('hvigne:Fermer', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		--TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'L\'vigne', '~y~Fermeture', 'Votre club l\'vigne est fermé', 'vigne', 2)
		TriggerClientEvent("rtx_notify:Notify", xPlayers[i], "Vignoble Remanbussa", "FERMER", 5000, "succes")
	
	end
end)

--RegisterNetEvent('hvigne:giveitem')
--AddEventHandler('hvigne:giveitem', function()
exports["WaveShield"]:AddEventHandler('hvigne:giveitem', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    	if xPlayer.canCarryItem('pomme', 1) then
        	xPlayer.addInventoryItem('pomme', 1)        
		else
	    	--TriggerClientEvent('esx:showNotification', source, "Vous ne pouvez pas porter d'avantage")
		end
end)

--RegisterServerEvent('hvigne:exchange')
--AddEventHandler('hvigne:exchange', function()
exports["WaveShield"]:AddEventHandler('hvigne:exchange', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
	local count = xPlayer.getInventoryItem('pomme').count
	if count >= 2 then
        xPlayer.removeInventoryItem('pomme', 2)
		xPlayer.addInventoryItem('juspomme', 1)
	else 
		--TriggerClientEvent('esx:showNotification', source, "Tu n'as plus assez de matière première")
	end
end)

--RegisterServerEvent('hvigne:sell')
--AddEventHandler('hvigne:sell', function()
exports["WaveShield"]:AddEventHandler('hvigne:sell', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
	local count = xPlayer.getInventoryItem('juspomme').count
	local pay = math.random(10, 10)*count
	local pay2 = math.random(5, 8)*count
	if count >= 1 then
        xPlayer.removeInventoryItem('juspomme', count)
		
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_vigne', function(account)
			account.addMoney(pay2)
		end)
		xPlayer.addAccountMoney('bank', pay)
	
	else 
		--TriggerClientEvent('esx:showNotification', source, "Tu n'as plus assez de matière première")
	end
		
end)
