local getIndexOrAddNewTable = require("modutram.helper.getIndexOrAddNewTable")
local optional = require("modutram.helper.optional")
local t = require("modutram.types")

-- @module modutram.slot.SlotConfigRepository

local SlotConfigRepository = {}

function SlotConfigRepository:new(o)
    o = o or {}

    o.repository = {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function SlotConfigRepository:add(slotConfig)
    local slotConfigsOfType = getIndexOrAddNewTable(self.repository, slotConfig.type)

    if not slotConfigsOfType[slotConfig.widthInCm] then
        slotConfigsOfType[slotConfig.widthInCm] = slotConfig
    end
end

function SlotConfigRepository:get(moduleType, moduleWidth)
    if not moduleWidth then
        if not self.repository[moduleType] then
            return nil
        end

        local result = {}

        for _, slotConfig in pairs(self.repository[moduleType]) do
            table.insert(result, slotConfig)
        end

        return result
    end

    local result = optional(self.repository[moduleType])[moduleWidth]
    return result and {result}
end

function SlotConfigRepository:getAll()
    local result = {}

    for _,  typeRepo in pairs(self.repository) do
        for _, typeAndWidthRepo in pairs(typeRepo) do
            table.insert(result, typeAndWidthRepo)
        end
    end

    return result
end

function SlotConfigRepository.makeWithParams(paramsFromModLua)
    local slotConfigRepository = SlotConfigRepository:new{}

    for _, slotConfig in pairs(paramsFromModLua) do
        if slotConfig.type < t.ASSET then
            slotConfigRepository:add(slotConfig)
        end
    end

    return slotConfigRepository
end

return SlotConfigRepository