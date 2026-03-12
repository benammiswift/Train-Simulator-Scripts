-------------------------------------------------------
-- BENAMMI SWIFT - CONTROL VALUE INITIALISATION SCRIPT
--
-- A simple script section to safely initialise the state of a control value on load
-- This is not intended to be used verbatim, it's a section for you to take ideas from :-)
-------------------------------------------------------

function Update(dt)

    local CurrentSimTime = Call("GetSimulationTime");

    if CurrentSimTime < 0.5 then
        EarlySetup();
    end
end

function EarlySetup()

    -- Use this to snap the CV to the target value instantly
    Call("SetControlValue", "UserVirtualReverser", 0, 0);

     -- Use this to make the game move the control smoothly (speed is dictated by the sensitiviy of the CV in the Blueprint)
    Call("SetControlTargetValue", "UserVirtualReverser", 0, 0);
end
