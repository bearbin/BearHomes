-- Copyright (c) 2013 Alexander Harkness

-- Permission is hereby granted, free of charge, to any person obtaining a
-- copy of this software and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, sublicense, and/or sell copies of the Software, and to
-- permit persons to whom the Software is furnished to do so, subject to
-- the following conditions:

-- The above copyright notice and this permission notice shall be included
-- in all copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
-- OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
-- IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
-- CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
-- TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
-- SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

function IsSpecial(homeName)

	-- Test to see if home name is one of the subcommands, and therefore unreachable.
	if (homeName == "list") or (homeName == "main") or (homeName == "delete") or (homeName == "player") or (homeName == "set") then
		-- Home is called one of the subcommands.
		return true
	else
		-- Home is not special, just normal and ready for use.
		return false
	end

end

function CanSetHome(Player)

	-- List homes of players, ready to see how many they have.
	local success, errorMsg, homeList = HHANDLE.list(Player:GetName())

	if not success then
		return false
	end	

	-- Count the homes.
	local homeNumber = #homeList

	-- Check permissions.
	if Player:HasPermission("bearhomes.home.set.multiple.1") then

		if homeNumber < MULTIHOME[1] then
			return true
		end

	end

	if Player:HasPermission("bearhomes.home.set.multiple.2") then

		if homeNumber < MULTIHOME[2] then
			return true
		end

	end

	if Player:HasPermission("bearhomes.home.set.multiple.3") then

		if homeNumber < MULTIHOME[3] then
			return true
		end

	end

	if Player:HasPermission("bearhomes.home.set.multiple.4") then

		if homeNumber < MULTIHOME[4] then
			return true
		end

	end

	if Player:HasPermission("bearhomes.home.set.multiple.5") then

		if homeNumber < MULTIHOME[5] then
			return true
		end

	else

		if homeNumber == 0 then
			return true
		else
			return false
		end

	end

end

function HandleHomeCommand(Split, Player)

	if Split[2] == "set" then -- Get ready to set yourselves some homes!

		if Player:HasPermission("bearhomes.home.set") ~= true then
			Player:SendMessage( cChatColor.Yellow .. "You don't have permissions to do this action." )
			return true
		end

		if #Split == 3 then -- Player has specified a name of home to be set.

			-- Check if home is special.
			if IsSpecial(Split[3]) then
				Player:SendMessage( cChatColor.Yellow .. "You can't call a home that!" )
				return true
			end

			-- Make sure player has not depleted their home allowance.
			if CanSetHome(Player) ~= true then
				Player:SendMessage( cChatColor.Yellow .. "You can't set any more homes. Delete one and try again." )
				return true
			end

			-- Actually set the player's home.
			local playerPos = Player:GetEyePosition()
			success, errorMsg = HHANDLE.set(Player:GetName(), Split[3], playerPos.x, playerPos.y, playerPos.z)
			if not success then
				Player:SendMessage( cChatColor.Yellow .. "Home cannot be set: " .. errorMsg )
				return true
			end

			-- Inform the player of what has happened.
			Player:SendMessage( cChatColor.Yellow .. "Home " .. Split[3] .. " set." )
			return true

		else -- Player wants to set their main home.

			-- Check if home is special.
			if IsSpecial(Split[3]) then
				Player:SendMessage( cChatColor.Yellow .. "You can't call a home that!" )
				return true
			end

			-- Make sure player has not depleted their home allowance.
			if CanSetHome(Player) ~= true then
				Player:SendMessage( cChatColor.Yellow .. "You can't set any more homes. Delete one and try again." )
				return true
			end

			-- Actually set the player's home.
			local playerPos = Player:GetEyePosition()
			success, errorMsg = HHANDLE.set(Player:GetName(), "main", playerPos.x, playerPos.y, playerPos.z)
			if not success then
				Player:SendMessage( cChatColor.Yellow .. "Home cannot be set: " .. errorMsg )
				return true
			end

			-- Inform the player of what has happened.
			Player:SendMessage( cChatColor.Yellow .. "Home set." )
			return true

		end

	elseif Split[2] == "list" then -- Player wants to list their homes.

		-- Make sure that the player has permission to do so.
		if Player:HasPermission("bearhomes.home.list") ~= true then
			Player:SendMessage( cChatColor.Yellow .. "You don't have permissions to do this action." )
			return true
		end

		-- Get the homes table.
		local success, errorMsg, homeList = HHANDLE.list(Player:GetName())

		if not success then
			Player:SendMessage( cChatColor.Yellow .. "Cannot list homes: " .. errorMsg )
			return true
		end

		if #homeList == 0 then
			Player:SendMessage( cChatColor.Yellow .. "You don't have any homes." )
			return true
		end

		for i = 1, #homeList do
			Player:SendMessage( cChatColor.Yellow .. homeList[i] )
		end

		return true

	elseif Split[2] == "delete" then -- Player wants to delete one of their homes.

		-- Make sure that the player has permission to do so.
		if Player:HasPermission("bearhomes.home.delete") ~= true then
			Player:SendMessage( cChatColor.Yellow .. "You don't have permissions to do this action." )
			return true
		end

		-- Delete the player's specified home.
		if Split[3] ~= nil then
			success, errorMsg = HHANDLE.delete(Player:GetName(), Split[3])
		else
			success, errorMsg = HHANDLE.delete(Player:GetName(), "main")
		end

		-- Inform the player of what happened.
		if not success then
			Player:SendMessage( cChatColor.Yellow .. "Cannot delete home: " .. errorMsg )
			return true
		else
			Player:SendMessage( cChatColor.Yellow .. "Home: " .. Split[3] .. " Deleted!" )
			return true
		end

	elseif Split[2] == "player" then -- Player wants to go to somebody else's home.

		-- Make sure that the player has permission to do so.
		if Player:HasPermission("bearhomes.home.otherplayer") ~= true then
			Player:SendMessage( cChatColor.Yellow .. "You don't have permissions to do this action." )
			return true
		end

		-- Make sure they tell whose home they want to go to.
		if Split[3] == nil then
			Player:SendMessage( cChatColor.Yellow .. "You need to enter the name of the person whose home you want to visit." )
			return true
		end

		-- Get the location of the player's home.
		if Split[4] ~= nil then
			success, errorMsg, x, y, z = HHANDLE.load(Split[3], Split[4])
		else
			success, errorMsg, x, y, z = HHANDLE.load(Split[3], "main")
		end

		-- Inform the user of what happened.
		if not success then
			Player:SendMessage( cChatColor.Yellow .. "Cannot go to home: " .. errorMsg )
			return true
		end

		-- Check to see that the player's home does not need to cool down.
		if GetTime() - HOMEVISITTIME[Player:GetName()] < COOLDOWN and not Player:HasPermission("bearhomes.home.cooldown.exempt") then
			Player:SendMessage( cChatColor.Yellow .. "You need to wait " .. GetTime() - HOMEVISITTIME[Player:GetName()] .. " more seconds until you can go home." )
		else
			HOMEVISITTIME[Player:GetName()] = GetTime()
		end

		-- Teleport the player.
		Player:TeleportTo(x, y, z)
		Player:SendMessage( cChatColor.Yellow .. "Went home!" )
		return true

	else -- Player wants to go to their own home.

		-- Make sure that the player has permission to do so.
		if Player:HasPermission("bearhomes.home") ~= true then
			Player:SendMessage( cChatColor.Yellow .. "You don't have permissions to do this action." )
			return true
		end

		-- Load the locaton of the player's home.
		if Split[2] ~= nil then
			success, errorMsg, x, y, z = HHANDLE.load(Player:GetName(), Split[2])
		else
			success, errorMsg, x, y, z = HHANDLE.load(Player:GetName(), "main")
		end

		-- Inform the user of what happened.
		if not success then
			Player:SendMessage( cChatColor.Yellow .. "Cannot go to home: " .. errorMsg )
			return true
		end

		-- Check to see that the player's home does not need to cool down.
		if GetTime() - HOMEVISITTIME[Player:GetName()] < COOLDOWN and not Player:HasPermission("bearhomes.home.cooldown.exempt") then
			Player:SendMessage( cChatColor.Yellow .. "You need to wait " .. GetTime() - HOMEVISITTIME[Player:GetName()] .. " more seconds until you can go home." )
		else
			HOMEVISITTIME[Player:GetName()] = GetTime()
		end

		-- Teleport the player.
		Player:TeleportTo(x, y, z)
		Player:SendMessage( cChatColor.Yellow .. "Went home!" )
		return true
		

	end

	return false
	
end
