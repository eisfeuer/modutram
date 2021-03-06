local TerminalGroup = require("modutram.terminal.TerminalGroup")

local TerminalGroupHandler = {}

function TerminalGroupHandler:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function TerminalGroupHandler:handle(gridModule)
    if not self:gridModuleIsValidPlatform(gridModule) then
        self:finalizeTerminalGroup()
        return
    end

    local neighbor = self.grid:get(self.neighborGridX, gridModule:getGridY())
    if not (neighbor:isTrack() and neighbor:getOption('hasTerminals', true)) then
        self:finalizeTerminalGroup()
        return
    end

    if neighbor.class ~= self.trackClass or self:hasDifferentLoadType(gridModule) then
        self:finalizeTerminalGroup()
        self:initializeTerminalGroup(neighbor, gridModule)
    end

    self.endPos = gridModule:getGridY()
    gridModule:callTerminalHandleFunc(self.terminalGroup)
    if neighbor:isBus() then
        self:finalizeTerminalGroup()
    end
end

function TerminalGroupHandler:hasDifferentLoadType(gridModule)
    return self.terminalGroup and self.terminalGroup.load ~= gridModule:getOption('load', 'passengers')
end

function TerminalGroupHandler:gridModuleIsValidPlatform(gridModule)
    if not gridModule then
        return false
    end

    if not gridModule:getOption('hasTerminals', true) then
        return false
    end

    if gridModule.class == 'PlatformIsland' then
        return true
    end

    if self.neighborDirection == 'left' then
        return gridModule.class == 'PlatformLeft' 
    end

    return gridModule.class == 'PlatformRight'
end

function TerminalGroupHandler:initializeTerminalGroup(trackGridModule, platformGridModule)
    local oppositeDirection = self.neighborDirection == 'left' and 'right' or 'left'

    self.terminalGroup = TerminalGroup:new{
        result = self.result,
        edgeListMap = self.edgeListMap,
        trackDirection = self.neighborDirection,
        platformDirection = oppositeDirection,
        load = platformGridModule:getOption('load', 'passengers')
    }

    self.trackClass = trackGridModule.class
    self.startPos = trackGridModule:getGridY()
    self.endPos = trackGridModule:getGridY()
end

function TerminalGroupHandler:finalizeTerminalGroup()
    if not (self.terminalGroup and self.startPos and self.endPos) then 
        self:reset()
        return
    end

    local centerTrackModule = self.grid:get(self.neighborGridX, self:getCenter(self.startPos, self.endPos))
    if not (centerTrackModule:isTrack() and centerTrackModule:getOption('hasTerminals', true)) then
        self:reset()
        return
    end

    self.terminalGroup.vehicleStopAlignment = self:getAlignment(self.startPos, self.endPos)
    centerTrackModule:callTerminalHandleFunc(self.terminalGroup)
    if self.terminalGroup:isValid() then
        self.terminalGroup:addToResult()
    end
    self:reset()
end

function TerminalGroupHandler:reset()
    self.terminalGroup = nil
    self.trackClass = nil
    self.startPos = nil
    self.endPos = nil
end

function TerminalGroupHandler:finalize()
    self:finalizeTerminalGroup()
end

function TerminalGroupHandler:getCenter(startPos, endPos)
    return math.floor((startPos + endPos) / 2)
end

function TerminalGroupHandler:getAlignment(startPos, endPos)
    return (endPos - startPos) % 2 == 1 and 'top' or 'middle'
end

return TerminalGroupHandler