local t = require('modutram.types')

local ModuleRepository = {}

function ModuleRepository.makePrefixPattern(namespace)
    if namespace then
        return '^modutram_' .. namespace
    end

    return '^modutram'
end

function ModuleRepository.makePatternFor(moduleType, namespace)
    local pattern = ModuleRepository.makePrefixPattern(namespace) .. '_' .. string.lower(moduleType)

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

function ModuleRepository.convertModule(repositoryItem, namespace)
    local slotTypeWithoutPrefix = string.match(repositoryItem.type, ModuleRepository.makePrefixPattern(namespace) .. '_([a-z0-9_]*)')
    local moduleType, widthInCm = string.match(slotTypeWithoutPrefix, '(.*)_([0-9][0-9]*)cm$')

    moduleType = moduleType or string.match(slotTypeWithoutPrefix, '^asset') or string.match(slotTypeWithoutPrefix, '^decoration')

    return {
        namespace = namespace,
        slotType = repositoryItem.type,
        type = t[string.upper(moduleType)],
        widthInCm = widthInCm and tonumber(widthInCm)
    }
end

return ModuleRepository