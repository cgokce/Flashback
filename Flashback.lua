-- Namespace
Flasback = {}
 
-- Single string to hold all data
Flasback.name = "Flasback"
 
function Flasback.OnPlayerCombatState(event, inCombat)
  -- The ~= operator is "not equal to" in Lua.
  if inCombat ~= Flasback.inCombat then
    -- The player's state has changed. Update the stored state...
    Flasback.inCombat = inCombat
 
    -- ...and then update the control.
    FlasbackIndicator:SetHidden(not inCombat)
  end
end


function Flasback.OnIndicatorMoveStop()
  Flasback.savedVariables.left = FlasbackIndicator:GetLeft()
  Flasback.savedVariables.top = FlasbackIndicator:GetTop()
end

function Flasback:RestorePosition()
  local left = self.savedVariables.left
  local top = self.savedVariables.top
 
  FlasbackIndicator:ClearAnchors()
  FlasbackIndicator:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, left, top)
end
 

function Flasback:Initialize()
  self.inCombat = IsUnitInCombat("player")
 
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_COMBAT_STATE, self.OnPlayerCombatState)
 
  self.savedVariables = ZO_SavedVars:New("FlasbackSavedVariables", 1, nil, {})
 
  self:RestorePosition()
end