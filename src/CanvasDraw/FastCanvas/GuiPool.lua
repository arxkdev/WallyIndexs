local module = {}

local OFF_SCREEN = UDim2.fromOffset(0, math.huge)

local TableInsert = table.insert
local TableRemove = table.remove

function module.new(original: GuiObject, initSize: number?)
	initSize = initSize or 50

	local Pool = {
		_Available = table.create(initSize),
		_Source = original:Clone(),
		_Index = initSize,
	}

	for i = 1, initSize do
		Pool._Available[i] = Pool._Source:Clone()
	end

	function Pool:Get()
		local Index = self._Index
		
		if Index > 0 then
			local object = self._Available[Index]
			TableRemove(self._Available, Index)
			self._Index -= 1
			return object
		end

		return self._Source:Clone()
	end

	function Pool:Return(object: GuiObject)
		object.Position = OFF_SCREEN
		TableInsert(self._Available, object)
		self._Index += 1
	end

	return Pool
end

return module