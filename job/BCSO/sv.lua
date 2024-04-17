ESX = exports["es_extended"]:getSharedObject()

TriggerEvent('esx_phone:registerNumber', 'sheriff', 'alerte sheriff', true, true)

TriggerEvent('esx_society:registerSociety', 'sheriff', 'sheriff', 'society_sheriff', 'society_sheriff', 'society_sheriff', {type = 'public'})

RegisterNetEvent('esx_policedog:hasClosestDrugs')
AddEventHandler('esx_policedog:hasClosestDrugs', function(playerId)
    local target = ESX.GetPlayerFromId(playerId)
    local src = source
    local inventory = target.inventory
	local drugs = {'pochoncoca', 'pochoncoco', 'sheroine', 'pochonmeth', 'pochonweed', 'champignon2'}
    for i = 1, #inventory do
        for k, v in pairs(drugs) do
            if inventory[i].name == v and inventory[i].count > 0 then
                TriggerClientEvent('esx_policedog:hasDrugs', src, true)
                return
            end
        end
    end
    TriggerClientEvent('esx_policedog:hasDrugs', src, false)
end)

ESX.RegisterServerCallback('finalpolice:getFineList', function(source, cb, category)
	MySQL.Async.fetchAll('SELECT * FROM fine_types WHERE category = @category', {
		['@category'] = category
	}, function(fines)
		cb(fines)
	end)
end)

ESX.RegisterServerCallback('rPolice:getVehicleInfos', function(source, cb, plate)

	MySQL.Async.fetchAll('SELECT owner, vehicle FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)

		local retrivedInfo = {
			plate = plate
		}

		if result[1] then
			MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)

				retrivedInfo.owner = result2[1].firstname .. ' ' .. result2[1].lastname

				retrivedInfo.vehicle = json.decode(result[1].vehicle)

				cb(retrivedInfo)

			end)
		else
			cb(retrivedInfo)
		end
	end)
end)

ESX.RegisterServerCallback('esx_policejob:getVehicleInfos', function(source, cb, plate)
    local retrivedInfo = {
        plate = plate
    }
    if Config.EnableESXIdentity then
        MySQL.Async.fetchSingle('SELECT users.firstname, users.lastname FROM owned_vehicles JOIN users ON owned_vehicles.owner = users.identifier WHERE plate = ?', {plate},
        function(result)
            if result then
                retrivedInfo.owner = ('%s %s'):format(result.firstname, result.lastname)
            end
            cb(retrivedInfo)
        end)
    else
        MySQL.Async.fetchScalar('SELECT owner FROM owned_vehicles WHERE plate = ?', {plate},
        function(owner)
            if owner then
                local xPlayer = ESX.GetPlayerFromIdentifier(owner)
                if xPlayer then
                    retrivedInfo.owner = xPlayer.getName()
                end
            end
            cb(retrivedInfo)
        end)
    end
end)


ESX.RegisterServerCallback('finalpolice:getVehicleFromPlate', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1] ~= nil then

			MySQL.Async.fetchAll('SELECT name, firstname, lastname FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)

				if Config.EnableESXIdentity then
					cb(result2[1].firstname .. ' ' .. result2[1].lastname, true)
				else
					cb(result2[1].name, true)
				end

			end)
		else
			cb(('unknown'), false)
		end
	end)
end)

RegisterServerEvent('finalpolice:spawned')
AddEventHandler('finalpolice:spawned', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'sheriff' and xPlayer ~= nil and xPlayer.job2 ~= nil and xPlayer.job2.name == 'sheriff' then
		Citizen.Wait(2500)
		TriggerClientEvent('esx_policejob:updateBlip', -1)
	end
end)

RegisterServerEvent('esx_policejob:forceBlip')
AddEventHandler('esx_policejob:forceBlip', function()
	TriggerClientEvent('esx_policejob:updateBlip', -1)
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(5000)
		TriggerClientEvent('esx_policejob:updateBlip', -1)
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_phone:removeNumber', 'sheriff')
	end
end)

RegisterServerEvent('finalpolice:message')
AddEventHandler('finalpolice:message', function(target, msg)
	TriggerClientEvent('esx:showNotification', target, msg)
end)

-- ALERTE sheriff

RegisterServerEvent('TireEntenduServeur')
AddEventHandler('TireEntenduServeur', function(gx, gy, gz)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == 'sheriff' or thePlayer.job2.name == 'sheriff' then
			TriggerClientEvent('TireEntendu', xPlayers[i], gx, gy, gz)
		end
	end
end)

RegisterServerEvent('PriseAppelServeur')
AddEventHandler('PriseAppelServeur', function(gx, gy, gz)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local name = xPlayer.getName(source)
	local xPlayers = ESX.GetPlayers()

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == 'sheriff' or thePlayer.job2.name == 'sheriff' then
			TriggerClientEvent('PriseAppel', xPlayers[i], name)
		end
	end
end)

RegisterServerEvent('police:PriseEtFinservice')
AddEventHandler('police:PriseEtFinservice', function(PriseOuFin)
	local _source = source
	local _raison = PriseOuFin
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local name = xPlayer.getName(_source)

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == 'sheriff' or thePlayer.job2.name == 'sheriff' then
			TriggerClientEvent('police:InfoService', xPlayers[i], _raison, name)
		end
	end
end)

RegisterServerEvent('finalpolice:requestarrest')
AddEventHandler('finalpolice:requestarrest', function(targetid, playerheading, playerCoords,  playerlocation)
	_source = source
	TriggerClientEvent('finalpolice:getarrested', targetid, playerheading, playerCoords, playerlocation)
	TriggerClientEvent('finalpolice:doarrested', _source)
end)

RegisterServerEvent('finalpolice:requestrelease')
AddEventHandler('finalpolice:requestrelease', function(targetid, playerheading, playerCoords,  playerlocation)
	_source = source
	TriggerClientEvent('finalpolice:getuncuffed', targetid, playerheading, playerCoords, playerlocation)
	TriggerClientEvent('finalpolice:douncuffing', _source)
end)

RegisterServerEvent('renfortpolice')
AddEventHandler('renfort', function(coords, raison)
	local _source = source
	local _raison = raison
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == 'sheriff' then
			TriggerClientEvent('renfortpolice:setBlip', xPlayers[i], coords, _raison)
		end
	end
end)

RegisterServerEvent('Huid_police:DemandeRenfortPolice')
AddEventHandler('Huid_police:DemandeRenfortPolice', function(coords, titre, raison)
    local xPlayers = ESX.GetExtendedPlayers('job', 'sheriff')
    for _, xPlayer in pairs(xPlayers) do
        xPlayer.triggerEvent('Huid_police:Alertpolice', coords, titre, raison)
        --TriggerClientEvent("Huid_police:Alertpolice", xPlayer.source, coords, titre, raison)
    end
end)

------------------------------------------------ Intéraction


RegisterNetEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'sheriff' or xPlayer.job2.name == 'sheriff' then
		TriggerClientEvent('esx_policejob:handcuff', target)
	else
		print(('[^3WARNING^7] Player ^5%s^7 Attempted To Exploit Handcuffs!'):format(xPlayer.source))
	end
end)

RegisterNetEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_policejob:drag', target, source)
end)

RegisterNetEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_policejob:putInVehicle', target)
end)

RegisterNetEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_policejob:OutVehicle', target)
end)

ESX.RegisterServerCallback('finalpolice:getOtherPlayerData', function(source, cb, target, notify)
    local xPlayer = ESX.GetPlayerFromId(target)

    --TriggerClientEvent("esx:showNotification", target, "~r~Quelqu'un vous fouille ...")

    if xPlayer then
        local data = {
            name = xPlayer.getName(),
            job = xPlayer.job.label,
			job2 = xPlayer.job2.label,
            grade = xPlayer.job.grade_label,
            inventory = xPlayer.getInventory(),
            accounts = xPlayer.getAccounts(),
            weapons = xPlayer.getLoadout(),
			--argentpropre = xPlayer.getMoney()
        }

        TriggerEvent('esx_license:getLicenses', target, function(licenses)
                 print(json.encode(licenses))
                data.licenses = licenses
        cb(data)
        end)
    end
end)

-------------------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent("corp:adrGet")
AddEventHandler("corp:adrGet", function()
    local _src = source
    local table = {}
    MySQL.Async.fetchAll('SELECT * FROM adr', {}, function(result)
        for k,v in pairs(result) do
            table[v.id] = v
        end
        TriggerClientEvent("corp:adrGet", _src, table)
    end)
end)

RegisterNetEvent("corp:adrDel")
AddEventHandler("corp:adrDel", function(id)
    local _src = source

    MySQL.Async.execute('DELETE FROM adr WHERE id = @id', { ['id'] = id },
    function(affectedRows)
        TriggerClientEvent("corp:adrDel", _src)
    end)
end)

RegisterNetEvent("corp:adrAdd")
AddEventHandler("corp:adrAdd", function(builder)
    local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	local name = xPlayer.getName(_src)
    local date = os.date("*t", os.time()).day.."/"..os.date("*t", os.time()).month.."/"..os.date("*t", os.time()).year.." à "..os.date("*t", os.time()).hour.."h"..os.date("*t", os.time()).min
    MySQL.Async.execute('INSERT INTO adr (author,date,firstname,lastname,reason,dangerosity) VALUES (@a,@b,@c,@d,@e,@f)',

    { 
        ['a'] = name,
        ['b'] = date,
        ['c'] = builder.firstname,
        ['d'] = builder.lastname,
        ['e'] = builder.reason,
        ['f'] = builder.dangerosity
    },


    function(affectedRows)
        TriggerClientEvent("corp:adrAdd", _src)
    end
    )
end)

----------------------------------------------------------------------------------------


RegisterNetEvent("corp:cjGet")
AddEventHandler("corp:cjGet", function()
    local _src = source
    local table = {}
    MySQL.Async.fetchAll('SELECT * FROM cj', {}, function(result)
        for k,v in pairs(result) do
            table[v.id] = v
        end
        TriggerClientEvent("corp:cjGet", _src, table)
    end)
end)

RegisterNetEvent("corp:cjDel")
AddEventHandler("corp:cjDel", function(id)
    local _src = source

    MySQL.Async.execute('DELETE FROM cj WHERE id = @id',
    { ['id'] = id },
    function(affectedRows)
        TriggerClientEvent("corp:cjDel", _src)
    end
    )
end)

RegisterNetEvent("corp:cjAdd")
AddEventHandler("corp:cjAdd", function(builder)
    local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	local name = xPlayer.getName(_src)
    local date = os.date("*t", os.time()).day.."/"..os.date("*t", os.time()).month.."/"..os.date("*t", os.time()).year.." à "..os.date("*t", os.time()).hour.."h"..os.date("*t", os.time()).min
    MySQL.Async.execute('INSERT INTO cj (author,date,firstname,lastname,reason) VALUES (@a,@b,@c,@d,@e)',

    { 
        ['a'] = name,
        ['b'] = date,
        ['c'] = builder.firstname,
        ['d'] = builder.lastname,
        ['e'] = builder.reason
    },

    function(affectedRows)
        TriggerClientEvent("corp:cjAdd", _src)
    end
    )
end)

------------------------------------------------

RegisterNetEvent("genius:sendcall")
AddEventHandler("genius:sendcall", function()

	local xPlayers = ESX.GetPlayers()
	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == 'sheriff' or thePlayer.job2.name == 'sheriff' then
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], "Central sheriff", nil, "Un Citoyen demande un agent de police au commissariat", "CHAR_sheriff", 8)
		end
	end
end)

function sendToDiscordWithSpecialURL (name,message,color,url)
    local DiscordWebHook = url
	local embeds = {
		{
			["title"]=message,
			["type"]="rich",
			["color"] =color,
			["footer"]=  {
			["text"]= "",
			},
		}
	}
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end




RegisterNetEvent("priseservice")
AddEventHandler("priseservice", function()
	PerformHttpRequest(Config.Logs_PriseFin_Service, function(err, text, headers) end, 'POST', json.encode({username = "", content = GetPlayerName(source) .. " à pris sont service"}), { ['Content-Type'] = 'application/json' })
end)

RegisterNetEvent("finservice")
AddEventHandler("finservice", function()
	PerformHttpRequest(Config.Logs_PriseFin_Service, function(err, text, headers) end, 'POST', json.encode({username = "", content = GetPlayerName(source) .. " à quitter sont service"}), { ['Content-Type'] = 'application/json' })
end)

RegisterNetEvent("LogsAmende")
AddEventHandler("LogsAmende", function()
	PerformHttpRequest(Config.Logs_Amende, function(err, text, headers) end, 'POST', json.encode({username = "", content = GetPlayerName(source) .. " a mis une amende a "..GetPlayerServerId(closestPlayer).." de "..amount.."$."}), { ['Content-Type'] = 'application/json' })
end)

-----------------------------------------

ESX.RegisterServerCallback('esx:GetTargetBills', function(source, cb, target)
	local xTarget = ESX.GetPlayerFromId(target)
    MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
        ['@identifier'] = xTarget.identifier
    }, function(bills)
        cb(bills)
    end)
end)

------------------------------------

RegisterServerEvent('add:addlic')
AddEventHandler('add:addlic', function(playerId, permis)
	local xPlayer  = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do

		local xPlayer2 = ESX.GetPlayerFromId(xPlayers[i])

		if xPlayer2.source == playerId then
			TriggerEvent('esx_license:addLicense', xPlayer2.source, permis)
			TriggerClientEvent('esx:showNotification', xPlayers.source, "Vous avez bien reçu le PPA")
		end
	end
end)

RegisterServerEvent('sup:addlic')
AddEventHandler('sup:addlic', function(playerId, permis)
	local xPlayer = ESX.GetPlayerFromId(source)
  	local xTarget = ESX.GetPlayerFromId(target)

	  local xPlayer  = ESX.GetPlayerFromId(source)
	  local xPlayers = ESX.GetPlayers()
  
	  for i=1, #xPlayers, 1 do
  
		  local xPlayer2 = ESX.GetPlayerFromId(xPlayers[i])
  
		  if xPlayer2.source == playerId then
			  TriggerEvent('esx_license:removeLicense', xPlayer2.source, permis)
			  TriggerClientEvent('esx:showNotification', xPlayer2.source, "Votre PPA a été révoquez")
		  end
	  end
end)

-- Open ID card

RegisterServerEvent('policebadge:open')
AddEventHandler('policebadge:open', function(ID, targetID, type)
	local identifier = ESX.GetPlayerFromId(ID).identifier
	local _source 	 = ESX.GetPlayerFromId(targetID).source

	MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, height FROM users WHERE identifier = @identifier', {['@identifier'] = identifier},
	function (user)
		if (user[1] ~= nil) then
			MySQL.Async.fetchAll('SELECT type FROM user_licenses WHERE owner = @identifier', {['@identifier'] = identifier},
			function (licenses)
				local array = {
					user = user,
					licenses = licenses
				}
				TriggerClientEvent('policebadge:open', _source, array, type)
			end)
		end
	end)
end)


RegisterServerEvent('policebadge:ItemsBadge')
AddEventHandler('policebadge:ItemsBadge', function()
	local XPlayer = ESX.GetPlayerFromId(source)

	local qtty = XPlayer.getInventoryItem(Config.BadgeItem).count
	if qtty > 1 then
		XPlayer.removeInventoryItem(Config.BadgeItem, 1)

	elseif qtty < 1 then
		XPlayer.addInventoryItem(Config.BadgeItem, 1)
	end
end)

local getOnlinePlayers, onlinePlayers = false, {}
ESX.RegisterServerCallback('esx_society:getOnlinePlayers', function(source, cb)
	if getOnlinePlayers == false and next(onlinePlayers) == nil then -- Prevent multiple xPlayer loops from running in quick succession
		getOnlinePlayers, onlinePlayers = true, {}
		
		local xPlayers = ESX.GetExtendedPlayers()
		for i=1, #(xPlayers) do 
			local xPlayer = xPlayers[i]
			table.insert(onlinePlayers, {
				source = xPlayer.source,
				identifier = xPlayer.identifier,
				name = xPlayer.name,
				job = xPlayer.job
			})
		end
		cb(onlinePlayers)
		getOnlinePlayers = false
		Wait(1000) -- For the next second any extra requests will receive the cached list
		onlinePlayers = {}
		return
	end
	while getOnlinePlayers do Wait(0) end -- Wait for the xPlayer loop to finish
	cb(onlinePlayers)
end)

--RegisterServerEvent('hsheriff:Ouvert')
--AddEventHandler('hsheriff:Ouvert', function(source)
exports["WaveShield"]:AddEventHandler('hsheriff:Ouvert', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent("rtx_notify:Notify", xPlayers[i], "L.S.P.D", "OUVERT", 5000, "success")
	
	end
end)

--RegisterServerEvent('hsheriff:Fermer')
--AddEventHandler('hsheriff:Fermer', function(source)
exports["WaveShield"]:AddEventHandler('hsheriff:Fermer', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent("rtx_notify:Notify", xPlayers[i], "L.S.P.D", "Fermer", 5000, "error")
	
	end
end)