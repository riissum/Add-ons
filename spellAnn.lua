-- Battle res not implemented.
-- Hunter Pets res not implemented.
local EventFrame = CreateFrame("Frame");

EventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
EventFrame:SetScript("OnEvent", function(self, event, ...)
	local timestamp, type, hideCaster, sourceGUID, sourceName, 
		sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
		
	local resSingSpells = buildSet { 2006, 2008, 7328, 115178, 50769 }
	-- { Resurrection, Ancestral Spirit, Redemption, Resuscitate, Revive }
	local resMassSpells = buildSet { 212036, 212048, 212056, 212051, 212040 } 
	-- { Mass Resurrection, Ancestral Vision, Absolution, Reawaken, Revitalize } 
	-- local resCombSpells = BuildSet { 20484, 61999 } 
	-- Rebirth, Raise ally, IMPL HUNTER PET RES

	if (event == "COMBAT_LOG_EVENT_UNFILTERED") then

		if(sourceName == UnitName("player")) then

			if (type == "SPELL_CAST_START") then
				local spellId, spellName, spellSchool = select(12, ...)
				
				if (resSingSpells[spellId]) then resAnn(spellId, destName, false)						
				elseif (resMassSpells[spellId]) then resAnn(spellId, nil, false) end
				
			elseif (type == "SPELL_CAST_SUCCESS") then
				local spellId, spellName, spellSchool = select(12, ...)
				
				if (resSingSpells[spellId]) then resAnn(spellId, destName, true)
				elseif (resMassSpells[spellId]) then resAnn(spellId, nil, true)	end
				
			elseif (type == "SPELL_INTERRUPT") then
				local spellId, spellName, spellSchool, xSpellId, xSpellName, xSpellSchool = select(12, ...)

				intrAnn(xSpellId, destName)
				
			end
			
		end
		
	end
	
end);


-- Takes a list { a, b, c } and returns a set { a=true, b=true, c=true }
function buildSet(L)
	local set = {}
	
	for _, l in ipairs(L) do
		set[l] = true
	end
	
	return set
end


function resAnn(spellId, target, done)
	local lang, lnk = GetDefaultLanguage("player"),GetSpellLink(spellId)
	local str, chnl = nil
	
	if(target == nil) then
		str = ternaryIf(done, "Rise, All!", ("Casting: "..lnk.."!"))
		chnl = "YELL"
	else
		str = ternaryIf(done, ("Rise, "..target.."!"), ("Casting: "..lnk.."!"))
		chnl = ternaryIf(done, "YELL", "WHISPER")
	end
	SendChatMessage(str,chnl,lang,chnl)
end

function intrAnn(spellId, target)
	local lnk,l = GetSpellLink(spellId),GetDefaultLanguage("player")
	local str = "I interrupted "..target.."'s "..lnk.."!"
			
	SendChatMessage(str,"SAY",l,"SAY")
end

function ternaryIf(cond, a, b)
	if cond then
		return a
	else
		return b
	end
end