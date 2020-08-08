---> Namespace string holding all data
Flashback.name = "Flashback"
 
---> Event Callback Reverse State
function Flashback.OnPlayerCombatState(event, inCombat)
  --Flashback.inCombat = IsUnitDead("player")
  inCombat = IsUnitDead("player")

  --Debug the event state
  if inCombat then
    d("Entering death state.")
    d(self.savedVariables.left==nil)
    --d(self.savedVariables.top)
  else
    d("Exiting death state.")
  end

  if inCombat ~= Flashback.inCombat then
    -- The player's state has changed. Update the stored state...
    Flashback.inCombat = inCombat
    --Flashback.inCombat = IsUnitDead("player")


    -- Update visibility
    FlashbackIndicator:SetHidden(not inCombat)
    FlashbackAuthor:SetHidden(not inCombat)
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

  if left == nil then
    left = 507
    top = 126
  end

  FlashbackIndicator:ClearAnchors()
  FlashbackIndicator:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, left, top)
end


function Flashback:UpdateQuote()
  local rand_num = math.random(Flashback.QuoteCount)
  local str_size = 20/string.len(Flashback.QuoteList[rand_num])  

  -- Scaling, low cost but blurry
  -- FlashbackIndicatorLabel:SetScale(1+str_size)
  -- FlashbackAuthorLabel:SetScale(1+str_size)
  
  --FlashbackIndicatorLabel:SetText( str_size .. Flashback.QuoteList[rand_num])
  FlashbackIndicatorLabel:SetText(Flashback.QuoteList[rand_num])
  FlashbackAuthorLabel:SetText("- " .. Flashback.AuthorList[rand_num])

  local path = "EsoUI/Common/Fonts/univers67.otf"
  local outline = "soft-shadow-thin"
 
  FlashbackIndicatorLabel:SetFont(path .. "|" .. 30+10*str_size .. "|" ..  outline)
  FlashbackAuthorLabel:SetFont(path .. "|" .. 30+10*str_size .. "|" ..  outline)
  
  -- Also move author maybe later add as feature
  --local author_size = 20/string.len(Flashback.AuthorList[rand_num])
  --FlashbackAuthor.SetSimpleAnchor(FlashbackIndicator,10,-500)

end
 
---> OnAddonLoad Callback
function Flashback:Initialize()

  Flashback:UpdateQuote()
  --self.inCombat = IsUnitInCombat("player")
  self.inCombat = IsUnitDead("player")

  -- https://wiki.esoui.com/Events
  -- EVENT_PLAYER_DEAD 
  -- EVENT_UNIT_DEATH_STATE_CHANGED -- working when death happens
  -- EVENT_RESURRECT_RESULT
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_UNIT_DEATH_STATE_CHANGED, self.OnPlayerCombatState)
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_RESURRECT_RESULT, self.OnPlayerCombatState)

  --EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_DEAD, self.OnPlayerCombatState)

  self.savedVariables = ZO_SavedVars:New("FlashbackSavedVariables", 1, nil, {})
 
  self:RestorePosition()
  
  --FlashbackIndicator:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, 507, 126)

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