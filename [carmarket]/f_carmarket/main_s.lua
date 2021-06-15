addEvent("onPlayerBuyCar", true)
addEvent("onPlayerSellCar", true)

local market = {pickup, text, x = -2418, y = -611, z = 132.5}
local selling = {pickup, text, x= -2420.64819, y = -612.79810, z = 132.56250}
local number = {pickup, text, x = -2423.03906, y = -614.44666, z = 132.56250, players = {}}

g_park = {
	{id = 602, price = 0},
	{id = 401, price = 0},
	{id = 587, price = 0},
	{id = 545, price = 0},
	{id = 517, price = 0},
}
	
	addEventHandler("onResourceStart", resourceRoot,
		function()
			market.pickup = createPickup(market.x, market.y, market.z, 3, 1318, 0)
			market.text = exports['fuchles_3DText']:create3DText("Авторынок", market.x, market.y, market.z, 10, false, 0, 0, 1)
			addEventHandler("onPickupHit", market.pickup, 
				function(player)
					cancelEvent()
					if getPedOccupiedVehicle(player) then return false end
					triggerClientEvent(player, "onClientMarketMenuOpen", resourceRoot, g_park)
				end
			);
			
			selling.pickup = createPickup(selling.x, selling.y, selling.z, 3, 1318, 0)
			selling.text = exports['fuchles_3DText']:create3DText("Продажа авто", selling.x, selling.y, selling.z, 10, false, 0, 0, 1)
			addEventHandler("onPickupHit", selling.pickup, 
				function(player)
					cancelEvent()
					if getPedOccupiedVehicle(player) then return false end
					triggerClientEvent(player, "onClientSellingMenuOpen", resourceRoot)
				end
			);
			
			number.pickup = createPickup(number.x, number.y, number.z, 3, 1318, 0)
			number.text = exports['fuchles_3DText']:create3DText("Смена номера", number.x, number.y, number.z, 10, false, 0, 0, 1)
			addEventHandler("onPickupHit", number.pickup, 
				function(player)
					cancelEvent()
					if getPedOccupiedVehicle(player) then return false end
					if not number.players[player] then number.players[player] = true end
					outputChatBox("Для смены номера введите команду #FFFFFF/addplate [x000x000]#8b8b8b, где x - любая буква, а 0 - любая цифра", player, 139, 139, 139, true)
				end
			);
			addEventHandler("onPickupLeave", number.pickup, 
				function(player)
					cancelEvent()
					if getPedOccupiedVehicle(player) then return false end
					if number.players[player] then number.players[player] = nil end
				end
			);
		end
	);
	
	addEventHandler("onResourceStop", resourceRoot,
		function()
			destroyElement(market.text)
			destroyElement(selling.text)
			destroyElement(number.text)
		end
	);
	
	addEventHandler("onResourceStart", getRootElement(),
		function(resource)
			--outputChatBox(getResourceName(resource))
			if getResourceName(resource) ~= "fuchles_3Dtext" then return false end
			market.text = exports['fuchles_3DText']:create3DText("Авторынок", market.x, market.y, market.z, 10, false, 0, 0, 1)
			selling.text = exports['fuchles_3DText']:create3DText("Продажа авто", selling.x, selling.y, selling.z, 10, false, 0, 0, 1)
			number.text = exports['fuchles_3DText']:create3DText("Смена номера", number.x, number.y, number.z, 10, false, 0, 0, 1)
		end
	);
	
	addEventHandler("onPlayerBuyCar", resourceRoot,
		function(player, key)
			if g_park[key] then
				if g_getPlayerCar(player) then
					outputChatBox("У вас уже есть автомобиль, вы не можете иметь более одного автомобиля", player)
				else
					outputChatBox("Вы успешно приобрели автомобиль " .. getVehicleNameFromModel(g_park[key].id) .. ", используйте /getcar, чтобы заспавнить автомобиль")
					g_updatePlayerCarValue(player, g_park[key].id)
				end
			end
		end
	);
	
	addEventHandler("onPlayerSellCar", resourceRoot,
		function(player)
			if g_getPlayerCar(player) then
				g_updatePlayerCarValue(player, 0)
				g_updatePlate(player, "none")
				if g_players[getPlayerSerial(player)].carState then
					g_players[getPlayerSerial(player)].carTable:destroy()
				end
				outputChatBox("Вы успешно продали свой автомобиль", player)
				triggerClientEvent(player, "onClientSellingMenuClose", resourceRoot)
			else
				outputChatBox("Вы не владеете автомобилем для его продажи", player)
			end
		end
	);
	
	function g_canPlayerChangePlate(player)
		if number.players[player] then return true else return false end
	end