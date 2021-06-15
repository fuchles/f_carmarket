g_players = {}

	local function checkPlayers()
		for k, player in pairs(getElementsByType("player")) do
			if not g_players[getPlayerSerial(player)] then
				dbExec( 
					g_connect,
					  
					[[INSERT INTO test_db.accounts (serial, car, number) 
						  VALUES (?, ?, ?);]], 
					  
					getPlayerSerial(player), 0, "none" 
				)
				print("Аккаунт " .. getPlayerSerial(player) .. " успешно создан")
			end
		end
	end

    addEventHandler("onResourceStart", resourceRoot,
        function()
            g_connect = dbConnect( 
                "mysql",
                "host=127.0.0.1; port=; dbname=test_db",
                "test",
                "A123789abc"
            );
			
            if g_connect then
                print "База данных успешно подключена"
            else
                print "Ошибка подключения к базе данных"
            end
			
			dbExec( 
				g_connect,
			  
				[[CREATE TABLE IF NOT EXISTS ?? ( 
					?? INT AUTO_INCREMENT PRIMARY KEY, 
					?? VARCHAR(32), 
					?? INT, 
					?? VARCHAR(32) );]], 
			  
				"test_db.accounts",
				"id",
				"serial",
				"car",
				"number"
			) 
			
			dbQuery(
				function(qHandle)
					local resultTable, num, err = dbPoll(qHandle, 0)
					
					if resultTable then
						for k, value in ipairs(resultTable) do
							g_players[value.serial] = {car = value.car, number = value.number, carState = false}
						end
						checkPlayers()
					end
				end,
					
				g_connect,
					
				"SELECT * FROM test_db.accounts;" 
			)
        end
    )
	
	
	
	function g_updatePlayerCarValue(player, id)
		local serial = getPlayerSerial(player)
		dbExec(g_connect, "UPDATE test_db.accounts SET car = " .. id .. " WHERE serial = '" .. serial .. "'")
	end
	
	function g_getPlayerData(player)
		local serial = getPlayerSerial(player)
		local query = dbQuery(g_connect, "SELECT id, car, number FROM test_db.accounts WHERE serial = '" .. serial .. "'")
		local result = dbPoll(query, -1)
		return result[1]
	end
	
	function g_getPlayerCar(player)
		local serial = getPlayerSerial(player)
		local query = dbQuery(g_connect, "SELECT car FROM test_db.accounts WHERE serial = '" .. serial .. "'")
		local result = dbPoll(query, -1)
		if result[1].car > 0 then return result[1].car else return false end
	end
	
	function g_getPlayerPlate(player)
		local serial = getPlayerSerial(player)
		local query = dbQuery(g_connect, "SELECT number FROM test_db.accounts WHERE serial = '" .. serial .. "'")
		local result = dbPoll(query, -1)
		if result[1].number ~= "none" then return result[1].number else return false end
	end
	
	function g_checkPlate(plate)
		local query = dbQuery(g_connect, "SELECT number FROM test_db.accounts WHERE number = '" .. plate .. "'")
		local result = dbPoll(query, -1)
		if not result[1] then return false else return result[1] end
	end
	
	function g_updatePlate(player, plate)
		local serial = getPlayerSerial(player)
		dbExec(g_connect, "UPDATE test_db.accounts SET number = '" .. plate .. "' WHERE serial = '" .. serial .. "'")
		return true
	end