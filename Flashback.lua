---> Namespace string holding all data
Flashback.name = "Flashback"
 
---> Event Callback Reverse State
function Flashback.OnPlayerCombatState(event, inCombat)
  -- The ~= operator is "not equal to" in Lua.
  if inCombat ~= Flashback.inCombat then
    -- The player's state has changed. Update the stored state...
    Flashback.inCombat = inCombat
 
    -- ...and then update the control.
    FlashbackIndicator:SetHidden(not inCombat)
  end
end

---> Position Save and Restore
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

---> TEXT UPDATES
-- Todo: Move this to the event callback


function Flashback:UpdateQuote()
  local rand_num = math.random(Flashback.QuoteCount)
  local str_size = string.len(Flashback.QuoteList[rand_num])

  FlashbackIndicatorLabel:SetText(Flashback.QuoteList[rand_num])
  FlashbackAuthorLabel:SetText("- " .. Flashback.AuthorList[rand_num])
end
 
---> OnAddonLoad Callback
function Flashback:Initialize()

  Flashback:UpdateQuote()
  self.inCombat = IsUnitInCombat("player")

  -- https://wiki.esoui.com/Events
  -- EVENT_PLAYER_DEAD 
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_COMBAT_STATE, self.OnPlayerCombatState)
 
  self.savedVariables = ZO_SavedVars:New("FlashbackSavedVariables", 1, nil, {})
 
  self:RestorePosition()
  
  -- Show coordinates
  -- FlashbackIndicatorLabel:SetText(self.savedVariables.left .. " " .. self.savedVariables.top)
end

function Flashback.OnAddOnLoaded(event, addonName)
  -- The event fires each time *any* addon loads - but we only care about when our own addon loads.
  if addonName == Flashback.name then
    Flashback:Initialize()
  end
end

-- Init event
EVENT_MANAGER:RegisterForEvent(Flashback.name, EVENT_ADD_ON_LOADED, Flashback.OnAddOnLoaded)