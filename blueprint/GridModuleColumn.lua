local GridModuleColumn = {}

function GridModuleColumn:new(o)
    o = o or {}

    o.gridModules = {}

    setmetatable(o, self)
    self.__index = self
    return o
end

function GridModuleColumn:addBlueprint(gridY, gridModuleBlueprint)
    self.gridModules[gridY] = gridModuleBlueprint
    return self
end

function GridModuleColumn:place(result, xPos, gridX)
    for gridY, gridModuleBlueprint in pairs(self.gridModules) do
        gridModuleBlueprint:place(result, xPos, gridX, gridY)
    end
end

return GridModuleColumn