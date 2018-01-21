local AddOn, mads = ...

local EQUIPMENT_SLOT_NAMES = { "HeadSlot", "NeckSlot", "ShoulderSlot", 
						"BackSlot", "ChestSlot", "ShirtSlot", 
						"TabardSlot", "WristSlot", "HandsSlot", 
						"WaistSlot", "LegsSlot", "FeetSlot", 
						"Finger0Slot", "Finger1Slot", "Trinket0Slot", 
						"Trinket1Slot", "MainHandSlot", "SecondaryHandSlot" }
local MAXIMUM_DURABILITY_ALL = 0
local CURRENT_DURABILITY_ALL = 0

function checkDurability(inDetails)
	MAXIMUM_DURABILITY_ALL = 0
	CURRENT_DURABILITY_ALL = 0
	
	for i,v in ipairs(EQUIPMENT_SLOT_NAMES) do
		checkDurabilityItem(v, inDetails)
	end
	local per = floor( (CURRENT_DURABILITY_ALL / MAXIMUM_DURABILITY_ALL) * 100 )
	print("|n |cff89cff0Durability:   "..per.."%   ("..CURRENT_DURABILITY_ALL.."\\"..MAXIMUM_DURABILITY_ALL..").")
end

function checkDurabilityItem(item, inDetails)
	local slotID, _, _ = GetInventorySlotInfo(item)
	local curDur, maxDur = GetInventoryItemDurability(slotID)

	if (maxDur ~= nil) then
		CURRENT_DURABILITY_ALL = CURRENT_DURABILITY_ALL + curDur
		MAXIMUM_DURABILITY_ALL = MAXIMUM_DURABILITY_ALL + maxDur
		local perDur = floor( (curDur / maxDur) * 100 )
		if(inDetails) then
			local icon 
			if(perDur == 0) then
				icon = "\124TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:12\124t  "
			elseif(perDur < 25) then
				icon = "\124TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:12\124t  "
			else
				icon = "      "
			end
			print(icon.."|cff89cff0"..item..":   "..perDur.."%   ("..curDur.."\\"..maxDur..")")
		end
	end
end