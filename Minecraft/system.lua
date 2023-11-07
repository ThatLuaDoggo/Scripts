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
local computer = require("computer")
local component = require("component")
local term = require("term")
local internet = component.internet
local gpu = component.gpu
local data = component.data
local modem = component.modem
local beep = computer.beep
