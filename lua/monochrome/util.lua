local hsluv = require 'monochrome.hsluv'

local M = {}

-- based on https://github.com/folke/tokyonight.nvim/blob/main/lua/tokyonight/util.lua
function M.hexToRgb(hex_str)
  local hex = '[abcdef0-9][abcdef0-9]'
  local pat = '^#(' .. hex .. ')(' .. hex .. ')(' .. hex .. ')$'
  hex_str = string.lower(hex_str)

  assert(string.find(hex_str, pat) ~= nil, 'hex_to_rgb: invalid hex_str: ' .. tostring(hex_str))

  local r, g, b = string.match(hex_str, pat)
  return { tonumber(r, 16), tonumber(g, 16), tonumber(b, 16) }
end

function M.blend(fg, bg, blend)
  local hsl1 = hsluv.hex_to_hsluv(bg)
  local hsl2 = hsluv.hex_to_hsluv(fg)
  local hue_blend, saturation_blend, lightness_blend = unpack(blend)
  local r1, g1, b1 = unpack(hsluv.hsluv_to_rgb(hsl1))
  local r2, g2, b2 = unpack(hsluv.hsluv_to_rgb(hsl2))

  local hue =
      hsluv.rgb_to_hsluv({ r1 + (r2 - r1) * hue_blend, g1 + (g2 - g1) * hue_blend, b1 + (b2 - b1) * hue_blend })[1]

  local _, s1, l1 = unpack(hsl1)
  local _, s2, l2 = unpack(hsl2)
  return hsluv.hpluv_to_hex({ hue, s1 + (s2 - s1) * saturation_blend, l1 + (l2 - l1) * lightness_blend })
end

function M.colorDistance(hs1, hs2)
  local h1, s1 = unpack(hs1)
  local h2, s2 = unpack(hs2)

  local hueDist = M.modularDistance(h1, h2, 360) / 180 * 2.0 - 1.0
  local saturationDist = math.abs(s1 - s2) / 100.0
  return hueDist * saturationDist
end

function M.modularDistance(a, b, m)
  return math.min((a - b) % m, (b - a) % m)
end

function M.invertColor(color)
  if color ~= 'NONE' then
    local hsl = hsluv.hex_to_hsluv(color)
    hsl[3] = 100 - hsl[3]
    if hsl[3] < 40 then
      hsl[3] = hsl[3] + (100 - hsl[3]) * 0.3
    end
    return hsluv.hsluv_to_hex(hsl)
  end
  return color
end

function M.darken(hsl, amount)
  local l = hsl[3] * (1.0 - amount)
  return { hsl[1], hsl[2], l }
end

function M.brighten(hsl, amount)
  local l = hsl[3] + (100.0 - hsl[3]) * amount
  return { hsl[1], hsl[2], l }
end

function M.desaturate(hsl, amount)
  local s = hsl[2] * (1.0 - amount)
  return { hsl[1], s, hsl[3] }
end

function M.saturate(hsl, amount)
  local s = hsl[2] + (100.0 - hsl[2]) * amount
  return { hsl[1], s, hsl[3] }
end

function M.brighten(color, percentage)
  local hsl = hsluv.hex_to_hsluv(color)
  local larpSpace = 100 - hsl[3]
  if percentage < 0 then
    larpSpace = hsl[3]
  end
  hsl[3] = hsl[3] + larpSpace * percentage
  return hsluv.hsluv_to_hex(hsl)
end

function M.darken(hex, amount, bg)
  return M.blend(hex, bg or require'monochrome.colors'.black, { math.abs(amount), math.abs(amount), math.abs(amount) })
end

function M.lighten(hex, amount, fg)
  return M.blend(hex, fg or require'monochrome.colors'.white, { math.abs(amount), math.abs(amount), math.abs(amount) })
end

local function range(from, to, step)
  local t = {}

  for value = from, to, step do
    t[#t + 1] = value
  end

  return t
end

function M.colorize(fg, bg)
  -- https://github.com/anotherglitchinthematrix/monochrome/blob/master/src/base.js
  local first = hsluv.hex_to_hsluv(bg)[3]
  local last = hsluv.hex_to_hsluv(fg)[3]
  local lower, higher
  if first < last then
    lower = first
    higher = last
    first = math.floor(first)
    last = math.ceil(last)
  else
    lower = last
    higher = first
    first = math.ceil(first)
    last = math.floor(last)
  end
  local palette = {}
  for i, v in pairs(range(first, last, (last - first) / 10)) do
    palette['gray' .. tostring(i - 1)] = hsluv.hpluv_to_hex({ 0, 0, v })
  end
  palette['gray10'] = nil
  palette['gray0'] = nil
  palette['white'] = hsluv.hpluv_to_hex({ 0, 0, hsluv.hex_to_hsluv(hsluv.hpluv_to_hex({ 0, 0, higher }))[3] })
  palette['black'] = hsluv.hpluv_to_hex({ 0, 0, hsluv.hex_to_hsluv(hsluv.hpluv_to_hex({ 0, 0, lower }))[3] })
  palette['fg'] = hsluv.hpluv_to_hex({ 0, 0, hsluv.hex_to_hsluv(hsluv.hpluv_to_hex({ 0, 0, last }))[3] })
  palette['bg'] = hsluv.hpluv_to_hex({ 0, 0, hsluv.hex_to_hsluv(hsluv.hpluv_to_hex({ 0, 0, first }))[3] })
  palette['bg_alt'] = M.blend(palette['bg'], palette['gray1'], { 0.5, 0.5, 0.5 })
  palette['fg_alt'] = M.blend(palette['fg'], palette['gray9'], { 0.5, 0.5, 0.5 })
  return palette
end

return M
