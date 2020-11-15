local TerminalGroup = {}

function TerminalGroup:new(o)
    o = o or {}

    o.terminals = {}
    o.vehicleTerminalHasPassengerTerminal = false

    setmetatable(o, self)
    self.__index = self
    return o
end

function TerminalGroup:addTerminalModel(modelId, modelTransformation, modelTerminalId)
    local modelPosition = self:addModelAndGetPosition(modelId, modelTransformation)
    self:attachTerminal(modelPosition, modelTerminalId)

    return modelPosition
end

function TerminalGroup:addVehicleTerminalModel(modelId, modelTransformation, modelTerminalId, hasPassengers)
    local modelPosition = self:addModelAndGetPosition(modelId, modelTransformation)

    self:attachVehicleTerminal(modelPosition, modelTerminalId)
    self.vehicleTerminalHasPassengerTerminal = hasPassengers or false

    return modelPosition
end

function TerminalGroup:attachVehicleTerminal(modelPosition, modelTerminalId)
    self.vehicleTerminal = {
        modelPosition,
        modelTerminalId or 0
    }
end

function TerminalGroup:attachTerminal(modelPosition, modelTerminalId)
    table.insert(self.terminals, {
        modelPosition,
        modelTerminalId or 0
    })
end

function TerminalGroup:addVehicleAndPassengerTerminalModel(modelId, modelTransformation, modelTerminalId)
    self:addVehicleTerminalModel(modelId, modelTransformation, modelTerminalId, true)
end

function TerminalGroup:attachVehicleTrackNode(edgeListType, catenaryOrTram, nodeIndex)
    local edgeListStartIndex = self.edgeListMap:getIndexOfFirstNodeInEdgeList(edgeListType, catenaryOrTram)
    self.vehicleNodeOverride = edgeListStartIndex + nodeIndex
end

function TerminalGroup:addModelAndGetPosition(modelId, modelTransformation)
    if not modelId then
        error("the first parameter MUST be a model id (e.g. station/tram/terminal.mdl)")
    end
    if not modelTransformation then
        error("the second parameter MUST be a transformation matrix")
    end

    local modelPosition = #self.result.models

    table.insert(self.result.models, {
        id = modelId,
        transf = modelTransformation
    })

    return modelPosition
end

function TerminalGroup:isValid()
    if not (self.vehicleTerminal or self.vehicleNodeOverride) then
        return false
    end

    if self.vehicleTerminalHasPassengerTerminal then
        return true
    end

    if #self.terminals > 0 then
        return true
    end

    return false
end

function TerminalGroup:findStation(stationTag)
    for _, station in pairs(self.result.stations) do
        if station.tag == stationTag then
            return station
        end
    end

    return nil
end

function TerminalGroup:addTerminalToStation(terminalGroupId)
    local stationTag = self.load == "cargo" and 0 or 1

    if not self.result.stations then
        self.result.stations = {}
    end

    local station = self:findStation(stationTag)

    if not station then
        station = {
            tag = stationTag,
            terminals = {}
        }
        table.insert(self.result.stations, station)
    end

    table.insert(station.terminals, terminalGroupId)
end

function TerminalGroup:addToResult()
    local resultTerminalGroup = {
        terminals = {}
    }

    if self.vehicleTerminal then
        table.insert(resultTerminalGroup.terminals, self.vehicleTerminal)
    elseif self.vehicleNodeOverride then
        resultTerminalGroup.vehicleNodeOverride = self.vehicleNodeOverride
    else
        error('no vehicle node')
    end
    
    for _, terminal in pairs(self.terminals) do
        table.insert(resultTerminalGroup.terminals, terminal)
    end

    if not self.result.terminalGroups then
        self.result.terminalGroups = {}
    end

    self:addTerminalToStation(#self.result.terminalGroups)

    table.insert(self.result.terminalGroups, resultTerminalGroup)
end

return TerminalGroup