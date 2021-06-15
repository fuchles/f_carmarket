local screen = {x,y}
screen.x, screen.y = guiGetScreenSize()

addEvent("onClientMarketMenuOpen", true)
addEvent("onClientMarketMenuClose", true)
addEvent("onClientSellingMenuOpen", true)
addEvent("onClientSellingMenuClose", true)


	g_carmenu = {}
		g_carmenu.state = false
		g_carmenu.size = {x,y}
		g_carmenu.size.x = screen.x * 0.2
		g_carmenu.size.y = g_carmenu.size.x * 1.2
		g_carmenu.pos = {x,y}
		g_carmenu.pos.x = screen.x/2 - g_carmenu.size.x/2
		g_carmenu.pos.y = screen.y/2 - g_carmenu.size.y/2
		g_carmenu.gui = {}
		g_carmenu.sellSize = {x,y}
		g_carmenu.sellSize.x = g_carmenu.size.x
		g_carmenu.sellSize.y = g_carmenu.sellSize.x * 0.75
		g_carmenu.sellPos = {x,y}
		g_carmenu.sellPos.x = screen.x/2 - g_carmenu.sellSize.x/2
		g_carmenu.sellPos.y = screen.y/2 - g_carmenu.sellSize.y/2
		
			function g_carmenu:open(park)
				if not self.state and park then
					self.state = true
					showCursor(true)
					local pos = self.pos
					local size = self.size
					
					self.gui["window"] = exports['fuchles_ui']:incWindowCreate(pos.x, pos.y, size.x, size.y, "Авторынок", "Выберите машину для покупки")
					self.gui["buttonClose"] = exports['fuchles_ui']:incButtonCreate(0.05, 0.85, 0.9, 0.1, "Закрыть", self.gui["window"])
					
					addEventHandler("onClientGUIClick", self.gui["buttonClose"],
						function()
							self:close()
						end
					);
					
					for k, value in ipairs(park) do
						local name = getVehicleNameFromModel(value.id)
						self.gui["button" .. name .. k] = exports['fuchles_ui']:incButtonCreate(0.05, 0.2 + 0.11 * (k - 1), 0.9, 0.1, name, self.gui["window"])
						
						addEventHandler("onClientGUIClick", self.gui["button" .. name .. k],
							function()
								--outputChatBox(value.id .. " " .. name .. " " .. value.price)
								triggerServerEvent("onPlayerBuyCar", resourceRoot, localPlayer, k)
							end
						);
					end
					
				end
			end
			
			function g_carmenu:openSell()
				if not self.state then
					self.state = true
					showCursor(true)
					local pos = self.sellPos
					local size = self.sellSize
					
					self.gui["window"] = exports['fuchles_ui']:incWindowCreate(pos.x, pos.y, size.x, size.y, "Авторынок", "Вы действительно хотите продать свой автомобиль?")
					self.gui["buttonAccept"] = exports['fuchles_ui']:incButtonCreate(0.05, 0.625, 0.9, 0.15, "Продать", self.gui["window"])
					self.gui["buttonClose"] = exports['fuchles_ui']:incButtonCreate(0.05, 0.8, 0.9, 0.15, "Закрыть", self.gui["window"])
					
					addEventHandler("onClientGUIClick", self.gui["buttonClose"],
						function()
							self:close()
						end
					);
					
					addEventHandler("onClientGUIClick", self.gui["buttonAccept"],
						function()
							triggerServerEvent("onPlayerSellCar", resourceRoot, localPlayer)
						end
					);
				end
			end
			
			function g_carmenu:close()
				if self.state then
					destroyElement(self.gui["window"])
					showCursor(false)
					self.state = false
				end
			end
			
	
	
	addEventHandler("onClientMarketMenuOpen", resourceRoot,
		function(park)
			g_carmenu:open(park)
		end
	);
	
	addEventHandler("onClientSellingMenuOpen", resourceRoot,
		function()
			g_carmenu:openSell()
		end
	);
	
	addEventHandler("onClientResourceStop", resourceRoot,
		function()
			g_carmenu:close()
		end
	);
	
	addEventHandler("onClientMarketMenuClose", resourceRoot,
		function()
			g_carmenu:close()
		end
	);
	
	addEventHandler("onClientSellingMenuClose", resourceRoot,
		function()
			g_carmenu:close()
		end
	);