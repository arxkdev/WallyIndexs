-- // Constants
local float = "f"
local int = "i"

local function Q_rsqrt(n : number)
	local i
	local x2, y
	local threehalfs = 1.5

	x2 = n * .5
	y = n
	i = int:unpack(float:pack(y))
	i = 0x5f3759df - bit32.rshift(i, 1)
	y = float:unpack(int:pack(i))
	y = y * (threehalfs - (x2 * y * y))
	y = y * (threehalfs - (x2 * y * y))

	return y
end

-- // Main Module
local vec2 = {}

function vec2.sort(y_ascend : boolean, x_ascend : boolean, ... : Vector2)
	local vertices = {...}
	
	table.sort(vertices, function(v1, v2)
		if v1.Y == v2.Y then
			return if x_ascend then v1.X < v2.X else v1.X > v2.X
		end
		
		return if y_ascend then v1.Y < v2.Y else v1.Y > v2.Y
	end)
	
	return table.unpack(vertices)
end

function vec2.barycentric_side(
	x : number,
	y : number,

	pa : Vector2,
	pb : Vector2
)
	return (pa.Y - pb.Y) * x + (pb.X - pa.X) * y + pa.X * pb.Y - pb.X * pa.Y
end

function vec2.swap(a : Vector2, b : Vector2)
	return b, a
end

function vec2.get_xy(vec : Vector2)
	return vec.X, vec.Y
end

function vec2.fast_unit(vec : Vector2)
	local magnitude = Q_rsqrt(vec:Dot(vec))
	return vec * magnitude
end

return vec2