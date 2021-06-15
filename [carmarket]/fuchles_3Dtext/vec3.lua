	
	vec3 = {}
	
	function vec3.getDistance(x, y, z, x1, y1, z1)
		local dx, dy, dz = x1 - x, y1 - y, z1 - z
		local length = math.sqrt(dx^2 + dy^2 + dz^2)
		return length
	end
	
	function vec3.length(x, y, z)
		return math.sqrt(x^2 + y^2 + z^2)
	end
	
	function vec3.normalize(x, y, z)
		return x/math.sqrt(x^2 + y^2 + z^2), y/math.sqrt(x^2 + y^2 + z^2), z/math.sqrt(x^2 + y^2 + z^2)
	end
	
	function vec3.getDirFromTo(x, y, z, x1, y1, z1)
		local dx, dy, dz = vec3.normalize(x1 - x, y1 - y, z1 - z)
		return dx, dy, dz
	end
	
	function vec3.scaleVec(vector, scale)
		return {x = vector.x * scale, y = vector.y * scale, z = vector.z * scale}
	end
	
	function vec3.addVec(vec, vec1)
		return {x = vec.x+vec1.x, y = vec.y+vec1.y, z = vec.z+vec1.z}
	end
	
	function vec3.dirToAngle(x, y)
		local angle = math.atan2(x, y)
		return 180*angle/math.pi
	end
	
	function vec3.angleToDir(rx, ry, rz)
		local dx = math.sin(math.rad(rz+90))
		local dy = math.cos(math.rad(rz+90))
		local dz = math.tan(math.rad(rx))
		return {x = dx, y = dy, z = dz}
	end
	
	function vec3.toVec(px, py, pz)
		if not px then px = 0 end
		if not py then py = 0 end
		if not pz then pz = 0 end
		return {x = px, y = py, z = pz}
	end
	
	function vec3.getPos(element)
		local px, py, pz = getElementPosition(element)
		return {x = px, y = py, z = pz}
	end