-- local element = false

	-- bindKey("e", "down",
		-- function()
			-- local screen = {x, y}
			-- screen.x, screen.y = guiGetScreenSize()
			-- local size = {x, y}
			-- size.x = screen.x * 0.2
			-- size.y = size.x * 1.25
			-- local info = "На работе водителя автобуса вам потребуется объезжать определенный маршрут и развозить по нему пассажиров. Стоимость аренды автобуса составляет 500$."
			-- element = incWindowCreate(screen.x/2 - size.x/2, screen.y/2 - size.y/2, size.x, size.y, "#FFD700Работа", info)
			-- local acceptBtn = incButtonCreate(0.1, 0.725, 0.8, 0.085, "Принять", element)
			-- local exitBtn = incButtonCreate(0.1, 0.825, 0.8, 0.085, "Выход", element)
			-- showCursor(true)
			-- addEventHandler("onClientGUIClick", exitBtn, onExit)
		-- end
	-- );
	
	-- bindKey("r", "down",
		-- function()
			-- destroyElement(element)
			-- showCursor(false)
		-- end
	-- );
	
	-- function onExit()
		-- destroyElement(element)
		-- showCursor(false)
	-- end