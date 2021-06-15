


	classVehicle = {}
		function classVehicle:create(model, x, y, z, rx, ry, rz, owner, plate)
			local public = {}
			
			local private = {}
				private.element = false
				private.serial = false
			
					function private:setup()
						private.serial = tostring(getPlayerSerial(owner))
						if not owner or getElementType(owner) ~= "player" or not isElement(owner) then return false end
						private.element = createVehicle(model, x, y, z, rx, ry, rz)
						if not private.element then 
							public:destroy()
							return false
						end
						g_players[private.serial].carState = true
						setVehiclePlateText(private.element, plate)
						setElementVelocity(private.element, 0, 0, -0.01)
						addEventHandler("onPlayerQuit", owner, private.onOwnerQuit)
						return true
					end
					
					function private.onOwnerQuit()
						public:destroy()
					end
					
					function public:getElement()
						return private.element
					end
					
					function public:destroy()
						removeEventHandler("onPlayerQuit", owner, private.onOwnerQuit)
						g_players[private.serial].carState = false
						g_players[private.serial].carTable = nil
						if isElement(private.element) then destroyElement(private.element) end
						for k, v in pairs(private) do private[k] = nil end
						for k, v in pairs(public) do public[k] = nil end
						private = nil
						public = nil
					end
			
			setmetatable(public, self)
			self.__index = self
			local result = private:setup()
			if result then return public else return false end
		end