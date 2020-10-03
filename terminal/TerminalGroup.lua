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
    table.insert(self.terminals, {
        self:addModelAndGetPosition(modelId, modelTransformation),
        modelTerminalId or 0
    })
end

function TerminalGroup:addVehicleTerminalModel(modelId, modelTransformation, modelTerminalId, hasPassengers)
    self.vehicleTerminal = {
        self:addModelAndGetPosition(modelId, modelTransformation),
        modelTerminalId or 0
    }
    self.vehicleTerminalHasPassengerTerminal = hasPassengers or false
end

function TerminalGroup:addVehicleAndPassengerTerminalModel(modelId, modelTransformation, modelTerminalId)
    self:addVehicleTerminalModel(modelId, modelTransformation, modelTerminalId, true)
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
    if not self.vehicleTerminal then
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

function TerminalGroup:addToResult()
    local resultTerminalGroup = {
        terminals = {}
    }

    table.insert(resultTerminalGroup.terminals, self.vehicleTerminal)
    
    for _, terminal in pairs(self.terminals) do
        table.insert(resultTerminalGroup.terminals, terminal)
    end

    if not self.result.terminalGroups then
        self.result.terminalGroups = {}
    end

    table.insert(self.result.terminalGroups, resultTerminalGroup)
end

return TerminalGroup