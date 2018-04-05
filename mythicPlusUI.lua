

KeystoneFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) timerUpdater(sinceLastUpdate); end)

local GoOrNah = false
Time1 = 130;
local OT = false

function timerUpdater(SLU)
	if (GoOrNah) then
		Time1 = Time1 - SLU
		--Time3, Time2, Time1, OT = getTimeLeft()
		--ksLvl, dung = getKeystoneLevel(), getKeystoneDungeon()
		ksLvl = 14;
		if(Time3 ~= nil) then
			potentialLvl = ksLvl + 3
		elseif(Time2 ~= nil) then
			potentialLvl = ksLvl + 2
			KeystoneFrame_TimeMark3String:SetTextColor(1,0,0,1)
		elseif(Time1 ~= nil) then
			potentialLvl = ksLvl + 1
			KeystoneFrame_TimeMark3String:SetTextColor(1,0,0,1)
			KeystoneFrame_TimeMark2String:SetTextColor(1,0,0,1)
		else
			potentialLvl = ksLvl - 1
			OT = true
			KeystoneFrame_TimeMark3String:SetTextColor(1,0,0,1)
			KeystoneFrame_TimeMark2String:SetTextColor(1,0,0,1)
			KeystoneFrame_TimeMark1String:SetTextColor(1,0,0,1)
			KeystoneFrame_TimeString:SetTextColor(1,0,0,1)
		end
		KeystoneFrame_NextLevelString:SetText("-> "..potentialLvl);
		
		
		if(OT) then
			KeystoneFrame_TimeString:SetText(OT)
		else
			KeystoneFrame_TimeString:SetText(Time1)
		end
	end
	KeystoneFrame_TimeString:SetText(toTimeFormatMilis(Time1))
	if(OT) then KeystoneFrame_OverTimeString:Show() end
end

function toggleTimeTest()

	if GoOrNah then
		GoOrNah = false
	else
		GoOrNah = true
	end

end
