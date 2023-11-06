  --// Variables \\--
    -- Requiring --
local computer = require("computer")
local component = require("component")
local term = require("term")
local event = require("event")
    -- Other --
local data = component.data
local modem = component.modem
local beep = computer.beep
local config = {
  beep = {
    enabled = false,
    sounds = {
      success = "1000:0.1,1600:0.06",
      error = "900:0.06,800:0.1"
    }
  }
}
  --// Config \\--
    -- Functions --
function split(str, seperator) -- https://stackoverflow.com/questions/1426954/split-string-in-lua
  if(seperator==nil)then
      seperator = "%s"
  end
  local splitted = {}
  for s in string.gmatch(str, "([^" .. seperator .. "]+)") do
    table.insert(splitted, s)
  end
  return splitted
end
    -- Metatables --
setmetatable(config.beep.sounds, {
    __call = function(table, ...)
      local args = {...}
      function read(instructions)
        instructions = split(instructions, ",")
        for _, instruction in next, instructions do
          instruction = split(instruction, ":")
          event.timer(0, function()
            beep(tonumber(instruction[1]), tonumber(instruction[2]))
          end)
        end
      end
      for _, sound in next, args do
        if(table[sound])then
          read(table[sound])
        end
      end
    end
})
  --// System \\-- (UI)
