local t = require('modutram.types')
local GridModule = require('modutram.grid_module.Base')
local Slot = require('modutram.slot.Slot')

local Column = require('modutram.grid.Column')

describe('Column', function ()
    describe('new', function ()
        local gridModule = GridModule:new{slot = Slot:new{id = Slot.makeId({type = t.PLATFORM_LEFT, gridX = 3, gridY = 1, xPos = 30})}}
        local column = Column:new{initialModule = gridModule}

        it ('has grid x', function ()
            assert.are.equal(3, column.gridX)
        end)

        it('has x position', function ()
            assert.are.equal(30, column.xPos)
        end)

        it('has type', function ()
            assert.are.equal(t.PLATFORM_LEFT, column.type)
        end)

        it('has set of grid modules containing the initail module', function ()
            assert.are.equal(1, #column.gridModules)
            assert.are.equal(gridModule, column.gridModules[1])
        end)

        it('has top grid Y', function ()
            assert.are.equal(1, column.topGridY)
        end)

        it('has bottom grid Y', function ()
            assert.are.equal(1, column.bottomGridY)
        end)
    end)

    describe('addGridModule', function ()
        it('adds grid module', function ()
            local gridModule1 = GridModule:new{slot = Slot:new({id = Slot.makeId({
                type = t.PLATFORM_LEFT,
                gridX = 3,
                gridY = 1
            })})}
            local gridModule2 = GridModule:new{slot = Slot:new({id = Slot.makeId({
                type = t.PLATFORM_LEFT,
                gridX = 3,
                gridY = 0
            })})}
            local gridModule3 = GridModule:new{slot = Slot:new({id = Slot.makeId({
                type = t.PLATFORM_LEFT,
                gridX = 3,
                gridY = 2
            })})}

            local column = Column:new{initialModule = gridModule1}

            assert.are.equal(1, #column.gridModules)
            assert.are.equal(gridModule1, column.gridModules[1])
            assert.are.equal(1, column.topGridY)
            assert.are.equal(1, column.bottomGridY)

            column:addGridModule(gridModule2)

            assert.are.equal(gridModule2, column.gridModules[0])
            assert.are.equal(1, column.topGridY)
            assert.are.equal(0, column.bottomGridY)

            column:addGridModule(gridModule3)

            assert.are.equal(gridModule3, column.gridModules[2])
            assert.are.equal(2, column.topGridY)
            assert.are.equal(0, column.bottomGridY)
        end)
    end)

    describe('hasGridModule', function ()
        it('checks whether column has grid module with ggiven gridY', function ()
            local gridModule1 = GridModule:new{slot = Slot:new({id = Slot.makeId({
                type = t.PLATFORM_LEFT,
                gridX = 3,
                gridY = 1
            })})}

            local column = Column:new{initialModule = gridModule1}

            assert.is_true(column:hasGridModule(1))
            assert.is_false(column:hasGridModule(2))
        end)
    end)

    describe('getGridModule', function ()
        it ('returns gridmodule with given grid y', function ()
            local gridModule1 = GridModule:new{slot = Slot:new({id = Slot.makeId({
                type = t.PLATFORM_LEFT,
                gridX = 3,
                gridY = 1
            })})}
            local gridModule2 = GridModule:new{slot = Slot:new({id = Slot.makeId({
                type = t.PLATFORM_LEFT,
                gridX = 3,
                gridY = 0
            })})}
            local gridModule3 = GridModule:new{slot = Slot:new({id = Slot.makeId({
                type = t.PLATFORM_LEFT,
                gridX = 3,
                gridY = 2
            })})}

            local column = Column:new{initialModule = gridModule1}

            column:addGridModule(gridModule2)
            column:addGridModule(gridModule3)

            assert.are.equal(gridModule3, column:getGridModule(2))
            assert.is_nil(nil, column:getGridModule(4))
        end)
    end)

    describe('eachGridModule', function ()
        it ("execute a function for every module", function ()
            local gridModule1 = GridModule:new{slot = Slot:new({id = Slot.makeId({
                type = t.PLATFORM_LEFT,
                gridX = 3,
                gridY = 1
            })})}
            local gridModule2 = GridModule:new{slot = Slot:new({id = Slot.makeId({
                type = t.PLATFORM_LEFT,
                gridX = 3,
                gridY = 0
            })})}
            local gridModule3 = GridModule:new{slot = Slot:new({id = Slot.makeId({
                type = t.PLATFORM_LEFT,
                gridX = 3,
                gridY = -2
            })})}

            local column = Column:new{initialModule = gridModule1}

            column:addGridModule(gridModule2)
            column:addGridModule(gridModule3)

            local result = {}

            column:eachGridModule(function (gridModule)
                table.insert(result, gridModule:getGridY())
            end)

            assert.are.same({-2, 0, 1}, result)
        end)
    end)

    describe('eachWithEmpty', function ()
        local gridModule1 = GridModule:new{slot = Slot:new({id = Slot.makeId({
            type = t.PLATFORM_LEFT,
            gridX = 3,
            gridY = 1
        })})}
        local gridModule2 = GridModule:new{slot = Slot:new({id = Slot.makeId({
            type = t.PLATFORM_LEFT,
            gridX = 3,
            gridY = 0
        })})}
        local gridModule3 = GridModule:new{slot = Slot:new({id = Slot.makeId({
            type = t.PLATFORM_LEFT,
            gridX = 3,
            gridY = -2
        })})}

        local column = Column:new{initialModule = gridModule1}

        column:addGridModule(gridModule2)
        column:addGridModule(gridModule3)

        local result = {}

        column:eachWithEmpty(function (gridModule)
            if gridModule then
                table.insert(result, gridModule:getGridY())
                return
            end

            table.insert(result, 'nil')
        end)

        assert.are.same({-2, 'nil', 0, 1}, result)
    end)

    describe('getGridLength', function ()
        it ('returns total column length in grid units', function ()
            local gridModule1 = GridModule:new{slot = Slot:new({id = Slot.makeId({
                type = t.PLATFORM_LEFT,
                gridX = 3,
                gridY = 1
            })})}
            local gridModule2 = GridModule:new{slot = Slot:new({id = Slot.makeId({
                type = t.PLATFORM_LEFT,
                gridX = 3,
                gridY = 0
            })})}
            local gridModule3 = GridModule:new{slot = Slot:new({id = Slot.makeId({
                type = t.PLATFORM_LEFT,
                gridX = 3,
                gridY = -2
            })})}
            local gridModule4 = GridModule:new{slot = Slot:new({id = Slot.makeId({
                type = t.PLATFORM_LEFT,
                gridX = 3,
                gridY = -5
            })})}
            local gridModule5 = GridModule:new{slot = Slot:new({id = Slot.makeId({
                type = t.PLATFORM_LEFT,
                gridX = 3,
                gridY = 2
            })})}

            local column1 = Column:new{initialModule = gridModule1}
            column1:addGridModule(gridModule3)
            assert.are.equal(4, column1:getGridLength())

            local column2 = Column:new{initialModule = gridModule5}
            column2:addGridModule(gridModule1)
            assert.are.equal(2, column2:getGridLength())

            local column3 = Column:new{initialModule = gridModule3}
            column3:addGridModule(gridModule4)
            assert.are.equal(4, column3:getGridLength())

            local column4 = Column:new{initialModule = gridModule2}
            column4:addGridModule(gridModule3)
            assert.are.equal(3, column4:getGridLength())

            local column5 = Column:new{initialModule = gridModule2}
            column5:addGridModule(gridModule5)
            assert.are.equal(3, column5:getGridLength())
            
            local column6 = Column:new{initialModule = gridModule2}
            assert.are.equal(1, column6:getGridLength())
        end)
    end)
end)