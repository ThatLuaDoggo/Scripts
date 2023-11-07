if not(require("component"))then
  return
else
  if not(require("component").gpu)then
    if(print)then
      print("Insert GPU to use drawing API")
    end
    return
  end
end
local API = {}
local component = require("component")
local gpu = component.gpu
API.Colors = {}
function API.Colors.Add(name, color) -- add color with "name" and "color"; "color" must be HEX or HEXADECIMAL, returns "True" on success, "False" on error
  if(API.Colors[name])then
    return false
  else
    local c = tostring(color):len()
    if(c==7)or(c==8)then
      API.Colors[name] = color
      return true
    else
      return false
    end
  end
end
function API.Fill(x, y, width, height, color, character) -- returns "True" on success, returns "False" on error
  if(x)and(y)and(width)and(height)then
    color = color or 0x000000
    character = tostring(character) or " "
    if(type(color)=="string")then
      if not(API.Colors[color])then
        color:gsub("#", "0x")
      end
      local s, m = pcall(function()
          local bg = gpu.getBackground()
          gpu.setBackground(API.Colors[color] or color)
          gpu.fill(x, y, width, height, character)
          gpu.setBackground(bg)
      end)
      return s
    end
  else
    return false
  end
end
function API.TextColor(color, text)
  local s, m = pcall(function()
        local fg = gpu.getForeground()
        gpu.setForeground(API.Colors[color] or color)
        print(text)
        gpu.setForeground(fg)
    end)
    return s
end
for i, v in next, gpu do
  API[i] = v
end
return API
