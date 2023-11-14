if not(require("computer"))or not(require("component"))or not(require("component").internet)or not(require("component").gpu)or not(require("component").data)or not(require("component").modem)or not(require("component").modem.isWireless())then
  return
end
function wget(url, file, ...)
  local folders = {...}
  local path = "/"
  for _, i in next, folders do
    path = path .. i .. "/"
  end
  pcall(function()
      os.execute("wget -fq " .. url .. " " .. path .. file)
  end)
end
function rm(file, ...)
  local folders = {...}
  local path = "/"
  for _, i in next, folders do
    path = path .. i .. "/"
  end
  pcall(function()
    os.execute("rm " .. path .. file)
  end)
end
local s, m = pcall(function()
    wget("https://www.example.com", "/system/wget.html")
    os.execute("rm /system/wget.html")
end)
if not(s)then
  return
end
function read(file, ...)
  local folders = {...}
  local path = "/"
  for _, i in next, folders do
    path = path .. i .. "/"
  end
  pcall(function()
      local file = io.open(path, "r")
      if(file)then
        local read = file:read()
        io.close(file)
        return true, read
      else
        return false, ""
      end
  end)
end
function write(mode, text, file, ...)
  local folders = {...}
  local path = "/"
  for _, i in next, folders do
    path = path .. i .. "/"
  end
  pcall(function()
      local file = io.open(path, (method == "append" and "a" and method == "write" and "w" or "r"))
      if(file)then
        file:write(text)
        return true
      else
        return false
      end
  end)
end
local computer = require("computer")
local component = require("component")
local event = require("event")
local term = require("term")
local internet = component.internet
local gpu = component.gpu
local data = component.data
local modem = component.modem
local beep = computer.beep
sf = gpu.setForeground
gf = gpu.getForeground
----------------------------------------------
function log(text, start, color, mode)
  local f = gf()
  start = start and "| > " or ""
  color = color or "0xFFFFFF"
  mode = (mode == 0 and "Dark" or mode == 1 and "Light" or "Light")
  if(colors)then
    if(colors.__Information[mode][color])then
      color = tonumber(colors.__Information[color])
    elseif(colors[mode][color])then
      color = tonumber(colors[mode][color])
    else
      xpcall(function()
          sf(tonumber(color))
          sf(f)
      end, function()
          xpcall(function()
              color = tostring(color):gsub("#", "0x")
              sf(color)
              sf(f)
          end, function()
              color = "0xFFFFFF"
          end)
      end)
    end
  end
  pcall(function()
      sf(color)
      print(start .. text)
      sf(f)
  end)
end
local function __setup()
  local continue = true
  term.clear()
  log("Checking System Content", true, "Info", 1)
  local s1, content1, s2, content2 = read("colors.lua", "system"), read("tracks.lua", "system")
  xpcall(function()
      load(content1)()
      load(content2)()
  end, function()
      rm("colors.lua", "system")
      rm("tracks.lua", "system")
      wget("https://raw.githubusercontent.com/ThatLuaDoggo/Scripts/main/Minecraft/colors.lua", "colors.lua", "system")
      wget("https://raw.githubusercontent.com/ThatLuaDoggo/Scripts/main/Minecraft/tracks.lua", "tracks.lua", "system")
      s1, content1, s2, content2 = read("colors.lua", "system"), read("tracks.lua", "system")
      xpcall(function()
          colors = load(content1)()
          api = load(content2)()
      end, function()
          log("Could not load Colors ('colors.lua') and System API ('tracks.lua'),\nUnfortunately this System cannot run without them.\nPlease try again later and restart your Computer.", true, "0xfa453e", 1)
          continue = false
      end)
  end)
  if(continue)then
    term.clear()
    log("Searching for nearest Server...\n(30 Seconds)", true, "Info", 1)
    local s = os.date("*t").sec
    local c = os.clock()
    local m = os.date("*t").min
    local r = c * s * 1000 / m
    for port = 1, 100 do
      term.clear()
      modem.broadcast(port, "-connect+3000," .. tostring(r))
      local type, a, from, port, b, message = event.pull("modem")
    end
  end
end
