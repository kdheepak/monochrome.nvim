M = {}
local hsluv = require 'monochrome.hsluv'

local function rgb2float(rgb)
  return { rgb[1], rgb[2], rgb[3] }
end
local function make_color(name, value)
  return '                <key>' .. name .. ' Component</key>\n                <real>' .. value .. '</real>\n'
end

function M.format(color)
  local float_colors = rgb2float(hsluv.hex_to_rgb(color))
  local blue = make_color('Blue', float_colors[3])
  local green = make_color('Green', float_colors[2])
  local red = make_color('Red', float_colors[1])
  return blue .. green .. red
end

return M
