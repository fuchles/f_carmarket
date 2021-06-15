


	incButton = {}
		function incButton:create(x, y, w, h, text, parent)
			local public = {}
				public.pos = {x = x, y = y}
				public.size = {x = w, y = h}
				public.text = text or " "
				public.element = false
			local private = {}
				private.triggered = false
				private.image = g_textures["button"]
				private.pressed = g_textures["button_pressed"]
				private.background = dxCreateTexture(1, 1)
				
				
				
					function private:setup()
						public.element = createElement("ui")
						
						local pixels = dxGetTexturePixels(private.background)
						dxSetPixelColor(pixels, 0, 0, 255, 255, 255, 255)
						dxSetTexturePixels(private.background, pixels)
						
						if parent then
							local parentPos = {x, y}; parentPos.x, parentPos.y = incGetPos(parent)
							local parentSize = {x, y}; parentSize.x, parentSize.y = incGetSize(parent)
							public.pos.x = parentPos.x + parentSize.x * public.pos.x
							public.pos.y = parentPos.y + parentSize.y * public.pos.y
							public.size.x = parentSize.x * public.size.x
							public.size.y = parentSize.y * public.size.y
							addEventHandler("onClientElementDestroy", parent, public.destroy)
						end
						
						addEventHandler("onClientElementDestroy", public.element, public.destroy)
						addEventHandler("onClientRender", root, private.onRender)
					end
					
					function private.onRender()
						local screen = {x, y}; screen.x, screen.y = guiGetScreenSize()
						local pos = public.pos
						local size = public.size
						local text = public.text
						local image = private.image
						local alpha = 200
						local sideBorder = screen.x * 0.001
						local background = private.background
						local text = public.text
						
						if isCursorShowing() then
							local cx, cy = getCursorPosition()
							cx = screen.x * cx; cy = screen.y * cy
							if cx >= pos.x and cx <= pos.x + size.x and cy >= pos.y and cy <= pos.y + size.y then
								image = private.pressed
								if getKeyState("mouse1") and not private.triggered then 
									private.triggered = true
									triggerEvent("onClientGUIClick", public.element)
								elseif not getKeyState("mouse1") and private.triggered then
									private.triggered = false
								end
							else
								image = private.image
							end
						else
							image = private.image
						end
						dxDrawImage(pos.x, pos.y, size.x, size.y, background, 0, 0, 0, tocolor(0, 0, 0, alpha))
						
						dxDrawImage(pos.x + sideBorder, pos.y + sideBorder, size.x - sideBorder * 2, size.y - sideBorder * 2, image)
						
						dxDrawText(text, pos.x + sideBorder, pos.y + sideBorder, pos.x + sideBorder + size.x - sideBorder * 2, pos.y + sideBorder + size.y - sideBorder * 2, tocolor(255, 255, 255, 255), 1.1, "default-bold", "center", "center", true, true)
					end
					
					function public:destroy()
						if parent then removeEventHandler("onClientElementDestroy", parent, public.destroy) end
						removeEventHandler("onClientRender", root, private.onRender)
						removeEventHandler("onClientElementDestroy", public.element, public.destroy)
						g_ui[public.element] = nil
						if isElement(public.element) then destroyElement(public.element) end
						for k, value in pairs(private) do private[k] = nil end
						for k, value in pairs(public) do public[k] = nil end
						private = nil
						public = nil
					end
			
			private:setup()
			setmetatable(public, self)
			self.__index = self
			return public
		end