-- Namespace
Flashback = {}
 
-- Single string to hold all data
Flashback.name = "Flashback"
 
function Flashback.OnPlayerCombatState(event, inCombat)
  -- The ~= operator is "not equal to" in Lua.
  if inCombat ~= Flashback.inCombat then
    -- The player's state has changed. Update the stored state...
    Flashback.inCombat = inCombat
 
    -- ...and then update the control.
    FlashbackIndicator:SetHidden(not inCombat)
  end
end


function Flashback.OnIndicatorMoveStop()
  Flashback.savedVariables.left = FlashbackIndicator:GetLeft()
  Flashback.savedVariables.top = FlashbackIndicator:GetTop()
end

function Flashback:RestorePosition()
  local left = self.savedVariables.left
  local top = self.savedVariables.top
 
  FlashbackIndicator:ClearAnchors()
  FlashbackIndicator:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, left, top)
end
 

function Flashback:Initialize()
  self.inCombat = IsUnitInCombat("player")
 
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_COMBAT_STATE, self.OnPlayerCombatState)
 
  self.savedVariables = ZO_SavedVars:New("FlashbackSavedVariables", 1, nil, {})
 
  self:RestorePosition()
end

function Flashback.OnAddOnLoaded(event, addonName)
  -- The event fires each time *any* addon loads - but we only care about when our own addon loads.
  if addonName == Flashback.name then
    Flashback:Initialize()
  end
end

-- Init event
EVENT_MANAGER:RegisterForEvent(Flashback.name, EVENT_ADD_ON_LOADED, Flashback.OnAddOnLoaded)