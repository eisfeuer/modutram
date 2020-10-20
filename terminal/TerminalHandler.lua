local TerminalGroupHandler = require("modutram.terminal.TerminalGroupHandler")

local TerminalHandler = {}

function TerminalHandler:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function TerminalHandler:addTerminalsFromGrid(grid, result, edgeListMap)
    grid:eachColumn(function (column)
        local leftTerminalGroupHandler = TerminalGroupHandler:new{
            neighborDirection = 'left',
            neighborGridX = column.gridX - 1,
            grid = grid,
            result = result,
            edgeListMap = edgeListMap
        }
        local rightTerminalGroupHandler = TerminalGroupHandler:new{
            neighborDirection = 'right',
            neighborGridX = column.gridX + 1,
            grid = grid,
            result = result,
            edgeListMap = edgeListMap
        }

        column:eachWithEmpty(function (gridModule)
            leftTerminalGroupHandler:handle(gridModule)
            rightTerminalGroupHandler:handle(gridModule)
        end)
        leftTerminalGroupHandler:finalize()
        rightTerminalGroupHandler:finalize()
    end)
end

function TerminalHandler:addNonTerminalLanesFromGrid(grid)
    grid:each(function (gridModule)
        gridModule:callLaneHandleFunc()
    end)
end

return TerminalHandler