


	addCommandHandler("getcar",
		function(sender)
			local serial = getPlayerSerial(sender)
			local car = g_getPlayerCar(sender)
			local plate = g_getPlayerPlate(sender)
			if not car then
				outputChatBox("У вас нет транспорта", sender)
				return false
			end
			if not plate then
				outputChatBox("Сначала выберите номер для автомобиля на авторынке", sender)
				return false
			end
			if g_players[serial].carState then
				outputChatBox("Вы уже заспавнили свой транспорт")
				return false
			end
			local pos = vec3.getPos(sender)
			local rot = vec3.getRot(sender); rot.z = - rot.z
			local dir = vec3.angleToDir(rot)
			dir = vec3.scaleVec(dir, 5)
			pos = vec3.addVec(pos, dir)
			g_players[serial].carTable = classVehicle:create(car, pos.x, pos.y, pos.z + 1, 0, 0, -rot.z + 90, sender, plate)
		end
	);
	
	addCommandHandler("updatecar",
		function(sender, cmd, id)
			g_updatePlayerCarValue(sender, tonumber(id))
		end
	);
	
	addCommandHandler("getinfo",
		function(sender)
			for k, value in pairs(g_getPlayerData(sender)) do
				outputChatBox(k .. " = " .. value)
			end
		end
	);
	
	addCommandHandler("checkplate",
		function(sender, cmd, plate)
			local result = g_checkPlate(plate)
			if result then
				outputChatBox("Данный номер уже занят")
			else
				outputChatBox("Данный номер свободен")
			end
		end
	);
	
	addCommandHandler("addplate",
		function(sender, cmd, plate)
			if not g_getPlayerCar(sender) then
				return outputChatBox("У вас нет транспорта", sender)
			end
			if not g_canPlayerChangePlate(sender) then
				return outputChatBox("Вы должны находиться на авторынке для смены номера", sender)
			end
			if not plate then
				return outputChatBox("Используйте /addplate [x000xx000]")
			end
			local result = string.match(plate, "(%a%d%d%d%a%a%d%d%d)")
			if string.len(plate) > 9 or not result then
				return outputChatBox('Номер должен быть задан в формате "X000XX000", где X - любая буква, а 0 - любая цифра')
			end
			plate = string.upper(plate)
			if not g_checkPlate(plate) then 
				g_updatePlate(sender, plate)
				outputChatBox("Вы успешно обновили номер, текущий номер: " .. plate)
			else
				outputChatBox("Данный номер уже занят")
			end
			--outputChatBox(tostring(result))
		end
	);