local tiled = require "com.ponywolf.ponytiled"
local physics = require "physics"
local json = require "json"

local mapData = json.decodeFile(system.pathForFile("maps", system.ResourceDirectory))  -- load from json export
local map = tiled.new(mapData, "objects")