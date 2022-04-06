local except = require("modutram.helper.except")
local optional = require('modutram.helper.optional')
local t = require('modutram.types')
local Asset = require("modutram.asset_module.Asset")
local Slot = require("modutram.slot.Slot")

-- @module modutram.grid_module.Base
local GridModuleBase = {}

local gridTypes = {
    t.TRAM_BIDIRECTIONAL_LEFT,
    t.TRAM_BIDIRECTIONAL_RIGHT,
    t.TRAM_UP,
    t.TRAM_DOWN,
    t.BUS_BIDIRECTIONAL_LEFT,
    t.BUS_BIDIRECTIONAL_RIGHT,
    t.BUS_UP_RIGHT,
    t.BUS_DOWN_RIGHT,
    t.TRAIN,
    t.PLATFORM_NONE,
    t.PLATFORM_ISLAND,
    t.PLATFORM_LEFT,
    t.PLATFORM_RIGHT,
}

function GridModuleBase:new(o)
    o = o or {}
    
    if not o.slot then
        error('Grid Module MUST have a slot attribute')
    end

    o.hasTerminalsLeft = false
    o.hasTerminalsRight = false
    o.class = 'Base'
    o.config = o.config or {}
    o.options = o.options or {}
    o.possibleLeftNeighbors = gridTypes
    o.possibleRightNeighbors = gridTypes
    o.assets = {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function GridModuleBase:getSlotId()
    return self.slot.id
end

function GridModuleBase:getModuleType()
    return self.slot.moduleType
end

function GridModuleBase:getType()
    return self.slot.type
end

function GridModuleBase:getGridX()
    return self.slot.gridX
end

function GridModuleBase:getGridY()
    return self.slot.gridY
end

function GridModuleBase:getAbsoluteX()
    return self.slot.xPos / 100
end

function GridModuleBase:getAbsoluteY()
    if not self.config.gridModuleLength then
        return nil
    end

    return self.config.gridModuleLength * self:getGridY()
end

function GridModuleBase:getAbsoluteZ()
    return self.config.baseHeight
end

function GridModuleBase:getOption(key, default)
    if self.options[key] == nil then
        if optional(self.slot:getOptions())[key] == nil then
            return default
        end

        return self.slot:getOptions()[key]
    end
    
    return self.options[key]
end

function GridModuleBase:setOption(key, value)
    self.options[key] = value
end

function GridModuleBase:setOptions(options)
    for key, value in pairs(options) do
        self:setOption(key, value)
    end
end

function GridModuleBase:isBlank()
    return self:getType() == t.VOID
end

function GridModuleBase:isPlatform()
    return false
end

function GridModuleBase:isTrack()
    return false
end

function GridModuleBase:isTram()
    return false
end

function GridModuleBase:isBus()
    return false
end

function GridModuleBase:isTrain()
    return false
end

function GridModuleBase:isRail()
    return self:isTram() or self:isTrain()
end

function GridModuleBase:getXPosInCm()
    return self.slot.xPos
end

function GridModuleBase:getGrid()
    return self.grid
end

function GridModuleBase:hasNeighborLeft()
    return self:getGrid():has(self:getGridX() - 1, self:getGridY())
end

function GridModuleBase:getNeighborLeft()
    return self:getGrid():get(self:getGridX() - 1, self:getGridY())
end

function GridModuleBase:hasNeighborRight()
    return self:getGrid():has(self:getGridX() + 1, self:getGridY())
end

function GridModuleBase:getNeighborRight()
    return self:getGrid():get(self:getGridX() + 1, self:getGridY())
end

function GridModuleBase:hasNeighborTop()
    return self:getGrid():has(self:getGridX(), self:getGridY() + 1)
end

function GridModuleBase:getNeighborTop()
    return self:getGrid():get(self:getGridX(), self:getGridY() + 1)
end

function GridModuleBase:hasNeighborBottom()
    return self:getGrid():has(self:getGridX(), self:getGridY() - 1)
end

function GridModuleBase:getNeighborBottom()
    return self:getGrid():get(self:getGridX(), self:getGridY() - 1)
end

function GridModuleBase:handleTerminals(terminalHandleFunc)
    self.terminalHandleFunc = terminalHandleFunc
end

function GridModuleBase:isTerminalLeft(terminalGroup)
    return terminalGroup.platformDirection == 'left'
end

function GridModuleBase:isTerminalRight(terminalGroup)
    return terminalGroup.platformDirection == 'right'
end

function GridModuleBase:canCallTerminalHandleFunc(terminalGroup)
    if not self.terminalHandleFunc then
        return false
    end

    if terminalGroup.platformDirection == 'self' then
        return self:getOption('isZigzag', false)
    end

    if self:isTerminalLeft(terminalGroup) then
        return not self.hasTerminalsLeft
    end

    if self:isTerminalRight(terminalGroup) then
        return not self.hasTerminalsRight
    end

    return false
end

function GridModuleBase:callTerminalHandleFunc(terminalGroup)
    if self:canCallTerminalHandleFunc(terminalGroup) then
        self.terminalHandleFunc(terminalGroup)

        if self:isTerminalLeft(terminalGroup) then
            self.hasTerminalsLeft = true
        end
        if self:isTerminalRight(terminalGroup) then
            self.hasTerminalsRight = true
        end
    end
end

function GridModuleBase:hasTerminals()
    return self.hasTerminalsLeft or self.hasTerminalsRight
end

function GridModuleBase:handleLanes(laneHandleFunc)
    self.laneHandleFunc = laneHandleFunc
end

function GridModuleBase:callLaneHandleFunc()
    if self.laneHandleFunc then
        self.laneHandleFunc(self.hasTerminalsLeft, self.hasTerminalsRight)
    end
end

function GridModuleBase:getConfig()
    return self.config
end

function GridModuleBase:registerAsset(slot, options)
    options = options or {}

    if not slot.assetId or slot.assetId == 0 then
        error('Module not an asset')
    end

    if self:hasAsset(slot.assetId) then
        error('Asset already registered')
    end

    local asset = Asset:new{parent = self, slot = slot, options = options}
    self.assets[slot.assetId] = asset

    return asset
end

function GridModuleBase:hasAsset(assetId)
    return self:getAsset(assetId) ~= nil
end

function GridModuleBase:getAsset(assetId)
    return self.assets[assetId]
end

function GridModuleBase:isBidirectionalLeftTrack()
    return string.match(self.class, "BidirectionalLeft$") ~= nil
end

function GridModuleBase:isBidirectionalRightTrack()
    return string.match(self.class, "BidirectionalRight$") ~= nil
end

function GridModuleBase:isUpGoingTrack()
    return string.match(self.class, "Up$") ~= nil or string.match(self.class, "UpLeft$") ~= nil or string.match(self.class, "UpRight$") ~= nil
end

function GridModuleBase:isDownGoingTrack()
    return string.match(self.class, "Down$") ~= nil or string.match(self.class, "DownLeft$") ~= nil or string.match(self.class, "DownRight$") ~= nil
end

function GridModuleBase:addAssetSlot(result, assetSlotId, slotType, transformation, spacing, shape)
    local slotId = Slot.makeId({
        type = t.ASSET,
        gridX = self:getGridX(),
        gridY = self:getGridY(),
        assetId = assetSlotId
    })

    table.insert(result.slots, {
        id = slotId,
        transf = transformation,
        type = slotType,
        spacing = spacing or self.config.defaultAssetSlotSpacing,
        shape = shape or 0
    })
end

function GridModuleBase:getColumn()
    return self.grid:getColumn(self:getGridX())
end

return GridModuleBase