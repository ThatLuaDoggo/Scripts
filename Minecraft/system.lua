if not(require("computer"))or not(require("component"))or not(require("component").internet)or not(require("component").gpu)or not(require("component").data)or not(require("component").modem)or not(require("component").modem.isWireless())then
  return
end
function wget(url, file, ...)
  local folders = {...}
  local path = "/"
  for _, i in next, folders do
    path = path .. i .. "/"
  end
  os.execute("wget -fq " .. url .. " " .. path .. file)
end
function rm(file, ...)
  local folders = {...}
  local path = "/"
  for _, i in next, folders do
    path = path .. i .. "/"
  end
  os.execute("rm " .. path .. file)
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
  local file = io.open(path, "r")
  if(file)then
    local read = file:read()
    io.close(file)
    return true, read
  else
    return false, ""
  end
end
function write(mode, text, file, ...)
  local folders = {...}
  local path = "/"
  for _, i in next, folders do
    path = path .. i .. "/"
  end
  local file = io.open(path, (method == "append" and "a" or method == "write" and "w" or "r"))
  if(file)then
    file:write(text)
    return true
  else
    return false
  end
end
local computer = require("computer")
local component = require("component")
local term = require("term")
local internet = component.internet
local gpu = component.gpu
local data = component.data
local modem = component.modem
local beep = computer.beep
sf = gpu.setForeground
gf = gpu.getForeground
----------------------------------------------
function log(text, start, color)
  local f = gf()
  start = start and "| > " or ""
  if(colors)then
    if(colors.__Information[color])then
      if(type(colors.__Information[color])=="table")then
        sf(colors.__Information[color].Write)
      end
    end
  end
  if(colors[color])then
    pcall(function()
        sf(colors[color])
    end)
  else
    pcall(function()
        color = tostring(color):gsub("#", "0x")
        sf(color)
    end)
  end
  print(start .. text)
  sf(f)
end
local function __setup()
  term.clear()
  local s, content = read("colors.lua", "system")
  if not(s)then
    log("Downloading Files... ('colors.lua')")
    wget("https://raw.githubusercontent.com/ThatLuaDoggo/Scripts/main/Minecraft/colors.lua", "colors.lua", "system")
    s, content = read("colors.lua", "system")
    if not(s)then
      log("An Error Occured in the File 'colors.lua'")
      return
    end
  end
  local s, m = pcall(function()
      load(content)()
  end)
  if not(s)then
    log("An Error Occured in the File 'colors.lua'")
    return
  end
  colors = load(content)()
end
