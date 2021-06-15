
addEvent("onPlayerRequestText3D", true)
local _container = {}

	text3D = {}
		function text3D:create(text, x, y, z, dist, parent, offsetX, offsetY, offsetZ)
			local public = {}
				public.pos = {x = x, y = y, z = z}
				public.text = text
				public.element = false
				public.distance = dist
				public.parent = false
				public.offset = {x = 0, y = 0, z = 0}
			
			local private = {}
				
					function private:setup()
						if parent then public.parent = parent end
						if offsetX then public.offset.x = offsetX end
						if offsetY then public.offset.y = offsetY end
						if offsetZ then public.offset.z = offsetZ end
						public.element = createElement("text3D", "newtext")
						public.pos = vec3.addVec(public.pos, public.offset)
						setElementPosition(public.element, public.pos.x, public.pos.y, public.pos.z)
						addEventHandler("onPlayerRequestText3D", public.element, private.onPlayerRequestText)
					end
					
					function private.onPlayerRequestText(player)
						triggerClientEvent(player, "onClientPlayerReceiveText", public.element, public.text, public.distance, public.parent, public.offset)
					end
					
					function public:changeText(text)
						public.text = text
						for k, player in pairs(getElementsByType("player")) do
							triggerClientEvent(player, "onClientText3DUpdate", public.element, public.text, public.distance, public.parent, public.offset)
						end
					end
				
					function public:destroy()
						destroyElement(public.element)
						for k, value in pairs(public) do public[k] = nil end
						for k, value in pairs(private) do private[k] = nil end
						public = nil
						private = nil
					end
					
			private:setup()
			setmetatable(public, self)
			self.__index = self
			return public
		end


function create3DText(text, x, y, z, dist, parent, offsetX, offsetY, offsetZ)
	if not text or not x or not y or not z or not dist then return false end
	local textTable = text3D:create(text, x, y, z, dist, parent, offsetX, offsetY, offsetZ)
	_container[textTable.element] = textTable
	return textTable.element
end

function remove3DText(textTable)
	if not textTable then return false end
	if not _container[textTable] then return false end
	_container[textTable]:destroy()
	return true
end

function change3DText(textTable, text)
	if not textTable or not text then return false end
	if not _container[textTable] then return false end
	_container[textTable]:changeText(text)
	return true
end