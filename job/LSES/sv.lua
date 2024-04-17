ESX = exports["es_extended"]:getSharedObject()
local appelTable = {}
local idAppel = 0
local deadPlayers = {}

TriggerEvent('esx_society:registerSociety', 'ambulance', 'ambulance', 'society_ambulance', 'society_ambulance', 'society_ambulance', {type = 'public'})

ESX.RegisterCommand('revive', 'mod', function(xPlayer, args, showError)
	args.playerId.triggerEvent('esx_ambulancejob:revive', true)
end, true, {help = 'revive un joueur', validate = true, arguments = {
	{name = 'playerId', help = 'The player id', type = 'player'}
}})

RegisterServerEvent('emy:pay')
AddEventHandler('emy:pay', function()
--exports["WaveShield"]:AddEventHandler('emy:pay', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
    local canAfford = false
	if xPlayer.getMoney() >= 1000 then
        canAfford = true
        xPlayer.removeMoney(1000)
    elseif xPlayer.getAccount('bank').money >= 1000 then
        canAfford = true
        xPlayer.removeAccountMoney('bank', 1000)
    end
end)

RegisterServerEvent("HuidEMS:CloseReport")
AddEventHandler("HuidEMS:CloseReport", function(idAppel)
    local xPlayers = ESX.GetExtendedPlayers('job', 'ambulance')
	for _, xPlayer in pairs(xPlayers) do
        xPlayer.triggerEvent('esx:showAdvancedNotification', "Central LSHD", nil, "L'appel ".. idAppel.." à été fermer", "CHAR_CHAT_CALL", 8)
	end
	for k, v in pairs(appelTable) do
		if v.idAppel == idAppel then
    		table.remove(appelTable, k)
			return
		end
	end
end)

ESX.RegisterServerCallback('esx_ambulancejob:checkBalance', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local bankBalance = xPlayer.getAccount('bank').money

	cb(bankBalance >= 500)
end)
RegisterNetEvent('HuidEMS:SendEMS')
AddEventHandler('HuidEMS:SendEMS', function(target)
    local xPlayer = ESX.GetPlayerFromId(target)
    if xPlayer ~= nil then
		TriggerClientEvent('esx:showAdvancedNotification', xPlayer, "Central LSHD", nil, "~w~Information: ~g~Depart ~w~d\'une unité.", "CHAR_CHAT_CALL", 8)
	end
end)

RegisterNetEvent('Huidems:envoyersingal')
AddEventHandler('Huidems:envoyersingal', function(coords)
    local xPlayer = ESX.GetPlayerFromId(source)
    local NomDuMec = xPlayer.getName()
	idAppel = idAppel + 1
    table.insert(appelTable, {
		idAppel = idAppel,
        id = source,
        nom = NomDuMec,
        gps = coords
    })
	local xPlayersEMS = ESX.GetExtendedPlayers('job', 'ambulance')
	for _, xPlayerEMS in pairs(xPlayersEMS) do
		xPlayerEMS.triggerEvent("Huidems:envoielanotif", idAppel)
	end
end)

RegisterServerEvent("Huidems:emsAppel")
AddEventHandler("Huidems:emsAppel", function()
	local xPlayers = ESX.GetExtendedPlayers('job', 'ambulance')
	for _, xPlayer in pairs(xPlayers) do
		xPlayer.triggerEvent("Huidems:envoielanotif")
	end
end)

RegisterNetEvent('esx_ambulancejob:payFine')
AddEventHandler('esx_ambulancejob:payFine', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local fineAmount = 1000

	xPlayer.showNotification('Vous avez payé $1000 pour être réanimer.')
	xPlayer.removeAccountMoney('bank', fineAmount)

	--TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ambulance', function(account)
	--	account.removeMoneyMoney(1000)
	--end)
	
end)


AddEventHandler('txAdmin:events:healedPlayer', function(eventData)
	if GetInvokingResource() ~= "monitor" or type(eventData) ~= "table" or type(eventData.id) ~= "number" then
		return
	end
	if deadPlayers[eventData.id] then
		TriggerClientEvent('esx_ambulancejob:revive', eventData.id)
		local Ambulance = ESX.GetExtendedPlayers("job", "ambulance")

		for _, xPlayer in pairs(Ambulance) do
			xPlayer.triggerEvent('esx_ambulancejob:PlayerNotDead', eventData.id)
		end
		deadPlayers[eventData.id] = nil
	end
end)

RegisterNetEvent('esx:onPlayerSpawn')
AddEventHandler('esx:onPlayerSpawn', function()
	local source = source
	if deadPlayers[source] then
		deadPlayers[source] = nil
		local Ambulance = ESX.GetExtendedPlayers("job", "ambulance")

		for _, xPlayer in pairs(Ambulance) do
				xPlayer.triggerEvent('esx_ambulancejob:PlayerNotDead', source)
		end
	end
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
	if deadPlayers[playerId] then
		deadPlayers[playerId] = nil
		
		local Ambulance = ESX.GetExtendedPlayers("job", "ambulance")
		for _, xPlayer in pairs(Ambulance) do
			xPlayer.triggerEvent('esx_ambulancejob:PlayerNotDead', playerId)
		end
	end
end)

RegisterNetEvent('esx_ambulancejob:onPlayerDistress')
AddEventHandler('esx_ambulancejob:onPlayerDistress', function()
	if deadPlayers[source] then
		deadPlayers[source] = 'distress'
		TriggerClientEvent('esx_ambulancejob:setDeadPlayers', -1, deadPlayers)
	end
end)

RegisterNetEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	deadPlayers[source] = 'dead'
	TriggerClientEvent('esx_ambulancejob:setDeadPlayers', -1, deadPlayers)
end)

ESX.RegisterServerCallback('HuidEMS:infoReport', function(source, cb)
    cb(appelTable)
end)

ESX.RegisterServerCallback('HuidEMS:PayePharmacy', function(source, cb, paye)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xMoney = xPlayer.getMoney()
    
    if xMoney >= paye then
      xPlayer.removeMoney(paye)
      cb(true)
    else
      cb(false)
    end
end)

RegisterNetEvent("HuidEMS:delitem")
AddEventHandler("HuidEMS:delitem", function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(item, 1)
end)

RegisterNetEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function(playerId)
	playerId = tonumber(playerId)
	if source == '' and GetInvokingResource() == 'monitor' then -- txAdmin support
        local xTarget = ESX.GetPlayerFromId(playerId)
        if xTarget then
            if deadPlayers[playerId] then
                print('vous avez réanimé %s', xTarget.name)
                xTarget.triggerEvent('esx_ambulancejob:revive')
            else
                print('n\'est pas inconscient')
            end
        else
            print('ce joueur n\'est plus en ligne')
        end
	else
		local xPlayer = source and ESX.GetPlayerFromId(source)

		if (xPlayer and xPlayer.job.name == 'ambulance') or (xPlayer and xPlayer.job2.name == 'ambulance') then
			local xTarget = ESX.GetPlayerFromId(playerId)

			if xTarget then
				if deadPlayers[playerId] then
						xPlayer.showNotification("vous avez réannimé "..xTarget.name)
						xTarget.triggerEvent('esx_ambulancejob:revive')
				else
					xPlayer.showNotification('n\'est pas inconscient')
				end
			else
				xPlayer.showNotification('ce joueur n\'est plus en ligne')
			end
		end
	end
end)

ESX.RegisterServerCallback('HuidEMS:checkitem', function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getInventoryItem(item).count > 0 then        
        cb(true)
    else
        TriggerClientEvent("esx:ShowNotification", xPlayer, "Vous n'en n'avez pas sur vous !")
        cb(false)
    end
end)

RegisterServerEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(target, typeSoin)
	TriggerClientEvent('esx_ambulancejob:heal', target, typeSoin)
end)


--[[exports["WaveShield"]:AddEventHandler('hambulance:giveitem', function(item)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(source)
  if xPlayer.canCarryItem(item, 1) then
    xPlayer.addInventoryItem(item, 1)   
	else
	  TriggerClientEvent('esx:showNotification', source, "Vous ne pouvez pas porter d'avantage")
	end
    
end)]]




ESX.RegisterServerCallback('esx_ambulancejob:getDeadPlayers', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == "ambulance" then 
		cb(deadPlayers)
	end
end)

ESX.RegisterServerCallback('esx_ambulancejob:getDeathStatus', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.scalar('SELECT is_dead FROM users WHERE identifier = ?', {xPlayer.identifier}, function(isDead)
		cb(isDead)
	end)
end)

RegisterNetEvent('esx_ambulancejob:setDeathStatus')
AddEventHandler('esx_ambulancejob:setDeathStatus', function(isDead)
	local xPlayer = ESX.GetPlayerFromId(source)
	if type(isDead) == 'boolean' then
		MySQL.update('UPDATE users SET is_dead = ? WHERE identifier = ?', {isDead, xPlayer.identifier})
		if not isDead then 
			local Ambulance = ESX.GetExtendedPlayers("job", "ambulance")
			for _, xPlayer in pairs(Ambulance) do
				xPlayer.triggerEvent('esx_ambulancejob:PlayerNotDead', source)
			end
		end
	end
end)

ESX.RegisterServerCallback('esx_ambulancejob:getCurrentHealth', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.scalar('SELECT currentHealth FROM users WHERE identifier = ?', {xPlayer.identifier}, function(currentHealth)
		if type(currentHealth) == "string" then currentHealth = tonumber(currentHealth) end
		cb(currentHealth)
	end)
end)

RegisterNetEvent('esx_ambulancejob:setCurrentHealth')
AddEventHandler('esx_ambulancejob:setCurrentHealth', function(currentHealth)
	if currentHealth == nil or currentHealth == "NULL" then return end
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.update('UPDATE users SET currentHealth = ? WHERE identifier = ?', {currentHealth, xPlayer.identifier})
end)


RegisterServerEvent('hambulance:sudo')
AddEventHandler('hambulance:sudo', function()
--exports["WaveShield"]:AddEventHandler('hambulance:sudo', function(source)
	local xPlayers	= ESX.GetExtendedPlayers()
	for _, xPlayer in pairs(xPlayers) do
		xPlayer.triggerEvent('esx:showAdvancedNotification', 'L.S.E.S', 'Disponible', 'Des médecins sont disponibles', 'LSMD', 2)
		--TriggerClientEvent("rtx_notify:Notify", xPlayers[i], "L.S.E.S", "Disponible", 5000, "info")
    end
end)


RegisterServerEvent('hambulance:sudf')
AddEventHandler('hambulance:sudf', function()
--exports["WaveShield"]:AddEventHandler('hambulance:sudf', function(source)
	local xPlayers	= ESX.GetExtendedPlayers()
	for _, xPlayer in pairs(xPlayers) do
		xPlayer.triggerEvent('esx:showAdvancedNotification', 'L.S.E.S', 'Indisponible', 'Plus aucun médecin n\'est disponible', 'LSMD', 2)
		--TriggerClientEvent("rtx_notify:Notify", xPlayers[i], "L.S.E.S", "Indisponible", 5000, "info")
    end
end)