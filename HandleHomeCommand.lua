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

	if (homeName == "list") or (homeName == "main") or (homeName == "delete") or (homeName == "player") or (homeName "set") then
		return true
	else
		return false
	end

end

function CanSetHome(Player)

	local homeList = HHANDLE.list(Player:GetName())
	local homeNumber = #homeList

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

	if #Split < 2 then

		Player:SendMessage(cChatColor.Yellow .. "Usage: /home <subcommand>")
		return true

	end

	if Split[2] == "set" then

		if Player:HasPermission("bearhomes.home.set") ~= true then

			Player:SendMessage( cChatColor.Yellow .. "You don't have permissions to do this action." )
			return false

		end

		if #Split == 3 then

			if IsSpecial(Split[3]) then
				Player:SendMessage( cChatColor.Yellow .. "You can't call a home that!" )
				return false
			end

			if CanSetHome(Player) ~= true then
				Player:SendMessage( cChatColor.Yellow .. "You can't set any more homes. Delete one and try again." )
				return false
			end

			local playerPos = Player:GetEyePosition()
			success, errorMsg = HHANDLE.set(Player:GetName(), Split[3], playerPos.x, playerPos.y, playerPos.z)
			if not success then
				Player:SendMessage( cChatColor.Yellow .. "Home cannot be set: " .. errorMsg )
				return false
			end

			Player:SendMessage( cChatColor.Yellow .. "Home " .. Split[3] .. "set." )
			return true

		else

			if CanSetHome(Player) ~= true then
				Player:SendMessage( cChatColor.Yellow .. "You can't set any more homes. Delete one and try again." )
				return false
			end

			local playerPos = Player:GetEyePosition()
			success, errorMsg = HHANDLE.set(Player:GetName(), "main", playerPos.x, playerPos.y, playerPos.z)

			if not success then
				Player:SendMessage( cChatColor.Yellow .. "Home cannot be set: " .. errorMsg )
				return false
			else
				Player:SendMessage( cChatColor.Yellow .. "Home set." )
				return true
			end

		end

	elseif Split[2] == "list" then

		if Player:HasPermission("bearhomes.home.list") ~= true then
			Player:SendMessage( cChatColor.Yellow .. "You don't have permissions to do this action." )
			return false
		end

		local success, errorMsg, homeList = HHANDLE.list(Player:GetName())

		if not success then
			Player:SendMessage( cChatColor.Yellow .. "Cannot list homes: " .. errorMsg )
			return false
		end

		if #homeList == 0 then
			Player:SendMessage( cChatColor.Yellow .. "You don't have any homes." )
			return false
		end

		for i = 1, #homeList do
			Player:SendMessage( cChatColour.Yellow .. homeList[i] )
		end

		return true

	elseif Split[2] == "delete" then

		if Player:HasPermission("bearhomes.home.delete") ~= true then
			Player:SendMessage( cChatColor.Yellow .. "You don't have permissions to do this action." )
			return false
		end

		if Split[3] ~= nil then
			success, errorMessage = HHANDLE.delete(Player:GetName(), Split[3])
		else
			success, errorMessage = HHANDLE.delete(Player:GetName(), "main")
		end

		if not success then
			Player:SendMessage( cChatColor.Yellow .. "Cannot delete home: " .. errorMsg )
			return false
		else
			Player:SendMessage( cChatColor.Yellow .. "Home: " .. Split[3] .. " Deleted!" )
			return true
		end

	elseif Split[2] == "player" then

		if Player:HasPermission("bearhomes.home.otherplayer") ~= true then
			Player:SendMessage( cChatColor.Yellow .. "You don't have permissions to do this action." )
			return false
		end

		if Split[3] == nil then
			Player:SendMessage( cChatColor.Yellow .. "You need to enter the name of the person whose home you want to visit." )
			return false
		end

		if Split[4] ~= nil then
			success, errorMessage, x, y, z = HHANDLE.load(Split[3], Split[4])
		else
			success, errorMessage, x, y, z = HHANDLE.load(Split[3], "main")
		end

		if not success then
			Player:SendMessage( cChatColor.Yellow .. "Cannot go to home: " .. errorMsg )
			return false
		end

		Player:TeleportTo(x, y, z)
		Player:SendMessage( cChatColor.Yellow .. "Went home!" )
		return true

	else

		if Player:HasPermission("bearhomes.home") ~= true then
			Player:SendMessage( cChatColor.Yellow .. "You don't have permissions to do this action." )
			return false
		end

		if Split[3] ~= nil then
			success, errorMessage, x, y, z = HHANDLE.load(Player:GetName(), Split[3])
		else
			success, errorMessage, x, y, z = HHANDLE.load(Player:GetName(), "main")
		end

		if not success then
			Player:SendMessage( cChatColor.Yellow .. "Cannot go to home: " .. errorMsg )
			return false
		end

		Player:TeleportTo(x, y, z)
		Player:SendMessage( cChatColor.Yellow .. "Went home!" )
		return true
		

	end	

	return false

end
