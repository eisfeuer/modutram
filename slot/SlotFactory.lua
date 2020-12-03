local Slot = require("modutram.slot.Slot")
local map = require("modutram.helper.map")

local SlotFactory = {}

function SlotFactory:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function SlotFactory:convertToMeters(xPos)
    return xPos / 100
end

function SlotFactory:makeTransformation(gridY, xPos)
    return {
        1, 0, 0, 0, 
        0, 1, 0, 0,
        0, 0, 1, 0,
        self:convertToMeters(xPos), gridY * self.config.gridModuleLength, self.config.baseHeight, 1
    }
end

function SlotFactory:makeId(slotConfig, gridX, gridY, xPos)
    return Slot.makeId({
        type = slotConfig.type,
        gridX = gridX,
        gridY = gridY,
        xPos = xPos
    })
end

function SlotFactory:makeSpacing(widthInCm)
    local widthInMeters = self:convertToMeters(widthInCm)
    return {widthInMeters / 2 - 0.1, widthInMeters / 2 - 0.1, self.config.gridModuleLength / 2 - 0.1, self.config.gridModuleLength / 2 - 0.1}
end

function SlotFactory:make(slotConfig, gridX, gridY, xPos)
    return {
        id = self:makeId(slotConfig, gridX, gridY, xPos),
        type = slotConfig.slotType,
        transf = self:makeTransformation(gridY, xPos),
        spacing = self:makeSpacing(slotConfig.widthInCm)
    }
end

function SlotFactory:makeAnySlot(slotConfigRepository, gridX, gridY, xPos)
    return map(slotConfigRepository:getAll(), function (slotConfig)
        return self:make(slotConfig, gridX, gridY, xPos)
    end)
end

function SlotFactory:makeSlotsLeftFromGridModule(slotConfigRepository, gridModule)
    local slots = {}

    if gridModule:getGridX() > -31 then
        for _, slotType in pairs(gridModule.possibleLeftNeighbors) do
            for _, slotConfig in pairs(slotConfigRepository:get(slotType) or {}) do
                local xPos = math.floor(gridModule:getXPosInCm() - ((gridModule:getOption("widthInCm", 0) + slotConfig.widthInCm ) / 2))

                if math.abs(xPos) <= 8000 then
                    table.insert(slots, self:make(
                        slotConfig,
                        gridModule:getGridX() - 1,
                        gridModule:getGridY(),
                        xPos
                    ))
                end
            end
        end
    end

    return slots
end

function SlotFactory:makeSlotsRightFromGridModule(slotConfigRepository, gridModule)
    local slots = {}

    if gridModule:getGridX() < 31 then
        for _, slotType in pairs(gridModule.possibleRightNeighbors) do
            for _, slotConfig in pairs(slotConfigRepository:get(slotType) or {}) do
                local xPos = math.floor(gridModule:getXPosInCm() + ((gridModule:getOption("widthInCm", 0) + slotConfig.widthInCm ) / 2))

                if math.abs(xPos) <= 8000 then
                    table.insert(slots, self:make(
                        slotConfig,
                        gridModule:getGridX() + 1,
                        gridModule:getGridY(),
                        xPos
                    ))
                end
            end
        end
    end

    return slots
end

function SlotFactory:makeSlotAtGridModule(slotConfigRepository, gridModule, verticalOffset)
    verticalOffset = verticalOffset or 0
    local slotConfig = slotConfigRepository:get(gridModule:getType(), gridModule:getOption("widthInCm", -1))

    if not (slotConfig and slotConfig[1]) then
        error('Access to a not existing module')
    end

    return self:make(
        slotConfig[1],
        gridModule:getGridX(),
        gridModule:getGridY() + verticalOffset,
        gridModule:getXPosInCm()
    )
end

function SlotFactory:makeSlotsAboveGridModule(slotConfigRepository, gridModule)
    if gridModule:getGridY() >= 31 then
        return {}
    end

    return { self:makeSlotAtGridModule(slotConfigRepository, gridModule, 1) }
end

function SlotFactory:makeSlotsBelowGridModule(slotConfigRepository, gridModule)
    if gridModule:getGridY() <= -31 then
        return {}
    end

    return { self:makeSlotAtGridModule(slotConfigRepository, gridModule, -1) }
end

return SlotFactory