local AddOn, mads = ...

SLASH_MADS1, SLASH_MADS2 = '/mads', '/MADS'
local eq = equipment
MY_HELPER = { HELP="/mads help to list all functions available", SHOW="/mads show - Show UI", HIDE="/mads hide - Hide UI", DUR="/mads dur - Shows durability of your gear. -all shows details.", TIME="/mads time - Show time left for completion of Mythic Keystone. -p prints to party." }


function handler(msg, editbox)
	local temp = msg
	local msgList = {}
	local eq

	if (msg == nil or msg == "") then return 0 end
	
	msgList = splitStr(msg, " ")
	
	if (msgList[0] == 'show') then
		MadsFrame:Show()
	elseif (msgList[0] == 'hide') then
		MadsFrame:Hide()
	elseif (msgList[0] == 'dur') then
		if (msgList[1] == '-all') then
			checkDurability(true)
		else
			checkDurability(false)
		end
	elseif (msgList[0] == 'time') then
		if(msgList[1] == '-p') then
			printTimeLeft("PARTY")
		elseif(msgList[1] == '-t') then
			if(msgList[2] == 's') then
				KeystoneFrame:Show()
			elseif(msgList[2] == 'h') then
				KeystoneFrame:Hide()
			else
				KeystoneFrame_TimeString:SetText(msgList[2])
			end
		else
			printTimeLeft()
		end
	elseif (msgList[0] == 'help') then
		print("|cffff0000 Mads: Help me.")
		slashHelp()
	else
		print("|cffff0000 Mads: Unknown command.")
		print("Type '/mads help' for a list of functions")
	end
end
SlashCmdList["MADS"] = handler;

function slashHelp() 
	for k,v in pairs(MY_HELPER) do
		print(v)
	end
end


function printTimeLeft(target)
	local timeTo3, timeTo2, timeTo1, overtime = getTimeLeft()
	local TARGETS = {PARTY=true}
	
	if(timeTo3 and timeTo2 and timeTo1) then
		str = format("Time: 3+ -> %s || 2+ -> %s || 1+ -> %s.", timeTo3, timeTo2, timeTo1) 
	elseif (timeTo2 and timeTo1) then
		str = format("Time: 2+ -> %s || 1+ -> %s.", timeTo2, timeTo1) 
	elseif (timeTo1) then
		str = format("Time: 1+ -> %s.", timeTo1) 
	elseif (overtime) then
		str = "Time expired! Overtime: "..overtime.."."
	else
		print("|cffff0000 Mads: No active Keystone.")
		print(MY_HELPER["TIME"])
		return
	end
	
	if (TARGETS[target]) then
		SendChatMessage(str, target, GetDefaultLanguage("player"), target)
	elseif (target == nil) then
		print(str)
	else
		print("|cffff0000 Mads: Invalid target.")
		print(MY_HELPER["TIME"])
		return
	end
	
	
end


--[===[ Some Table Structure for handeling the command arguments ]===]--

local splitStrList = {}
local _next = 0

function splitStr(str, splitAt)
	resetTable()
	return splitStrFunc(str, splitAt)
end

function splitStrFunc(str, splitAt)
	for i=1, #str do
		local c = string.sub(str, i,i)
		if (c == splitAt) then
			local a = string.sub(str, 1, i-1)
			insertTable(splitStrList, a)
			local r = string.sub(str, i+1)
			
			return splitStrFunc(r, splitAt)
		end
	end
	insertTable(splitStrList, str)
	return splitStrList
end

function insertTable(t, e)
	t[_next] = e;
	_next = _next + 1; 
end

function resetTable()
	splitStrList = {}
	_next = 0
end