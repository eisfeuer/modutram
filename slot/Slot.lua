local t = require('modutram.types')
local NatBomb = require('modutram.slot.natbomb')

local GRID_MODULE_DIGIT_SPACES = {6, 6, 13}
local ASSET_MODULE_DIGIT_SPACES = {6, 6, 8, 5}

local Slot = {}

local function toSignedId(unsigned_id)
    if unsigned_id then
        return unsigned_id - 32
    end
    return 0
end

local function toSignedXPos(xPos, gridX)
    if xPos == 0 or gridX >= 0 then
        return xPos
    end

    return -xPos
end

function Slot:new (o)
    if not (o and o.id) then
        error("Required Property Id is missing")
    end

    local slotType = NatBomb.explode({25}, o.id)[1]

    if Slot.isGridModuleType(slotType) then
        local ids = NatBomb.explode(GRID_MODULE_DIGIT_SPACES, o.id)

        o.type = ids[1] or t.VOID
        o.moduleType = Slot.getModuleTypeFromSlotType(o.type)
        o.gridX = toSignedId(ids[2])
        o.gridY = toSignedId(ids[3])

        o.xPos = toSignedXPos(ids[4], o.gridX)
    else
        local ids = NatBomb.explode(ASSET_MODULE_DIGIT_SPACES, o.id or 0)

        o.type = ids[1] or t.VOID
        o.moduleType = Slot.getModuleTypeFromSlotType(o.type)
        o.gridX = toSignedId(ids[2])
        o.gridY = toSignedId(ids[3])

        o.assetId = ids[4] or 0
        o.decorationId = ids[5] or 0
    end

    setmetatable(o, self)
    self.__index = self
    return o
end

function Slot:isGridModule()
    return self.moduleType < t.TYPE_ASSET and self.moduleType > 0
end

function Slot:isAssetModule()
    return not self:isGridModule()
end

function Slot.isGridModuleType(slotType)
    local moduleType = Slot.getModuleTypeFromSlotType(slotType)
    return moduleType < t.TYPE_ASSET and moduleType > 0
end

function Slot.makeId(options)
    local type = options.type or t.VOID
    if Slot.isGridModuleType(type) then
        return NatBomb.implode(GRID_MODULE_DIGIT_SPACES, {
            type,
            (options.gridX or 0) + 32,
            (options.gridY or 0) + 32,
            options.xPos and math.abs(options.xPos) or 0,
        })
    end

    return NatBomb.implode(ASSET_MODULE_DIGIT_SPACES, {
        type,
        (options.gridX or 0) + 32,
        (options.gridY or 0) + 32,
        options.assetId or 0,
        options.decorationId or 0
    })
end

function Slot.getModuleTypeFromSlotType(slotType)
    return math.floor(slotType / 8)
end

function Slot:getModuleData()
    return self.moduleData or {}
end

function Slot:getOptions()
    local options = {}
    local moduleData = self:getModuleData()

    if moduleData.name then
        options.moduleName = moduleData.name
    end

    if moduleData.metadata then
        for key, value in pairs(moduleData.metadata) do
            if key == 'modutram' then
                for k, v in pairs(value) do
                    options[k] = v
                end
            end

            local optionKey =  string.match(key, '^modutram_(.*)$')
            if optionKey then
                options[optionKey] = value
            end
        end
    end

    return options
end

function Slot:debug()
    print('ID: ' .. self.id)
    print('Type: ' .. self.type .. '(Grid Type: ' .. self.moduleType .. ')')
    print('Grid X: ' .. self.gridX)
    print('Grid Y: ' .. self.gridY)
    if self:isGridModule() then
        print('Y Position (in cm): ' .. self.yPos)
    else
        print('Asset Id: ' .. self.assetId)
        print('Decoration Id: ' .. self.decorationId)
    end
end

function Slot.getTypeFromId(slotId)
    return NatBomb.explode({25}, slotId)[1]
end

return Slot