

local EventFrame = CreateFrame("Frame")

EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
EventFrame:SetScript("OnEvent", function(self, event, ...)
	local isInstance, type = IsInInstance()
	if (isInstance) then
		local name, type, difficulty, difficultyName, 
			maxPlayers, playerDifficulty, isDynamicInstance, 
			mapID, instanceGroupSize = GetInstanceInfo()
		if (difficulty == 8) then -- Is challenge mode
			local ksLvl, v2, v3, v4,v5,v6,v7 = C_ChallengeMode.GetActiveKeystoneInfo(); -- arg1, arg2, arg3 = lvl, no. players?, charged/depleted?
			print("!!!  CHALLENGE  !!!")
			print("Level: "..ksLvl)
			print(v2)
			for k,v in pairs(v2) do
				print(k,v)
			end
			print("-")
			print(v3)
			print(v4)
			print(v5)
			print(v6)
			print(v7)
			print("-------")
		end
		--print("name: "..name)
		--print("type: "..type)
		--print("difficulty: "..difficulty)
		--print("difficultyName: "..difficultyName)
		--print("maxPlayers: "..maxPlayers)
		--print("playerDifficulty: "..playerDifficulty)
		--print("isDynamicInstance: "..tostring(isDynamicInstance))
		--print("mapID: "..mapID)
		--print("instanceGroupSize: "..instanceGroupSize)
	end

end)

local ChallengeFrame = CreateFrame("Frame")

ChallengeFrame:RegisterEvent("CHALLENGE_MODE_START")
ChallengeFrame:SetScript("OnEvent", function(self, event, ...)

	print("Challenge: START")

end)

function checkInstance()
	local isInstance, type = IsInInstance()
	
	
	if (isInstance and isDungeon(type)) then
	
	end
end

function isDungeon(type)
	if (type == "party") then
		return true
	else
		return false
	end
end

