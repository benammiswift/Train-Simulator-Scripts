-------------------------------------------------------
-- BENAMMI SWIFT - CONFIGURABLE THROTTLE NOTCH SCRIPT
--
-- A configurable throttle smoothing and notch system.
-- Allows defining any number of throttle notches using a table
-- of catch ranges and target positions.
--
-- When the driver moves the throttle into a defined range,
-- the script smoothly snaps the control to the configured
-- notch position. Outside these ranges the throttle moves
-- freely without snapping.
--
-- Intended to make it easy to implement realistic detents
-- such as idle, run notches, or centre catches without
-- hard-coding logic into the script.
-------------------------------------------------------

--=====================================================
-- CONFIGURATION
--=====================================================

-- Movement speeds
notchUpMultiplier = 0.5
notchDownMultiplier = 0.5

-- Define notch catch ranges
-- min = lower bound of catch range
-- max = upper bound of catch range
-- target = position the control snaps to
notches = {
    { min = -0.099, max = 0.099, target = 0 }, -- centre notch
    --{ min = 0.45, max = 0.55, target = 0.5 },
    --{ min = 0.9,  max = 1.0,  target = 1.0 }
}


--=====================================================
-- STATE VARIABLES
--=====================================================

oldVirThrottle = 0
virThrottleTarget = 0


--=====================================================
-- HELPER FUNCTIONS
--=====================================================

-- Find a notch target if the value is inside a catch range
function getNotchTarget(value)

    for _, notch in ipairs(notches) do
        if value >= notch.min and value <= notch.max then
            return notch.target
        end
    end

    return value -- no notch, free movement
end


-- Smoothly move current value toward target
function smoothMove(deltaTime, currentValue, targetValue, increaseSpeedMultiplier, decreaseSpeedMultiplier)

    if currentValue < targetValue then
        return math.min(currentValue + deltaTime * increaseSpeedMultiplier, targetValue)

    elseif currentValue > targetValue then
        return math.max(currentValue - deltaTime * decreaseSpeedMultiplier, targetValue)
    end

    return currentValue
end


-- Update throttle logic
function updateThrottle(currentValue, oldValue, targetValue)

    if currentValue ~= oldValue then
        -- Determine target from notch table
        targetValue = getNotchTarget(currentValue)
    else
        -- Move toward the target
        currentValue = smoothMove(time, currentValue, targetValue, notchUpMultiplier, notchDownMultiplier)
    end

    return currentValue, targetValue
end


--=====================================================
-- THROTTLE UPDATE (This goes in update() somewhere)
--=====================================================

virThrottle, virThrottleTarget =
    updateThrottle(virThrottle, oldVirThrottle, virThrottleTarget)

oldVirThrottle = virThrottle
