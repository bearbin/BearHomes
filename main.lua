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

-- Configuration

HOMEHANDLER = "INISAVE" -- Included handler is "INISAVE". Download more online or make your own.
MULTIHOME = {}
table.insert(MULTIHOME, 2) -- Rank one for multiple homes.
table.insert(MULTIHOME, 3) -- Rank two for multiple homes.
table.insert(MULTIHOME, 4) -- Rank threee for multiple homes.
table.insert(MULTIHOME, 5) -- Rank four for multiple homes.
table.insert(MULTIHOME, 6) -- Rank five for multiple homes.

-- Globals

PLUGIN = {}
LOGPREFIX = ""
HHANDLE = {}
APIVER = 1

-- Plugin Start

function Initialize( Plugin )

        PLUGIN = Plugin
        PluginManager = cRoot:Get():GetPluginManager()

        Plugin:SetName( "BearHomes" )
        Plugin:SetVersion( 1 )

	LOGPREFIX = "["..Plugin:GetName().."] "

	-- Commands

	PluginManager:BindCommand("/home", "bearhomes.home", HandleHomeCommand, "Go to a home.")
	PluginManager:BindCommand("/home set", "bearhomes.home.set", HandleHomeCommand, "Set a home.")
	PluginManager:BindCommand("/home list", "bearhomes.home.list", HandleHomeCommand, "List your homes."
	PluginManager:BindCommand("/home delete", "bearhomes.home.delete", HandleHomeCommand, "Delete one of your homes.")
	PluginManager:BindCommand("/home player", "bearhomes.home.otherplayer", HandleHomeCommand, "Go to another player's home.")

	-- Save Handler Setup
	--   Get Info

	HHANDLE.apiVer, HHANDLE.init, HHANDLE.load, HHANDLE.save, HHANDLE.delete, HHANDLE.list = _G[HOMEHANDLER]() 

	if HHANDLE.apiVer ~= APIVER then

		LOGWARN( LOGPREFIX .. "Cannot use specified Save Handler, falling back to INISAVE." )
		HHANDLE.apiVer, HHANDLE.init, HHANDLE.load, HHANDLE.save, HHANDLE.list, HHANDLE.delete = _G["INISAVE"]() 

	end 

	--   Run Init

	HHANDLE.init()		

	-- Finishing Up

	LOGINFO( LOGPREFIX .. "Plugin v" .. Plugin:GetVersion() .. " Enabled!" )
        return true

end

function OnDisable()
	LOGINFO( LOGPREFIX .. "Plugin Disabled!" )
end
