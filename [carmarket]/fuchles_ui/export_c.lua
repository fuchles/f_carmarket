g_ui = {}

function incGetPos(element)
	if not isElement(element) or not g_ui[element] then return false end
	local pos = g_ui[element].pos
	return pos.x, pos.y
end

function incGetSize(element)
	if not isElement(element) or not g_ui[element] then return false end
	local size = g_ui[element].size
	return size.x, size.y
end

function incWindowCreate(x, y, w, h, titleText, text, parent)
	if not x or not y then return false end
	if not w or not h then return false end
	if not titleText then titleText = "" end
	if not text then text = "" end
	if not parent then parent = false end
	local incTable = incWindow:create(x, y, w, h, titleText, text, parent)
	g_ui[incTable.element] = incTable
	return incTable.element
end

function incButtonCreate(x, y, w, h, text, parent)
	if not x or not y then return false end
	if not w or not h then return false end
	if not text then text = "" end
	if not parent then parent = false end
	local incTable = incButton:create(x, y, w, h, text, parent)
	g_ui[incTable.element] = incTable
	return incTable.element
end