TIME_TO_3 = 0.6
TIME_TO_2 = 0.8

local KEYSTONE_ACTIVE = false
local PLAYER_DEATHS = { }
local KEYSTONE_LEVEL 
local KEYSTONE_DUNGEON
local ChallengeFrame = CreateFrame("Frame")
local DeathCountFrame = CreateFrame("Frame")
-- Also registers COMBAT_LOG_UNFILTERED is started with ChallengeFrame_OnEvent()

ChallengeFrame:RegisterEvent("CHALLENGE_MODE_START")
ChallengeFrame:RegisterEvent("CHALLENGE_MODE_COMPLETED")
ChallengeFrame:RegisterEvent("WORLD_STATE_TIMER_START")

ChallengeFrame:SetScript("OnEvent", function(self, event, ...)
	if (event == "CHALLENGE_MODE_START") then

		DeathCountFrame:RegisterEvent("COMBAT_LOG_UNFILTERED")
		DeathCountFrame:SetScript("OnEvent", DeathCountFrame_OnEvent)

	elseif (event == "CHALLENGE_MODE_COMPLETED") then
	
		DeathCountFrame:UnregisterEvent("COMBAT_LOG_UNFILTERED")
		KEYSTONE_ACTIVE = false
		
	elseif (event == "WORLD_STATE_TIMER_START") then
		local mapID = C_ChallengeMode.GetActiveChallengeMapID()
		local name, _, timeLimit, _ = C_ChallengeMode.GetMapInfo(mapID)
		local ksLvl, affixIDs, charged = C_ChallengeMode.GetActiveKeystoneInfo();
		KEYSTONE_DUNGEON = name
		KEYSTONE_LEVEL = ksLvl
		print("Mythic keystone started. Good luck!")
		print(name.." (+"..ksLvl..")")
		print("Timelimit: "..toTimeFormat(timeLimit))
		if (KEYSTONE_ACTIVE ~= true) then
			KEYSTONE_ACTIVE = true
			PLAYER_DEATHS = { }
		end
		
	end
end)

function getKeystoneDungeon()
	if (KEYSTONE_ACTIVE) then
		return KEYSTONE_DUNGEON
	end
	return nil;
end
function getKeystoneLevel()
	if (KEYSTONE_ACTIVE) then
		return KEYSTONE_LEVEL
	end
	return nil;
end

function DeathCountFrame_OnEvent(self, event, ...)
	local timestamp, type, hideCaster, sourceGUID, sourceName, 
		sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
		
	if (event == "COMBAT_LOG_UNFILTERED") then
		if (type == "UNIT_DIED") then
			--local recapID, unconsciousOnDeath = select(12, ...)
			print(destName.." just died..")
		end
	end

end



function toTimeFormat(V)
	if (type(V) == "number") then
		if (V <= 0) then -- If time has run out, we dont care. Display 00:00.
			return "00:00"
		else
			local minutes = floor(V / 60)
			local seconds = (V - (minutes*60))
			return string.format("%02d:%02d", minutes, seconds)
		end
	else -- If it not a number we dont care.
		return false
	end
end

function toTimeFormatMilis(V)
	if (type(V) == "number") then
		if (V <= 0) then -- If time has run out, we dont care. Display 00:00.
			return "00:00"
		else
			local minutes = floor(V / 60)
			local seconds = floor(V - (minutes*60))
			local milis = roundMilis((V - seconds - minutes*60))*10
			
			local secmil
			if (milis >= 10) then
				secmil = string.format("%02d.%01d",seconds,0)
			else
				secmil = string.format("%02d.%01d",seconds,milis)
			end
			return string.format("%02d:%s", minutes, secmil)
		end
	else -- If it not a number we dont care.
		return false
	end
end

function roundMilis(num)
  local mult = 10^(1 or 0)
  return math.floor(num * mult + 0.5) / mult
end

--[==[ SOME FUNCTION GO THRU ALL TIMERIDS, NO USE, TIMERID OF M+ IS ALWAYS *1*.
function testTimers()
	local timers = GetWorldElapsedTimers()
	
	for i = 1, select("#", timers) do
		local timerID = select(i, timers);
		local _, elapsedTime, type = GetWorldElapsedTime(timerID)
		local mapID = C_ChallengeMode.GetActiveChallengeMapID()
		local name, _, timeLimit, _ = C_ChallengeMode.GetMapInfo(mapID)
		print(format("TimerID: %d, of type %s with remaining of %d time.", timerID, type, toTimeFormat(timeLimit-elapsedTime)))
	end
	
end 
]==]--

function getTimerID()
	local timers = GetWorldElapsedTimers()
	
	for i = 1, select("#", timers) do
		local timerID = select(i, timers);
		local _, _, type = GetWorldElapsedTime(timerID);
		if (type == 2) then
			return timerID
		end
	end
	return false
end

function getTimeLeft()
	local timerID = getTimerID()
	local timeTo3, timeTo2, timeTo1, overtime = false
	if (timerID) then
		local mapID = C_ChallengeMode.GetActiveChallengeMapID()
		local _, elapsedTime, _ = GetWorldElapsedTime(timerID)
		local _, _, timeLimit, _ = C_ChallengeMode.GetMapInfo(mapID)
		
		if (elapsedTime < (timeLimit*TIME_TO_3)) then
		
			timeTo3 = ((timeLimit*TIME_TO_3)-elapsedTime)
			timeTo2 = ((timeLimit*TIME_TO_2)-elapsedTime)
			timeTo1 = ((timeLimit)-elapsedTime)

		elseif (elapsedTime < (timeLimit*TIME_TO_2)) then
		
			timeTo2 = ((timeLimit*TIME_TO_2)-elapsedTime)
			timeTo1 = ((timeLimit)-elapsedTime)

		elseif (elapsedTime < timeLimit) then

			timeTo1 = ((timeLimit)-elapsedTime)
			
		else
			overtime = (-1)*(timeLimit-elapsedTime)
		end

		timeTo3 = toTimeFormat(timeTo3)
		timeTo2 = toTimeFormat(timeTo2)
		timeTo1 = toTimeFormat(timeTo1)
		overtime = toTimeFormat(overtime)
		return timeTo3, timeTo2, timeTo1, overtime
	end
	return -1
end