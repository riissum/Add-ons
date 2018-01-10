SLASH_MADS1, SLASH_MADS2 = '/mads', '/MADS'

local function handler(msg, editbox)
	if (msg == 'show' or msg == 'SHOW') then
		MadsFrame:Show()
		print("|cffffff00 MadsFrame:Show()")
	elseif (msg == 'hide' or msg == 'HIDE') then
		MadsFrame:Hide()
		print("|cffffff00 MadsFrame:Hide()")
	else
		print("|cffff0000 Mads: Unknown command.")
		print("/mads show - Show UI")
		print("/mads hide - Hide UI")
	end
end
SlashCmdList["MADS"] = handler;





