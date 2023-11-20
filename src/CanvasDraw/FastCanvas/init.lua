--[[

FastCanvas is a modified version of Greedy/GradientCanvas by BoatBomber. 
This version has the ability to remove blur artefacts from the original module and improve performance. 
There are also some other minor additions to fit CanvasDraw's needs.

Original module: https://github.com/boatbomber/GradientCanvas

]]

local module = {}

local GuiPool = require(script.GuiPool)
--local Util = require(script.Util)

-- Micro optimisations
local TableInsert = table.insert
local TableClear = table.clear
local TableCreate = table.create

local Mclamp = math.clamp

local UDim2FromScale = UDim2.fromScale
local ColorSeqKeyPNew = ColorSequenceKeypoint.new
local ColorSeqNew = ColorSequence.new

function module.new(ResX: number, ResY: number, BlurEnabled: boolean)
	local Canvas = {
		_Active = 0,
		_ColumnFrames = {},
		_UpdatedColumns = {},

		--Threshold = 2,
		--LossyThreshold = 4,
	}

	local invX, invY = 1 / ResX, 1 / ResY
	--local dist = ResY * 0.03

	-- Generate initial grid of color data
	local Grid = TableCreate(ResX)
	for x = 1, ResX do
		Grid[x] = TableCreate(ResY, Color3.new(0.98, 1, 1))
	end
	Canvas._Grid = Grid

	-- Create a pool of Frame instances with Gradients
	do
		local Pixel = Instance.new("Frame")
		Pixel.BackgroundColor3 = Color3.new(1, 1, 1)
		Pixel.BorderSizePixel = 0
		Pixel.Name = "Pixel"
		local Gradient = Instance.new("UIGradient")
		Gradient.Name = "Gradient"
		Gradient.Rotation = 90
		Gradient.Parent = Pixel

		Canvas._Pool = GuiPool.new(Pixel, ResX)
		Pixel:Destroy()
	end

	-- Create GUIs
	local Gui = Instance.new("Frame")
	Gui.Name = "GradientCanvas"
	Gui.BackgroundTransparency = 1
	Gui.ClipsDescendants = true
	Gui.Size = UDim2.fromScale(1, 1)
	Gui.Position = UDim2.fromScale(0.5, 0.5)
	Gui.AnchorPoint = Vector2.new(0.5, 0.5)

	local AspectRatio = Instance.new("UIAspectRatioConstraint")
	AspectRatio.AspectRatio = ResX / ResY
	AspectRatio.Parent = Gui

	local Container = Instance.new("Folder")
	Container.Name = "FrameContainer"
	Container.Parent = Gui

	-- Define API
	local function createGradient(colorData, x, pixelStart, pixelCount)
		local Sequence = TableCreate(#colorData)
		for i, data in colorData do
			Sequence[i] = ColorSeqKeyPNew(Mclamp(data.p / pixelCount, 0, 1), data.c)
		end

		local Frame = Canvas._Pool:Get()
		Frame.Position = UDim2FromScale(invX * (x - 1), pixelStart * invY)
		Frame.Size = UDim2FromScale(invX, invY * pixelCount)
		Frame.Gradient.Color = ColorSeqNew(Sequence)
		Frame.Parent = Container

		if Canvas._ColumnFrames[x] == nil then
			Canvas._ColumnFrames[x] = { Frame }
		else
			TableInsert(Canvas._ColumnFrames[x], Frame)
		end

		Canvas._Active += 1
	end

	function Canvas:Destroy()
		TableClear(Canvas._Grid)
		TableClear(Canvas)
		Gui:Destroy()
	end

	function Canvas:SetParent(parent: Instance)
		Gui.Parent = parent
	end

	function Canvas:SetPixel(x: number, y: number, color: Color3)
		local Col = self._Grid[x]

		if Col[y] ~= color then
			Col[y] = color
			self._UpdatedColumns[x] = Col
		end
	end
	
	function Canvas:GetPixel(x: number, y: number)
		--local Col = self._Grid[x]
		--if not Col then
		--	return
		--end

		return self._Grid[x][y]
	end

	function Canvas:Clear(x: number?)
		if x then
			local column = self._ColumnFrames[x]
			if column == nil then return end

			for _, object in column do
				self._Pool:Return(object)
				self._Active -= 1
			end
			TableClear(column)
		else
			for _, object in Container:GetChildren() do
				self._Pool:Return(object)
			end
			self._Active = 0
			TableClear(self._ColumnFrames)
		end
	end

	function Canvas:Render()
		for x, column in self._UpdatedColumns do
			self:Clear(x)

			local colorCount, colorData = 1, {
				{ p = 0, c = column[1] },
			}

			local pixelStart, pixelCount = 0, 0
			--local pixelStart, lastPixel, pixelCount = 0, 0, 0
			
			local lastColor = column[1]

			-- Compress into gradients
			for y, color in column do
				pixelCount += 1

				-- Early exit to avoid the delta check on direct equality
				if lastColor == color then
					continue
				end

				--local delta = Util.DeltaRGB(lastColor, color)
				--if delta > self.Threshold then
				local offset = y - pixelStart - 1

				--if (delta > self.LossyThreshold) or (y-lastPixel > dist) then
				
				TableInsert(colorData, { p = offset - 0.08, c = lastColor })
				--colorCount += 1
				
				TableInsert(colorData, { p = offset, c = color })
				colorCount += 2

				lastColor = color
				--lastPixel = y

				if colorCount > 18 then
					TableInsert(colorData, { p = pixelCount, c = color })
					createGradient(colorData, x, pixelStart, pixelCount)

					pixelStart = y - 1
					pixelCount = 0
					colorCount = 1
					TableClear(colorData)
					colorData[1] = { p = 0, c = color }
				end
				--end
			end

			if pixelCount + pixelStart ~= ResY then
				pixelCount += 1
			end
			TableInsert(colorData, { p = pixelCount, c = lastColor })
			createGradient(colorData, x, pixelStart, pixelCount)
		end

		TableClear(self._UpdatedColumns)
	end

	return Canvas
end

return module