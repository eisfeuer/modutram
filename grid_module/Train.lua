local TrainClass = {}

function TrainClass:new(GridModule)
    local Train = GridModule
    Train.class = 'Train'

    function Train:isTrain()
        return true
    end

    return Train
end

return TrainClass