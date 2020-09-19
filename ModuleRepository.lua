local t = require('modutram.types')

local ModuleRepository = {}

function ModuleRepository.makePatternFor(moduleType, namespace)
    local pattern = '^modutram'

    if namespace then
        pattern = pattern .. '_' .. namespace
    end

    pattern = pattern .. '_' .. string.lower(moduleType)

    if moduleType == 'ASSET' or moduleType == 'DECORATION' then
        return pattern
    end

    return pattern .. '_[0-9][0-9]*cm$'
end

function ModuleRepository.isModutramItem(repositoryItem, namespace)
    for moduleType in pairs(t) do
        if string.match(repositoryItem.type, ModuleRepository.makePatternFor(moduleType, namespace)) then
            return true
        end
    end

    return false
end

return ModuleRepository