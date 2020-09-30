local TerminalGroup = require("modutram.terminal.TerminalGroup")

describe("TerminalGroup", function ()
    describe("addTerminalModel", function ()
        it("adds a terminal model to the group", function ()
            local result = {
                models = {{
                    id = "a_model.mdl",
                    transf = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1}
                }},
                terminalGroups = {}
            }

            local terminalGroup = TerminalGroup:new{result = result}

            assert.are.same({}, terminalGroup.terminals)

            terminalGroup:addTerminalModel('terminal_model.mdl', {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 2, 1}, 1)

            assert.are.same({
                models = {{
                    id = "a_model.mdl",
                    transf = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1}
                }, {
                    id = "terminal_model.mdl",
                    transf = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 2, 1}
                }},
                terminalGroups = {}
            }, result)

            assert.are.same({{1, 1}}, terminalGroup.terminals)
        end)

        it("adds a terminal model with default terminal id", function ()
            local result = {
                models = {{
                    id = "a_model.mdl",
                    transf = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1}
                }},
                terminalGroups = {}
            }

            local terminalGroup = TerminalGroup:new{result = result}

            terminalGroup:addTerminalModel('terminal_model.mdl', {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 2, 1})

            assert.are.same({
                models = {{
                    id = "a_model.mdl",
                    transf = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1}
                }, {
                    id = "terminal_model.mdl",
                    transf = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 2, 1}
                }},
                terminalGroups = {}
            }, result)

            assert.are.same({{1, 0}}, terminalGroup.terminals)
        end)
    end)

    describe("addVehicleTerminal", function ()
        it("adds a vehicle terminal model", function ()
            local result = {
                models = {{
                    id = "a_model.mdl",
                    transf = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1}
                }},
                terminalGroups = {}
            }

            local terminalGroup = TerminalGroup:new{result = result}

            assert.are.same({}, terminalGroup.terminals)

            terminalGroup:addVehicleTerminalModel('terminal_model.mdl', {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 2, 1}, 1, true)

            assert.are.same({
                models = {{
                    id = "a_model.mdl",
                    transf = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1}
                }, {
                    id = "terminal_model.mdl",
                    transf = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 2, 1}
                }},
                terminalGroups = {}
            }, result)

            assert.are.same({1, 1}, terminalGroup.vehicleTerminal)
            assert.is_true(terminalGroup.vehicleTerminalHasPassengerTerminal)
        end)

        it("adds a vehicle terminal model with default values", function ()
            local result = {
                models = {{
                    id = "a_model.mdl",
                    transf = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1}
                }},
                terminalGroups = {}
            }

            local terminalGroup = TerminalGroup:new{result = result}

            assert.are.same({}, terminalGroup.terminals)

            terminalGroup:addVehicleTerminalModel('terminal_model.mdl', {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 2, 1})

            assert.are.same({
                models = {{
                    id = "a_model.mdl",
                    transf = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1}
                }, {
                    id = "terminal_model.mdl",
                    transf = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 2, 1}
                }},
                terminalGroups = {}
            }, result)

            assert.are.same({1, 0}, terminalGroup.vehicleTerminal)
            assert.is_false(terminalGroup.vehicleTerminalHasPassengerTerminal)
        end)
    end)

    describe("addVehicleAndPassengerTerminalModel", function ()
        it ("adds a terminam model containing vehicle and passenger terminal", function ()
            local result = {
                models = {{
                    id = "a_model.mdl",
                    transf = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1}
                }},
                terminalGroups = {}
            }

            local terminalGroup = TerminalGroup:new{result = result}

            assert.are.same({}, terminalGroup.terminals)

            terminalGroup:addVehicleAndPassengerTerminalModel('terminal_model.mdl', {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 2, 1})

            assert.are.same({
                models = {{
                    id = "a_model.mdl",
                    transf = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1}
                }, {
                    id = "terminal_model.mdl",
                    transf = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 2, 1}
                }},
                terminalGroups = {}
            }, result)

            assert.are.same({1, 0}, terminalGroup.vehicleTerminal)
            assert.is_true(terminalGroup.vehicleTerminalHasPassengerTerminal)
        end)
    end)

    describe('isValid', function ()
        it ('is not valid when terminal group has no vehicle terminal', function ()
            local result = {models = {}}

            local terminalGroup = TerminalGroup:new{result = result}

            assert.is_false(terminalGroup:isValid())

            terminalGroup:addTerminalModel("terminal_model.mdl", {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 2, 1})

            assert.is_false(terminalGroup:isValid())
        end)

        it ('is not valid when terminal group has no passenger terminals', function ()
            local result = {models = {}}

            local terminalGroup = TerminalGroup:new{result = result}

            terminalGroup:addVehicleTerminalModel("terminal_model.mdl", {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 2, 1})

            assert.is_false(terminalGroup:isValid())
        end)

        it ('is valid when terminal group has vehicle and passenger terminal', function ()
            local result = {models = {}}

            local terminalGroup = TerminalGroup:new{result = result}

            terminalGroup:addVehicleTerminalModel("terminal_model.mdl", {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 2, 1})
            terminalGroup:addTerminalModel("terminal_model.mdl", {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 2, 1})

            assert.is_true(terminalGroup:isValid())
        end)

        it ('is valid when terminal group has combined vehicle and passenger terminal', function ()
            local result = {models = {}}

            local terminalGroup = TerminalGroup:new{result = result}

            terminalGroup:addVehicleTerminalModel("terminal_model.mdl", {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 2, 1}, 0, true)

            assert.is_true(terminalGroup:isValid())
        end)
    end)

    describe('addToResult', function ()
        it ('adds terminal group to results', function ()
            local result = {models = {}}

            local terminalGroup = TerminalGroup:new{result = result}

            terminalGroup:addVehicleTerminalModel("terminal_model.mdl", {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 2, 1})
            terminalGroup:addTerminalModel("terminal_model.mdl", {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 2, 1})

            terminalGroup:addToResult()

            assert.are.same({{
                terminals = {{0,0}, {1,0}}
            }}, result.terminalGroups)
        end)
    end)
end)