local Column = require('modutram.Grid.Column')
local Slot = require('modutram.slot.Slot')
local GridModule = require('modutram.GridModule.Base')
local t = require('modutram.types')

local Grid = {}

function Grid:new(o)
    o = o or {}

    if not o.config then
        error('Grid MUST have a config attribute')
    end

    o.columns = o.columns or {}
    o.bounds = o.bounds or {
        top = 0,
        bottom = 0,
        left = 0,
        right = 0
    }

    setmetatable(o, self)
    self.__index = self

    return o
end

function Grid:isEmpty()
    return next(self.columns) == nil
end

function Grid:hasAnyModulesAtGridX(gridX)
    return self:getColumn(gridX) ~= nil
end

function Grid:getColumn(gridX)
    return self.columns[gridX]
end

function Grid:updateBounds(gridX, gridY)
    self.bounds.left = math.min(self.bounds.left, gridX)
    self.bounds.right = math.max(self.bounds.right, gridX)
    self.bounds.top = math.max(self.bounds.top, gridY)
    self.bounds.bottom = math.min(self.bounds.bottom, gridY)
end

function Grid:set(gridModule)
    if self:hasAnyModulesAtGridX(gridModule:getGridX()) then
        self:getColumn(gridModule:getGridX()):addGridModule(gridModule)
    else
        self.columns[gridModule:getGridX()] = Column:new{initialModule = gridModule}
    end

    self:updateBounds(gridModule:getGridX(), gridModule:getGridY())
end

function Grid:makeVoidModule(gridX, gridY)
    local slot = Slot:new{id = Slot.makeId({type = t.VOID, gridX = gridX, gridY = gridY})}
    return GridModule:new{slot = slot}
end

function Grid:get(gridX, gridY)
    return self:getColumn(gridX) and self:getColumn(gridX):getGridModule(gridY) or self:makeVoidModule(gridX, gridY)
end

function Grid:has(gridX, gridY)
    return self:hasAnyModulesAtGridX(gridX) and self:getColumn(gridX):hasGridModule(gridY)
end

function Grid:isInBounds(gridX, gridY)
    return gridX >= -self.config.gridMaxXyPosition
        and gridX <= self.config.gridMaxXyPosition
        and gridY >= -self.config.gridMaxXyPosition
        and gridY <= self.config.gridMaxXyPosition
end

function Grid:getActiveGridBounds()
    return self.bounds
end

function Grid:getActiveGridSlotBounds()
    return {
        left = self.bounds.left - 1,
        right = self.bounds.right + 1,
        top = self.bounds.top + 1,
        bottom = self.bounds.bottom - 1,
    }
end

return Grid