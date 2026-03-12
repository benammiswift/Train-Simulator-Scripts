-------------------------------------------------------
-- BENAMMI SWIFT - TAIL LIGHT SCRIPT
--
-- A simple script for driving tail light functionality on a wagon
-- Intended to be configurable, requires a tail light child object front and back.
-- Then you can add the node name of your lit node (and an optional light emitter child) then you're off 
-------------------------------------------------------

-------------------------------------------------------
-- CONFIGURATION
-------------------------------------------------------

-- Tail lamp child objects
TAIL_CHILD_1 = "TailLamp_Front"
TAIL_CHILD_2 = "TailLamp_Rear"

-- Glow nodes
LIGHT_NODE_1 = "tail_glow_front"
LIGHT_NODE_2 = "tail_glow_rear"

-- Light emitters
LIGHT_EMITTER_1 = "TailEmitterFront"
LIGHT_EMITTER_2 = "TailEmitterRear"

-- Flash timing
ON_TIME  = 0.6
OFF_TIME = 0.6

-------------------------------------------------------
-- MESSAGE ID
-------------------------------------------------------

MSG_PROBE = 2001

-------------------------------------------------------
-- INTERNAL STATE
-------------------------------------------------------

gConsistLength = 0

gFlashTimer = 0
gFlashState = false

gFrontActive = false
gRearActive = false

-------------------------------------------------------
-- UPDATE LOOP
-------------------------------------------------------

function Update(time)

    ---------------------------------------------------
    -- detect consist length change
    ---------------------------------------------------

    local newLength = Call("*:GetConsistLength")

    if newLength ~= gConsistLength then

        gConsistLength = newLength
        ProbeEnds()

    end

    ---------------------------------------------------
    -- flashing logic
    ---------------------------------------------------

    if not gFrontActive and not gRearActive then
        return
    end

    gFlashTimer = gFlashTimer - time

    if gFlashTimer <= 0 then

        gFlashState = not gFlashState
        gFlashTimer = gFlashState and ON_TIME or OFF_TIME

        SetLampState(
            gFrontActive and gFlashState,
            gRearActive and gFlashState
        )

    end

end

-------------------------------------------------------
-- CONSIST PROBE
-------------------------------------------------------

function ProbeEnds()

    ---------------------------------------------------
    -- probe forward
    ---------------------------------------------------

    local frontResult =
        Call("*:SendConsistMessage", MSG_PROBE, "", 0)

    ---------------------------------------------------
    -- probe backward
    ---------------------------------------------------

    local rearResult =
        Call("*:SendConsistMessage", MSG_PROBE, "", 1)

    ---------------------------------------------------
    -- determine end vehicles
    ---------------------------------------------------

    gFrontActive = (frontResult == 0)
    gRearActive  = (rearResult == 0)

    ---------------------------------------------------
    -- reset flashing state
    ---------------------------------------------------

    gFlashState = true
    gFlashTimer = ON_TIME

    SetLampState(gFrontActive, gRearActive)

end

-------------------------------------------------------
-- CONSIST MESSAGE HANDLER
-------------------------------------------------------

function OnConsistMessage(message, content, direction)

    if message == MSG_PROBE then
        return
    end

end

-------------------------------------------------------
-- LAMP CONTROL
-------------------------------------------------------

function SetLampState(frontState, rearState)

    local f = frontState and 1 or 0
    local r = rearState and 1 or 0

    ---------------------------------------------------
    -- FRONT LAMP
    ---------------------------------------------------

    Call("ActivateNode", TAIL_CHILD_1 .. ":all", f)
    Call("ActivateNode", LIGHT_NODE_1, f)
    Call("SetLightState", LIGHT_EMITTER_1, f)

    ---------------------------------------------------
    -- REAR LAMP
    ---------------------------------------------------

    Call("ActivateNode", TAIL_CHILD_2 .. ":all", r)
    Call("ActivateNode", LIGHT_NODE_2, r)
    Call("SetLightState", LIGHT_EMITTER_2, r)

end
