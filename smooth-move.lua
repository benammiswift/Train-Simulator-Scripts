-------------------------------------------------------
-- BENAMMI SWIFT - SMOOTH MOVE SCRIPT
--
-- Smoothly moves a value toward a target over time.
--
-- deltaTime – Time since the last update.
-- currentValue – The current value.
-- targetValue – The value to move toward.
-- increaseSpeedMultiplier – Speed used when increasing toward the target.
-- decreaseSpeedMultiplier – Speed used when decreasing toward the target.
--
-- Returns the new value after moving toward the target without overshooting it.
-------------------------------------------------------

function smoothMove(deltaTime, currentValue, targetValue, increaseSpeedMultiplier, decreaseSpeedMultiplier)
    if currentValue < targetValue then
        return math.min(currentValue + deltaTime * increaseSpeedMultiplier, targetValue)
    elseif currentValue > targetValue then
        return math.max(currentValue - deltaTime * decreaseSpeedMultiplier, targetValue)
    end
    return currentValue
end
