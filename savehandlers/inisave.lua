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

-- Nothing here yet...

function INISAVESPLIT(string, pattern)

	-- Define variables.
	local table = {}  -- NOTE: use {n = 0} in Lua-5.0
	local fpat = "(.-)" .. pattern
	local last_end = 1
	local s, e, cap = string:find(fpat, 1)

	-- Split the string.
	while s do
		if s ~= 1 or cap ~= "" then
			table.insert(t,cap)
		end
		last_end = e+1
		s, e, cap = string:find(fpat, last_end)
	end

	if last_end <= #string then
		cap = string:sub(last_end)
		table.insert(t, cap)
	end

	-- Return the table.
	return t

end

function INISAVEINIT()
	-- We don't need no init function...
	return true, nil
end

function INISAVESAVE( playerName, homeName, xCoord, yCoord, zCoord )

	-- Make sure that the function has been called correctly.
	assert( playerName ~= nil and homeName ~= nil and xCoord ~= nil and yCoord ~= nil and  zCoord ~= nil, "While setting home, not all values filled out." )

	-- Join the coordinates.
	combinedCoords = xCoord .. "," .. yCoord .. "," .. zCoord

	-- Setup the cIniFile instance.
	local iniFile = cIniFile( PLUGIN:GetLocalDirectory() .. "/homes.ini" )
	iniFile:CaseInsensitive()
	iniFile:ReadFile()
	
	-- Write the data to the Ini File.
	local success = iniFile:SetValue( playerName, homeName, combinedCoords )
	local success2 = iniFile:WriteFile()

	-- Check to make sure that the data has been written, if not return an error.
	if not success then
		return false, "Data could not be written to the INI file."
	else if not success2 then
		return false, "The INI file could not be saved to disk."
	end

	-- Inidcate that the function has worked as intended.
	return true, nil

end

function INISAVELOAD(playerName, homeName)

	-- Make sure that the function has been called correctly.
	assert( playerName ~= nil and homeName ~= nil, "While loading home, not all values filled out." )

	-- Setup the cIniFile instance.
	local iniFile = cIniFile( PLUGIN:GetLocalDirectory() .. "/homes.ini" )
	iniFile:CaseInsensitive()
	iniFile:ReadFile()

	-- Get the data from the INI file.
	local coords = iniFile:GetValueSet(playerName, homeName, "")

	-- Make sure that the home exists.
	if coords == "" then
		return false, "Could not read home from file, it likely does not exist.", nil, nil, nil
	end

	-- Split the coordinates.
	coords = INISAVESPLIT(coords, ",")

	-- Return the success and the coordinates of the home.
	return true, nil, coords[1], coords[2], coords[3]

end

function INISAVEDELETE(playerName, homeName)

	-- Make sure that the function has been called correctly.
	assert( playerName ~= nil and homeName ~= nil, "While deleting home, not all values filled out." )

	-- Setup the cIniFile instance.
	local iniFile = cIniFile( PLUGIN:GetLocalDirectory() .. "/homes.ini" )
	iniFile:CaseInsensitive()
	iniFile:ReadFile()

	-- Delete the data from the INI file.
	local success = DeleteValue( String Keyname, String Valuename )

	-- Check to see success of deleting home.
	if not success then
		return false, "Could not delete home, does it exist?"
	end

	-- Write back to the INI file.
	iniFile:WriteFile()

	-- Return our success.
	return true, nil

end

function INISAVELIST(playerName)

	local homeList = {}

	-- Setup the cIniFile instance.
	local iniFile = cIniFile( PLUGIN:GetLocalDirectory() .. "/homes.ini" )
	iniFile:CaseInsensitive()
	iniFile:ReadFile()

	-- Find the homes.
	local numValues = iniFile:NumValues(playerName)
	for i = 0, numValues
		table.insert(iniFile:ValueName(playerName, i)
	end

	return true, nil, homeList

end

function INISAVE()
	return 1, INISAVEINIT, INISAVESAVE, INISAVELOAD, INISAVEDELETE, INISAVELIST
end
