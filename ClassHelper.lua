

local ClassHelperFrame = CreateFrame("Frame")
local ClassFrame
local ACTIVE_BUFFS = {}

ClassHelperFrame:RegisterEvent("PLAYER_LOGIN")
ClassHelperFrame:SetScript("OnEvent", function(self, ...) 
		local _, engClass, _ = UnitClass("player")
		ClassFrame = CreateFrame("Frame")

		if (engClass == "PRIEST") then
			print("Priest: OK")
			ACTIVE_BUFFS = { Voidform=0 }
			ClassFrame:RegisterEvent("UNIT_AURA","player")
			ClassFrame:SetScript("OnEvent", PriestHelper)
		else
			print("|cffff0000 Mads: Unsupported class for ClassHelper. Terminates.")
			return
		end
	

end)


function PriestHelper(self, event, ...) 
	local unit = ...
	if (event == "UNIT_AURA" and unit == "player") then
	
	
		-- VOIDFORM HANDLER
		local name, _, _, count = UnitBuff(unit, "Voidform")
		if (count) then
			if(ACTIVE_BUFFS["Voidform"] ~= count) then
				ACTIVE_BUFFS["Voidform"] = count
				if (count > 19 and (count % 5 == 0)) then
					RaidNotice_AddMessage(RaidWarningFrame,"Voidform has "..count.." stacks!",ChatTypeInfo["RAID_WARNING"])
					PlaySound("888") -- DING
				end
			end
		elseif (ACTIVE_BUFFS["Voidform"] ~= 0) then
			ACTIVE_BUFFS["Voidform"] = 0
			PlaySound("11466") -- YOU ARE NOT PREPARED. LOL.
			RaidNotice_AddMessage(RaidWarningFrame,"Voidform has ended!",ChatTypeInfo["RAID_WARNING"])
		end
	end
end