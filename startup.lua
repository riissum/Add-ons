local frame = CreateFrame("FRAME", "Mads AddOn")

frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event, ...)
	RaidNotice_AddMessage(RaidWarningFrame,"Welcome back, " .. UnitName("player") .. "!",ChatTypeInfo["RAID_WARNING"])
	KeystoneFrame:Show()
end)
