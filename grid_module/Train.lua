local TrainClass = {}

function TrainClass:new(GridModule)
    local Train = GridModule
    Train.class = 'Train'

    return Train
end

return TrainClass