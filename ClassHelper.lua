

local ClassHelperFrame = CreateFrame("Frame")
local ClassFrame
local ACTIVE_BUFFS = {}

ClassHelperFrame:RegisterEvent("PLAYER_LOGIN")
ClassHelperFrame:SetScript("OnEvent", function(self, ...) 
		local _, engClass, _ = UnitClass("player")
		ClassFrame = CreateFrame("Frame")
		local currentSpec = GetSpecialization()
		local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec)) or "None"

		if (engClass == "PRIEST") then
		
			print("|cff00daecClassHelper: |cff00ff00OK. |cffffffff("..currentSpecName.." Priest)")
			ACTIVE_BUFFS = { Voidform=0 }
			ClassFrame:RegisterEvent("UNIT_AURA","player")
			ClassFrame:SetScript("OnEvent", PriestHelper)
			
		elseif (engClass == "PALADIN") then
		
			print("|cff00daecClassHelper: |cff00ff00OK. |cffffffff("..currentSpecName.." Paladin)")
			ClassFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) PaladinHelperBuffs(sinceLastUpdate); end)
			
		elseif (engClass == "DRUID") then
		
			print("|cff00daecClassHelper: |cff00ff00OK. |cffffffff("..currentSpecName.." Druid)")
			if (currentSpecName == "Feral") then
				ClassFrame:RegisterEvent("UNIT_POWER")
				ClassFrame:SetScript("OnEvent", DruidHelper)
				ClassFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) DruidHelperNotify(sinceLastUpdate); end)
			end
			
		else
			print("|cff00daecClassHelper: Terminated.")
			return
		end
	

end)

local timeSinceLastAnnounce = { A=1000, B=1000 }
local alertPower = false

function DruidHelper(self, event, ...)

	-- Helper for Feral, Checks for 5 combopoints
	if (event == "UNIT_POWER") then
		local comboPoints = UnitPower("player", 4)
		if(comboPoints == 5) then
			alertPower = true
		else
			alertPower = false
		end
	end

end

function DruidHelperNotify(sinceLastUpdate)
	-- timeSinceLastAnnounce[A] = UNIT_POWER
	timeSinceLastAnnounce[A] = timeSinceLastAnnounce[A] + sinceLastUpdate
	local willPlay, soundHandle
	
	if (timeSinceLastAnnounce[A] >= 3 and alertPower) then
		willPlay, soundHandle = PlaySoundFile("Interface\\AddOns\\git_Mads\\sounds\\Growl.ogg")
	else
		StopSound(soundHandle)
	end
end

function PaladinHelperBuffs(SLU) 
	local ACTIVE_BUFFS = { A="Greater Blessing of Wisdom", B="Greater Blessing of Kings" }
	
	for k,v in pairs(ACTIVE_BUFFS) do
		local _, _, _, count = UnitBuff("player", v)
		timeSinceLastAnnounce[k] = timeSinceLastAnnounce[k] + SLU
		local tt
		if (count) then
			if (timeSinceLastAnnounce[k] >= 60) then
				tt = date("[%H:%M]", time())
				print(tt..": "..v.." Buff ok.")
				timeSinceLastAnnounce[k] = 0
			end
		elseif (count == nil) then
			if (timeSinceLastAnnounce[k] >= 60) then
				tt = date("[%H:%M]", time())
				print(tt..": "..v.." Buff missing.")
				timeSinceLastAnnounce[k] = 0
			end
		end
	end
end

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