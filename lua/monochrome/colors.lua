local util = require 'monochrome.util'

local Default = { '#EBEBEB', '#101010' }
local Subtle = { '#F1F5F9', '#0A1219' }
local CoolGray = { '#F9FAFB', '#111827' }
local Amplified = { '#FFFFFF', '#000000' }

local colors = {
  bright_red = '#ffc4c4',
  bright_green = '#eff6ab',
  bright_yellow = '#ffe6b5',
  bright_blue = '#c9e6fd',
  bright_purple = '#f7d7ff',
  bright_aqua = '#ddfcf8',
  bright_orange = '#ffd3c2',
  neutral_red = '#eca8a8',
  neutral_green = '#ccd389',
  neutral_yellow = '#efd5a0',
  neutral_blue = '#a5c6e1',
  neutral_purple = '#e1bee9',
  neutral_aqua = '#c7ebe6',
  neutral_orange = '#efb6a0',
  faded_red = '#ec8989',
  faded_green = '#c9d36a',
  faded_yellow = '#ceb581',
  faded_blue = '#8abae1',
  faded_purple = '#db9fe9',
  faded_aqua = '#abebe2',
  faded_orange = '#E69E83',
}

local color_style
if vim.g.monochrome_style == 'default' then
  color_style = Default
elseif vim.g.monochrome_style == 'subtle' then
  color_style = Subtle
elseif vim.g.monochrome_style == 'amplified' then
  color_style = Amplified
elseif vim.g.monochrome_style == 'coolgray' then
  color_style = CoolGray
else
  color_style = Default
end

local fg, bg = unpack(color_style)
if vim.o.background == 'light' then
  bg, fg = fg, bg
end

for k, v in pairs(util.colorize(fg, bg)) do
  colors[k] = v
end

return colors
