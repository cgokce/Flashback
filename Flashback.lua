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

---> MOVEMENT
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

-- This need to be updated at event callback
local rand_num = math.random(6)

---> TEXT UPDATES
function Flashback:UpdateQuote()
  FlashbackIndicatorLabel:SetText(Flashback.QuoteList[rand_num])
  FlashbackSource:SetText(Flashback.AuthorList[rand_num])
end
 

function Flashback:Initialize()
  self.inCombat = IsUnitInCombat("player")

  -- https://wiki.esoui.com/Events
  -- EVENT_PLAYER_DEAD 
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