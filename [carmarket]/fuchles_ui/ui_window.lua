

	incWindow = {}
		function incWindow:create(x, y, w, h, titleText, text, parent)
			local public = {}
				public.element = false
				public.pos = {x = x, y = y}
				public.size = {x = w, y = h}
				public.title = {text = titleText, image = false}
				public.text = text
				
			local private = {}
				private.background = dxCreateTexture(1, 1)
			
			
					function private:setup()
						public.element = createElement("ui")
						
						--setElementData(public.element, "pos", {x = x, y = y}, false)
						--setElementData(public.element, "size", {x = w, y = h}, false)
						
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
						
						addEventHandler("onClientRender", root, private.onRender)
						addEventHandler("onClientElementDestroy", public.element, public.destroy)
					end
					
					function private.onRender()
						local pos = public.pos
						local size = public.size
						local screen = {x, y}; screen.x, screen.y = guiGetScreenSize()
						local alpha = 200
						local upperBorder = screen.y*0.025
						local sideBorder = screen.x * 0.002
						local imageWidth = 0
						local imageHeight = 0
						if public.title.image then
							imageWidth = size.x - sideBorder * 2
							--imageWidth = size.x
							imageHeight = imageWidth/3
						end
						dxDrawImage(pos.x, pos.y, size.x, size.y, private.background, 0, 0, 0, tocolor(0, 0, 0, alpha))
						dxDrawImage(pos.x, pos.y, size.x, upperBorder, private.background, 0, 0, 0, tocolor(0, 0, 0, alpha))
						dxDrawImage(pos.x, pos.y + upperBorder, sideBorder, size.y - upperBorder - sideBorder, private.background, 0, 0, 0, tocolor(0, 0, 0, alpha))
						dxDrawImage(pos.x, pos.y + size.y - sideBorder, size.x, sideBorder, private.background, 0, 0, 0, tocolor(0, 0, 0, alpha))
						dxDrawImage(pos.x + size.x - sideBorder, pos.y + upperBorder, sideBorder, size.y - upperBorder - sideBorder, private.background, 0, 0, 0, tocolor(0, 0, 0, alpha))
						if public.title.image then
							--dxDrawImage(pos.x, pos.y + upperBorder, imageWidth, imageHeight, public.title.image)
							dxDrawImage(pos.x + sideBorder, pos.y + upperBorder, imageWidth, imageHeight, public.title.image)
							dxDrawImage(pos.x + sideBorder, pos.y + upperBorder + imageHeight, imageWidth, sideBorder, private.background, 0, 0, 0, tocolor(0, 0, 0, alpha))
						end
						
						if public.title.text then
							dxDrawText(public.title.text, pos.x, pos.y, pos.x + size.x, pos.y + upperBorder, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center", false, false, false, true)
						end
						
						if public.text then
							dxDrawText(public.text, pos.x + sideBorder * 2, pos.y + upperBorder + imageHeight + upperBorder, pos.x + size.x - sideBorder * 2, pos.y + upperBorder + imageHeight + upperBorder + size.y, tocolor(255, 255, 255, 255), 1.1, "default-bold", "center", "top", true, true)
						end
					end
					
					function public:destroy()
						if parent then removeEventHandler("onClientElementDestroy", parent, public.destroy) end
						removeEventHandler("onClientRender", root, private.onRender)
						removeEventHandler("onClientElementDestroy", public.element, public.destroy)
						private.background = nil
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