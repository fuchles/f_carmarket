addEvent("onClientPlayerReceiveText", true)
addEvent("onClientText3DUpdate", true)

local _container = {}

addEventHandler("onClientRender", root,
	function()
		for k, v in pairs(getElementsByType("text3D")) do
			if not _container[v] then
				--outputChatBox(tostring(v))
				_container[v] = text3D:create(v)
			end
		end
	end
);

	text3D = {}
		function text3D:create(element)
			local public = {}
				public.text = "none"
				public.distance = 0
				public.element = element
				public.parent = false
				public.offset = {x, y, z}
				
			local private = {}
					
					function private:setup()
						addEventHandler("onClientPlayerReceiveText", public.element, private.onPlayerReceiveText)
						addEventHandler("onClientRender", root, private.onRender)
						addEventHandler("onClientElementDestroy", public.element, public.destroy)
						addEventHandler("onClientText3DUpdate", public.element, private.onUpdate)
						triggerServerEvent("onPlayerRequestText3D", public.element, localPlayer)
					end
					
					function private.onPlayerReceiveText(text, dist, parent, offset)
						public.text = text
						public.distance = dist
						public.parent = parent
						public.offset = offset
					end
					
					function private.onUpdate(text, dist, parent, offset)
						public.text = text
						public.distance = dist
						public.parent = parent
						public.offset = offset
					end
					
					function private.onRender()
						local pos = {}
						if public.parent then
							pos = vec3.toVec(getElementPosition(public.parent))
							local rot = vec3.toVec(getElementRotation(public.parent))
							local fwd = vec3.angleToDir(rot.x, rot.y, -rot.z - 90)
							local rght = vec3.angleToDir(rot.x, rot.y, -rot.z)
							--local up = vec3.angleToDir(-rot.x + 90, rot.y, rot.z)
							fwd = vec3.scaleVec(fwd, public.offset.y)
							rght = vec3.scaleVec(rght, public.offset.x)
							pos = vec3.addVec(pos, fwd)
							pos = vec3.addVec(pos, rght)
							pos.z = pos.z + public.offset.z
						else
							pos = vec3.toVec(getElementPosition(public.element))
							--pos = vec3.addVec(pos, public.offset)
						end
						local ppos = vec3.toVec(getElementPosition(localPlayer))
						local dist = vec3.getDistance(pos.x, pos.y, pos.z, ppos.x, ppos.y, ppos.z)
						if dist <= public.distance then
							--outputChatBox("Вы видите этот текст")
							local x, y = getScreenFromWorldPosition(pos.x, pos.y, pos.z)
							if x then
								dxDrawBorderedText	(
														0.5, public.text, x, y, x, y,
														tocolor(255, 255, 255), 1.1,
														"default-bold", "center", "center",
														false, false, false, true
													)
							end
						end
					end
					
					function public:destroy()
						removeEventHandler("onClientRender", root, private.onRender)
						removeEventHandler("onClientPlayerReceiveText", public.element, private.onPlayerReceiveText)
						removeEventHandler("onClientElementDestroy", public.element, public.destroy)
						removeEventHandler("onClientText3DUpdate", public.element, private.onUpdate)
						_container[public.element] = nil
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
		
		
function dxDrawBorderedText (outline, text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    local outline = (scale or 1) * (1.333333333333334 * (outline or 1))
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left - outline, top - outline, right - outline, bottom - outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left + outline, top - outline, right + outline, bottom - outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left - outline, top + outline, right - outline, bottom + outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left + outline, top + outline, right + outline, bottom + outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left - outline, top, right - outline, bottom, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left + outline, top, right + outline, bottom, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left, top - outline, right, bottom - outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left, top + outline, right, bottom + outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
end