
local arenaFrame = CreateFrame("Frame")

arenaFrame:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
arenaFrame:SetScript("OnEvent", function(self, event, ...) 
	local hmm = ...
	--SendChatMessage("Kimsemus", "PARTY", GetDefaultLanguage("player"), "PARTY")
	print(...)
	

end)
